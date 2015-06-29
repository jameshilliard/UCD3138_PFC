//standard_interrupt.c

#include "include.h"  
void preset_filter1(signed int preset_value)
{
	 LoopMuxRegs.SAMPTRIGCTRL.bit.FE0_TRIG_DPWM1_EN = 0;
	 Filter1Regs.FILTERPRESET.all = (1 << 27) + (1 << 24) + preset_value;
	 LoopMuxRegs.SAMPTRIGCTRL.bit.FE0_TRIG_DPWM1_EN = 1;
}
#if AUTOBAUD_SUPPORT
/* standard_interrupt.c
* measure_baud is called inside of the
* handle_standard_interrupt_global_tasks functions
* it measures the pulse width of the incoming
* signal from the UART on the PFC
*/
void measure_baud(void)
{
	T24SREG = TimerRegs.T24CAPCTRL.bit.CAP_INT_FLAG;
	if ((T24SREG == 1) && (edge == 0))		//first edge detected
	{
		result = TimerRegs.T24CAPDAT.bit.CAP_DAT;		//read and clear
		edge = 1;														//increase edge to capture second edge
	}
	else if ((T24SREG == 1) && (edge == 1)) 		//second edge detected
		{
			result = TimerRegs.T24CAPDAT.bit.CAP_DAT - result;
	//result now contains the difference between edges captured
			pulse_width = result;													//store result into pulse_width - will be passed into match_baud();
			edge = 0;														//reset edge to detect first edge again
		}
		else
		{
		}
	}
#endif
inline void clear_negative_accumulators(void)
{
	iv.negative_cycle_counter = 0;
	iv.negative_vin_squared_accumulate = 0;
}

inline void clear_positive_accumulators(void)
{
	iv.positive_cycle_counter = 0;
	iv.positive_vin_squared_accumulate = 0;
}

inline void store_negative_cycle_values(void)
{
#ifdef AC_DROP_OPTIMIZATION
	if((iv.ac_drop)&&(iv.supply_state == STATE_PFC_ON))
	{
		Uint32 temp_vin_squared_average;
		temp_vin_squared_average = iv.negative_vin_squared_accumulate / iv.negative_cycle_counter;
		iv.vin_squared_for_ac_drop = temp_vin_squared_average;
	}
	else
#endif
	{
	iv.vin_squared_average = iv.negative_vin_squared_accumulate / iv.negative_cycle_counter;
	iv.vin_squared_for_ac_drop = iv.vin_squared_average;
	iv.half_cycle_counter_filtered = iv.negative_cycle_counter + iv.half_cycle_counter_filtered - (iv.half_cycle_counter_filtered >> 6);
}
}

inline void store_positive_cycle_values(void)
{
#ifdef AC_DROP_OPTIMIZATION
	if((iv.ac_drop)&&(iv.supply_state == STATE_PFC_ON))
	{
		Uint32 temp_vin_squared_average;
		temp_vin_squared_average = iv.positive_vin_squared_accumulate / iv.positive_cycle_counter;
		iv.vin_squared_for_ac_drop = temp_vin_squared_average;
	}
	else
#endif
	{
	iv.vin_squared_average = iv.positive_vin_squared_accumulate / iv.positive_cycle_counter;
	iv.vin_squared_for_ac_drop = iv.vin_squared_average;
	iv.half_cycle_counter_filtered = iv.positive_cycle_counter + iv.half_cycle_counter_filtered - (iv.half_cycle_counter_filtered >> 6);
}
}

inline void accumulate_negative_cycle_values()
{
	iv.negative_vin_squared_accumulate = (iv.vin_squared >> 9) + iv.negative_vin_squared_accumulate;
}

inline void accumulate_positive_cycle_values()
{
	iv.positive_vin_squared_accumulate = (iv.vin_squared >> 9) + iv.positive_vin_squared_accumulate;
}

inline half_cycle_processing() //processing that syncs with AC signal to filter it out.
{		
	if(iv.positive == 1)
	{
		iv.positive_cycle_counter++;
		if((iv.positive_cycle_counter == 2) && (iv.negative_cycle_counter >= 20))
		//if it really is a positive cycle and not a glitch, handle previous negative cycle results
		//if they are valid
		{
//			iv.sequence_to_change = 1;
			store_negative_cycle_values();
			clear_negative_accumulators();
#if(DC_INPUT_ADJUST_VOLTAGE_SUPPORT==1)
			dc_input = 0;
			ac_input = 1;
#endif
		}
		else if (iv.positive_cycle_counter > 2)
		{
			clear_negative_accumulators();  //to deal with possible negative glitches
			if (iv.positive_cycle_counter >= 150)
			{//here if pulse too long, most likely DC input, just take what we've got and start over
				store_positive_cycle_values();
				clear_positive_accumulators();
#if(DC_INPUT_ADJUST_VOLTAGE_SUPPORT==1)
				dc_input = 1;
				ac_input = 0;
#endif
			}				
		}
		accumulate_positive_cycle_values();
	}
	else 
	{
		iv.negative_cycle_counter++;
		if((iv.negative_cycle_counter == 2) && (iv.positive_cycle_counter >= 20))
		//if it really is a negative cycle, handle previous positive cycle
		//if it was valid
		{
//			iv.sequence_to_change = 2;
			store_positive_cycle_values();
			clear_positive_accumulators();
#if(DC_INPUT_ADJUST_VOLTAGE_SUPPORT==1)
			dc_input = 0;
			ac_input = 1;
#endif
		}
		else if (iv.negative_cycle_counter > 2)
		{
			clear_positive_accumulators();

			if (iv.negative_cycle_counter >= 150)
			{//here if pulse too long, most likely DC input, just take what we've got and start over
				store_negative_cycle_values();
				clear_negative_accumulators();
#if(DC_INPUT_ADJUST_VOLTAGE_SUPPORT==1)
				dc_input = 1;
				ac_input = 0;
#endif
			}				
		}
		accumulate_negative_cycle_values();
	}
}

inline int32 proportional_integral(int32 error) //error is difference between ADC value and target output voltage
{
	int32 output, steady_state_error;

	if( abs(error) < iv.pis.nl_threshold) //if error in steady state range
	{
		steady_state_error = iv.vbus_target - (iv.vbus_filtered >> 6);
		iv.pis.p = iv.pis.kp * steady_state_error;//Q15*Q12
  		iv.pis.i = iv.pis.i + (iv.pis.ki * steady_state_error);//Q27+Q15*Q12
	}
	else
	{	//non-linear gain for Voltage loop
#ifdef AC_DROP_OPTIMIZATION
		if(!iv.ac_drop_recovery_not_complete)
#endif//AC_DROP_OPTIMIZATION
		{
			iv.pis.p = iv.pis.kp_nl * error;//Q15*Q12
			iv.pis.i = iv.pis.i + (iv.pis.ki_nl * error);

			if(error < 0 && iv.pis.i>0)
			{
				iv.pis.i = iv.pis.i/2;
			}
		}
	}

//	if(iv.ac_drop_recovery_not_complete)
	{
//		if(((error < 0) && (iv.pis.i > 0)) || ((error > 0) && (iv.pis.i < 0)))
//    	{
//        	iv.pis.i = 0;//reset the integral just when AC voltage has restored
//			//iv.ac_drop_recovery_not_complete = 0;//AC drop recovery completed
//    	}
		if((iv.vbus_setpoint<(iv.vbus_avg-10*4095/VBUS_FULL_RANGE) && iv.pis.i>0) || ((iv.vbus_setpoint-10*4095/VBUS_FULL_RANGE)>iv.vbus_avg && iv.pis.i<0)){
			iv.pis.i=0;
		}
	}

	if(iv.pis.i > PI_I_HIGH_LIMIT)
	{
		iv.pis.i = PI_I_HIGH_LIMIT;
	}
	else if	(iv.pis.i < PI_I_LOW_LIMIT)
	{
		iv.pis.i = PI_I_LOW_LIMIT;
	}

	output = (iv.pis.p + iv.pis.i) >> 12; //scale for Q15 numbers from Q15 coefficients and a Q12 error from ADC

	if(output > PI_OUTPUT_HIGH_LIMIT)
	{
		output = PI_OUTPUT_HIGH_LIMIT;
	}
	else if	(output < PI_OUTPUT_LOW_LIMIT)
	{
		output = PI_OUTPUT_LOW_LIMIT;
	}

	iv.pis.output = output;

	return output;//Q15
}

