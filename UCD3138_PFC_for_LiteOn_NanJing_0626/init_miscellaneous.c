//init_miscellaneous

#include "include.h"  

void init_pmbus(void)
{
	int32 pmbus_address = 0x58;
	//pmbus initialization code.  Much of this is unnecessary after a reset, but is put
	//in for completeness, and in case code is entered after some other program uses
	//PMBus interface

	PMBusRegs.PMBINTM.all = 0x1FF; //disable all PMBus interrupts
	PMBusRegs.PMBCTRL2.all = PMBCTRL2_HALF0_PEC_ENA 
							 + pmbus_address 
							 + PMBCTRL2_HALF0_SLAVE_ADDRESS_MASK_DISABLE
							 + PMBCTRL2_ALL_RX_BYTE_ACK_CNT; 
	pmbus_state = PMBUS_STATE_IDLE;  //initialize state to no message in progress 

}

void init_adc_polled(void) 
{
	AdcRegs.ADCCTRL.bit.MAX_CONV = NUMBER_OF_ADC_CHANNELS_ACTIVE - 1; 

   	AdcRegs.ADCCTRL.bit.SAMPLING_SEL = 6;//268KS/s

	PMBusRegs.PMBCTRL3.bit.IBIAS_A_EN = 0;//disable current source
    PMBusRegs.PMBCTRL3.bit.IBIAS_B_EN = 0;

//for IPM board#1 (modified)
//L-customer
    //adc00 Vac_L
    //adc01 T_PRI
    //adc02 IIN_SENSE (meter)
    //adc03 PFC_OUT (Vbus)	ACOMP-B for OV
    //adc04 Vac_N
    //adc06 Temp_Ex
    //adc13 IPFC_DET (CBC)	ACOMP-E for OC
    //EAP0	IPFC_DET (Close Loop)
	AdcRegs.ADCSEQSEL0.bit.SEQ0 = 3; //Vbus
	AdcRegs.ADCSEQSEL0.bit.SEQ1 = 0; //Vac_L
	AdcRegs.ADCSEQSEL0.bit.SEQ2 = 4; //Vac_N
	AdcRegs.ADCSEQSEL0.bit.SEQ3 = 2; //Iac
//	AdcRegs.ADCSEQSEL1.bit.SEQ4 = 1; //T_PRI
//	AdcRegs.ADCSEQSEL1.bit.SEQ5 = 6; //Temp_Ex


	AdcRegs.ADCCTRL.bit.SINGLE_SWEEP = 1; //single sweep conversion
	AdcRegs.ADCCTRL.bit.BYPASS_EN = 3; //bypass adc02
	AdcRegs.ADCSEQSEL0.bit.SEQ2_SH = 1;//Vac_N dual sampling with Iac
	AdcRegs.ADCSEQSEL0.bit.SEQ1_SH = 0;//Vac_L not dual sampling with Iac
#if !Temperature_sense_share_vbus
	AdcRegs.ADCAVGCTRL.bit.AVG0_CONFIG = 0; //4x averaging for vout
//	AdcRegs.ADCAVGCTRL.bit.AVG1_CONFIG = 0; //4x averaging for vin 
//	AdcRegs.ADCAVGCTRL.bit.AVG2_CONFIG = 0; //4x averaging for vin
//	AdcRegs.ADCAVGCTRL.bit.AVG3_CONFIG = 0; //4x averaging for Iac

	AdcRegs.ADCAVGCTRL.bit.AVG0_EN = 1;  //enable averaging
//	AdcRegs.ADCAVGCTRL.bit.AVG1_EN = 1;  //enable averaging
//	AdcRegs.ADCAVGCTRL.bit.AVG2_EN = 1;  //enable averaging
//	AdcRegs.ADCAVGCTRL.bit.AVG3_EN = 1;  //enable averaging
#endif
	AdcRegs.ADCCTRL.bit.ADC_EN = 1;
	AdcRegs.ADCCTRL.bit.SW_START = 1; //trigger sweep
	AdcRegs.ADCCTRL.bit.SW_START = 0; //clear trigger - required 
}

