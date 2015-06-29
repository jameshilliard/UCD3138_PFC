//main.c

#define MAIN (1)//Declaring MAIN forces the EXTERN variables to be defined
#include "include.h"    

//*********************************************************//
//*** Define
//*********************************************************//
#define USER_DATA_START_SEGMENT		56
//#define USER_DATA_SEGMENT_COUNT		8
#define CALIBRATION_SEGMENT_COUNT	8
//#define BLACK_BOX_SEGMENT_COUNT		10
//#define MISC_SEGMENT_COUNT			1

//*********************************************************//
//*** Type Define
//*********************************************************//
typedef struct {
	unsigned VIN_CALIBRATED :1;	//20141205--Kevin.Lai
	unsigned IIN1_CALIBRATED :1;	//20140523--Kevin.Lai
	unsigned FlashWriteCalibration :1;
} tPS_FLAG;

typedef enum {
	CAL_VOUT = 0, CAL_IOUT, CAL_VIN,             //0x02,20141208T1--Ernest.Huang
	CAL_IIN,
	CAL_CLEAR_ALL,
	CAL_CLEAR_VOUT,
	CAL_CLEAR_IOUT,
	CAL_CLEAR_VIN,
	CAL_CLEAR_IIN,
	CAL_IOUT_1,		//0x09
	CAL_IOUT_2,
	CAL_IOUT_CS,
	CAL_VOUT_CS,
	CAL_IOUT_3,		// [Tommy YR Chen] 20110526 added
	CAL_IOUT_4,		// [Tommy YR Chen] 20111103 added
	CAL_IOUT_LCS,	// [Tommy YR Chen] 20111103 added
	CAL_IIN_1,		//0x10,20140522--Kevin.Lai
	CAL_IIN_2,		//20140522--Kevin.Lai
	CAL_PIN,		//20140522--Kevin.Lai
	CAL_PIN_1,		//0x13,20140522--Kevin.Lai
	CAL_PIN_2		//20140522--Kevin.Lai
} eCalibration_Info;

//*********************************************************//
//*** Prama Define
//*********************************************************//
#pragma DATA_SECTION(Liteon_CAL, ".LITEON_CAL");
volatile const LITEON_CAL_STRUCTURE Liteon_CAL;

//*********************************************************//
//*** 
//*********************************************************//
EXTERN Uint8 bstatus;
EXTERN tPS_FLAG PS;

void handle_serial_in(char rx_byte)		//this function is for debugging useage
{
#ifdef VOLTAGE_LOOP_DISABLE//voltage loop open			
	if(((rx_byte == '+') || (rx_byte == '=')) && (iv.i_target_average < (0x3fff - 50)))
	{
		iv.i_target_average += 50;
	}
	else if((rx_byte == '-') && (iv.i_target_average > 50))
	{
		iv.i_target_average -= 50;
	}
#else //voltage loop close
	if (((rx_byte == '+') || (rx_byte == '='))
			&& (iv.vbus_target <= (VBUS_DPWM_OFF_LEVEL - 10))) {
		iv.vbus_target += 10;
	} else if ((rx_byte == '-') && (iv.vbus_target >= 10)) {
		iv.vbus_target -= 10;
	}
#endif
	else if ((rx_byte == 'q') && (iv.i_target_offset < 256)) {
		iv.i_target_offset++;
	} else if ((rx_byte == 'w') && (iv.i_target_offset > 0)) {
		iv.i_target_offset--;
	} else if ((rx_byte == 'a') && (switching_frequency < 150)) {
		switching_frequency++;
		set_new_switching_frequency();
	} else if ((rx_byte == 's') && (switching_frequency > 60)) {
		switching_frequency--;
		set_new_switching_frequency();
	}
}

unsigned usqr_simple(unsigned d, unsigned N)
//copied from ARM System Developers Guide, page 238,239.  Assembly language version also available.
{
	unsigned t, q = 0, r = d;

	do {						//calculate next quotient bit
		N--;				//move down to next bit
		t = 2 * q + (1 << N);		//new r = old r - (t<<N)
		if ((r >> N) >= t)		 //if (r >+ (t<<N)
				{
			r -= (t << N);	//update remainder
			q += (1 << N);
		}
	} while (N);

	return q;
}