inline void calculate_current_target_shunt(void)
{
	iv.i_target_sensed = ((iv.cir_buff[iv.emi_pointer] * iv.i_target_average) >> 16) + iv.i_target_offset;//Q12/Q14 >> 16 = Q10

	if((iv.vbus_setpoint-155)<iv.vbus_raw){//[Ken Zhang]Vbus>setpoint-20=390

		if(iv.i_target_sensed > SATURATE_CURRENT_LIMIT){ //saturate current target at maximum current
			iv.i_target_sensed = SATURATE_CURRENT_LIMIT;
		}
	}
	else{
		if(iv.i_target_sensed > 0x2ff){ //saturate current target at maximum current
			iv.i_target_sensed = 0x2ff;
		}
	}


	FeCtrl0Regs.EADCDAC.bit.DAC_VALUE = iv.i_target_sensed << 4; //disregard dithering bits.
}

inline void handle_voltage_loop(void)
{
#ifndef VOLTAGE_LOOP_DISABLE
	#ifdef AC_DROP_OPTIMIZATION
	if((iv.ac_drop)&&(iv.supply_state == STATE_PFC_ON))
	{
		;
	}
	else
	#endif
	{
		if (xflag)
		{
			iv.pis.i = 0;
			iv.i_target_average = 0;
			iv.i_target_offset = 0;
		}
		else
		{
#if !Temperature_sense_share_vbus
	iv.i_target_average = ((iv.vff_multiplier >> 5) * 
						proportional_integral((int32)iv.vbus_target - (int32)iv.adc_raw[VBUS_CHANNEL])) >> 11;//Q10*Q15>>11 = Q14
#else
		iv.i_target_average = ((iv.vff_multiplier >> 5) *
						proportional_integral((int32)iv.vbus_target - (int32)iv.vbus_avg)) >> 11;//Q10*Q15>>11 = Q14
#endif
		}
	}
#endif
}

inline void rectify_vac(void)
{
	if(iv.adc_raw[AC_L_CHANNEL] > iv.adc_raw[AC_N_CHANNEL] )//this is the cycle for line
	{
		iv.vin_raw = iv.adc_raw[AC_L_CHANNEL] - iv.adc_raw[AC_N_CHANNEL];
		iv.positive = 1;
	}
	else //cycle for neutral
	{
		iv.vin_raw = iv.adc_raw[AC_N_CHANNEL] - iv.adc_raw[AC_L_CHANNEL];	
		iv.positive = 0;
	}

	iv.vin_sum = iv.vin_raw + iv.vin_sum - (iv.vin_sum >> 2);
	iv.vin_average = iv.vin_sum >> 2;


	if((iv.supply_state == STATE_IDLE) && (iv.vin_peak < iv.vin_average ))
	{
		iv.vin_peak = iv.vin_average ;
	}
}

inline void check_ac_drop(void)
{
#ifdef AC_DROP_OPTIMIZATION

	if((!iv.ac_drop)&&(iv.ac_drop_recovery_not_complete))
	{
		ac_recover_counter ++;
		if(ac_recover_counter > 300) //wait for 30ms
		{
			ac_recover_counter = 0;
			iv.ac_drop_recovery_not_complete = 0;
//			MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 1;
		}
	}
	if((iv.supply_state == STATE_PFC_ON)&&(iv.ac_drop))
	{
		; //do nothing
	}
	else
#endif
	{
	iv.vin_squared_slow_average = iv.vin_squared_slow_average + (iv.vin_squared >> 9)-
									(iv.vin_squared_slow_average >> VRECT_SQUARED_SLOW_AVERAGE_SHIFT); 
									//Q15 + shift of 15 gives Q30
	}
	if(iv.vin_average > AC_DROP_V_RECT_THRESHOLD)
	{
		iv.ac_drop_count = 0; //if over threshold, clear counter
		iv.ac_drop_continue_count = 0;
		iv.ac_drop_continue = 0;
	}
	else
	{
		iv.ac_drop_count++;
		iv.ac_drop_continue_count++;
		if(iv.ac_drop_continue_count >500) //>50ms, it is not cycle drop
		{
			iv.ac_drop_continue = 1;
			iv.ac_drop = 0;
			iv.ac_drop_recovery_not_complete = 0;
			Filter1Regs.FILTERCTRL.bit.KI_STALL = 0;
			//AC dissapear, should go to idle state
			//
		}
		if((iv.ac_drop_count > AC_DROP_COUNT_MAX)&& (iv.ac_drop_continue == 0))
		{
			#ifdef AC_DROP_OPTIMIZATION
			if((iv.supply_state == STATE_PFC_ON)&&(!iv.ac_drop))
			{
				Filter1Regs.FILTERCTRL.bit.KI_STALL = 1;
				preset_filter1((0x7fffff >> 6)); //preset duty to current loop[Ken Zhang] preset duty 1.5%£¬1/2^6=1/64
			}
			#endif

			MiscAnalogRegs.GLBIOVAL.bit.CONTROL_IO_VALUE = 1;//active high for AC NON OK
			bufferTX.P2S.status.bit.INPUT_OK = 0;
			iv.ac_drop = 1;
			iv.ac_drop_recovery_not_complete = 1;
			iv.vin_squared_for_ac_drop = 0;//clear for ac recovery detection
		}
	}

	if(iv.vin_average > AC_DROP_V_RECT_THRESHOLD)//(iv.vin_squared_for_ac_drop > AC_UNDROPPED_THRESHOLD) //if above ac not dropped threshold
	{
	#ifdef AC_DROP_OPTIMIZATION
		if((iv.supply_state == STATE_PFC_ON)&&(iv.ac_drop)&&(iv.ac_drop_continue == 0))
		{
			Uint32 temp_preset;
			unsigned long long temp_vin, temp_vout;
			temp_vin = iv.vin_raw * 152;
#if !Temperature_sense_share_vbus
			temp_vout =  iv.adc_avg[VBUS_CHANNEL]*223;
#else
			temp_vout =  iv.vbus_avg*223;
#endif
			temp_preset = (Uint32)(((temp_vout - temp_vin)<<23)/temp_vout);
			Filter1Regs.FILTERCTRL.bit.KI_STALL = 0;
			preset_filter1(temp_preset); //calculate filter ki
#if !Temperature_sense_share_vbus
			iv.interrupt_counter_1 = iv.adc_avg[VBUS_CHANNEL] << 8;
#else
			iv.interrupt_counter_1 = iv.vbus_avg << 8;
#endif

			iv.ramp_up_step =80;//0x50;
			iv.supply_state = STATE_RAMP_UP;
		}
	#endif
		iv.ac_drop = 0;
	}
//	if((iv.vin_squared_for_ac_drop > AC_UNDROPPED_THRESHOLD)) //if above ac not dropped threshold
	if((iv.vin_squared_for_ac_drop > AC_UNDROPPED_THRESHOLD)&&bufferTX.P2S.status.bit.INPUT_OK==0) //[Ken Zhang] and for timer overflow issue
	{ 
		iv.interrupt_counter_6 ++;
		if(iv.interrupt_counter_6 > 650) //65ms
		{
			MiscAnalogRegs.GLBIOVAL.bit.CONTROL_IO_VALUE = 0;//active low for AC OK
			bufferTX.P2S.status.bit.INPUT_OK = 1;
			//iv.ac_drop = 0;  // we've got enough energy, clear AC drop warning
			iv.interrupt_counter_6 =0;
		}
	}
}

