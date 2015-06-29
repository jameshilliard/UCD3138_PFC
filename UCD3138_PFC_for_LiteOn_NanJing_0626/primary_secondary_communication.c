#include "include.h"

extern int8 flash_vrect_scaling_offset;

extern int32 flash_calibration_checksum;

extern Uint8 flash_vac_ov;
extern Uint8 flash_vac_uv;

extern Uint8 flash_over_temperature_limit;

//extern struct POWER_CALIBRATION flash_power_calibration;

void byte_out_pri_sec_com(Uint8 byte)
{
//	byte_out_0(byte);
	char_out_0(byte);
	uart_tx_checksum = uart_tx_checksum + byte;
}

Uint8 translate_nybble_in(Uint8 nyb)
{
	if((nyb >= '0') && (nyb <= '9'))
	{
		return nyb - '0';
	}
	else if((nyb >= 'a') && (nyb <= 'f'))
	{
		return nyb - 'a' + 10;
	}
	else if((nyb >= 'A') && (nyb <= 'F'))
	{
		return nyb - 'A' + 10;
	}
	else
	{
		return 0;
	}
}

void translate_text_to_raw(void)
{
	//translates text serial in buffer to raw one.
	int32 i; //loop counter, index into input array
	int32 j = 0;

	for(i = 0; i < (UART_BYTES *2);i++)
	{
		uart_rx_buf[j] = translate_nybble_in(uart_text_in_buf[i]) << 4; //high nybble
		i++;
		uart_rx_buf[j] = translate_nybble_in(uart_text_in_buf[i]) + uart_rx_buf[j]; //add in low nybble
		j++;
	}
}

