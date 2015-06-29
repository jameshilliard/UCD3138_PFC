//system_defines.h
//function enable
#define DC_INPUT_ADJUST_VOLTAGE_SUPPORT	1
#define METER_DEBUG						0
#define AC_DROP_OPTIMIZATION
#define ADJUST_VOLTAGE_SUPPORT			0//1	//0: not support adjust voltage, always output 390V or 360V//[Ken Zhang]modify for 2252_3L//1: support adjust voltage, definition V360 need to set as 0#define ADJUST_VOL_BY_PIN				0	//0: adjust voltage by output current from secondary side, 1: adjust voltage by Pin from primary side
#define Temperature_sense_share_vbus	1
#define AUTOBAUD_SUPPORT				0
#define V360	0		//0: Vbus 390V, 1:Vbus 360V
#define PFC_TYPE 1		//for single phase PFC with shunt sensing
#define T_r (10560)//high res(250ps), 2640ns, oscillate period
#define MIN_VIN (175) //
//#define VOLTAGE_LOOP_DISABLE (1)//for opened voltage loop, comment this out for closed voltage loop

// Memory allocation constants
#define DATA_FLASH_START_ADDRESS 	(0x18800)
#define DATA_FLASH_END_ADDRESS 		(0x18fff)
#define DATA_FLASH_LENGTH			(DATA_FLASH_END_ADDRESS - DATA_FLASH_START_ADDRESS + 1)
#define	DATA_FLASH_SEGMENT_SIZE		(32)
#define	DATA_FLASH_NUM_SEGMENTS		(DATA_FLASH_LENGTH / DATA_FLASH_SEGMENT_SIZE) 

#define MFBALRX_BYTE0_BLOCK_SIZE_2K     	(0x20) 		

#define MFBALRX_BYTE0_RONLY					(0x02)		   // 1      Read-only protection// Flash Error codes
#define FLASH_SUCCESS 				(0)
#define FLASH_INVALID_SEGMENT 		(1)
#define	FLASH_INVALID_ADDRESS		(2)
#define	FLASH_MISCOMPARE			(3)

#define NULL						(0)

//Vbus measurement defines

#define VBUS_FULL_RANGE (527)//(569) //full range of ADC for VBUS//[Ken Zhang] changed 20150310
#define VBUS_FULL_RANGE_TEXT "527"//"569" //sent to model for design of voltage loop.//[Ken Zhang] changed 20150311
#define VBUS_TO_VAC_SCALING  ((int)((VBUS_FULL_RANGE * 32768)/VAC_FULL_RANGE))

#if V360

#define VBUS_POWER_GOOD_ON ((int32)((350<<12)/VBUS_FULL_RANGE))//350V//385V#define VBUS_POWER_GOOD_OFF ((int32)((310<<12)/VBUS_FULL_RANGE))//310V//340V
#else //390

#define VBUS_POWER_GOOD_ON ((int32)((375<<12)/VBUS_FULL_RANGE))//375V
#define VBUS_POWER_GOOD_OFF ((int32)((345<<12)/VBUS_FULL_RANGE))//345V
#define VBUS_POWER_GOOD_OFF_320 ((int32)((320<<12)/VBUS_FULL_RANGE))//320V
#endif
//Vac measurement defines

#define VAC_VOLTAGE_DIVIDER (5.11/815.11) //Vin sense gain//[Ken Zhang]20150311
#define VAC_FULL_RANGE (399) //full range of ADC (+-399)//[Ken Zhang]20150311
#define VAC_FR_SQ (VAC_FULL_RANGE * VAC_FULL_RANGE)
#define VAC_MIN_ON (175.0)  // minimum Vin to turn on PFC
#define VAC_MIN_OFF (167.0)// brown-out,Ernest20141112T1
#define VAC_MIN_RELAY_OFF (55.0)

#define VAC_MIN_ON_PEAK ((Uint32)((VAC_MIN_ON * 1.414 * 4096) / VAC_FULL_RANGE))

#define VAC_MIN_ON_SQ (VAC_MIN_ON * VAC_MIN_ON)
#define VAC_MIN_OFF_SQ (VAC_MIN_OFF * VAC_MIN_OFF)
#define VAC_MIN_RELAY_OFF_SQ (VAC_MIN_RELAY_OFF*VAC_MIN_RELAY_OFF)
#define VAC_MIN_ON_SQ_AVG ((Uint32)((VAC_MIN_ON_SQ/VAC_FR_SQ) * 32768))//Q15 ratio of squares of minimum operating voltage and VAC full range
#define VAC_MIN_OFF_SQ_AVG ((Uint32)((VAC_MIN_OFF_SQ/VAC_FR_SQ) * 32768))//Q15 ratio of squares of minimum operating voltage and VAC full range
#define VAC_MIN_RELAY_OFF_SQ_AVG ((Uint32)((VAC_MIN_RELAY_OFF_SQ/VAC_FR_SQ) * 32768))
#define VAC_STANDBY_PFC_DIS	((Uint32)(((220.0*220.0)/VAC_FR_SQ) * 32768))
#define AC_DROP_V_RECT_THRESHOLD (204) //calculated for 80 volts at 1 millisecond//[Ken Zhang]90Vac/50Hz count for 0.5ms
#define AC_UNDROPPED_THRESHOLD ((Uint32)(((170.0)*(170.0)/VAC_FR_SQ) * 32768))//(0x656) //threshold for vin squared average to indicate ac is back