void init_fault_mux(void)
{
	volatile int32 temp;

    // Enable ACOMP-E pin and connect to current limit on DPWM-1
    FaultMuxRegs.DPWM1CLIM.bit.ACOMP_E_EN = 1;           // Connect ACOMP-E to DPWM-1 current limit input
    FaultMuxRegs.ACOMPCTRL2.bit.ACOMP_E_SEL = 0;         // Use threshold register for trip
    FaultMuxRegs.ACOMPCTRL2.bit.ACOMP_E_POL = 1;         // Above thresh to trip
    FaultMuxRegs.ACOMPCTRL2.bit.ACOMP_E_THRESH = OC_COMPARATOR; 	// Trip value (127 = 2.5V)

    // Enable ACOMP-B pin and connect to DPWM-1 for Vbus OV protection
    FaultMuxRegs.DPWM1FAULTDET.bit.PWMA_ACOMP_B_EN = 1;       // Connect ACOMP-B to DPWM-1 Bus OV limit input
    FaultMuxRegs.ACOMPCTRL0.bit.ACOMP_B_SEL = 0;         // Use threshold register for trip
    FaultMuxRegs.ACOMPCTRL0.bit.ACOMP_B_POL = 1;         // Above thresh to trip
    FaultMuxRegs.ACOMPCTRL0.bit.ACOMP_EN = 1;           // Global enable to start all ACOMPS (REQUIRED)
}

void init_timer_interrupt(void)
{
	TimerRegs.T16PWM0CMP0DAT.all = 390;  //approx 50KHz. by spec//15.6MHz/312=50kHz//[Ken Zhang]change to 40kHz,25us
	TimerRegs.T16PWM0CMP1DAT.all = 0xffff;
	TimerRegs.T16PWM0CMPCTRL.all = 2;
	TimerRegs.T16PWM0CNTCTRL.all = 0x00c;

	disable_fast_interrupt(); //make sure fast interrupt is disabled
	disable_interrupt();
	write_firqpr (0x02000000); //make them all irqs except FAULT_INT  
	write_reqmask(0x02020000); //enable FAULT_INT and PWM0_INT 
	enable_interrupt();
	enable_fast_interrupt(); //make sure fast interrupt is enabled for OVP shutdown
}