int32 u_to_s(Uint8 u) //convert from unsigned to signed.
{
	if(u < 0x80)
	{
		return (int32) u;
	}
	else
	{
		return (int32) ((int32)u - 0x100);
	}
}
/*
void store_calibration_data(void)
{
	adc_overall.vac_uv = uart_rx_buf[1] + 45;
	adc_overall.vac_ov = uart_rx_buf[2] + 45;
	adc_overall.over_temperature_limit = uart_rx_buf[3] - 50;
	ram_power_calibration.coef_a = u_to_s(uart_rx_buf[4]);
	ram_power_calibration.coef_b = u_to_s(uart_rx_buf[5]);
	ram_power_calibration.coef_c = u_to_s(uart_rx_buf[6]);
	ram_power_calibration.coef_d = u_to_s(uart_rx_buf[7]);
	ram_vrect_scaling_offset = u_to_s(uart_rx_buf[8]);
}
void output_ram_calibration_data(void)
{
	decimal_out_4_digits(adc_overall.vac_ov);
	decimal_out_4_digits(adc_overall.vac_uv);
	decimal_out_4_digits(adc_overall.over_temperature_limit);
	decimal_out_4_digits(ram_power_calibration.coef_a);
	decimal_out_4_digits(ram_power_calibration.coef_b);
	decimal_out_4_digits(ram_power_calibration.coef_c);
	decimal_out_4_digits(ram_power_calibration.coef_d);
	decimal_out_4_digits(ram_vrect_scaling_offset);
	crlf_out();
}

void flash_wait(void)
{
	while(DecRegs.DFLASHCTRL.bit.BUSY != 0)
	{
		; //do nothing while it programs or erases
	}
}

void write_calibration_data(void)
{
	erase_data_flash_segment(63); //calibration segment
	flash_wait();
	write_data_flash_word((Uint32 *) &flash_vrect_scaling_offset,
										(ram_vrect_scaling_offset << 24) |
										(((adc_overall.vac_ov) - 45) << 16) |
										(((adc_overall.vac_uv) - 45) << 8) |
										((adc_overall.over_temperature_limit + 50)& 0xff));
	flash_wait();
	{
		union PC_U
		{
			Uint32 all;
			struct POWER_CALIBRATION pc;
		};

		union PC_U pc_u;

		pc_u.pc = ram_power_calibration;

		write_data_flash_word((Uint32 *) &flash_power_calibration, pc_u.all);
	}

	flash_wait();
	write_data_flash_word((Uint32 *) &flash_calibration_checksum,
							 				ram_vrect_scaling_offset  +
											((adc_overall.vac_ov) - 45) +
							 				((adc_overall.vac_uv) - 45)  +
											(adc_overall.over_temperature_limit + 50) + 
											ram_power_calibration.coef_a +
											ram_power_calibration.coef_b +
											ram_power_calibration.coef_c +
											ram_power_calibration.coef_d);
	flash_wait();
}
void expand_vac_calibration_data(void)
{
	int32 vac_calibration_scaled;  //offset as a Q15 number

	vac_calibration_scaled = (ram_vrect_scaling_offset * 419430) >> 15;
	//convert from +-5% in 8 bits to Q15 equivalent
	//419430 = (.05/128)*2**15*2**15

	vac_scaling_hyperterminal = (65932 * (32768 + vac_calibration_scaled)) >> 15;
	//multiply nominal scaler by 1 + offset in Q15
	vac_scaling_pri_sec = (6593 * (32768 + vac_calibration_scaled)) >> 15;
	//multiply nominal scaler by 1 + offset in Q15
}
void expand_power_calibration_data(void)
{
	int32 offset_difference;  //difference between 110 and 220 volt offsets
	int32 offset_220;

	twenty_percent_110_offset = (ram_power_calibration.coef_a * PIN_CAL_OFFSET_MULTIPLIER)
									 >> PIN_CAL_OFFSET_SHIFT;
	 //calculate 20% slope
	 offset_220 = (ram_power_calibration.coef_c * PIN_CAL_OFFSET_MULTIPLIER) 
	 					>> PIN_CAL_OFFSET_SHIFT;
	 offset_difference = (offset_220 - twenty_percent_110_offset) << 14;
	 //make it a Q14 number
	twenty_percent_slope = offset_difference / 1100;
	//divide by 1100 because difference is 110 volts, 
	//but calculations are done in tenths of volts
	seventy_five_percent_110_offset = (ram_power_calibration.coef_b * PIN_CAL_OFFSET_MULTIPLIER)
	                                      >> PIN_CAL_OFFSET_SHIFT;
	 //calculate 20% slope
	 offset_220 = (ram_power_calibration.coef_d * PIN_CAL_OFFSET_MULTIPLIER) 
	 					>> PIN_CAL_OFFSET_SHIFT;
	 offset_difference = (offset_220 - seventy_five_percent_110_offset) << 14;
	 //make it a Q14 number
	seventy_five_percent_slope = offset_difference / 1100;
	//divide by 1100 because difference is 110 volts, 
	//but calculations are done in tenths of volts

}
void expand_calibration_data(void)
{
	expand_power_calibration_data();
	expand_vac_calibration_data();
}

void get_calibration_from_flash(void)
{
	if(flash_calibration_checksum == (flash_vrect_scaling_offset +
										flash_over_temperature_limit +
										flash_vac_ov +
										flash_vac_uv +
										flash_power_calibration.coef_a +
										flash_power_calibration.coef_b +
										flash_power_calibration.coef_c +
										flash_power_calibration.coef_d)) //check checksum
	{

		adc_overall.vac_ov = flash_vac_ov + 45; //put offset back in.
		adc_overall.vac_uv = flash_vac_uv + 45; //put offset back in.
		adc_overall.over_temperature_limit = flash_over_temperature_limit - 50; //put offset back in.

		ram_power_calibration = flash_power_calibration;
		ram_vrect_scaling_offset = flash_vrect_scaling_offset;
		expand_calibration_data();
	}
	else  //put in defaults - most are zero, so already OK
	{
		adc_overall.vac_ov = 240;
		adc_overall.vac_uv = 90;
		adc_overall.over_temperature_limit = 125;
	}

}
*/