void poll_adc(void)
{
	if(AdcRegs.ADCSTAT.bit.ADC_INT == 1)//If the conversion is complete
	{
#if !Temperature_sense_share_vbus
		iv.adc_raw[0] = AdcRegs.ADCRESULT[0].bit.RESULT;
		if ((iv.ac_drop == 0) && (iv.adc_raw[VBUS_CHANNEL] > VBUS_DPWM_OFF_LEVEL))
		//if (iv.adc_raw[VBUS_CHANNEL] > VBUS_DPWM_OFF_LEVEL)
		{
			xflag = 1;
			iv.pis.i = 0;
			preset_filter1(0);
			// 2%
			Filter1Regs.FILTERYNCLPHI.all = 0x28F5C; 					
			turn_off_pfc();
			iv.supply_state = STATE_PFC_HICCUP;
		}		
		iv.adc_raw[1] = AdcRegs.ADCRESULT[1].bit.RESULT;
		iv.adc_raw[2] = AdcRegs.ADCRESULT[2].bit.RESULT;
		iv.adc_raw[3] = AdcRegs.ADCRESULT[3].bit.RESULT;

		//for voltage loop
		iv.adc_avg[VBUS_CHANNEL] = AdcRegs.ADCAVGRESULT[VBUS_CHANNEL].bit.RESULT;

		iv.interrupt_counter_2 ++;

		if(iv.interrupt_counter_2 == 50000)//1s
		{
			AdcRegs.ADCCTRL.bit.MAX_CONV = NUMBER_OF_ADC_CHANNELS_ACTIVE;//5 channels
			AdcRegs.ADCSEQSEL1.bit.SEQ4 = 6;
		}
		else if(iv.interrupt_counter_2 == 50001)//
		{
			iv.adc_temp_ex_raw = AdcRegs.ADCRESULT[4].bit.RESULT;
			ext_temp1 = iv.adc_temp_ex_raw>>2;
			AdcRegs.ADCCTRL.bit.MAX_CONV = NUMBER_OF_ADC_CHANNELS_ACTIVE - 1;//4 channels
		}
		else if(iv.interrupt_counter_2 == 100000)//2s
		{
			AdcRegs.ADCCTRL.bit.MAX_CONV = NUMBER_OF_ADC_CHANNELS_ACTIVE;//5 channels
			AdcRegs.ADCSEQSEL1.bit.SEQ4 = 1;
		}
		else if(iv.interrupt_counter_2 == 100001)//
		{
			iv.adc_t_pri_raw = AdcRegs.ADCRESULT[4].bit.RESULT;
			pri_temp1 = iv.adc_t_pri_raw>>2;
			AdcRegs.ADCCTRL.bit.MAX_CONV = NUMBER_OF_ADC_CHANNELS_ACTIVE - 1;//4 channels
			iv.interrupt_counter_2 = 0;
		}

		if(iv.sequence_to_change == 1)//this is line cycle
		{
			AdcRegs.ADCSEQSEL0.all = 0x02041003;
			iv.sequence_to_change = 0;
		}
		else if(iv.sequence_to_change == 2)//this is neutral cycle
		{
			AdcRegs.ADCSEQSEL0.all = 0x02140003;
			iv.sequence_to_change = 0;
		}

		AdcRegs.ADCCTRL.bit.SW_START = 1;  // trigger a new measurement sequence

		iv.vbus_filtered = iv.adc_raw[VBUS_CHANNEL] + iv.vbus_filtered - (iv.vbus_filtered >> 6);//Q18
#else
		iv.interrupt_counter_2 ++;

//				if(iv.sequence_to_change == 1)//this is line cycle
				{
					if(iv.interrupt_counter_2 == 50000)//1s
					{
						iv.vbus_raw = AdcRegs.ADCRESULT[0].bit.RESULT;
						AdcRegs.ADCSEQSEL0.all = 0x02041006;
					}
					else if(iv.interrupt_counter_2 == 100000)//2s
					{
						iv.vbus_raw = AdcRegs.ADCRESULT[0].bit.RESULT;
						AdcRegs.ADCSEQSEL0.all = 0x02041001;
					}
					else
					{
						AdcRegs.ADCSEQSEL0.all = 0x02041003;
					}
//					iv.sequence_to_change = 0;
				}
/*				else if(iv.sequence_to_change == 2)//this is neutral cycle
				{
					if(iv.interrupt_counter_2 == 50000)//1s
					{
						iv.vbus_raw = AdcRegs.ADCRESULT[0].bit.RESULT;
						AdcRegs.ADCSEQSEL0.all = 0x02140006;
					}
					else if(iv.interrupt_counter_2 == 100000)//2s
					{
						iv.vbus_raw = AdcRegs.ADCRESULT[0].bit.RESULT;
						AdcRegs.ADCSEQSEL0.all = 0x02140001;
					}
					else
					{
						AdcRegs.ADCSEQSEL0.all = 0x02140003;
					}
					iv.sequence_to_change = 0;
				}
				else
				{
					if(iv.interrupt_counter_2 == 50000)//1s
					{
						iv.vbus_raw = AdcRegs.ADCRESULT[0].bit.RESULT;
						AdcRegs.ADCSEQSEL0.all = 0x02041006;
					}
					else if(iv.interrupt_counter_2 == 100000)//2s
					{
						iv.vbus_raw = AdcRegs.ADCRESULT[0].bit.RESULT;
						AdcRegs.ADCSEQSEL0.all = 0x02041001;
					}
					else
					{
						AdcRegs.ADCSEQSEL0.all = 0x02041003;
					}
				}*/



				if(iv.interrupt_counter_2 == 50001)//
				{
					iv.adc_temp_ex_raw = AdcRegs.ADCRESULT[0].bit.RESULT;
					ext_temp1 = iv.adc_temp_ex_raw>>2;
				}
				else if(iv.interrupt_counter_2 == 100001)//
				{
					iv.adc_t_pri_raw = AdcRegs.ADCRESULT[0].bit.RESULT;
					pri_temp1 = iv.adc_t_pri_raw>>2;
					iv.interrupt_counter_2 = 0;
//					if(pri_temp1<t_pri_min) t_pri_min=pri_temp1;//[Ken Zhang] add for test Tpri bounce
				}
				else
				{
					iv.vbus_raw = AdcRegs.ADCRESULT[0].bit.RESULT;
				}
		if ((iv.ac_drop == 0) && (iv.vbus_raw > VBUS_DPWM_OFF_LEVEL))
		//if (iv.adc_raw[VBUS_CHANNEL] > VBUS_DPWM_OFF_LEVEL)
		{
			xflag = 1;
			iv.pis.i = 0;
			preset_filter1(0);
			// 2%
			Filter1Regs.FILTERYNCLPHI.all = 0x28F5C;
			turn_off_pfc();
			iv.supply_state = STATE_PFC_HICCUP;
//			MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 1;
		}
				iv.adc_raw[1] = AdcRegs.ADCRESULT[1].bit.RESULT;
				iv.adc_raw[2] = AdcRegs.ADCRESULT[2].bit.RESULT;
				iv.adc_raw[3] = AdcRegs.ADCRESULT[3].bit.RESULT;


				AdcRegs.ADCCTRL.bit.SW_START = 1;  // trigger a new measurement sequence

				iv.vbus_filtered = iv.vbus_raw + iv.vbus_filtered - (iv.vbus_filtered >> 6);//Q18
				iv.vbus_sum = iv.vbus_raw + iv.vbus_sum - (iv.vbus_sum >>2);	//Q14
				iv.vbus_avg = iv.vbus_sum >>2; //Q12
		
#endif
		//for EMI and IPM compensation
		iv.cir_buff[iv.cir_buff_ptr] = iv.vin_raw;
		iv.emi_pointer = (iv.cir_buff_ptr - iv.emi_buff_delay) & 0x3f; //get pointer to delayed signal
		iv.ipm_pointer = (iv.cir_buff_ptr - iv.ipm_buff_delay) & 0x3f; //get pointer to delayed signal
	    iv.cir_buff_ptr = (iv.cir_buff_ptr + 1) & 0x3f;
	}
//	//			if(iv.vbus_target == VBUS_RAMP_VOLTAGE_1)//350V
//				if(vbus_mode == VBUS_MODE_350)
//				{
//			#if !Temperature_sense_share_vbus
//					if(iv.adc_raw[VBUS_CHANNEL] <= VBUS_POWER_GOOD_OFF_320)//add hysterisis
//			#else
//					if(iv.vbus_raw <= VBUS_POWER_GOOD_OFF_320)
//			#endif
//					{
//						MiscAnalogRegs.GLBIOVAL.bit.ALERT_IO_VALUE	= 1;//output high for Vbus not ok
//						vbus_ok = 0;
//					}
//				}
//	//			else if(iv.vbus_target == VBUS_RAMP_VOLTAGE_3)//351V
//				else if(vbus_mode == VBUS_MODE_390)
//				{
//			#if !Temperature_sense_share_vbus
//					if(iv.adc_raw[VBUS_CHANNEL] <= VBUS_POWER_GOOD_OFF_320)//add hysterisis
//			#else
//					if(iv.vbus_raw <= VBUS_POWER_GOOD_OFF_320)
//			#endif
//					{
//						MiscAnalogRegs.GLBIOVAL.bit.ALERT_IO_VALUE	= 1;//output high for Vbus not ok
//						vbus_ok = 0;
//					}
//				}
//	//			else if(iv.vbus_target == iv.vbus_setpoint)//410V
//				else if(vbus_mode == VBUS_MODE_410)
//				{
//			#if !Temperature_sense_share_vbus
//					if(iv.adc_raw[VBUS_CHANNEL] <= VBUS_POWER_GOOD_OFF)//add hysterisis
//			#else
//					if(iv.vbus_raw <= VBUS_POWER_GOOD_OFF)
//			#endif
//					{
//						MiscAnalogRegs.GLBIOVAL.bit.ALERT_IO_VALUE	= 1;//output high for Vbus not ok
//						vbus_ok = 0;
//			//			MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 0;
//					}
//				}
//				else
//				{
//				#if !Temperature_sense_share_vbus
//						if(iv.adc_raw[VBUS_CHANNEL] <= VBUS_POWER_GOOD_OFF)//add hysterisis
//				#else
//						if(iv.vbus_raw <= VBUS_POWER_GOOD_OFF)
//				#endif
//						{
//							MiscAnalogRegs.GLBIOVAL.bit.ALERT_IO_VALUE	= 1;//output high for Vbus not ok
//							vbus_ok = 0;
//				//			MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 0;
//						}
//				}
}