inline void voltage_feed_forward(void)	//calculate Km/Vrms^2
{
#ifdef AC_DROP_OPTIMIZATION
	if ((iv.ac_drop_recovery_not_complete)
			&& ((iv.supply_state == STATE_PFC_ON)
					|| (iv.supply_state == STATE_RAMP_UP))) // if ac recovery don't completed
			{
		iv.vff_pointer_temp = iv.vff_pointer + 1;
		if (iv.vff_pointer_temp > 6)
			iv.vff_pointer_temp = 0;
		iv.vff_multiplier = iv.vff_multiplier_temp[iv.vff_pointer_temp];

	} else
#endif
	{
		if (iv.vin_squared_average < VAC_MIN_OFF_SQ_AVG) //if VAC is below normal operating range
		{
			iv.vff_multiplier = K_FEED_FORWARD / VAC_MIN_OFF_SQ_AVG; //Q30/Q15 = Q15 limit to minimum operating voltage to avoid overflow
		} else //here if vac is within range
		{
			if (abs(
					iv.vin_squared_average
							- (iv.vin_squared_slow_average
									>> VRECT_SQUARED_SLOW_AVERAGE_SHIFT))
					> (iv.vin_squared_slow_average
							>> (VRECT_SQUARED_SLOW_AVERAGE_SHIFT + 4)))
					//above code compares difference between fast and slow VAC values to a percentage of the slow value.
					//instead of multiplying the slow value times a constant, it uses a shift.  So a shift of +4, for
					//example = 1/16  or .0625% of the slow value.
					//so the code below is executed if the difference between fast and slow values is greater
					//than the percentage.  It uses the fast value.
					{
				iv.vff_multiplier = K_FEED_FORWARD / iv.vin_squared_average;//Q30/Q15 = Q15
			} else //here if the fast and slow values are close - use the slow value.
			{
				if (iv.vin_squared_slow_average
						< (VAC_MIN_OFF_SQ_AVG
								<< VRECT_SQUARED_SLOW_AVERAGE_SHIFT)) {
					iv.vff_multiplier = K_FEED_FORWARD / VAC_MIN_OFF_SQ_AVG; //Q30/Q15 = Q15 limit to minimum operating voltage to avoid overflow
				} else {
					iv.vff_multiplier = K_FEED_FORWARD
							/ (iv.vin_squared_slow_average
									>> VRECT_SQUARED_SLOW_AVERAGE_SHIFT); //Q30/Q15 = Q15
				}
			}
		}
		iv.vff_multiplier_temp[iv.vff_pointer] = iv.vff_multiplier;

		if (iv.vff_pointer == 6)
			iv.vff_pointer = 0;
		else
			iv.vff_pointer++;
	}
}

inline void dynamic_system_optimization(void) {

	Filter1Regs.COEFCONFIG.all = 0x0AAAAAAA; //use coefficient set C//[Ken Zhang] for debug
//	Filter1Regs.COEFCONFIG.all = 0x09999999;//use coefficient set B
//	return;

//	if (iv.pis.output > 40) {
//		iv.i_target_offset = 7; //[Ken Zhang] 11mV offset at EAP0, convert to digital 0.011/1.6*1024=7
//		iv.i_target_offset = 10; //[Ken Zhang] sample 2 9.5mV offset at EAP0, convert to digital 0.0095/1.6*1024=7
//	} else {
//		iv.i_target_offset = 0;
//	}

	if (pin < 1800)	//[Ken Zhang] 400W
			{
		iv.emi_buff_delay = 9;
		iv.i_target_offset = 0;
	} else if (pin < 2600)	//[Ken Zhang] 600W
			{
		iv.emi_buff_delay = 9;
		iv.i_target_offset = 3;
	} else if (pin < 4000)	//[Ken Zhang] 800W
			{
		iv.emi_buff_delay = 6;
		iv.i_target_offset = 5;
	} else {
		iv.emi_buff_delay = 4;
		iv.i_target_offset = 9;
	}
}
#if AUTOBAUD_SUPPORT
void init_TCAP(void)
{
	TimerRegs.T24CAPCTRL.bit.CAP_SEL = 1;//input signal comes from SCI_RX[0] pin
	TimerRegs.T24CAPCTRL.bit.EDGE = 2;//enable capture on falling edge
}
#endif