void init_miscellaneous(void)
{
	iv.cir_buff_ptr = 0;
	iv.emi_buff_delay = 9;

	iv.ramp_up_step = 118;//720;//0x50; //slow ramp up//[Ken Zhang]change to 118,20150408
	iv.interrupt_counter_1 = 0;
	iv.supply_state = STATE_IDLE;
	status_1.bits.dither_enabled = 0;

	iv.i_target_offset = 12;
	iv.sample_trigger_offset = 450;//450ns

	bufferTX.P2S.Header = 0xaa;
	bufferTX.P2S.command = 1;

	fw_revision[0] = '1';
	fw_revision[1] = '.';
	fw_revision[2] = '0';
	fw_revision[3] = '2';

	bufferTX.P2S.status.bit.PFC_DIS = 1;
#if(DC_INPUT_ADJUST_VOLTAGE_SUPPORT==1)
	dc_ac_half_load_rampdown_voltage = VBUS_RAMP_VOLTAGE_1;
//	ac_input = 0;
//	dc_input = 0;
#endif
//pin17/PWM3A 		for Backdoor
//pin18/PWM3B 		for relay
//pin19/PMBUS_ALERT	for PFCOK_IN
//pin20/PMBUS_CTRL	for ACOK_IN
	MiscAnalogRegs.GLBIOEN.bit.DPWM3A_IO_EN 	= 1;	//for backdoor
	MiscAnalogRegs.GLBIOEN.bit.DPWM3B_IO_EN 	= 1;	//for relay
	MiscAnalogRegs.GLBIOEN.bit.ALERT_IO_EN		= 1;	//for PFCOK_IN
	MiscAnalogRegs.GLBIOEN.bit.CONTROL_IO_EN	= 1;	//for ACOK_IN

	MiscAnalogRegs.GLBIOVAL.bit.DPWM3B_IO_VALUE	= 0;	//initial low for relay control
	MiscAnalogRegs.GLBIOVAL.bit.ALERT_IO_VALUE	= 1;	//initial high for PFCOK_IN, active low
	MiscAnalogRegs.GLBIOVAL.bit.CONTROL_IO_VALUE= 1;	//initial high for ACOK_IN, active low

	MiscAnalogRegs.GLBIOOE.bit.DPWM3B_IO_OE		= 1;	//for relay
	MiscAnalogRegs.GLBIOOE.bit.ALERT_IO_OE		= 1;	//for PFCOK_IN
	MiscAnalogRegs.GLBIOOE.bit.CONTROL_IO_OE	= 1;	//for ACOK_IN


	MiscAnalogRegs.GLBIOEN.bit.DPWM0A_IO_EN 	= 1;
	MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 0;
	MiscAnalogRegs.GLBIOOE.bit.DPWM0A_IO_OE		= 1;


	TimerRegs.WDCTRL.bit.CNT_RESET = 1;

	vbus_mode = VBUS_MODE_410;//default as 410
	brown_in_voltage = VAC_MIN_ON_PEAK;
	vin_min_on_sq_avg = VAC_MIN_ON_SQ_AVG;
	vin_min_off_sq_avg = VAC_MIN_OFF_SQ_AVG;
	vin_min_off = VAC_MIN_OFF;

	ext_temp1 = 0x030C;
	pri_temp1 = 0x030C;
//#1
//	iin_slope = 465;
//	iin_slope_shift = 7;
//	iin_offset = 124;
//	iin_offset_shift = 0;
//	vin_slope = 201;
//	vin_slope_shift = 11;
//	vin_offset = 0;
//	vin_offset_shift = 0;

//#6
//	iin_slope = 937;
//	iin_slope_shift = 8;
//	iin_offset = 182;
//	iin_offset_shift = 0;
//	vin_slope = 101;
//	vin_slope_shift = 10;
//	vin_offset = 0;
//	vin_offset_shift = 0;

//#3
//	iin_slope = 935;
//	iin_slope_shift = 8;
//	iin_offset = 702;
//	iin_offset_shift = 2;
//	vin_slope = 101;
//	vin_slope_shift = 10;
//	vin_offset = 0;
//	vin_offset_shift = 0;

//#5
//	iin_slope = 235;
//	iin_slope_shift = 6;
//	iin_offset = 731;
//	iin_offset_shift = 2;
//	vin_slope = 201;
//	vin_slope_shift = 11;
//	vin_offset = 0;
//	vin_offset_shift = 0;

//#8
//	iin_slope = 234;
//	iin_slope_shift = 6;
//	iin_offset = 727;
//	iin_offset_shift = 2;
//	vin_slope = 101;
//	vin_slope_shift = 10;
//	vin_offset = 0;
//	vin_offset_shift = 0;

//#4
//	iin_slope = 667;	0x00029B
//	iin_slope_shift = 7;	0x000007
//	iin_offset = 163;	0x0000A3
//	iin_offset_shift = 0;	0x000000
//	vin_slope = 101;	0x000065
//	vin_slope_shift = 10;	0x00000A
//	vin_offset = 0;		0x000000
//	vin_offset_shift = 0;	0x00000

	iin_slope = UserData.Calibration.E_Meter.iin_slope;
	iin_slope_shift = UserData.Calibration.E_Meter.iin_slope_shift;
	iin_offset = UserData.Calibration.E_Meter.iin_offset;
	iin_offset_shift = UserData.Calibration.E_Meter.iin_offset_shift;
	vin_slope = UserData.Calibration.E_Meter.vin_slope;
	vin_slope_shift = UserData.Calibration.E_Meter.vin_slope_shift;
	vin_offset = UserData.Calibration.E_Meter.vin_offset;
	vin_offset_shift = UserData.Calibration.E_Meter.vin_offset_shift;

	iv.ipm_buff_delay = 0;
	emi_capacitance = 5360;//the toal capaciatance of EMI filter(include the one right after bridge rectifier) in nF
	emi_resistance = 340;//the total resistance of EMI filter in mohm,Ernest20141202T1(170mohm*2)
	emi_discharge_resistance = 225;//discharge resistor in EMI filter in Kohm
	standard_int_freq = 80000;//Hz //20us

}