//process received data from UART
void process_uart_rx_data(void)
{
#if 1
//	string_out_0("process_uart_rx_data");
	if(uart_rx_data_rdy == 1) //if received a new data packet
	{
//		string_out_0("uart_rx_data_rdy");
		int32 checksum, i;
		checksum = 0;
		for(i=0; i<(UART_BYTES-1); i++)  //calculate checksum
		{
			checksum += uart_text_in_buf[i];
		}
		checksum = checksum &0xff;
		checksum = 0x100 - checksum;
		if((uart_text_in_buf[0]==0xAA)&&(checksum == uart_text_in_buf[UART_BYTES-1])) //process received data if checksum is correct and header is correct
		{
			bufferRX.S2P.Header 	= uart_text_in_buf[0]; //this should be no need copy again
			bufferRX.S2P.status.all = uart_text_in_buf[1];
			bufferRX.S2P.command 	= uart_text_in_buf[2];
			bufferRX.S2P.data[0] 	= uart_text_in_buf[3];
			bufferRX.S2P.data[1] 	= uart_text_in_buf[4];
			bufferRX.S2P.checksum 	= uart_text_in_buf[5]; //this should be no need copy again
			switch(bufferRX.S2P.command)
			{
				case 1://Output Current
					output_current = (bufferRX.S2P.data[1]<<8 ) + bufferRX.S2P.data[0] ;
					break;
				case 2://Standby Output Current
					standby_output_current = (bufferRX.S2P.data[1]<<8 ) + bufferRX.S2P.data[0] ;
					break;
				case 3://Vac from meter IC
					vac_from_meter_ic = (bufferRX.S2P.data[0]<<8 ) + bufferRX.S2P.data[1] ;
					break;
				case 4://Reserved
					break;
				default:
					break;
			}
		}
		else
		{
//			string_out_0("receive wrong data");
			for(i=0; i<(UART_BYTES-1); i++)  //calculate checksum
			{
				uart_rx_buf_err[i] = uart_text_in_buf[i];
			}

		}
		uart_rx_data_rdy = 0; //clear flag, now it's ready to receive next data packet
	}
#else
	if(uart_rx_data_rdy == 1) //if received a new data packet
	{
		int32 checksum, i;

		translate_text_to_raw(); 

		checksum = 0;
		for(i=0; i<(UART_BYTES-1); i++)  //calculate checksum
		{
			checksum += uart_rx_buf[i];
		}

		if((checksum & 0xff) == uart_rx_buf[UART_BYTES-1]) //process received data if checksum is correct
		{
/*			if((uart_rx_buf[0]) ==1) //if calibration mode
			{
				store_calibration_data();
				expand_calibration_data();
			}
			else if((uart_rx_buf[0]) ==3) //if write calibration data to flash mode
			{
				write_calibration_data();
				status_1.bits.calibrating = 1; //acknowledge that it's calibrated.
			}
			else //here for run mode messages
*/			{
				if((uart_rx_buf[0] & 0x80) == 0x80) //if program flash programming mode
				{
					disable_fast_interrupt();
					disable_interrupt();

					//turn off all PWM outputs
					Dpwm1Regs.DPWMCTRL1.bit.GPIO_B_VAL = 0;//drive low
					Dpwm2Regs.DPWMCTRL1.bit.GPIO_B_VAL = 0;//drive low
					Dpwm1Regs.DPWMCTRL1.bit.GPIO_B_EN = 1;//turn off phase 1
					Dpwm2Regs.DPWMCTRL1.bit.GPIO_B_EN = 1;//turn off phase 2.

				//	reflash(); //does not return, but goes to reset after flash is programmed.
				}
				else
				{
					union STATUS_1 new_status_1;

					new_status_1.all = uart_rx_buf[0]; //put new status data into status union.
				
					status_1.bits.pout_mode = new_status_1.bits.pout_mode; 

					if(new_status_1.bits.dither_enabled != status_1.bits.dither_enabled) 
					{
						status_1.bits.dither_enabled = new_status_1.bits.dither_enabled;
						set_new_switching_frequency();//move back to center frequency in case we have stopped dither
					}

					if(new_status_1.bits.sleep_mode != status_1.bits.sleep_mode) 
					{
						;//put code here to handle sleep mode on/off
						status_1.bits.sleep_mode = new_status_1.bits.sleep_mode;
					}

					if(new_status_1.bits.burst_mode != status_1.bits.burst_mode) 
					{
						;//put code here to handle burst mode on/off
						status_1.bits.burst_mode = new_status_1.bits.burst_mode;
					}

					if(new_status_1.bits.phase_a_off != status_1.bits.phase_a_off) //if phase_a_off changed
					{
						;//here to handle phase a on/off
						status_1.bits.phase_a_off = new_status_1.bits.phase_a_off;
					}

#if(pfc_type == 0)//if interleaved PFC
					if(new_status_1.bits.phase_b_off != status_1.bits.phase_b_off) //if phase_b_off changed
					{
						status_1.bits.phase_b_off = new_status_1.bits.phase_b_off;

						if(new_status_1.bits.phase_b_off == 1)//if phase_b is now off 
						{	
					  		Dpwm2Regs.DPWMCTRL1.bit.GPIO_B_EN = 1;//turn off phase 2
						}
						else //if phase b is now on
						{	
							Dpwm2Regs.DPWMCTRL1.bit.GPIO_B_EN = 0;//turn on phase 2
						}
					}
#endif
						
					if((uart_rx_buf[2] + SWITCH_FREQ_OFFSET) != switching_frequency) //if new switching frequency
					{
						if(((uart_rx_buf[2] + SWITCH_FREQ_OFFSET) >= MIN_SWITCH_FREQ) &&
						  ((uart_rx_buf[2] + SWITCH_FREQ_OFFSET) <= MAX_SWITCH_FREQ))
						{
							switching_frequency = uart_rx_buf[2] + SWITCH_FREQ_OFFSET;
							set_new_switching_frequency();
						}
					}

					if((uart_rx_buf[1] + 200) != iv.vbus_voltage) //if new vbus voltage
					{
						if(((uart_rx_buf[1] + 200) >= 300) &&
						  ((uart_rx_buf[1] + 200) <= 400))
						  //if desired bus voltage is within range.
						{
							iv.vbus_voltage = uart_rx_buf[1] + 200;
							iv.vbus_target = ((int32)((iv.vbus_voltage * 4096)/VBUS_FULL_RANGE));
							//VBUS_FULL_RANGE is full range voltage, 4096 is full range on ADC
						}
					}
				}
			}
		}

		uart_rx_data_rdy = 0; //clear flag, now it's ready to receive next data packet
	}
#endif
}
/*
void output_ram_calibration_values(void)
{
	decimal_out(twenty_percent_110_offset); //offset of efficiency at 20 percent power, 110 Vin
	decimal_out(twenty_percent_slope); //slope of efficiency variation at 20 percent power.

	decimal_out(seventy_five_percent_110_offset); //offset of efficiency at 70 percent power, 110 Vin
	decimal_out(seventy_five_percent_slope); //slope of efficiency variation at 70 percent power.

	crlf_out();

//	decimal_out(vac_scaling_hyperterminal);
//	decimal_out(vac_scaling_pri_sec);

//	decimal_out(flash_vrect_scaling_offset);

//	nybble_out_space(status_1.bits.dither_enabled);
//	nybble_out_space(status_1.bits.phase_b_off);
//	decimal_out_4_digits(switching_frequency);
//	decimal_out_4_digits(vbus_voltage);
}

void running_calibration_message_test(void)
{
	int32 i;

	if(uart_rx_data_rdy == 0)
	{
		nybble_out_space(uart_rx_data_rdy);
		byte_out_space(uart_rx_buf_ptr);

		for(i =0;i < uart_rx_buf_ptr; i++)
		{
			char_out(uart_text_in_buf[i]);
		}
		char_out('\r');
	}
	else
	{
		crlf_out();
		process_uart_rx_data();
		output_ram_calibration_values();
		crlf_out();
		output_primary_secondary_message();

	}
}

void test_calibration_message(void)
{
	int32 i; //loop counter

	crlf_out();


	decimal_out(flash_vrect_scaling_offset);

	decimal_out_4_digits(flash_vac_ov);
	decimal_out_4_digits(flash_vac_uv);
	decimal_out_4_digits(flash_over_temperature_limit);

	decimal_out(flash_calibration_checksum);

	crlf_out();
	decimal_out(twenty_percent_110_offset); //offset of efficiency at 20 percent power, 110 Vin
	decimal_out(twenty_percent_slope); //slope of efficiency variation at 20 percent power.

	decimal_out(seventy_five_percent_110_offset); //offset of efficiency at 70 percent power, 110 Vin
	decimal_out(seventy_five_percent_slope); //slope of efficiency variation at 70 percent power.

	decimal_out_4_digits(adc_overall.vac_ov);
	decimal_out_4_digits(adc_overall.vac_uv);
	decimal_out_4_digits(adc_overall.over_temperature_limit);
	crlf_out();
	decimal_out_4_digits(switching_frequency);
	decimal_out_4_digits(vbus_voltage);
	byte_out(status_1.all);
	crlf_out();
	output_ram_calibration_data();
	for(;;)
	{
		while(uart_rx_data_rdy == 0)
		{
			nybble_out_space(uart_rx_data_rdy);
			byte_out_space(uart_rx_buf_ptr);

			for(i =0;i < uart_rx_buf_ptr; i++)
			{
				char_out(uart_text_in_buf[i]);
			}
			char_out('\r');
		}
		crlf_out();
		nybble_out_space(uart_rx_data_rdy);

		process_uart_rx_data();

		nybble_out_space(uart_rx_data_rdy);
		byte_out_space(uart_rx_buf_ptr);

		for(i = 0;i < 22; i++)
		{
			char_out(uart_text_in_buf[i]);
		}
		crlf_out();
		output_ram_calibration_data();
		for(i = 0;i < 10; i++)
		{
			byte_out(uart_rx_buf[i]);
		}
		crlf_out();

		decimal_out(flash_vrect_scaling_offset);

		decimal_out_4_digits(flash_vac_ov);
		decimal_out_4_digits(flash_vac_uv);
		decimal_out_4_digits(flash_over_temperature_limit);

		decimal_out(flash_calibration_checksum);

		crlf_out();
		decimal_out(twenty_percent_110_offset); //offset of efficiency at 20 percent power, 110 Vin
		decimal_out(twenty_percent_slope); //slope of efficiency variation at 20 percent power.

		decimal_out(seventy_five_percent_110_offset); //offset of efficiency at 70 percent power, 110 Vin
		decimal_out(seventy_five_percent_slope); //slope of efficiency variation at 70 percent power.

		decimal_out_4_digits(adc_overall.vac_ov);
		decimal_out_4_digits(adc_overall.vac_uv);
		decimal_out_4_digits(adc_overall.over_temperature_limit);
		crlf_out();
		decimal_out_4_digits(switching_frequency);
		decimal_out_4_digits(vbus_voltage);
		byte_out(status_1.all);
		crlf_out();
		pmbus_handler();
	}
}
*/
inline void float_to_L11(float input_val)
{
	// set exponent to -16
	int exponent = -16;
	// extract mantissa from input value
	mantissa =(int)(input_val *65536);
	// Search for an exponent that produces
	// a valid 11-bit mantissa
	do
	{
		if((mantissa >= -1024) &&(mantissa <= 1023))
		{
			break; // stop if mantissa valid
		}
		exponent++;
//		mantissa =(int)(input_val / pow(2.0, exponent));
		if(exponent <= 0)
			mantissa = (mantissa+1) >> 1;
		else
			mantissa = mantissa << 1;
	} while (exponent < 15);
	// Format the exponent of the L11
	uExponent = exponent << 11;
	// Format the mantissa of the L11
	uMantissa = mantissa & 0x07FF;
	// Compute value as exponent | mantissa
//	return uExponent | uMantissa;

}
void output_primary_secondary_message(void)
{
#if 1

	uart_tx_timeout = 0;
	uart_tx_checksum = 0;
#if 1
	byte_out_pri_sec_com(bufferTX.P2S.Header);
	byte_out_pri_sec_com((Uint8)bufferTX.P2S.status.all);
	byte_out_pri_sec_com(bufferTX.P2S.command);
	switch (bufferTX.P2S.command) //send slow data one byte at a time
	{
	case 1://Pri Temperature
#if 0
		//780 = 0x030C
		bufferTX.P2S.data[0] = 0x0C;
		bufferTX.P2S.data[1] = 0x03;
#else
		bufferTX.P2S.data[0] = (unsigned char)(pri_temp1 & 0x000000ff);
		bufferTX.P2S.data[1] = (unsigned char)((pri_temp1>>8) & 0x000000ff);
#endif
		break;
	case 2://Pri Major FW Rev
		bufferTX.P2S.data[0] = fw_revision[0] ;
		bufferTX.P2S.data[1] = fw_revision[1] ;
		break;
	case 3://Input Voltage Reporting
		float_to_L11(vin_rms);
		PMBUS_L11_Vin = uExponent | uMantissa;
#if(METER_DEBUG==1)
		if(PMBUS_L11_Vin & 0x0400)
		{
			L11_negative_flag = 1;
			MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 1;
			meter_l11.Vin = PMBUS_L11_Vin;
			meter_raw.Vin = vin_rms;
		}
#endif
		bufferTX.P2S.data[1] = (PMBUS_L11_Vin>>8)&0xff;
		bufferTX.P2S.data[0] = PMBUS_L11_Vin & 0xff;
		break;
	case 4://PFC Voltage Reporting
#if !Temperature_sense_share_vbus
//		pfc_voltage = iv.adc_avg[VBUS_CHANNEL] * VBUS_FULL_RANGE /4096;
		pfc_voltage = (iv.adc_avg[VBUS_CHANNEL] * VBUS_FULL_RANGE)>>12;
#else
//		pfc_voltage = iv.vbus_avg * VBUS_FULL_RANGE /4096;
		pfc_voltage = (iv.vbus_avg * VBUS_FULL_RANGE)>>12;
#endif
		bufferTX.P2S.data[1] = (pfc_voltage>>8)&0xff;
		bufferTX.P2S.data[0] = pfc_voltage&0xff;;
		break;
	case 5://Pri Minor FW Rev
		bufferTX.P2S.data[0] = fw_revision[2] ;
		bufferTX.P2S.data[1] = fw_revision[3] ;
		break;
	case 6://Pri Temperature (Exhaust)
#if 0
		//780 = 0x030C
		bufferTX.P2S.data[0] = 0x0C;
		bufferTX.P2S.data[1] = 0x03;
#else


		bufferTX.P2S.data[0] = (unsigned char)(ext_temp1 & 0x000000ff);
		bufferTX.P2S.data[1] = (unsigned char)((ext_temp1>>8) & 0x000000ff);
#endif
		break;
	case 7://Pri Bootloader Rev
		bufferTX.P2S.data[0] = 0;
		bufferTX.P2S.data[1] = 0;
		break;
	case 8://Input Current Reporting
		float_to_L11((float)iin_rms/1000);
		PMBUS_L11_Iin = uExponent | uMantissa;
#if(METER_DEBUG==1)
		if(PMBUS_L11_Iin & 0x0400)
		{
			L11_negative_flag = 1;
			MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 1;
			meter_l11.Iin = PMBUS_L11_Iin;
			meter_raw.Iin = iin_rms;
		}
#endif
		bufferTX.P2S.data[1] = (PMBUS_L11_Iin>>8)&0xff;
		bufferTX.P2S.data[0] = PMBUS_L11_Iin & 0xff;
		break;
	case 9://Input Power Reporting
		float_to_L11((float)pin/10);
		PMBUS_L11_Pin = uExponent | uMantissa;
#if(METER_DEBUG==1)
		if(PMBUS_L11_Pin & 0x0400)
		{
			L11_negative_flag = 1;
			MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 1;
			meter_l11.Pin = PMBUS_L11_Pin;
			meter_raw.Pin = pin;
		}
#endif
		bufferTX.P2S.data[1] = (PMBUS_L11_Pin>>8)&0xff;
		bufferTX.P2S.data[0] = PMBUS_L11_Pin & 0xff;
		break;
	case 10://Input Frquency Reporting
		bufferTX.P2S.data[1] = ((ac_frequency/10)>>8) & 0xff;//[Ken Zhang]ac_frequency need div 10
		bufferTX.P2S.data[0] = (ac_frequency/10) & 0xff;
		break;
	default:
		bufferTX.P2S.command = 0;
		break;
	}
	bufferTX.P2S.command++;
	if(bufferTX.P2S.command >10)
		bufferTX.P2S.command =1;
	byte_out_pri_sec_com(bufferTX.P2S.data[0]);
	byte_out_pri_sec_com(bufferTX.P2S.data[1]);


	uart_tx_checksum = uart_tx_checksum & 0x000000ff;
	uart_tx_checksum = 0x100-uart_tx_checksum;
	byte_out_pri_sec_com((Uint8)(uart_tx_checksum & 0xff));
//	char_out_0('\r');  //carriage return/linefeed to make it easier to read on hyperterminal
//	char_out_0('\n');
#endif
#else
	int32 vac;
	int32 iac; 
	int32 vbus;
	int32 pin_hold; //hold power in when sending it out slow, avoid changes between bytes
	int32 pout_hold; //hold power in when sending it out slow, avoid changes between bytes

	if(((status_1.bits.pout_mode) != (status_1_hold.bits.pout_mode)) && (primary_secondary_count == 12))
	//if pout mode changed, and we're sending second byte of pout/pin on slow rate
	{
		primary_secondary_count = 11; //restart sending of first byte instead
	}

	status_1_hold = status_1; //latch modes in case they change

	if((status_1_hold.bits.pout_mode) || (primary_secondary_count == 11)) //if they want pout, calculate it.
	{	
		pout_hold = (pin * 104858) >> 14;//don't have pout data, so use pin instead
	}
	
	if((!status_1_hold.bits.pout_mode) || (primary_secondary_count == 11)) //if they want pin, calculate it.
	{
		pin_hold = (pin * 104858) >> 14;
		//calculate this early so it won't delay in the middle of the transmission
		//scale from tenths of a watt to 1024 watts full range in 16 bits
		//(pin/10)*64,  a 1 in the uart data equals 1/64th W
	}	
/*
	vac = ((usqr_simple((iv.vin_squared_slow_average >> (VRECT_SQUARED_SLOW_AVERAGE_SHIFT - 9)),15) * VAC_FULL_RANGE) >> 12) - 45;
	//45 volts is subtracted from the VAC before it is transmitted
	//all voltages of 45 and below are sent as zero
		
	if(vac < 0)
	{
		vac = 0;
	}
	if(vac > 255)
	{
		vac = 255;
	}

	iac = (iin_rms * 1049) >> 15;//convert from thousandths of an amp to 32nd of an amp  1049 = (32/1000) * 32768
*/

//for APEC2014
	vac = iin_rms >> 8;
	iac = iin_rms & 0xFF;

	vbus = (((iv.vbus_filtered >> 6) * VBUS_FULL_RANGE) >> 12)- 200;
	//DC Bus voltage is the actual voltage on the DC bus - 200.  So any voltages below 200 will also be described as 0

	if(vbus < 0)
	{
		vbus = 0;
	}		
	   
	uart_tx_timeout = 0;
	uart_tx_checksum = 0;
	byte_out_pri_sec_com(status_0.all); //status 0
	byte_out_pri_sec_com(status_1.all); //status 1
	status_1.bits.calibrating = 0;  //clear calibrating bit, so we only acknowledge it once.
	byte_out_pri_sec_com(vac); //Vac
//	debug_buffer[0] = vac;
	byte_out_pri_sec_com(iac); //Iac
//	debug_buffer[1] = iac;
	if(status_1_hold.bits.pout_mode)
	{
		byte_out_pri_sec_com((pout_hold & 0xff00) >> 8); //Po high byte
		byte_out_pri_sec_com(pout_hold & 0xff); //Po low byte
	}
	else //put out pin instead
	{
		byte_out_pri_sec_com((pin_hold & 0xff00) >> 8); //Pin high byte
		byte_out_pri_sec_com(pin_hold & 0xff); //Pin low byte
//		debug_buffer[2] = (pin_hold & 0xff00) >> 8;
//		debug_buffer[3] = pin_hold & 0xff;
	}

	byte_out_pri_sec_com(vbus); //DC Bus voltage
//	debug_buffer[4] = vbus;
	byte_out_pri_sec_com(primary_secondary_count);
	switch (primary_secondary_count) //send slow data one byte at a time
	{
		case 0: 
			byte_out_pri_sec_com(switching_frequency - SWITCH_FREQ_OFFSET); //PFC switching frequency
			break;
		case 1: 
			byte_out_pri_sec_com(0); //temperature
			break;
		case 2: 
			byte_out_pri_sec_com(0); //VAC_UV
			break;
		case 3: 
			byte_out_pri_sec_com(0); //VAC_OV
			break;
		case 4: 
			byte_out_pri_sec_com(0); //over temperature limit
			break;
		case 5:
			{
				int32 vbus_voltage_temp;
				if(iv.vbus_voltage > 200)
				{
					vbus_voltage_temp = 0;
				}
				else
				{
					vbus_voltage_temp = iv.vbus_voltage - 200;
				}
				 
				byte_out_pri_sec_com(vbus_voltage_temp); //over temperature limit
			}
			break;
		case 6:
			byte_out_pri_sec_com(0); 
			break;
		case 7:
			byte_out_pri_sec_com(0); 
			break;
		case 8:
			byte_out_pri_sec_com(0); 
			break;
		case 9:
			byte_out_pri_sec_com(0); 
			break;
		case 10:
			byte_out_pri_sec_com(0);
			break;
		case 11:
			if(status_1_hold.bits.pout_mode) //put out other power on slow channel
			//so if it's pout mode, pin goes on slow channel, and vice versa.
			{
				byte_out_pri_sec_com((pin_hold & 0xff00) >> 8); //Pin high byte
			}
			else //put out pout instead
			{
				byte_out_pri_sec_com((pout_hold & 0xff00) >> 8); //Pout high byte
			}

			break;
		case 12:
			if(status_1_hold.bits.pout_mode)
			{
				byte_out_pri_sec_com(pin_hold & 0xff); //Pi low byte
			}
			else //put out pout instead
			{
				byte_out_pri_sec_com(pout_hold & 0xff); //Po low byte
			}
			break;
		case 13: 
			byte_out_pri_sec_com(debug_buffer[0]); 
			break;
		case 14: 
			byte_out_pri_sec_com(debug_buffer[1]); 
			break;
		case 15: 
			byte_out_pri_sec_com(debug_buffer[2]); 
			break;
		case 16: 
			byte_out_pri_sec_com(debug_buffer[3]); 
			break;
		case 17: 
			byte_out_pri_sec_com(debug_buffer[4]); 
			break;
		case 18: 
			byte_out_pri_sec_com(debug_buffer[5]); 
			break;
		case 19: 
			byte_out_pri_sec_com(debug_buffer[6]); 
			break;
		case 20: 
			byte_out_pri_sec_com(debug_buffer[7]); 
			primary_secondary_count = -1;
			break;
		default:
			primary_secondary_count = -1;
			break;
	}
	primary_secondary_count++;
	byte_out_pri_sec_com((Uint8)(uart_tx_checksum & 0xff)); 
	char_out_1('\r');  //carriage return/linefeed to make it easier to read on hyperterminal
	char_out_1('\n'); 
#endif
}