void ReadCalibration(void) {
	memcpy((void *) &UserData.Calibration, (void *) &Liteon_CAL,
			sizeof(UserData.Calibration));
}

void WriteCalibration(void) {
	Uint16 status;

	while (DecRegs.DFLASHCTRL.bit.BUSY != 0) {
		; //do nothing while busy erasing DFlash
	}

	status = update_data_flash((void*) &Liteon_CAL, &UserData.Calibration,
			sizeof(UserData.Calibration));
	if (status != FLASH_SUCCESS) {
		bstatus = status;
	}

}
void CheckInputCaliData(void) {
	if (UserData.Calibration.E_Meter.iin_slope == 0xFFFFFFFF) { //Uint32
		UserData.Calibration.E_Meter.iin_slope = 667;      //Ernest20141208T1
		UserData.Calibration.E_Meter.iin_slope_shift = 7;  //Ernest20141208T1
		UserData.Calibration.E_Meter.iin_offset = 163;     //Ernest20141208T1
		UserData.Calibration.E_Meter.iin_offset_shift = 0; //Ernest20141208T1
		UserData.Calibration.E_Meter.vin_slope = 101;      //Ernest20141208T1
		UserData.Calibration.E_Meter.vin_slope_shift = 10; //Ernest20141208T1
		UserData.Calibration.E_Meter.vin_offset = 0;       //Ernest20141208T1
		UserData.Calibration.E_Meter.vin_offset_shift = 0; //Ernest20141208T1
	}
}

void SaveCalibrationDataToFlash(void)		//20140521--Kevin.Lai
{
	erase_one_section(USER_DATA_START_SEGMENT, sizeof(UserData.Calibration));//20140526--Kevin.Lai

	WriteCalibration();
}

static void CalibrateVIN(Uint8 VIN_TYPE) {
	int16 slope;

	if (VIN_TYPE == CAL_VIN) {
		slope = (pmbus_buffer[3] << 24) | (pmbus_buffer[4] << 16)
				| (pmbus_buffer[5] << 8) | pmbus_buffer[6];
//		if((slope > 8) && (slope < 1024))
		{
			vin_slope = slope;
			vin_slope_shift = (pmbus_buffer[7] << 24) | (pmbus_buffer[8] << 16)
					| (pmbus_buffer[9] << 8) | pmbus_buffer[10];
			vin_offset = (pmbus_buffer[11] << 24) | (pmbus_buffer[12] << 16)
					| (pmbus_buffer[13] << 8) | pmbus_buffer[14];
			vin_offset_shift = (pmbus_buffer[15] << 24)
					| (pmbus_buffer[16] << 16) | (pmbus_buffer[17] << 8)
					| pmbus_buffer[18];

			UserData.Calibration.E_Meter.vin_slope = vin_slope;
			UserData.Calibration.E_Meter.vin_slope_shift = vin_slope_shift;
			UserData.Calibration.E_Meter.vin_offset = vin_offset;
			UserData.Calibration.E_Meter.vin_offset_shift = vin_offset_shift;

			PS.VIN_CALIBRATED = 1;
		}

#if 0
		slope = (pmbus_buffer[20] << 24)|(pmbus_buffer[21] << 16)|(pmbus_buffer[22] << 8)|pmbus_buffer[23];
		if((slope > 8) && (slope < 1024)) {
			iin_slope = slope;
			iin_slope_shift = (pmbus_buffer[24] << 24)|(pmbus_buffer[25] << 16)|(pmbus_buffer[26] << 8)|pmbus_buffer[27];
			iin_offset = (pmbus_buffer[28] << 24)|(pmbus_buffer[29] << 16)|(pmbus_buffer[30] << 8)|pmbus_buffer[31];
			iin_offset_shift = (pmbus_buffer[32] << 24)|(pmbus_buffer[33] << 16)|(pmbus_buffer[34] << 8)|pmbus_buffer[35];

			UserData.Calibration.E_Meter.iin_slope = iin_slope;
			UserData.Calibration.E_Meter.iin_slope_shift = iin_slope_shift;
			UserData.Calibration.E_Meter.iin_offset = iin_offset;
			UserData.Calibration.E_Meter.iin_offset_shift = iin_offset_shift;

			PS.IIN1_CALIBRATED = 1;
		}

#endif

	} else {
		//Error Handling
	}
}

