//variables.h
//this file defines all global variables


#ifdef MAIN 					// If it is the main routine
	#define EXTERN	 			// 	it isn't extern, so define it as nothing
#else 							// If it isn't the main routine
	#define EXTERN extern 		// 	it is extern
#endif

//---Ernest,define constant value---
/*Iout*/
#define	IOUT_MAX							350 //398(IOUT_FF,ADC value): 43.3A(IOUT_MAX),43.3*9.19(coefficient)=398
#define IOUT_VALUE(Percent)					((Uint32)IOUT_MAX * Percent / 100)
//----------------------------------

struct PROPORTIONAL_INTEGTRAL_STRUCTURE 
{
	int32 p;
	int32 i;
	int32 kp;
	int32 ki;
	int32 kp_nl;
	int32 ki_nl;
	int32 nl_threshold;
	int32 output;
	int32 output_filtered;
};

typedef enum
{
	STATE_IDLE,
	STATE_RELAY_BOUNCE,	
	STATE_RAMP_UP,				
	STATE_PFC_ON,
	STATE_RAMP_DOWN,
	STATE_PFC_SHUT_DOWN,
	STATE_PFC_HICCUP		
} SUPPLY_STATE;

typedef enum
{
	I_STATE_1,
	I_STATE_2,	
	I_STATE_3,				
	I_STATE_4,				
	I_STATE_5				
} INTERRUPT_STATE;

struct INTERRUPT_VARIABLES
{
	//stuff for ADC measurement
	Uint32 adc_raw[NUMBER_OF_ADC_CHANNELS_ACTIVE];
	Uint32 adc_avg[NUMBER_OF_ADC_CHANNELS_ACTIVE];
	Uint32 adc_temp_ex_raw;
	Uint32 adc_t_pri_raw;

	//stuff for Iin
	Uint32 iin_raw;
	Uint32 iin_filtered;
	Uint32 iin_squared;
	unsigned long long iin_squared_filtered;
			
	//stuff for Vin
	Uint32 vin_raw;
	Uint32 vin_sum;
	Uint32 vin_filtered;
	Uint32 vin_average;
	Uint32 vin_squared;
	Uint32 vin_squared_slow_average;
	Uint32 vin_squared_average;
	unsigned long long vin_squared_filtered;

	//stuff for pin
	Uint32 pin_raw;
	unsigned long long pin_filtered;

	//stuff for Vout
	Uint32 vbus_scaled;  //scale vbus to match scale of vin
	Uint32 vbus_target;	 //sacled in ADC counts
	Uint32 vbus_voltage; //scaled in volts
	Uint32 vbus_setpoint; //scaled in ADC counts
	Uint32 vbus_filtered; //a slow filter for voltage loop

	//stuff for current loop
	Uint32 i_target_average; //average current command
	Uint32 i_target_sensed; //instantanous current command
	Uint32 i_target_offset;
	Uint32 sample_trigger_offset;
	Uint32 vff_multiplier;
	Uint32 cla_output_filtered;


	//stuff for ramp up
	Uint32 interrupt_counter_1;
	Uint32 interrupt_counter_2;
	Uint32 interrupt_counter_3;
	Uint32 interrupt_counter_4;
	Uint32 interrupt_counter_5;
	Uint32 interrupt_counter_6;
	Uint32 interrupt_counter_7;
	Uint32 interrupt_counter_8; //Ernest20141125T1
	Uint32 ramp_up_step;

	// stuff for ac drop detection
	Uint32 ac_drop_count;
	Uint32 ac_drop;
	Uint32 ac_drop_recovery_not_complete;
	Uint32 vin_squared_for_ac_drop;

	// stuff for half cycle measurement
	Uint32 negative_cycle_counter;
	Uint32 negative_vin_squared_accumulate;
	Uint32 positive_cycle_counter;
	Uint32 positive_vin_squared_accumulate;
	Uint32 half_cycle_counter_filtered;
	Uint32 sequence_to_change;

	//stuff for frequency dither
	Uint32 switching_period;
	Uint32 dither_max_period;
	Uint32 dither_min_period;
	Uint32 dither_step;
	Uint32 period_times_2_14;

 	//stuff for EMI CAP compensation	
 	Uint16 cir_buff[64]; //64buffer for vin
	Uint8 cir_buff_ptr; //pointer for current ADC measurement;
	Uint8 emi_buff_delay; //delay for waveform from circular buffer for EMI compensation.
	Uint8 emi_pointer; //pointer for current used measurement
	Uint8 ipm_buff_delay; //Iin_sense has delay, to sompensate that, delay vac_sense for accurate input power measurement
	Uint8 ipm_pointer;//pointer for current used measurement for IPM compensation