inline void uart_receive_data(void)
{
	if(uart_tx_timeout <= UART_TX_TIME) //1000ms, count time since the last packet was sent
	{
		uart_tx_timeout++;
	}

	if(uart_rx_data_rdy == 0) //receive data, one byte a time
	{
		if(Uart0Regs.UARTRXST.bit.RX_RDY == 1)
		{
			uart_text_in_buf[uart_rx_buf_ptr] =  Uart0Regs.UARTRXBUF.bit.RXDAT; //read a byte and clear RX_RDY flag
			if((uart_rx_buf_ptr==0)&&(uart_text_in_buf[uart_rx_buf_ptr]!=0xAA))
			{
				uart_rx_buf_ptr =0;
				uart_rx_data_rdy =0;
			}
			else
			{
				uart_rx_buf_ptr ++; //point to next byte
			}
			uart_rx_timer = 0; 
			if(uart_rx_buf_ptr == UART_BYTES ) //received all bytes
			{
				uart_rx_buf_ptr = 0; //reset the pointer
				uart_rx_data_rdy = 1; //set flag to let background process received data
			}
		}
		else
		{
			uart_rx_timer ++;
//			if(uart_rx_timer > (UART_TX_TIME - 2000))//if we didn't receive data for more than 800ms, the data packet is invalid
			if(uart_rx_timer > 5000)//if we didn't receive data for more than 800ms, the data packet is invalid
			{
				uart_rx_buf_ptr = 0;
			}
		}
	}
}
inline void PMBusDebugHandle(){
//Variable init is put at init_pmbus()
	if(meDebug.dataLogSW){
	meDebug.freqDivCount++;
	if(meDebug.freqDivCount>meDebug.freqDivTop){
		meDebug.freqDivCount=0;
		if(meDebug.dataCnt<500){
			switch(meDebug.ptrSelectSW){
			case 0:
				meDebug.dataLog[meDebug.dataCnt]=iv.pis.output;
				break;
			case 1:
				meDebug.dataLog[meDebug.dataCnt]=iv.i_target_average;
				break;
			case 2:
				meDebug.dataLog[meDebug.dataCnt]=iv.i_target_sensed;
				break;
			case 3:
				meDebug.dataLog[meDebug.dataCnt]=iv.cir_buff[iv.emi_pointer];
				break;
			case 4:
				meDebug.dataLog[meDebug.dataCnt]=iv.vff_multiplier;
				break;
			default:
				meDebug.dataLog[meDebug.dataCnt]=iv.pis.output;
				meDebug.ptrSelectSW=0;
				break;
			}
			meDebug.dataCnt++;
		}else{
			meDebug.dataCnt=0;
			meDebug.dataLogSW=0;
		}
	}
	}
}
//inline void frequency_dithering(void)
//{
//	if(status_1.bits.dither_enabled == 1)
//	{
//		if(iv.dither_direction == 1)
//		{
//			iv.period_times_2_14 = iv.period_times_2_14 + iv.dither_step;
//			iv.switching_period = iv.period_times_2_14 >> 14;
//			if(iv.switching_period > iv.dither_max_period)
//			{
//				iv.switching_period = iv.dither_max_period;
//				iv.dither_direction = 0;
//			}
//		}
//		else //if dither direction equalled 0 to start with
//		{
//			iv.period_times_2_14 = iv.period_times_2_14 - iv.dither_step;
//			iv.switching_period = iv.period_times_2_14 >> 14;
//			if(iv.switching_period < iv.dither_min_period)
//			{
//				iv.switching_period = iv.dither_min_period;
//				iv.dither_direction = 1;
//			}
//		}
//
//		Dpwm1Regs.DPWMPRD.all = iv.switching_period; //new period for new frequency
//		Dpwm2Regs.DPWMPRD.all = iv.switching_period; //new period for new frequency
//
//		Dpwm1Regs.DPWMSAMPTRIG1.all = iv.switching_period - (iv.sample_trigger_offset * 4); // sample at the end of period
//		Dpwm1Regs.DPWMPHASETRIG.all = iv.switching_period >> 1; //50% delay for next phase
//	}
//}

void turn_on_pfc(void)
{
	Dpwm1Regs.DPWMCTRL1.bit.GPIO_A_EN = 0;//turn on phase 1
	bufferTX.P2S.status.bit.PFC_DIS = 0;
}

void turn_off_pfc(void)
{
	Dpwm1Regs.DPWMCTRL1.bit.GPIO_A_VAL = 0;//drive low
	Dpwm1Regs.DPWMCTRL1.bit.GPIO_A_EN = 1;//turn off phase 1
	LoopMuxRegs.GLBEN.all= 0;//disable all front end and DPWMs
	bufferTX.P2S.status.bit.PFC_DIS = 1;
}

inline void idle_state_handler(void)
{
//	MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 1;

	if(ac_input==1)
	{
		brown_in_voltage = VAC_MIN_ON_PEAK;
		vin_min_on_sq_avg = VAC_MIN_ON_SQ_AVG;
		vin_min_off_sq_avg = VAC_MIN_OFF_SQ_AVG;
		vin_min_off = VAC_MIN_OFF;
	}
	else if(dc_input==1)
	{
		brown_in_voltage = VDC_MIN_ON_PEAK;
		vin_min_on_sq_avg = VDC_MIN_ON_SQ_AVG;
		vin_min_off_sq_avg = VDC_MIN_OFF_SQ_AVG;
		vin_min_off = VDC_MIN_OFF;
	}
	else
	{
		brown_in_voltage = VAC_MIN_ON_PEAK;
		vin_min_on_sq_avg = VAC_MIN_ON_SQ_AVG;
		vin_min_off_sq_avg = VAC_MIN_OFF_SQ_AVG;
		vin_min_off = VAC_MIN_OFF;
	}
	if((iv.vin_peak > brown_in_voltage)&& (iv.ac_drop == 0))//if Vac above 87 volts
	{
#if(DC_INPUT_ADJUST_VOLTAGE_SUPPORT==1)
		if(ac_input==1)
		{
			dc_ac_half_load_rampdown_voltage = VBUS_RAMP_VOLTAGE_1;
			dc_ac_half_load_vbus_good_off = VBUS_POWER_GOOD_OFF_320;
		}
		else if(dc_input ==1)
		{
			dc_ac_half_load_rampdown_voltage = VBUS_RAMP_VOLTAGE_DC_1;
			dc_ac_half_load_vbus_good_off = VBUS_POWER_GOOD_OFF_DC_310;
		}
		else
		{
			dc_ac_half_load_rampdown_voltage = VBUS_RAMP_VOLTAGE_1;
			dc_ac_half_load_vbus_good_off = VBUS_POWER_GOOD_OFF_320;
		}
#endif
		MiscAnalogRegs.GLBIOVAL.bit.CONTROL_IO_VALUE = 0;//active low for ACOK_IN
		bufferTX.P2S.status.bit.INPUT_OK = 1;

		if((iv.vin_squared_average > vin_min_on_sq_avg))//if Vac above 90 volts
		{
			iv.interrupt_counter_1 ++; //count time
		}
		else
		{
			iv.interrupt_counter_1 = 0;
		}

		if(iv.interrupt_counter_1 >= 1300)//130ms
		{
/*			if((bufferRX.S2P.status.bit.PFC_DIS==1)&&(bufferRX.S2P.status.bit.Standby_mode==1)&&(iv.vin_squared_average > VAC_STANDBY_PFC_DIS))//||1)//[Ken Zhang] disable PFC
			{

			}
			else*/
			{
				MiscAnalogRegs.GLBIOVAL.bit.DPWM3B_IO_VALUE = 1;//turn on relay
				iv.interrupt_counter_1 = 0; //start delay for debounce

				iv.pis.kp =	0x20000;//[Ken Zhang] PI for startup
				iv.pis.ki = 0x35;
				iv.pis.kp_nl =	0x20000;
				iv.pis.ki_nl =	0x35;

				iv.supply_state = STATE_RELAY_BOUNCE;
				iv.vin_peak = 0;
			}
		}
	}
	else
	{
		MiscAnalogRegs.GLBIOVAL.bit.CONTROL_IO_VALUE = 1;//active high for AC NON OK
		bufferTX.P2S.status.bit.INPUT_OK = 0;
		if(iv.vin_squared_average <= VAC_MIN_RELAY_OFF_SQ_AVG)
		{
			iv.interrupt_counter_7++;
			if(iv.interrupt_counter_7 > 20)//2ms
			{
				MiscAnalogRegs.GLBIOVAL.bit.DPWM3B_IO_VALUE = 0;//turn off relay
				iv.interrupt_counter_7 = 0;
				vbus_ok = 0;
			}
		}
	}
}