static void CalibrateIIN(Uint8 IIN_TYPE) {
	int16 slope;

	if (IIN_TYPE == CAL_IIN_1) {
		slope = (pmbus_buffer[3] << 24) | (pmbus_buffer[4] << 16)
				| (pmbus_buffer[5] << 8) | pmbus_buffer[6];
//		if((slope > 8) && (slope < 1024))
		{
			iin_slope = slope;
			iin_slope_shift = (pmbus_buffer[7] << 24) | (pmbus_buffer[8] << 16)
					| (pmbus_buffer[9] << 8) | pmbus_buffer[10];
			iin_offset = (pmbus_buffer[11] << 24) | (pmbus_buffer[12] << 16)
					| (pmbus_buffer[13] << 8) | pmbus_buffer[14];
			iin_offset_shift = (pmbus_buffer[15] << 24)
					| (pmbus_buffer[16] << 16) | (pmbus_buffer[17] << 8)
					| pmbus_buffer[18];

			UserData.Calibration.E_Meter.iin_slope = iin_slope;
			UserData.Calibration.E_Meter.iin_slope_shift = iin_slope_shift;
			UserData.Calibration.E_Meter.iin_offset = iin_offset;
			UserData.Calibration.E_Meter.iin_offset_shift = iin_offset_shift;

			PS.IIN1_CALIBRATED = 1;
		}
	} else {
		//Error Handling
	}
}

void CMD_GEN_CAL_W_Handler(void) {
	Uint8 type;
	Uint8 isNeedToWrite = 0;

	type = pmbus_buffer[2];
	switch (type) {
	case CAL_VIN:
		CalibrateVIN(CAL_VIN);
#if 0
		isNeedToWrite = 1;
#else
		isNeedToWrite = 0;
#endif
		break;
	case CAL_IIN:
		//return;
		break;
	case CAL_CLEAR_ALL:
		UserData.Calibration.E_Meter.vin_slope = 1024;
		UserData.Calibration.E_Meter.vin_slope_shift = 0;
		UserData.Calibration.E_Meter.vin_offset = 0;
		UserData.Calibration.E_Meter.vin_offset_shift = 0;
		UserData.Calibration.E_Meter.iin_slope = 1024;
		UserData.Calibration.E_Meter.iin_slope_shift = 0;
		UserData.Calibration.E_Meter.iin_offset = 0;
		UserData.Calibration.E_Meter.iin_offset_shift = 0;

		PS.IIN1_CALIBRATED = 0;
		isNeedToWrite = 1;
		break;
	case CAL_CLEAR_VIN:
		UserData.Calibration.E_Meter.vin_slope = 1024;
		UserData.Calibration.E_Meter.vin_slope_shift = 0;
		UserData.Calibration.E_Meter.vin_offset = 0;
		UserData.Calibration.E_Meter.vin_offset_shift = 0;
		PS.VIN_CALIBRATED = 0;
		break;
	case CAL_CLEAR_IIN:
		UserData.Calibration.E_Meter.iin_slope = 1024;
		UserData.Calibration.E_Meter.iin_slope_shift = 0;
		UserData.Calibration.E_Meter.iin_offset = 0;
		UserData.Calibration.E_Meter.iin_offset_shift = 0;
		PS.IIN1_CALIBRATED = 0;
		//isNeedToWrite = 1;
		break;
	case CAL_IIN_1:
		CalibrateIIN(CAL_IIN_1);
		isNeedToWrite = 1;
		break;
	default:
		//return;
		break;
	}

	/*
	 //debug
	 gPmbusCmd.GEN_CAL_W[0] = pmbus_buffer[1];
	 gPmbusCmd.GEN_CAL_W[1] = pmbus_buffer[2];
	 gPmbusCmd.GEN_CAL_W[2] = pmbus_buffer[3];
	 gPmbusCmd.GEN_CAL_W[3] = pmbus_buffer[4];
	 gPmbusCmd.GEN_CAL_W[4] = pmbus_buffer[5];
	 gPmbusCmd.GEN_CAL_W[5] = pmbus_buffer[6];
	 gPmbusCmd.GEN_CAL_W[6] = pmbus_buffer[7];
	 */
	//RefreshAllCaliInfo();
	if (isNeedToWrite == 1) {
		//Flash need to be written
		SaveCalibrationDataToFlash();
		//PS.FlashWriteCalibration = 1;
	}

}