 	Uint8 dither_direction; //1 if going up, 0 if going down in dither.
	Uint8 positive;
	Uint32 vin_peak;
	Uint32 vbus_raw;
	Uint32 vbus_sum;
	Uint32 vbus_avg;
	Uint32 vff_multiplier_temp[7];
	Uint32 vff_pointer;
	Uint32 vff_pointer_temp;
	Uint32 interrupt_counter_9;
	Uint32 interrupt_counter_10;
	Uint32 interrupt_counter_11;
	Uint32 ac_drop_continue_count;
	Uint32 ac_drop_continue;

 	struct PROPORTIONAL_INTEGTRAL_STRUCTURE pis;
	INTERRUPT_STATE interrupt_state;
	SUPPLY_STATE supply_state;
};

struct STATUS_0_BITS
{
	int32 reserved_0:27;
	int32 ot:1;
	int32 vdc_uv:1;
	int32 vdc_ov:1;
	int32 vac_uv:1;
	int32 vac_ov:1;
};

union STATUS_0
{
	int32 all;
	struct STATUS_0_BITS bits;
};

struct STATUS_1_BITS
{
	int32 reserved_0:25;
	int32 phase_b_off:1;
	int32 phase_a_off:1;
	int32 burst_mode:1;
	int32 sleep_mode:1;
	int32 dither_enabled:1;
	int32 pout_mode:1;
	int32 calibrating:1;
};

union STATUS_1
{
	int32 all;
	struct STATUS_1_BITS bits;
};

EXTERN union STATUS_0 status_0;
EXTERN union STATUS_1 status_1, status_1_hold;

EXTERN struct INTERRUPT_VARIABLES iv;

EXTERN int32 switching_frequency;

//stuff for UART communication
EXTERN Uint8 uart_rx_buf[UART_BYTES];
EXTERN Uint8 uart_text_in_buf[UART_BYTES];
EXTERN Uint8 uart_rx_data_rdy; //flag, received a new data packet
EXTERN Uint8 uart_rx_buf_ptr; //point to the buffer which will store the coming data
EXTERN int32 uart_rx_timer; //count IRQ, used to count the UART receive idle period
EXTERN int32 uart_tx_timeout; //used to count the timeout for message transmission
EXTERN int32 uart_tx_checksum; //checksum for transmit
EXTERN int32 primary_secondary_count;

//stuff for memory debugger
EXTERN Uint8 parm_index;
EXTERN int16 parm_offset;	
EXTERN Uint8 parm_count;		
EXTERN Uint8 parm_size;	

EXTERN union{
	   			Uint8	byte[32];	// Byte at a time
		   		Uint32	word[8];	// Same data, a word at a time
			} copy_buffer;	

//stuff for PMBus communication
EXTERN Uint8 pmbus_buffer[40];
EXTERN Uint8 pmbus_state;
EXTERN Uint8 pmbus_number_of_bytes;
EXTERN Uint8 pmbus_buffer_position;
EXTERN Uint16 pmbus_status_half_word_0_value; //save pmbus status, since cleared on read.
EXTERN Uint16 pmbus_status_half_word_0_value_ored; //for debug

EXTERN Uint8 ipm_or_zvs;
EXTERN Uint8 zvs_flag;//turn on/off ZVS
EXTERN Uint8 debug_buffer[8];

EXTERN Uint8 erase_segment_counter;	// Number of DFlash segment remaining to be erased
EXTERN Uint8 erase_segment_number;		// DFlash segment number being erased
EXTERN Uint8 flash_write_status;	// Global status while attempting to write to Data Flash.



//stuff for IPM
EXTERN Uint32 emi_capacitance;
EXTERN Uint32 emi_resistance;
EXTERN Uint32 emi_discharge_resistance;
EXTERN Uint32 iin_rms;
//EXTERN Uint32 iemi_squared;
EXTERN Uint32 pin;
EXTERN Uint32 iin_slope;
EXTERN Uint32 iin_slope_shift;
EXTERN Uint32 iin_offset;
EXTERN Uint32 iin_offset_shift;
EXTERN Uint32 vin_rms;
EXTERN Uint32 vin_slope;
EXTERN Uint32 vin_slope_shift;
EXTERN Uint32 vin_offset;
EXTERN Uint32 vin_offset_shift;

struct HK_S2P_STATUS
{
	Uint32 reserved2:28;
	Uint32 Fixed_Bulk_voltage:1;
	Uint32 Sleep_mode:1;
	Uint32 PFC_DIS:1;
	Uint32 Standby_mode:1;
};