inline void relay_bounce_state_handler(void)
{
	volatile int32 temp;

	if(iv.vin_squared_average > vin_min_on_sq_avg)//if Vac above 90 volts
	{
		iv.interrupt_counter_1 ++; //count time
	}
	else
	{
		iv.interrupt_counter_1 = 0;
	}
#if !Temperature_sense_share_vbus
	if((iv.interrupt_counter_1 >= 100)&&(iv.adc_avg[VBUS_CHANNEL] > VBUS_FEEDBACK_CHECK))//10ms
//	if(iv.adc_avg[VBUS_CHANNEL] > VBUS_FEEDBACK_CHECK)//if Vbus above 110V
	{
		iv.interrupt_counter_1 = iv.adc_avg[VBUS_CHANNEL] << 8; //ramp up starts from retified Vout
		iv.vbus_target = iv.adc_avg[VBUS_CHANNEL];
#else
	if((iv.interrupt_counter_1 >= 100)&&(iv.vbus_avg > VBUS_FEEDBACK_CHECK))//10ms
	{
		iv.interrupt_counter_1 = iv.vbus_avg << 8; //ramp up starts from retified Vout
		iv.vbus_target = iv.vbus_avg;
#endif
		iv.pis.i = 0;
		temp = FaultMuxRegs.FAULTMUXINTSTAT.all; //read to clear the interrupt flag
		FaultMuxRegs.ACOMPCTRL0.bit.ACOMP_B_INT_EN = 1;		//enable ACOMP-B interrupt
		LoopMuxRegs.GLBEN.all = 0x70F;//global enable all Front_ends and DPWMs

		turn_on_pfc();
		rampup_target = iv.vbus_setpoint;
		iv.supply_state = STATE_RAMP_UP;
	}
}

inline void ramp_up_state_handler(void)
{
	iv.interrupt_counter_1 = iv.interrupt_counter_1 + iv.ramp_up_step;
	if((iv.interrupt_counter_1 >> 8) >= rampup_target) //we've ramped to target
	{
		iv.vbus_target = rampup_target;
		if( iv.vbus_target > iv.vbus_avg)
		{
#if !Temperature_sense_share_vbus
			if((iv.vbus_target - iv.adc_avg[VBUS_CHANNEL])>72)//10V
#else
			if( iv.vbus_target > (iv.vbus_avg+72))//10V
#endif
			{
				iv.interrupt_counter_1 = iv.interrupt_counter_1 - iv.ramp_up_step;
			}
			else
			{

				iv.interrupt_counter_1 = 0;
				iv.ramp_up_step = 10; //slow ramp up
				softstart_flag = 1;
				rampup_notcomplete = 0;
				iv.supply_state = STATE_PFC_ON;
			}
		}
		else
		{
			iv.interrupt_counter_1 = 0;
			iv.ramp_up_step = 10; //slow ramp up
			softstart_flag = 1;//[Ken Zhang]add 20150527
			rampup_notcomplete = 0;
			iv.supply_state = STATE_PFC_ON;
		}
	}
	else
	{
		iv.vbus_target = iv.interrupt_counter_1 >> 8;
	}
}
				
inline void pfc_on_state_handler(void)
{
//	MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 0;
	if(pre_vbus_mode==VBUS_MODE_410)
	{
		vbus_mode =VBUS_MODE_410;
	}
	else if(pre_vbus_mode==VBUS_MODE_390)
	{
		vbus_mode=VBUS_MODE_390;
	}
	else if(pre_vbus_mode==VBUS_MODE_350)
	{
		vbus_mode=VBUS_MODE_350;
	}
	else if(pre_vbus_mode==VBUS_MODE_320)
	{
		vbus_mode=VBUS_MODE_320;
	}
	else
	{

	}

//	if(iv.vin_squared_average > VAC_MIN_OFF_SQ_AVG)//if Vac above 85 volts

//	if((iv.vin_squared_average > VAC_MIN_OFF_SQ_AVG)&&(iv.vin_average > VAC_MIN_OFF))//if Vac above 85 volts
	if((iv.vin_squared_average > vin_min_off_sq_avg)&&(iv.vin_average > vin_min_off)&&(bufferTX.P2S.status.bit.INPUT_OK == 1))//if Vac above 85 volts

//	if(iv.vin_average > VAC_MIN_OFF)
	{
		if(iv.vin_squared_average > VAC_STANDBY_PFC_DIS)
		{
			if((bufferRX.S2P.status.bit.PFC_DIS==1)&&(bufferRX.S2P.status.bit.Standby_mode==1))
			{
//				turn_off_pfc();
//				iv.interrupt_counter_3 = 0;
//				iv.supply_state = STATE_IDLE;
			}
		}

//		if(bufferRX.S2P.status.bit.Standby_mode!=1)
//		{
//#if !Temperature_sense_share_vbus
//			if(iv.adc_avg[VBUS_CHANNEL] >= VBUS_POWER_GOOD_ON) //if Vbus voltage is good
//#else
////			if((iv.vbus_avg >= VBUS_POWER_GOOD_ON)&&(iv.vbus_target == iv.vbus_setpoint)) //if Vbus voltage is good
//			if((iv.vbus_avg >= VBUS_POWER_GOOD_ON)&&(vbus_mode == VBUS_MODE_410)) //if Vbus voltage is good
//#endif
//			{
//				if(iv.interrupt_counter_10 > 200) //20ms
//				{
//					MiscAnalogRegs.GLBIOVAL.bit.ALERT_IO_VALUE	= 0;//active low for PFCOK_IN
//					MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 0;
//					iv.interrupt_counter_10 =0;
//					vbus_ok = 1;
//				}
//				else
//				{
//					iv.interrupt_counter_10 ++;
//				}
//			}
//#if(DC_INPUT_ADJUST_VOLTAGE_SUPPORT==1)
////			else if((iv.vbus_avg >= VBUS_POWER_GOOD_OFF)&&((iv.vbus_target == dc_ac_half_load_rampdown_voltage)||(iv.vbus_target == VBUS_RAMP_VOLTAGE_3)))
//			else if((iv.vbus_avg >= VBUS_POWER_GOOD_OFF)&&((vbus_mode == VBUS_MODE_350)||(vbus_mode == VBUS_MODE_390)))
//#else
//			else if((iv.vbus_avg >= VBUS_POWER_GOOD_OFF)&&((iv.vbus_target == VBUS_RAMP_VOLTAGE_1)||(iv.vbus_target == VBUS_RAMP_VOLTAGE_3)))
//#endif
//			{
//				if(iv.interrupt_counter_11 > 200) //20ms
//				{
//					MiscAnalogRegs.GLBIOVAL.bit.ALERT_IO_VALUE	= 0;//active low for PFCOK_IN
////					MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 0;
//					iv.interrupt_counter_11 =0;
//					vbus_ok = 1;
//				}
//				else
//				{
//					iv.interrupt_counter_11 ++;
//				}
//			}
//		}
		if(softstart_flag == 1)
		{
			iv.interrupt_counter_7++;
			if(iv.interrupt_counter_7 > 1000)//100ms
			{
				iv.pis.kp =	0x8000;//[Ken Zhang] 20150521
				iv.pis.ki = 0x080;
				softstart_flag = 0;
				iv.interrupt_counter_7 = 0;

			}
			else if(iv.interrupt_counter_7 > 800)//80ms
			{
				iv.pis.kp_nl =	0x20000;//180000;
				iv.pis.ki_nl =	0x0500;

			}
			else if(iv.interrupt_counter_7 > 400)//40ms
			{
//				iv.pis.kp =	0x10000;
//				iv.pis.ki = 0x050;
			}
		}

#if ADJUST_VOLTAGE_SUPPORT
		if(bufferRX.S2P.status.bit.Fixed_Bulk_voltage==0)
		{
//			if(iv.vbus_target == VBUS_RAMP_VOLTAGE_1) //350V
			if(vbus_mode == VBUS_MODE_350)
			{
				if( (iv.vin_squared_average > VAC_MIN_RAMPDOWN_SQ_AVG) && (iv.vin_squared_average < VAC_MAX_RAMPDOWN_SQ_AVG) )
				{

					if(bufferRX.S2P.status.bit.Standby_mode==0)
					{
				//if((output_current >= 0x00D2) || (output_current <= 0x008C)||((iv.vin_squared_average < VAC_MIN_RAMPDOWN_SQ_AVG) || (iv.vin_squared_average > VAC_MAX_RAMPDOWN_SQ_AVG))) //<40% or >60%
				//if((output_current >= IOUT_VALUE(60)) || (output_current <= IOUT_VALUE(40))||((iv.vin_squared_average < VAC_MIN_RAMPDOWN_SQ_AVG) || (iv.vin_squared_average > VAC_MAX_RAMPDOWN_SQ_AVG))) //Ernest20141121<40%(43.3A*0.4=17.32A) or >60%(43.3A*0.6=25.98A)
//				if((output_current >= IOUT_VALUE(60)) ||((iv.vin_squared_average < VAC_MIN_RAMPDOWN_SQ_AVG) || (iv.vin_squared_average > VAC_MAX_RAMPDOWN_SQ_AVG))) //Ernest20141121,>60%(43.3A*0.6=25.98A),Vin<100V or Vin>240V
						if((output_current >= IOUT_VALUE(60))) //Ernest20141121,>60%(43.3A*0.6=25.98A),Vin<100V or Vin>240V
						{
							if(iv.interrupt_counter_4 > 10000) //10000*100us = 1s
							{
								iv.interrupt_counter_4 = 0;
								iv.interrupt_counter_5 = 0;
								iv.interrupt_counter_8 = 0; //Ernest20141125T1
		//						iv.interrupt_counter_1 = VBUS_RAMP_VOLTAGE_1 << 8;
		#if !Temperature_sense_share_vbus
								iv.interrupt_counter_1 = iv.adc_avg[VBUS_CHANNEL] << 8;
		#else
								iv.interrupt_counter_1 = iv.vbus_avg << 8;
		#endif
								rampup_target = iv.vbus_setpoint; //410V

								pre_vbus_mode = VBUS_MODE_410;
								rampup_notcomplete = 1;
								iv.supply_state = STATE_RAMP_UP; //350V up to 410V
							}
							else
							{
								iv.interrupt_counter_4++;
								iv.interrupt_counter_5 = 0;
								iv.interrupt_counter_8 = 0;
							}
						}
						else if(output_current <= IOUT_VALUE(40)) //Ernest20141125T1<40%(43.3A*0.4=17.32A)
						{
							if(iv.interrupt_counter_8 > 10000) //10000*100us = 1s
							{
								iv.interrupt_counter_4 = 0;
								iv.interrupt_counter_5 = 0;
								iv.interrupt_counter_8 = 0; //Ernest20141125T1
		//						iv.interrupt_counter_1 = VBUS_RAMP_VOLTAGE_1 << 8;
		#if !Temperature_sense_share_vbus
								iv.interrupt_counter_1 = iv.adc_avg[VBUS_CHANNEL] << 8;
		#else
								iv.interrupt_counter_1 = iv.vbus_avg << 8;
		#endif
								rampup_target = VBUS_RAMP_VOLTAGE_3; //360V
								pre_vbus_mode = VBUS_MODE_390;
	//							vbus_mode=VBUS_MODE_390;
								rampup_notcomplete = 1;
								iv.supply_state = STATE_RAMP_UP; //350V up to 360V
							}
							else
							{
								iv.interrupt_counter_8++;
								iv.interrupt_counter_4 = 0;
								iv.interrupt_counter_5 = 0;
							}
						}
						else
						{
							iv.interrupt_counter_4 = 0;
							iv.interrupt_counter_5 = 0;
							iv.interrupt_counter_8 = 0; //Ernest20141125T1
						}
					}
					else if(bufferRX.S2P.status.bit.Standby_mode==1)
					{
	//					iv.interrupt_counter_1 = VBUS_RAMP_VOLTAGE_1 << 8;
	#if !Temperature_sense_share_vbus
							iv.interrupt_counter_1 = iv.adc_avg[VBUS_CHANNEL] << 8;
	#else
							iv.interrupt_counter_1 = iv.vbus_avg << 8;
	#endif
						rampdown_target = VBUS_RAMP_VOLTAGE_2;
//						MiscAnalogRegs.GLBIOVAL.bit.ALERT_IO_VALUE	= 1;//output high for Vbus not ok
//						MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 1;
						iv.ramp_up_step = 200; //fast ramp down
						pre_vbus_mode = VBUS_MODE_320;
						vbus_mode=VBUS_MODE_320;
						rampdown_notcomplete = 1;
						iv.supply_state = STATE_RAMP_DOWN;
						iv.interrupt_counter_4 = 0;
						iv.interrupt_counter_5 = 0;
						iv.interrupt_counter_8 = 0; //Ernest20141125T1
					}
				}
				else
				{
					if(iv.interrupt_counter_4 > 10000) //10000*100us = 1s
					{
						iv.interrupt_counter_4 = 0;
						iv.interrupt_counter_5 = 0;
						iv.interrupt_counter_8 = 0; //Ernest20141125T1
//						iv.interrupt_counter_1 = VBUS_RAMP_VOLTAGE_1 << 8;
#if !Temperature_sense_share_vbus
						iv.interrupt_counter_1 = iv.adc_avg[VBUS_CHANNEL] << 8;
#else
						iv.interrupt_counter_1 = iv.vbus_avg << 8;
#endif
						rampup_target = iv.vbus_setpoint; //410V
						pre_vbus_mode = VBUS_MODE_410;
						rampup_notcomplete = 1;
						iv.supply_state = STATE_RAMP_UP; //350V up to 410V
					}
					else
					{
						iv.interrupt_counter_4++;
						iv.interrupt_counter_5 = 0;
						iv.interrupt_counter_8 = 0;
					}
				}
			}
//			else if(iv.vbus_target == VBUS_RAMP_VOLTAGE_3) //360V,Ernest20141125T1
			else if(vbus_mode == VBUS_MODE_390)
			{
				if( (iv.vin_squared_average > VAC_MIN_RAMPDOWN_SQ_AVG) && (iv.vin_squared_average < VAC_MAX_RAMPDOWN_SQ_AVG) )
				{

					if(bufferRX.S2P.status.bit.Standby_mode==0)
					{
						if((output_current >= IOUT_VALUE(60)) ||((iv.vin_squared_average < VAC_MIN_RAMPDOWN_SQ_AVG) || (iv.vin_squared_average > VAC_MAX_RAMPDOWN_SQ_AVG))) //Ernest20141121,>60%(43.3A*0.6=25.98A),Vin<100V or Vin>240V
	//					if((output_current >= IOUT_VALUE(60))) //Ernest20141121,>60%(43.3A*0.6=25.98A),Vin<100V or Vin>240V
						{
							if(iv.interrupt_counter_4 > 10000) //10000*100us = 1s
							{
								iv.interrupt_counter_4 = 0;
								iv.interrupt_counter_5 = 0;
								iv.interrupt_counter_8 = 0; //Ernest20141125T1
		//						iv.interrupt_counter_1 = VBUS_RAMP_VOLTAGE_3 << 8;
		#if !Temperature_sense_share_vbus
								iv.interrupt_counter_1 = iv.adc_avg[VBUS_CHANNEL] << 8;
		#else
								iv.interrupt_counter_1 = iv.vbus_avg << 8;
		#endif
								rampup_target = iv.vbus_setpoint; //410V
								pre_vbus_mode = VBUS_MODE_410;
								rampup_notcomplete = 1;
								iv.supply_state = STATE_RAMP_UP; //360V up to 410V
							}
							else
							{
								iv.interrupt_counter_4++;
								iv.interrupt_counter_5 = 0;
								iv.interrupt_counter_8 = 0;
							}
						}
						else if(output_current >= IOUT_VALUE(45) && (output_current <= IOUT_VALUE(55))) //Ernest20141126T1,45%(43.3A*0.45=19.485A) - 55%(43.3A*0.55=23.815A)
						{
							if(iv.interrupt_counter_5 > 10000) //10000*100us = 1s
							{
								iv.interrupt_counter_4 = 0;
								iv.interrupt_counter_5 = 0;
								iv.interrupt_counter_8 = 0; //Ernest20141125T1
		//						iv.interrupt_counter_1 = VBUS_RAMP_VOLTAGE_3 << 8;
		#if !Temperature_sense_share_vbus
								iv.interrupt_counter_1 = iv.adc_avg[VBUS_CHANNEL] << 8;
		#else
								iv.interrupt_counter_1 = iv.vbus_avg << 8;
		#endif
	#if(DC_INPUT_ADJUST_VOLTAGE_SUPPORT==1)
							rampdown_target = dc_ac_half_load_rampdown_voltage; //350V
	#else
							rampdown_target = VBUS_RAMP_VOLTAGE_1; //350V
	#endif
								pre_vbus_mode = VBUS_MODE_350;
								vbus_mode=VBUS_MODE_350;
								rampdown_notcomplete = 1;
								iv.supply_state = STATE_RAMP_DOWN; //360V down to 350V
							}
							else
							{
								iv.interrupt_counter_5++;
								iv.interrupt_counter_4 = 0;
								iv.interrupt_counter_8 = 0;
							}
						}
						else
						{
							iv.interrupt_counter_4 = 0;
							iv.interrupt_counter_5 = 0;
							iv.interrupt_counter_8 = 0; //Ernest20141125T1
						}
					}
					else if(bufferRX.S2P.status.bit.Standby_mode==1)
					{
	//					iv.interrupt_counter_1 = VBUS_RAMP_VOLTAGE_1 << 8;
	//					iv.interrupt_counter_1 = VBUS_RAMP_VOLTAGE_3 << 8;
	#if !Temperature_sense_share_vbus
							iv.interrupt_counter_1 = iv.adc_avg[VBUS_CHANNEL] << 8;
	#else
							iv.interrupt_counter_1 = iv.vbus_avg << 8;
	#endif
						rampdown_target = VBUS_RAMP_VOLTAGE_2;
//						MiscAnalogRegs.GLBIOVAL.bit.ALERT_IO_VALUE	= 1;//output high for Vbus not ok
//						MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 1;
						iv.ramp_up_step = 200; //fast ramp down
						pre_vbus_mode = VBUS_MODE_320;
						vbus_mode=VBUS_MODE_320;
						rampdown_notcomplete = 1;
						iv.supply_state = STATE_RAMP_DOWN;
						iv.interrupt_counter_4 = 0;
						iv.interrupt_counter_5 = 0;
						iv.interrupt_counter_8 = 0; //Ernest20141125T1
					}
				}
				else
				{
					if(iv.interrupt_counter_4 > 10000) //10000*100us = 1s
					{
						iv.interrupt_counter_4 = 0;
						iv.interrupt_counter_5 = 0;
						iv.interrupt_counter_8 = 0; //Ernest20141125T1
//						iv.interrupt_counter_1 = VBUS_RAMP_VOLTAGE_1 << 8;
#if !Temperature_sense_share_vbus
						iv.interrupt_counter_1 = iv.adc_avg[VBUS_CHANNEL] << 8;
#else
						iv.interrupt_counter_1 = iv.vbus_avg << 8;
#endif
						rampup_target = iv.vbus_setpoint; //410V
						pre_vbus_mode = VBUS_MODE_410;
						rampup_notcomplete = 1;
						iv.supply_state = STATE_RAMP_UP; //350V up to 410V
					}
					else
					{
						iv.interrupt_counter_4++;
						iv.interrupt_counter_5 = 0;
						iv.interrupt_counter_8 = 0;
					}
				}
			}
//			else if(iv.vbus_target == iv.vbus_setpoint)//410V
			else if(vbus_mode == VBUS_MODE_410)
			{
				if( (iv.vin_squared_average > VAC_MIN_RAMPDOWN_SQ_AVG) && (iv.vin_squared_average < VAC_MAX_RAMPDOWN_SQ_AVG) )
				{

					if(bufferRX.S2P.status.bit.Standby_mode==0)
					{
						//if((output_current >= 0x009D) && (output_current <= 0x00C0))//45% - 55%
						if((output_current >= IOUT_VALUE(45)) && (output_current <= IOUT_VALUE(55)))//Ernest20141121T1,45%(43.3A*0.45=19.485A) - 55%(43.3A*0.55=23.815A)
						{
							if(iv.interrupt_counter_5 > 10000) //10000*100us = 1s
							{
								iv.interrupt_counter_4 = 0;
								iv.interrupt_counter_5 = 0;
								iv.interrupt_counter_8 = 0;
	//							iv.interrupt_counter_1 = iv.vbus_setpoint << 8;
	#if !Temperature_sense_share_vbus
							iv.interrupt_counter_1 = iv.adc_avg[VBUS_CHANNEL] << 8;
	#else
							iv.interrupt_counter_1 = iv.vbus_avg << 8;
	#endif
	#if(DC_INPUT_ADJUST_VOLTAGE_SUPPORT==1)
								rampdown_target = dc_ac_half_load_rampdown_voltage; //350V
	#else
								rampdown_target = VBUS_RAMP_VOLTAGE_1; //350V
	#endif
								pre_vbus_mode = VBUS_MODE_350;
								vbus_mode=VBUS_MODE_350;
								rampdown_notcomplete = 1;
								iv.supply_state = STATE_RAMP_DOWN; //410V down to 350V
							}
							else
							{
								iv.interrupt_counter_5++;
								iv.interrupt_counter_4 = 0;
								iv.interrupt_counter_8 = 0;
							}
						}
						else if(output_current <= IOUT_VALUE(40)) //Ernest20141125T1<40%(43.3A*0.4=17.32A)
						{
							if(iv.interrupt_counter_8 > 10000) //10000*100us = 1s
							{
								iv.interrupt_counter_4 = 0;
								iv.interrupt_counter_5 = 0;
								iv.interrupt_counter_8 = 0; //Ernest20141125T1
	//							iv.interrupt_counter_1 = iv.vbus_setpoint << 8;
	#if !Temperature_sense_share_vbus
							iv.interrupt_counter_1 = iv.adc_avg[VBUS_CHANNEL] << 8;
	#else
							iv.interrupt_counter_1 = iv.vbus_avg << 8;
	#endif
								rampdown_target = VBUS_RAMP_VOLTAGE_3; //360V
								pre_vbus_mode = VBUS_MODE_390;
								vbus_mode=VBUS_MODE_390;
								rampdown_notcomplete = 1;
								iv.supply_state = STATE_RAMP_DOWN; //410V up to 360V
							}
							else
							{
								iv.interrupt_counter_8++;
								iv.interrupt_counter_4 = 0;
								iv.interrupt_counter_5 = 0;
							}
						}
						else
						{
							iv.interrupt_counter_4 = 0;
							iv.interrupt_counter_5 = 0;
							iv.interrupt_counter_8 = 0; //Ernest20141125T1
						}
					}
					else if(bufferRX.S2P.status.bit.Standby_mode==1)
					{
//						iv.interrupt_counter_1 = iv.vbus_setpoint << 8;
#if !Temperature_sense_share_vbus
						iv.interrupt_counter_1 = iv.adc_avg[VBUS_CHANNEL] << 8;
#else
						iv.interrupt_counter_1 = iv.vbus_avg << 8;
#endif
						rampdown_target = VBUS_RAMP_VOLTAGE_2;
//						MiscAnalogRegs.GLBIOVAL.bit.ALERT_IO_VALUE	= 1;//output high for Vbus not ok
//						MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 1;
						iv.ramp_up_step = 200; //fast ramp down
						pre_vbus_mode = VBUS_MODE_320;
						vbus_mode=VBUS_MODE_320;
						rampdown_notcomplete = 1;
						iv.supply_state = STATE_RAMP_DOWN;
					}

				}
			}
//			else if(iv.vbus_target == VBUS_RAMP_VOLTAGE_2)//320V
			else if(vbus_mode == VBUS_MODE_320)
			{
				if( (iv.vin_squared_average > VAC_MIN_RAMPDOWN_SQ_AVG) && (iv.vin_squared_average < VAC_MAX_RAMPDOWN_SQ_AVG) )
				{
					if(bufferRX.S2P.status.bit.Standby_mode==0)
					{

//						iv.interrupt_counter_1 = VBUS_RAMP_VOLTAGE_2 << 8;
#if !Temperature_sense_share_vbus
						iv.interrupt_counter_1 = iv.adc_avg[VBUS_CHANNEL] << 8;
#else
						iv.interrupt_counter_1 = iv.vbus_avg << 8;
#endif
						//if((output_current >= 0x009D) && (output_current <= 0x00C0))//45% - 55%
//						if((output_current >= IOUT_VALUE(45)) && (output_current <= IOUT_VALUE(55)))//Ernest20141121T1,45%(43.3A*0.45=19.485A) - 55%(43.3A*0.55=23.815A)
//						{
//#if(DC_INPUT_ADJUST_VOLTAGE_SUPPORT==1)
//							rampup_target = dc_ac_half_load_rampdown_voltage;
//#else
//							rampup_target = VBUS_RAMP_VOLTAGE_1;
//#endif
//							pre_vbus_mode = VBUS_MODE_350;
////							vbus_mode=VBUS_MODE_350;
//						}
//						else if(output_current <= IOUT_VALUE(40))
//						{
//							rampup_target = VBUS_RAMP_VOLTAGE_3;
//							pre_vbus_mode = VBUS_MODE_390;
////							vbus_mode=VBUS_MODE_390;
//						}
//						else
						{
							rampup_target = iv.vbus_setpoint;
							pre_vbus_mode = VBUS_MODE_410;
						}
							iv.ramp_up_step = 190; //fast ramp up
							rampup_notcomplete = 1;
							iv.supply_state = STATE_RAMP_UP;

					}
				}
				else
				{
//					iv.interrupt_counter_1 = VBUS_RAMP_VOLTAGE_2 << 8;
#if !Temperature_sense_share_vbus
						iv.interrupt_counter_1 = iv.adc_avg[VBUS_CHANNEL] << 8;
#else
						iv.interrupt_counter_1 = iv.vbus_avg << 8;
#endif
					rampup_target = iv.vbus_setpoint;
					iv.ramp_up_step = 190; //fast ramp up
					pre_vbus_mode = VBUS_MODE_410;
					rampup_notcomplete = 1;
					iv.supply_state = STATE_RAMP_UP;
				}
			}
		}
#endif
		iv.interrupt_counter_3 = 0;
		if(vbus_ok == 1)
		{
			if((iv.ac_drop==0)&&(bufferRX.S2P.status.bit.Standby_mode==0)&&(iv.supply_state == STATE_PFC_ON))
//		if((iv.ac_drop==0)&&(bufferRX.S2P.status.bit.Standby_mode==0))
			{
				#if !Temperature_sense_share_vbus
					if((iv.vbus_target - iv.adc_avg[VBUS_CHANNEL])>180)//>25V
					{
						iv.interrupt_counter_1 = iv.adc_avg[VBUS_CHANNEL] << 8; //ramp up starts from retified Vout
				#else
					if(iv.vbus_target > (iv.vbus_raw+230))//[Ken Zhang]>30V
//					if(iv.vbus_target >(iv.vbus_avg+230))//[Ken Zhang]>30V
					{
						iv.interrupt_counter_1 = iv.vbus_avg << 8; //ramp up starts from retified Vout
						iv.ramp_up_step = 118;//[Ken Zhang]add for debug 20150529
				#endif
						rampup_target = iv.vbus_target;
						iv.supply_state = STATE_RAMP_UP;
					}
			}
		}
	}
	else
	{
		iv.interrupt_counter_3 ++;
		//if(iv.interrupt_counter_3 == 300)//wait for 30ms,borwn-out
		if(iv.interrupt_counter_3 == 500)//wait for 50ms,borwn-out
		{

//			MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 1;
			turn_off_pfc();
			iv.ramp_up_step = 118;//300;//0x50; //fast ramp up
//			MiscAnalogRegs.GLBIOVAL.bit.DPWM3B_IO_VALUE = 0;//turn off relay
			iv.interrupt_counter_3 = 0;
			iv.supply_state = STATE_IDLE;
			vbus_ok = 0;
			iv.vbus_target =  iv.vbus_setpoint;
			iv.cir_buff_ptr = 0;
			iv.emi_buff_delay = 9;

			iv.ramp_up_step = 118;//0x50; //slow ramp up
			iv.interrupt_counter_1 = 0;
			iv.interrupt_counter_2 = 0;
			iv.interrupt_counter_3 = 0;
			iv.interrupt_counter_4 = 0;
			iv.interrupt_counter_5 = 0;
			iv.interrupt_counter_6 = 0;
			iv.interrupt_counter_7 = 0;
			iv.interrupt_counter_8 = 0;
			iv.interrupt_counter_9 = 0;
			iv.interrupt_counter_10 = 0;
			status_1.bits.dither_enabled = 0;

			bufferTX.P2S.status.bit.PFC_DIS = 1;

		}
	}
}

inline void ramp_down_state_handler(void)
{
	iv.interrupt_counter_1 = iv.interrupt_counter_1 - iv.ramp_up_step;
	if((iv.interrupt_counter_1 >> 8) <= rampdown_target) //we've ramped to target
	{
		iv.vbus_target = rampdown_target;
#if !Temperature_sense_share_vbus
		if((iv.adc_raw[VBUS_CHANNEL] - iv.vbus_target)>72)//10V
#else
		if((iv.vbus_raw - iv.vbus_target)>72)//10V
#endif
		{
			iv.interrupt_counter_1 = iv.interrupt_counter_1 + iv.ramp_up_step;

		}
		else
		{
			iv.interrupt_counter_1 = 0;
			rampdown_notcomplete = 0;
			iv.supply_state = STATE_PFC_ON;
		}
	}
	else
	{
		iv.vbus_target = iv.interrupt_counter_1 >> 8;
	}
	if((vbus_mode==VBUS_MODE_320)&&(bufferRX.S2P.status.bit.Standby_mode==0))
	{
		iv.interrupt_counter_1 = 0;
		rampdown_notcomplete = 0;
		iv.supply_state = STATE_PFC_ON;
	}
}

inline void	pfc_shut_down_state_handler(void)
{
	//PFC OVP shuts down, indicates serious hardware issue, latched here 
	turn_off_pfc();
	bufferTX.P2S.status.bit.PFC_OVP = 1;
}

inline void pfc_hiccup_state_handler(void)
{		
#if !Temperature_sense_share_vbus
	if(iv.adc_avg[VBUS_CHANNEL] < VBUS_DPWM_ON_LEVEL)
#else
	if(iv.vbus_avg < VBUS_DPWM_ON_LEVEL)
#endif
	{
			iv.pis.i = 0;
			xflag = 0;
			Filter1Regs.FILTERYNCLPHI.all = 0x7fffff; 	
			// Global enable all Front_ends and DPWMs
			LoopMuxRegs.GLBEN.all = 0x70F;		
			
			turn_on_pfc();
			if((rampdown_notcomplete==1)&&(rampup_notcomplete==0))
			{
				iv.supply_state = STATE_RAMP_DOWN;
			}
			else if((rampdown_notcomplete==0)&&(rampup_notcomplete==1))
			{
//				iv.supply_state = STATE_RAMP_UP;
				//should not be happen
			}
			else
			{
				iv.supply_state = STATE_PFC_ON;
			}
//			MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 0;
	}

}
inline void supply_state_handler(void)
{
	switch(iv.supply_state) //seems to be 2.3 microseconds, at least in regulated modes.
	{
		case STATE_IDLE :
			idle_state_handler();
			break;

		case STATE_RELAY_BOUNCE:
			relay_bounce_state_handler();
			break;

		case STATE_RAMP_UP :
			ramp_up_state_handler();
			break;

		case STATE_PFC_ON:
			pfc_on_state_handler();	
			break;

		case STATE_RAMP_DOWN :
			ramp_down_state_handler();
			break;

		case STATE_PFC_SHUT_DOWN:
			pfc_shut_down_state_handler();
			break;

		case STATE_PFC_HICCUP:
			pfc_hiccup_state_handler();
			break;
		default:
			break;
	}
}

#pragma INTERRUPT(standard_interrupt,IRQ)
void standard_interrupt(void)	//50KHz, 20us
{
//	MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 1;//[Ken Zhang]for test timing

	poll_adc();//[Ken Zhang]used 6.52us,seems impossible

	rectify_vac();
	calculate_current_target_shunt();
	input_power_measurement();


#if AUTOBAUD_SUPPORT
	//measure baud rate with timer capture
	measure_baud();
#endif
	switch(iv.interrupt_state) //seems to be 2.3 microseconds, at least in regulated modes.
	{
		case I_STATE_1 :

			handle_voltage_loop();
			iv.interrupt_state = I_STATE_2;

			break;

		case I_STATE_2 :

			half_cycle_processing();
			PMBusDebugHandle();

			iv.interrupt_state = I_STATE_3;
			break;

		case I_STATE_3 :

			check_ac_drop();

			iv.interrupt_state = I_STATE_4;
			break;

		case I_STATE_4 :

			uart_receive_data();

//
			iv.interrupt_state = I_STATE_5;
			break;

		case I_STATE_5 :

			supply_state_handler();
//			frequency_dithering();
			iv.interrupt_state = I_STATE_1;

			break;

		default: //if it's in an illegal state
			iv.interrupt_state = I_STATE_1; //start it up again
			break;
	}
//	MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 0;//[Ken Zhang]for test timing
	TimerRegs.T16PWM0CMPCTRL.all = 3; //clear interrupt bit by a read/write.
//	MiscAnalogRegs.GLBIOVAL.bit.DPWM0A_IO_VALUE	= 0;

}