void main() {
	MiscAnalogRegs.IOMUX.all = 0; //enable JTAG
	MiscAnalogRegs.IOMUX.bit.JTAG_DATA_MUX_SEL = 1;
	MiscAnalogRegs.GLBIOEN.bit.DPWM3A_IO_EN = 1;
	MiscAnalogRegs.GLBIOOE.bit.DPWM3A_IO_OE = 0;

	//Check to see if PWM3A is pulled low, or flash trim checksum is bad, if yes then go to ROM. if no then go to flash.
	if ((MiscAnalogRegs.GLBIOREAD.bit.DPWM3A_IO_READ == 0)
			|| (PMBusRegs.PMBCTRL1.bit.SLAVE_ADDR == 0x7e)) {
		pmbus_write_rom_mode();
	}

	look_for_interrupted_dflash_erase(); //Check to see if the last DFLASH erase was interrupted

	pmbus_write_restore_default_all(); //load PFC configuration from data flash

	ReadCalibration();

	CheckInputCaliData();

	init_miscellaneous();
	MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 1;//[Ken Zhang]for test timing
	init_adc_polled();

	init_uart();

	init_front_ends();

	init_dpwms();

	init_filters();

	init_loop_mux();

	init_fault_mux();

	init_timer_interrupt();
	MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 0;//[Ken Zhang]for test timing
	init_pmbus();
#if AUTOBAUD_SUPPORT
	//Initialize TCAP
	init_TCAP();
#endif

	for (;;) {
//		MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 0;

		e_metering();
//		MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 0;
		pmbus_handler();

		voltage_feed_forward();

		pmbus_handler();

		dynamic_system_optimization();

		pmbus_handler();

		if (erase_segment_counter > 0) {
			erase_task();	//  Handle the DFlash segment erases
		}

		pmbus_handler();

		if (uart_tx_timeout >= UART_TX_TIME) {
			output_primary_secondary_message();
		} else {
			process_uart_rx_data();
		}
#if AUTOBAUD_SUPPORT
		//Match baud
		match_baud(pulse_width);
#endif
		pmbus_handler();

		if (bufferRX.S2P.status.bit.Standby_mode != 1) {
#if !Temperature_sense_share_vbus
			if(iv.adc_avg[VBUS_CHANNEL] >= VBUS_POWER_GOOD_ON) //if Vbus voltage is good
#else
			//			if((iv.vbus_avg >= VBUS_POWER_GOOD_ON)&&(iv.vbus_target == iv.vbus_setpoint)) //if Vbus voltage is good
			if ((iv.vbus_avg >= VBUS_POWER_GOOD_ON)
					&& (vbus_mode == VBUS_MODE_410)) //if Vbus voltage is good
#endif
					{
//						if(iv.interrupt_counter_10 > 200) //20ms
//						{
				MiscAnalogRegs.GLBIOVAL.bit.ALERT_IO_VALUE = 0; //active low for PFCOK_IN
//							MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 0;
//							iv.interrupt_counter_10 =0;
				vbus_ok = 1;
//						}
//						else
//						{
//							iv.interrupt_counter_10 ++;
//						}
			}
#if(DC_INPUT_ADJUST_VOLTAGE_SUPPORT==1)
			//			else if((iv.vbus_avg >= VBUS_POWER_GOOD_OFF)&&((iv.vbus_target == dc_ac_half_load_rampdown_voltage)||(iv.vbus_target == VBUS_RAMP_VOLTAGE_3)))
			else if ((iv.vbus_avg >= VBUS_POWER_GOOD_OFF)
					&& ((vbus_mode == VBUS_MODE_350)
							|| (vbus_mode == VBUS_MODE_390)))
#else
					else if((iv.vbus_avg >= VBUS_POWER_GOOD_OFF)&&((iv.vbus_target == VBUS_RAMP_VOLTAGE_1)||(iv.vbus_target == VBUS_RAMP_VOLTAGE_3)))
#endif
					{
//						if(iv.interrupt_counter_11 > 200) //20ms
//						{
				MiscAnalogRegs.GLBIOVAL.bit.ALERT_IO_VALUE = 0; //active low for PFCOK_IN
				//					MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 0;
//							iv.interrupt_counter_11 =0;
				vbus_ok = 1;
//						}
//						else
//						{
//							iv.interrupt_counter_11 ++;
//						}
			}
		}

		pmbus_handler();

		if (bufferRX.S2P.status.bit.Standby_mode == 1) {
			MiscAnalogRegs.GLBIOVAL.bit.ALERT_IO_VALUE = 1;
		}
		pmbus_handler();
//			if(iv.vbus_target == VBUS_RAMP_VOLTAGE_1)//350V
		if (vbus_mode == VBUS_MODE_350) {
#if(DC_INPUT_ADJUST_VOLTAGE_SUPPORT==1)
#if !Temperature_sense_share_vbus
			if(iv.adc_raw[VBUS_CHANNEL] <= dc_ac_half_load_vbus_good_off)//add hysterisis
#else
			if (iv.vbus_raw <= dc_ac_half_load_vbus_good_off)
#endif
#else
#if !Temperature_sense_share_vbus
			if(iv.adc_raw[VBUS_CHANNEL] <= VBUS_POWER_GOOD_OFF_320)//add hysterisis
#else
			if(iv.vbus_raw <= VBUS_POWER_GOOD_OFF_320)
#endif
#endif
			{
				MiscAnalogRegs.GLBIOVAL.bit.ALERT_IO_VALUE = 1;	//output high for Vbus not ok
				vbus_ok = 0;
			}
		}
//			else if(iv.vbus_target == VBUS_RAMP_VOLTAGE_3)//351V
		else if (vbus_mode == VBUS_MODE_390) {
#if !Temperature_sense_share_vbus
			if(iv.adc_raw[VBUS_CHANNEL] <= VBUS_POWER_GOOD_OFF_320)//add hysterisis
#else
			if (iv.vbus_raw <= VBUS_POWER_GOOD_OFF_320)
#endif
			{
				MiscAnalogRegs.GLBIOVAL.bit.ALERT_IO_VALUE = 1;	//output high for Vbus not ok
//					MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 1;
				vbus_ok = 0;
			}
		}
//			else if(iv.vbus_target == iv.vbus_setpoint)//410V
		else if (vbus_mode == VBUS_MODE_410) {
#if !Temperature_sense_share_vbus
			if(iv.adc_raw[VBUS_CHANNEL] <= VBUS_POWER_GOOD_OFF)//add hysterisis
#else
			if (iv.vbus_raw <= VBUS_POWER_GOOD_OFF)
#endif
			{
				MiscAnalogRegs.GLBIOVAL.bit.ALERT_IO_VALUE = 1;	//output high for Vbus not ok
//					MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 1;
				vbus_ok = 0;
				//			MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 0;
			}
		} else {
#if !Temperature_sense_share_vbus
			if(iv.adc_raw[VBUS_CHANNEL] <= VBUS_POWER_GOOD_OFF)//add hysterisis
#else
			if (iv.vbus_raw <= VBUS_POWER_GOOD_OFF)
#endif
			{
				MiscAnalogRegs.GLBIOVAL.bit.ALERT_IO_VALUE = 1;	//output high for Vbus not ok
//						MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 1;
				vbus_ok = 0;
				//			MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 0;
			}
		}
		pmbus_handler();
//		MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 0;
	}
}

//#pragma INTERRUPT(c_int00,RESET)     // CCS 5.4 and up will give a compile time error for interrupt handlers not compiled in ARM mode

void c_int00(void) {
	main();
}