struct HK_P2S_STATUS
{
	Uint32 reserved2:27;
	Uint32 PRI_CHECKSUM_OK:1;
	Uint32 PRIMARY_ISP_MODE:1;
	Uint32 INPUT_OK:1;
	Uint32 PFC_OVP:1;
	Uint32 PFC_DIS:1;

};
union S2P_STATUS
{
	struct HK_S2P_STATUS bit;
	Uint32 all;
};
union P2S_STATUS
{
	struct HK_P2S_STATUS bit;
	Uint32 all;
};
struct HK_UART_S2P_PACKET
{
	unsigned char Header;
	union S2P_STATUS status;
	unsigned char command;
	unsigned char data[2];
	unsigned char checksum;
};
struct HK_UART_P2S_PACKET
{
	unsigned char Header;
	union P2S_STATUS status;
	unsigned char command;
	unsigned char data[2];
	unsigned char checksum;
};
union HK_S2P_FRAME
{
	struct HK_UART_S2P_PACKET S2P;
	unsigned char  Data[6];
};

union HK_P2S_FRAME
{
	struct HK_UART_P2S_PACKET P2S;
	unsigned char  Data[6];
};
EXTERN union HK_P2S_FRAME bufferTX;
EXTERN union HK_S2P_FRAME bufferRX;

EXTERN unsigned char fw_revision[4];
EXTERN Uint32 pfc_voltage;

EXTERN Uint16 output_current;
EXTERN Uint16 standby_output_current;
EXTERN Uint16 vac_from_meter_ic;
EXTERN Uint8 uart_rx_buf_err[UART_BYTES];


EXTERN Uint16 PMBUS_L11_Vin;
EXTERN Uint16 PMBUS_L11_Iin;
EXTERN Uint16 PMBUS_L11_Pin;
EXTERN int mantissa;
EXTERN Uint16 uExponent;
EXTERN Uint16 uMantissa;

EXTERN Uint32 ac_frequency;
EXTERN Uint32 rampup_target;
EXTERN Uint32 rampdown_target;
EXTERN Uint32 pri_temp1;
EXTERN Uint32 ext_temp1;

EXTERN Uint8 softstart_flag;
// UART Autobaud Rate Detection
EXTERN Uint32 pulse_width;
EXTERN Uint32 baud_div_value;
EXTERN Uint8 T24SREG;
EXTERN Uint8 edge;
EXTERN Uint32 result;
EXTERN Uint32 ac_recover_counter;
EXTERN Uint32 xflag;
EXTERN Uint32 vbus_ok;
EXTERN Uint32 ac_input;
EXTERN Uint32 dc_input;
EXTERN Uint32 dc_ac_half_load_rampdown_voltage;
EXTERN Uint32 dc_ac_half_load_vbus_good_off;
EXTERN Uint32 vbus_mode;
EXTERN Uint32 pre_vbus_mode;

EXTERN Uint32 rampdown_notcomplete;
EXTERN Uint32 rampup_notcomplete;

EXTERN Uint32 brown_in_voltage;
EXTERN Uint32 brown_out_voltage;
EXTERN Uint32 vin_min_on_sq_avg;
EXTERN Uint32 vin_min_off_sq_avg;
EXTERN Uint32 vin_min_off;
struct MASS_DEBUG_STRUCTURE{//[Ken Zhang]add for mass variable debug
	Uint16 dataLog[500];
	Uint16 dataCnt;
	Uint8  dataLogSW;
	Uint16 freqDivTop;// default 10kHz
	Uint16 freqDivCount;
	Uint8 ptrSelectSW;//value 0:iv.pis.output;1:iv.i_target_average;2:iv.i_target_sensed;3:iv.cir_buff[iv.emi_pointer];4:iv.vff_multiplier;
};
EXTERN struct MASS_DEBUG_STRUCTURE meDebug;

//*********************************************************//
//*** 
//*********************************************************//
typedef struct _E_METER_CAL_STRUCTURE
{
	Uint32 iin_slope;
	Uint32 iin_slope_shift;
	Uint32 iin_offset;
	Uint32 iin_offset_shift;
	Uint32 vin_slope;
	Uint32 vin_slope_shift;
	Uint32 vin_offset;
	Uint32 vin_offset_shift;
}E_METER_CAL_STRUCTURE;


typedef struct _LITEON_CAL_STRUCTURE
{
	E_METER_CAL_STRUCTURE E_Meter;
}LITEON_CAL_STRUCTURE;

typedef struct _USER_DATA_PAGE
{
	LITEON_CAL_STRUCTURE Calibration;
}USER_DATA_PAGE;

EXTERN USER_DATA_PAGE UserData;
EXTERN Uint32 standard_int_freq;
EXTERN Uint32 e_meter_version;