#define AC_DROP_COUNT_MAX  (10)
//feedforward gain
#define  K_FEED_FORWARD ((Uint32)(0.5 * VAC_MIN_OFF * 1.414 * VAC_VOLTAGE_DIVIDER * 0x7FFFFFFF))//Q30//switching frequency defines
#define SWITCH_FREQ_NUMERATOR (250000) //numerator to divide by KHz to get period.
#define MAX_SWITCH_FREQ (200) //KHz.
#define MIN_SWITCH_FREQ (50) //KHz.
#define DITHER_PERIOD (100000) //number of timer ticks for one dither half cycle.
#define SWITCH_FREQ_OFFSET (55) //offset from secondary/primary communication byte to real value.
//ADC results assignment
#define VBUS_CHANNEL (0)
#define AC_L_CHANNEL (1)
#define AC_N_CHANNEL (2)
#define IIN_CHANNEL  (3)

#define NUMBER_OF_ADC_CHANNELS_ACTIVE (4)//how many ADC channels are used
#define VRECT_SQUARED_SLOW_AVERAGE_SHIFT (15)
#define IPM_FILTER_SHIFT 	(15)

//voltage loop defines
#define PI_I_HIGH_LIMIT ((1 << 27)-1) 
#define PI_I_LOW_LIMIT (-1 << 27)
#define PI_OUTPUT_HIGH_LIMIT (32767) //max Q15 number
#define PI_OUTPUT_LOW_LIMIT (0) //min Q15 number
#define OC_COMPARATOR (35)//Ipk=44/127*2.5/6.5/0.004=34.0A//[Ken Zhang]20150408
#define SATURATE_CURRENT_LIMIT (0x170)//[Ken Zhang] about 22A for current reference

#if V360

#define VBUS_DPWM_OFF_LEVEL ((int32)((400<<12)/VBUS_FULL_RANGE)) //400//430V
#define VBUS_DPWM_ON_LEVEL  ((int32)((350<<12)/VBUS_FULL_RANGE)) //350//380V
#else
#define VBUS_DPWM_OFF_LEVEL ((int32)((430<<12)/VBUS_FULL_RANGE)) //[Ken Zhang]480//400//430V
#define VBUS_DPWM_ON_LEVEL  ((int32)((400<<12)/VBUS_FULL_RANGE)) //350//380V
#endif

#define VBUS_FEEDBACK_CHECK	((int32)((180<<12)/VBUS_FULL_RANGE))//[Ken Zhang]Vbus should rise to 180Vdc
//UART related
#define UART_BYTES (6) //serial receive buffer size
#define UART_TX_TIME (3000) //number of timer interrupts between transmissions on serial port
#define VAC_MIN_RAMPDOWN_SQ_AVG	2080//((Uint32)(((100*100)/VAC_FR_SQ) * 32768))
#define VAC_MAX_RAMPDOWN_SQ_AVG	11986//((Uint32)(((240*240)/VAC_FR_SQ) * 32768))
#define RAMP_UP_DOWN_VOLTAGE_1 ((Uint32)(350))	//ramp down for efficient,Ernest20141115T1
#define RAMP_UP_DOWN_VOLTAGE_2 ((Uint32)(320))	//Standby mode voltage
#define RAMP_UP_DOWN_VOLTAGE_3 ((Uint32)(390))//(351))	//ramp down for efficient (<=40% load),Ernest20141127T1
#define VBUS_RAMP_VOLTAGE_1	((Uint32)((RAMP_UP_DOWN_VOLTAGE_1*4095)/VBUS_FULL_RANGE))
#define VBUS_RAMP_VOLTAGE_2	((Uint32)((RAMP_UP_DOWN_VOLTAGE_2*4095)/VBUS_FULL_RANGE))
#define VBUS_RAMP_VOLTAGE_3	((Uint32)((RAMP_UP_DOWN_VOLTAGE_3*4095)/VBUS_FULL_RANGE)) //Ernest20141125T1
#if(DC_INPUT_ADJUST_VOLTAGE_SUPPORT==1)
#define RAMP_UP_DOWN_VOLTAGE_DC_1 ((Uint32)(341))
#define VBUS_RAMP_VOLTAGE_DC_1	((Uint32)((RAMP_UP_DOWN_VOLTAGE_DC_1*4095)/VBUS_FULL_RANGE))
#define VBUS_POWER_GOOD_OFF_DC_310 ((int32)((310<<12)/VBUS_FULL_RANGE))//320V
#endif
#define VBUS_MODE_410	1	//Vbus = 410
#define VBUS_MODE_390	2	//Vbus = 390
#define VBUS_MODE_350	3	//Vbus = 350
#define VBUS_MODE_320	4	//Vbus = 320
#define VDC_MIN_ON (173.0)  // minimum Vin to turn on PFC
#define VDC_MIN_OFF (143.0)// brown-out
#define VDC_MIN_ON_SQ (VDC_MIN_ON * VDC_MIN_ON)
#define VDC_MIN_OFF_SQ (VDC_MIN_OFF * VDC_MIN_OFF)
#define VDC_MIN_ON_PEAK ((Uint32)((VDC_MIN_ON * 4096) / VAC_FULL_RANGE))
#define VDC_MIN_ON_SQ_AVG ((Uint32)((VDC_MIN_ON_SQ/VAC_FR_SQ) * 32768))
#define VDC_MIN_OFF_SQ_AVG ((Uint32)((VDC_MIN_OFF_SQ/VAC_FR_SQ) * 32768))
