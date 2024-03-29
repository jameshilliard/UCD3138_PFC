//pmbus_coefficients.c

//include.h

//###########################################################################
//
// FILE:   Cyclone_Device.h
//
// TITLE:  Cyclone Device Definitions.
//
//###########################################################################
//
//  Ver  | dd mmm yyyy | Who  | Description of changes
// ======|=============|======|==============================================
//  1.00 | 12 Aug 2009 | CMF  | Started with Spartan_Device.h.
//       |             |      | Updated for 1.0 Memory map document.
//       |             |      |
//
//  Texas Instruments, Inc
//  Copyright Texas Instruments 2009. All rights reserved.
//###########################################################################




//===========================================================================
// For Portability, It Is Recommended To Use Following Data Type Definitions
//
	typedef signed char          int8;
	typedef char                 Uint8;
	typedef short                int16;
	typedef unsigned short       Uint16;
	typedef int                  int32;
	typedef unsigned int         Uint32;

	typedef	Uint16	PM11;  	// PMBus literal format.  Top 5 bits are exponent, 
			      	// bottom 11 bits are signed integer


//===========================================================================
// Include All Peripheral Structure Definitions:
//
//###########################################################################
//
// FILE:   cyclone_adc.h
//
// TITLE:  Cyclone 12-bit Analog-to-Digital Converter Register Definitions.
//
// NOTES:
//  1) Bitfields have been defined for big-endian only.
//###########################################################################
//
//  Ver  | dd mmm yyyy | Who  | Description of changes
// ======|=============|======|==============================================
//  1.00 | 12 Aug 2009 | CMF  | Started with cyclone_adc.h.
//       |             |      | Updated for 1.0 Memory map document.
//       |             |      |
//
//  Texas Instruments, Inc
//  Copyright Texas Instruments 2008. All rights reserved.
//###########################################################################



  //===============================================================================
  // 12-bit Analog-to-Digital Converter Individual Register Bit Definitions
  //===============================================================================

  //-----------------------------------------------------------------------------
  // ADC Control Register 1 bit definitions
  //-----------------------------------------------------------------------------
  struct ADCCTRL_BITS {             // bits   description
    Uint32 EXT_TRIG_DLY:8;          // 31:24  External ADC Trigger Delay
    Uint32 EXT_TRIG_GPIO_VAL:1;     // 23     ADC External Trigger GPIO Value
    Uint32 EXT_TRIG_GPIO_DIR:1;     // 22     ADC External Trigger GPIO Direction
    Uint32 EXT_TRIG_GPIO_EN:1;      // 21     ADC External Trigger GPIO Enable
    Uint32 EXT_TRIG_EN:1;           // 20     External ADC Trigger Enable
    Uint32 EXT_TRIG_SEL:4;          // 19:16  External ADC Trigger Select
    Uint32 SAMPLING_SEL:3;          // 15:13  Sampling Select 
    Uint32 ADC_SEL_REF:1;           // 12     ADC Reference Select 
    Uint32 ADC_ROUND:1;             // 11     ADC Rounding Enable
    Uint32 BYPASS_EN:3;             // 10:8   Dual Sample and Hold Bypass
    Uint32 MAX_CONV:4;              // 7:4    Maximum Number of Conversions
    Uint32 SINGLE_SWEEP:1;          // 3      Single Loop Sweep Select
    Uint32 SW_START:1;              // 2      Software start of conversion
    Uint32 ADC_INT_EN:1;            // 1      ADC End of Conversion Interrupt
    Uint32 ADC_EN:1;                // 0      ADC Enable
  }; 
  union ADCCTRL_REG {
    Uint32                  all;
    struct ADCCTRL_BITS     bit;
  };
  
  //-----------------------------------------------------------------------------
  // ADC Status Register
  //-----------------------------------------------------------------------------
  struct ADCSTAT_BITS {            // bits    description
    Uint32 rsvd:25;                // 31:7    Reserved
    Uint32 CURRENT_CH:4;           // 6:3     Current Channel
    Uint32 ADC_EXT_TRIG_VAL:1;     // 2       ADC External Trigger Pin Value
    Uint32 ADC_INT_RAW:1;          // 1       End of Conversion Status, Raw
    Uint32 ADC_INT:1;              // 0       Latched Interrupt Status
  };
  union ADCSTAT_REG {
    Uint32                  all;
    struct ADCSTAT_BITS     bit;
  };

  //-------------------------------------------------------------------------------
  // ADC Test Control Register bit definitions
  // (Reserved for TI use)
  //-------------------------------------------------------------------------------
  struct ADCTSTCTRL_BITS {          // bits   description
    Uint32 rsvd1:22;                // 31:10  reserved
    Uint32 TEST_CH_SEL:4;           // 9:6    Test channel select
    Uint32 rsvd0:5;                 // 5:1    Reserved
    Uint32 ADC_TEST_EN:1;           // 0      ADC test enable
  };
  union ADCTSTCTRL_REG {
    Uint32                      all;
    struct ADCTSTCTRL_BITS      bit;
  };

  //-----------------------------------------------------------------------------
  // ADC Sequence Select 0 Register bit definitions
  //-----------------------------------------------------------------------------
  struct ADCSEQSEL0_BITS {         // bits   description
    Uint32 rsvd3:3;                // 31:29  reserved
    Uint32 SEQ3_SH:1;              // 28     Dual channel sequence select
    Uint32 SEQ3:4;                 // 27:24  Conversion #3 channel
    Uint32 rsvd2:3;                // 23:21  reserved
    Uint32 SEQ2_SH:1;              // 20     Dual channel sequence select
    Uint32 SEQ2:4;                 // 19:16  Conversion #2 channel
    Uint32 rsvd1:3;                // 15:13  reserved
    Uint32 SEQ1_SH:1;              // 12     Dual channel sequence select
    Uint32 SEQ1:4;                 // 11:8   Conversion #1 channel
    Uint32 rsvd0:3;                // 7:5    reserved
    Uint32 SEQ0_SH:1;              // 4      Dual channel sequence select
    Uint32 SEQ0:4;                 // 3:0    Conversion #0 channel
  };
  union ADCSEQSEL0_REG {
    Uint32                     all;
    struct ADCSEQSEL0_BITS     bit;
  };
  
  //-----------------------------------------------------------------------------
  // ADC Sequence Select 1 Register bit definitions
  //-----------------------------------------------------------------------------
  struct ADCSEQSEL1_BITS {         // bits   description
    Uint32 rsvd3:3;                // 31:29  reserved
    Uint32 SEQ7_SH:1;              // 28     Dual channel sequence select
    Uint32 SEQ7:4;                 // 27:24  Conversion #7 channel
    Uint32 rsvd2:3;                // 23:21  reserved
    Uint32 SEQ6_SH:1;              // 20     Dual channel sequence select
    Uint32 SEQ6:4;                 // 19:16  Conversion #6 channel
    Uint32 rsvd1:3;                // 15:13  reserved
    Uint32 SEQ5_SH:1;              // 12     Dual channel sequence select
    Uint32 SEQ5:4;                 // 11:8   Conversion #5 channel
    Uint32 rsvd0:3;                // 7:5    reserved
    Uint32 SEQ4_SH:1;              // 4      Dual channel sequence select
    Uint32 SEQ4:4;                 // 3:0    Conversion #4 channel
  };
  union ADCSEQSEL1_REG {
    Uint32                     all;
    struct ADCSEQSEL1_BITS     bit;
  };  
  
  //-----------------------------------------------------------------------------
  // ADC Sequence Select 2 Register bit definitions
  //-----------------------------------------------------------------------------
  struct ADCSEQSEL2_BITS {         // bits   description
    Uint32 rsvd3:3;                // 31:29  reserved
    Uint32 SEQ11_SH:1;             // 28     Dual channel sequence select
    Uint32 SEQ11:4;                // 27:24  Conversion #11 channel
    Uint32 rsvd2:3;                // 23:21  reserved
    Uint32 SEQ10_SH:1;             // 20     Dual channel sequence select
    Uint32 SEQ10:4;                // 19:16  Conversion #10 channel
    Uint32 rsvd1:3;                // 15:13  reserved
    Uint32 SEQ9_SH:1;              // 12     Dual channel sequence select
    Uint32 SEQ9:4;                 // 11:8   Conversion #9 channel
    Uint32 rsvd0:3;                // 7:5    reserved
    Uint32 SEQ8_SH:1;              // 4      Dual channel sequence select
    Uint32 SEQ8:4;                 // 3:0    Conversion #8 channel
  };
  union ADCSEQSEL2_REG {
    Uint32                     all;
    struct ADCSEQSEL2_BITS     bit;
  };   
  
  //-----------------------------------------------------------------------------
  // ADC Sequence Select 3 Register bit definitions
  //-----------------------------------------------------------------------------
  struct ADCSEQSEL3_BITS {         // bits   description
    Uint32 rsvd3:3;                // 31:29  reserved
    Uint32 SEQ15_SH:1;             // 28     Dual channel sequence select
    Uint32 SEQ15:4;                // 27:24  Conversion #15 channel
    Uint32 rsvd2:3;                // 23:21  reserved
    Uint32 SEQ14_SH:1;             // 20     Dual channel sequence select
    Uint32 SEQ14:4;                // 19:16  Conversion #14 channel
    Uint32 rsvd1:3;                // 15:13  reserved
    Uint32 SEQ13_SH:1;             // 12     Dual channel sequence select
    Uint32 SEQ13:4;                // 11:8   Conversion #13 channel
    Uint32 rsvd0:3;                // 7:5    reserved
    Uint32 SEQ12_SH:1;             // 4      Dual channel sequence select
    Uint32 SEQ12:4;                // 3:0    Conversion #12 channel
  };
  union ADCSEQSEL3_REG {
    Uint32                     all;
    struct ADCSEQSEL3_BITS     bit;
  };  

  //-----------------------------------------------------------------------------
  // ADC Result Register bit definitions
  //-----------------------------------------------------------------------------
  struct ADCRESULT_BITS {          // bits   description
    Uint32 rsvd0:20;               // 31:12  reserved
    Uint32 RESULT:12;              // 11:0   Conversion result
  };
  union ADCRESULT_REG {
    Uint32                     all;
    struct ADCRESULT_BITS     bit;
  };
  
  //-----------------------------------------------------------------------------
  // ADC Averaged Result Register bit definitions
  //-----------------------------------------------------------------------------
  struct ADCAVGRESULT_BITS {          // bits   description
    Uint32 rsvd0:20;               // 31:12  reserved
    Uint32 RESULT:12;              // 11:0   Conversion result
  };
  union ADCAVGRESULT_REG {
    Uint32                     all;
    struct ADCAVGRESULT_BITS   bit;
  }; 

  //-----------------------------------------------------------------------------
  // ADC Digital Compare Limits x Register bit definitions
  //-----------------------------------------------------------------------------
  struct ADCCOMPLIM_BITS {         // bits   description
    Uint32 rsvd1:4;                // 31:28  reserved
    Uint32 UPPER_LIMIT:12;         // 27:16  Upper limit
    Uint32 rsvd0:4;                // 15:12  reserved
    Uint32 LOWER_LIMIT:12;         // 11:0   Lower limit
  };
  union ADCCOMPLIM_REG {
    Uint32                     all;
    struct ADCCOMPLIM_BITS    bit;
  };
  
  //-----------------------------------------------------------------------------
  // ADC Digital Comparator Enable Register bit definitions
  //-----------------------------------------------------------------------------
  struct ADCCOMPEN_BITS {          // bits   description
    Uint32 rsvd2:4;                // 31:28  reserved
    Uint32 COMP5_UP_INT_EN:1;      // 27     Comparator 5 Upper Interrupt Enable
    Uint32 COMP5_LO_INT_EN:1;      // 26     Comparator 5 Lower Interrupt Enable
    Uint32 COMP4_UP_INT_EN:1;      // 25     Comparator 4 Upper Interrupt Enable
    Uint32 COMP4_LO_INT_EN:1;      // 24     Comparator 4 Lower Interrupt Enable
    Uint32 COMP3_UP_INT_EN:1;      // 23     Comparator 3 Upper Interrupt Enable
    Uint32 COMP3_LO_INT_EN:1;      // 22     Comparator 3 Lower Interrupt Enable
    Uint32 COMP2_UP_INT_EN:1;      // 21     Comparator 2 Upper Interrupt Enable
    Uint32 COMP2_LO_INT_EN:1;      // 20     Comparator 2 Lower Interrupt Enable
    Uint32 COMP1_UP_INT_EN:1;      // 19     Comparator 1 Upper Interrupt Enable
    Uint32 COMP1_LO_INT_EN:1;      // 18     Comparator 1 Lower Interrupt Enable
    Uint32 COMP0_UP_INT_EN:1;      // 17     Comparator 0 Upper Interrupt Enable
    Uint32 COMP0_LO_INT_EN:1;      // 16     Comparator 0 Lower Interrupt Enable
    Uint32 rsvd1:2;                // 15:14  Reserved
    Uint32 COMP5_DATA_SEL:1;       // 13     Comparator 5 Data Select
    Uint32 COMP4_DATA_SEL:1;       // 12     Comparator 4 Data Select
    Uint32 COMP3_DATA_SEL:1;       // 11     Comparator 3 Data Select
    Uint32 COMP2_DATA_SEL:1;       // 10     Comparator 2 Data Select
    Uint32 COMP1_DATA_SEL:1;       // 9      Comparator 1 Data Select
    Uint32 COMP0_DATA_SEL:1;       // 8      Comparator 0 Data Select
    Uint32 rsvd0:2;                // 7:6    reserved
    Uint32 COMP5_EN:1;             // 5      Digital comparator 5 enable
    Uint32 COMP4_EN:1;             // 4      Digital comparator 4 enable
    Uint32 COMP3_EN:1;             // 3      Digital comparator 3 enable
    Uint32 COMP2_EN:1;             // 2      Digital comparator 2 enable
    Uint32 COMP1_EN:1;             // 1      Digital comparator 1 enable
    Uint32 COMP0_EN:1;             // 0      Digital comparator 0 enable
  };
  union ADCCOMPEN_REG {
    Uint32                    all;
    struct ADCCOMPEN_BITS    bit;
  };
  
  //-----------------------------------------------------------------------------
  // ADC Digital Comparator Results Register bit definitions
  //-----------------------------------------------------------------------------
  struct ADCCOMPRESULT_BITS {       // bits   description
    Uint32 rsvd1:4;                 // 31:28  Reserved
    Uint32 DCOMP5_UP_RAW:1;         // 27     Comparator 5 Upper Limit Raw Result
    Uint32 DCOMP5_LO_RAW:1;         // 26     Comparator 5 Lower Limit Raw Result
    Uint32 DCOMP4_UP_RAW:1;         // 25     Comparator 4 Upper Limit Raw Result
    Uint32 DCOMP4_LO_RAW:1;         // 24     Comparator 4 Lower Limit Raw Result
    Uint32 DCOMP3_UP_RAW:1;         // 23     Comparator 3 Upper Limit Raw Result
    Uint32 DCOMP3_LO_RAW:1;         // 22     Comparator 3 Lower Limit Raw Result
    Uint32 DCOMP2_UP_RAW:1;         // 21     Comparator 2 Upper Limit Raw Result
    Uint32 DCOMP2_LO_RAW:1;         // 20     Comparator 2 Lower Limit Raw Result
    Uint32 DCOMP1_UP_RAW:1;         // 19     Comparator 1 Upper Limit Raw Result
    Uint32 DCOMP1_LO_RAW:1;         // 18     Comparator 1 Lower Limit Raw Result
    Uint32 DCOMP0_UP_RAW:1;         // 17     Comparator 0 Upper Limit Raw Result
    Uint32 DCOMP0_LO_RAW:1;         // 16     Comparator 0 Lower Limit Raw Result
    Uint32 rsvd0:4;                 // 15:12  Reserved
    Uint32 DCOMP5_UP_INT:1;         // 11     Comparator 5 Upper Limit Latch Result
    Uint32 DCOMP5_LO_INT:1;         // 10     Comparator 5 Lower Limit Latch Result
    Uint32 DCOMP4_UP_INT:1;         // 9      Comparator 5 Upper Limit Latch Result
    Uint32 DCOMP4_LO_INT:1;         // 8      Comparator 5 Lower Limit Latch Result
    Uint32 DCOMP3_UP_INT:1;         // 7      Comparator 5 Upper Limit Latch Result
    Uint32 DCOMP3_LO_INT:1;         // 6      Comparator 5 Lower Limit Latch Result
    Uint32 DCOMP2_UP_INT:1;         // 5      Comparator 5 Upper Limit Latch Result
    Uint32 DCOMP2_LO_INT:1;         // 4      Comparator 5 Lower Limit Latch Result
    Uint32 DCOMP1_UP_INT:1;         // 3      Comparator 5 Upper Limit Latch Result
    Uint32 DCOMP1_LO_INT:1;         // 2      Comparator 5 Lower Limit Latch Result
    Uint32 DCOMP0_UP_INT:1;         // 1      Comparator 5 Upper Limit Latch Result
    Uint32 DCOMP0_LO_INT:1;         // 0      Comparator 5 Lower Limit Latch Result
  };
  union ADCCOMPRESULT_REG {
    Uint32                        all;
    struct ADCCOMPRESULT_BITS     bit;
  };
  
  //-----------------------------------------------------------------------------
  // ADC Averaging Control Register Bit Definitions
  //-----------------------------------------------------------------------------
  struct ADCAVGCTRL_BITS {          // bits   description
    Uint32 rsvd5:9;                 // 31:23  Reserved
    Uint32 AVG5_CONFIG:2;           // 22:21  Averaging Module 5 Configuration
    Uint32 AVG5_EN:1;               // 20     Averaging Module 5 Enable
    Uint32 rsvd4:1;                 // 19     Reserved
    Uint32 AVG4_CONFIG:2;           // 18:17  Averaging Module 4 Configuration
    Uint32 AVG4_EN:1;               // 16     Averaging Module 4 Enable
    Uint32 rsvd3:1;                 // 15     Reserved
    Uint32 AVG3_CONFIG:2;           // 14:13  Averaging Module 3 Configuration
    Uint32 AVG3_EN:1;               // 12     Averaging Module 3 Enable
    Uint32 rsvd2:1;                 // 11     Reserved
    Uint32 AVG2_CONFIG:2;           // 10:9   Averaging Module 2 Configuration
    Uint32 AVG2_EN:1;               // 8      Averaging Module 2 Enable
    Uint32 rsvd1:1;                 // 7      Reserved
    Uint32 AVG1_CONFIG:2;           // 6:5    Averaging Module 1 Configuration
    Uint32 AVG1_EN:1;               // 4      Averaging Module 1 Enable
    Uint32 rsvd0:1;                 // 3      Reserved
    Uint32 AVG0_CONFIG:2;           // 2:1    Averaging Module 0 Configuration
    Uint32 AVG0_EN:1;               // 0      Averaging Module 0 Enable
  };
  union ADCAVGCTRL_REG {
    Uint32                        all;
    struct ADCAVGCTRL_BITS        bit;
  };

  //===========================================================================
  // ADC Module Register File
  //
  struct ADC_REGS {
    union  ADCCTRL_REG        ADCCTRL;         // ADC Control Register
    union  ADCSTAT_REG        ADCSTAT;         // ADC Status Register
    union  ADCTSTCTRL_REG     ADCTSTCTRL;      // ADC Test Control Register
    union  ADCSEQSEL0_REG     ADCSEQSEL0;      // ADC Sequencer Select Register 0
    union  ADCSEQSEL1_REG     ADCSEQSEL1;      // ADC Sequencer Select Register 1
    union  ADCSEQSEL2_REG     ADCSEQSEL2;      // ADC Sequencer Select Register 2
    union  ADCSEQSEL3_REG     ADCSEQSEL3;      // ADC Sequencer Select Register 3
    union  ADCRESULT_REG      ADCRESULT[16];   // ADC Conversion Result 0:15
    union  ADCAVGRESULT_REG   ADCAVGRESULT[6]; // ADC Averaged Conversion Result 0:5 
    union  ADCCOMPLIM_REG     ADCCOMPLIM[6];   // ADC Digital Compare Limits Register 0:5
    union  ADCCOMPEN_REG      ADCCOMPEN;       // ADC Digital Compare Enable Register
    union  ADCCOMPRESULT_REG  ADCCOMPRESULT;   // ADC Digital Compare Result Register
    union  ADCAVGCTRL_REG     ADCAVGCTRL;      // ADC Averaging Control Register
  };
  
  //-----------------------------------------------------------------------------
  // ADC Module External References & Function Declarations:
  //-----------------------------------------------------------------------------
  extern volatile struct ADC_REGS AdcRegs;



//===========================================================================
// End of file
//===========================================================================
//###########################################################################
//
// FILE:   cyclone_cim.h
//
// TITLE:  Cyclone Central Interrupt Module Register Definitions.
//
// NOTES:
//  1) Bitfields have been defined for big-endian only.
//###########################################################################
//
//  Ver  | dd mmm yyyy | Who  | Description of changes
// ======|=============|======|==============================================
//  1.00 | 12 Aug 2009 | CMF  | Started with Spartan_Cim.h.
//       |             |      | Updated for 1.0 Memory map document.
//  2.00 | 13 Jun 2011 | FW   | Updated for 2p0 Memory map document; 
//                            | Added Interrupt names.
//
//  Texas Instruments, Inc
//  Copyright Texas Instruments 2008. All rights reserved.
//###########################################################################




//===========================================================================
// Central Interrupt Module Individual Register Bit Definitions
//

//-------------------------------------------------
// IRQ Index Offset Vector Register bit definitions
//
struct IRQIVEC_BITS {             // bits   description
   Uint32 rsvd0:24;               // 31:8   reserved
   Uint32 IRQIVEC:8;              // 7:0    Index vector
};
union IRQIVEC_REG {
   Uint32                 all;
   struct IRQIVEC_BITS    bit;
};

//-------------------------------------------------
// FIQ Index Offset Vector Register bit definitions
//
struct FIQIVEC_BITS {             // bits   description
   Uint32 rsvd0:24;               // 31:8   reserved
   Uint32 FIQIVEC:8;              // 7:0    Index vector
};
union FIQIVEC_REG {
   Uint32                 all;
   struct FIQIVEC_BITS    bit;
};

//-------------------------------------------------
// FIQ/IRQ Program Control Register bit definitions
//
struct FIRQPR_BITS {                   // bits   description
   Uint32 FIRQ_SYS_SOFT:1;             // 31     Interrupt 31, System Software Interrupt
   Uint32 FIRQ_FAULT_PIN:1;            // 30     Interrupt 30, Fault Pin Interrupt
   Uint32 FIRQ_DPWM0:1;                // 29     Interrupt 29, Every(1-16)DPWM0 switching cycles or CLF flag shutdown Interrupt
   Uint32 FIRQ_DPWM1:1;                // 28     Interrupt 28, Every(1-16)DPWM1 switching cycles or CLF flag shutdown Interrupt
   Uint32 FIRQ_DPWM2:1;                // 27     Interrupt 27, Every(1-16)DPWM2 switching cycles or CLF flag shutdown Interrupt
   Uint32 FIRQ_DPWM3:1;                // 26     Interrupt 26, Every(1-16)DPWM3 switching cycles or CLF flag shutdown Interrupt
   Uint32 FIRQ_FAULT_MUX:1;            // 25     Interrupt 25, Fault Mux Interrupt
   Uint32 FIRQ_ADC_CONV:1;             // 24     Interrupt 24, ADC-12 End of Conversion Interrupt
   Uint32 FIRQ_CPCC:1;                 // 23     Interrupt 23, CPCC Interrupt, Mode switched in CPCC module Flag needs to be read for details
   Uint32 FIRQ_TMR_COMP0:1;            // 22     Interrupt 22, 24-bit Timer Compare 0 interrupt
   Uint32 FIRQ_TMR_CAPT0:1;            // 21     Interrupt 21, 24-bit Timer Capture 0 interrupt
   Uint32 FIRQ_TMR_COMP1:1;            // 20     Interrupt 20, 24-bit Timer Compare 1 interrupt
   Uint32 FIRQ_TMR_CAPT1:1;            // 19     Interrupt 19, 24-bit Timer Capture 1 interrupt
   Uint32 FIRQ_TMR_OVFL:1;             // 18     Interrupt 18, 24-bit Timer counter overflow interrupt
   Uint32 FIRQ_PWM0_COMP:1;            // 17     Interrupt 17, 16-bit Timer PWM0 counter overflow or Compare interrupt
   Uint32 FIRQ_PWM1_COMP:1;            // 16     Interrupt 16, 16-bit Timer PWM1 counter overflow or Compare interrupt
   Uint32 FIRQ_PWM2_COMP:1;            // 15     Interrupt 15, 16-bit Timer PWM2 counter overflow or Compare interrupt
   Uint32 FIRQ_PWM3_COMP:1;            // 14     Interrupt 14, 16-bit Timer PWM3 counter overflow or Compare interrupt
   Uint32 FIRQ_FRONT_END2:1;           // 13     Interrupt 13, Front End 2 Interrupt
   Uint32 FIRQ_FRONT_END1:1;           // 12     Interrupt 12, Front End 1 Interrupt
   Uint32 FIRQ_FRONT_END0:1;           // 11     Interrupt 11, Front End 0 Interrupt
   Uint32 FIRQ_DIGI_COMP:1;            // 10     Interrupt 10, Digital comparator interrupt
   Uint32 FIRQ_PMBUS:1;                // 9      Interrupt 9, PMBus related interrupt
   Uint32 FIRQ_UART2_TX:1;             // 8      Interrupt 8, UART2 TX buffer empty
   Uint32 FIRQ_UART2_RX:1;             // 7      Interrupt 7, UART2 RX buffer has a byte
   Uint32 FIRQ_UART1_TX:1;             // 6      Interrupt 6, UART1 TX buffer empty
   Uint32 FIRQ_UART1_RX:1;             // 5      Interrupt 5, UART1 RX buffer has a byte
   Uint32 FIRQ_UART_ERR:1;             // 4      Interrupt 4, UART or SCI error Interrupt. Frame, parity or Overrun
   Uint32 FIRQ_WTDG_WAKE:1;            // 3      Interrupt 3, Wakeup interrupt when watchdog equals half of set watch time
   Uint32 FIRQ_WTDG_RSET:1;            // 2      Interrupt 2, Interrupt from watchdog exceeded (reset)
   Uint32 FIRQ_EXT_INT:1;              // 1      Interrupt 1, Interrupt on one or all external input pins
   Uint32 FIRQ_BRWN_OUT:1;             // 0      Interrupt 0, Brownout interrupt
};
union FIRQPR_REG {
   Uint32                 all;
   struct FIRQPR_BITS     bit;
};

//-------------------------------------------------
// Pending Interrupt Read Location Register bit definitions
//
struct INTREQ_BITS {                     // bits   description
   Uint32 INTREQ_SYS_SOFT:1;             // 31     Interrupt 31, System Software Interrupt
   Uint32 INTREQ_FAULT_PIN:1;            // 30     Interrupt 30, Fault Pin Interrupt
   Uint32 INTREQ_DPWM0:1;                // 29     Interrupt 29, Every(1-16)DPWM0 switching cycles or CLF flag shutdown Interrupt
   Uint32 INTREQ_DPWM1:1;                // 28     Interrupt 28, Every(1-16)DPWM1 switching cycles or CLF flag shutdown Interrupt
   Uint32 INTREQ_DPWM2:1;                // 27     Interrupt 27, Every(1-16)DPWM2 switching cycles or CLF flag shutdown Interrupt
   Uint32 INTREQ_DPWM3:1;                // 26     Interrupt 26, Every(1-16)DPWM3 switching cycles or CLF flag shutdown Interrupt
   Uint32 INTREQ_FAULT_MUX:1;            // 25     Interrupt 25, Fault Mux Interrupt
   Uint32 INTREQ_ADC_CONV:1;             // 24     Interrupt 24, ADC-12 End of Conversion Interrupt
   Uint32 INTREQ_CPCC:1;                 // 23     Interrupt 23, CPCC Interrupt, Mode switched in CPCC module Flag needs to be read for details
   Uint32 INTREQ_TMR_COMP0:1;            // 22     Interrupt 22, 24-bit Timer Compare 0 interrupt
   Uint32 INTREQ_TMR_CAPT0:1;            // 21     Interrupt 21, 24-bit Timer Capture 0 interrupt
   Uint32 INTREQ_TMR_COMP1:1;            // 20     Interrupt 20, 24-bit Timer Compare 1 interrupt
   Uint32 INTREQ_TMR_CAPT1:1;            // 19     Interrupt 19, 24-bit Timer Capture 1 interrupt
   Uint32 INTREQ_TMR_OVFL:1;             // 18     Interrupt 18, 24-bit Timer counter overflow interrupt
   Uint32 INTREQ_PWM0_COMP:1;            // 17     Interrupt 17, 16-bit Timer PWM0 counter overflow or Compare interrupt
   Uint32 INTREQ_PWM1_COMP:1;            // 16     Interrupt 16, 16-bit Timer PWM1 counter overflow or Compare interrupt
   Uint32 INTREQ_PWM2_COMP:1;            // 15     Interrupt 15, 16-bit Timer PWM2 counter overflow or Compare interrupt
   Uint32 INTREQ_PWM3_COMP:1;            // 14     Interrupt 14, 16-bit Timer PWM3 counter overflow or Compare interrupt
   Uint32 INTREQ_FRONT_END2:1;           // 13     Interrupt 13, Front End 2 Interrupt
   Uint32 INTREQ_FRONT_END1:1;           // 12     Interrupt 12, Front End 1 Interrupt
   Uint32 INTREQ_FRONT_END0:1;           // 11     Interrupt 11, Front End 0 Interrupt
   Uint32 INTREQ_DIGI_COMP:1;            // 10     Interrupt 10, Digital comparator interrupt
   Uint32 INTREQ_PMBUS:1;                // 9      Interrupt 9, PMBus related interrupt
   Uint32 INTREQ_UART2_TX:1;             // 8      Interrupt 8, UART2 TX buffer empty
   Uint32 INTREQ_UART2_RX:1;             // 7      Interrupt 7, UART2 RX buffer has a byte
   Uint32 INTREQ_UART1_TX:1;             // 6      Interrupt 6, UART1 TX buffer empty
   Uint32 INTREQ_UART1_RX:1;             // 5      Interrupt 5, UART1 RX buffer has a byte
   Uint32 INTREQ_UART_ERR:1;             // 4      Interrupt 4, UART or SCI error Interrupt. Frame, parity or Overrun
   Uint32 INTREQ_WTDG_WAKE:1;            // 3      Interrupt 3, Wakeup interrupt when watchdog equals half of set watch time
   Uint32 INTREQ_WTDG_RSET:1;            // 2      Interrupt 2, Interrupt from watchdog exceeded (reset)
   Uint32 INTREQ_EXT_INT:1;              // 1      Interrupt 1, Interrupt on one or all external input pins
   Uint32 INTREQ_BRWN_OUT:1;             // 0      Interrupt 0, Brownout interrupt
};
union INTREQ_REG {
   Uint32                 all;
   struct INTREQ_BITS     bit;
};

//-------------------------------------------------
// Interrupt Request Mask Register bit definitions
//
struct REQMASK_BITS {             // bits   description
   Uint32 REQMASK_SYS_SOFT:1;             // 31     Interrupt 31, System Software Interrupt
   Uint32 REQMASK_FAULT_PIN:1;            // 30     Interrupt 30, Fault Pin Interrupt
   Uint32 REQMASK_DPWM0:1;                // 29     Interrupt 29, Every(1-16)DPWM0 switching cycles or CLF flag shutdown Interrupt
   Uint32 REQMASK_DPWM1:1;                // 28     Interrupt 28, Every(1-16)DPWM1 switching cycles or CLF flag shutdown Interrupt
   Uint32 REQMASK_DPWM2:1;                // 27     Interrupt 27, Every(1-16)DPWM2 switching cycles or CLF flag shutdown Interrupt
   Uint32 REQMASK_DPWM3:1;                // 26     Interrupt 26, Every(1-16)DPWM3 switching cycles or CLF flag shutdown Interrupt
   Uint32 REQMASK_FAULT_MUX:1;            // 25     Interrupt 25, Fault Mux Interrupt
   Uint32 REQMASK_ADC_CONV:1;             // 24     Interrupt 24, ADC-12 End of Conversion Interrupt
   Uint32 REQMASK_CPCC:1;                 // 23     Interrupt 23, CPCC Interrupt, Mode switched in CPCC module Flag needs to be read for details
   Uint32 REQMASK_TMR_COMP0:1;            // 22     Interrupt 22, 24-bit Timer Compare 0 interrupt
   Uint32 REQMASK_TMR_CAPT0:1;            // 21     Interrupt 21, 24-bit Timer Capture 0 interrupt
   Uint32 REQMASK_TMR_COMP1:1;            // 20     Interrupt 20, 24-bit Timer Compare 1 interrupt
   Uint32 REQMASK_TMR_CAPT1:1;            // 19     Interrupt 19, 24-bit Timer Capture 1 interrupt
   Uint32 REQMASK_TMR_OVFL:1;             // 18     Interrupt 18, 24-bit Timer counter overflow interrupt
   Uint32 REQMASK_PWM0_COMP:1;            // 17     Interrupt 17, 16-bit Timer PWM0 counter overflow or Compare interrupt
   Uint32 REQMASK_PWM1_COMP:1;            // 16     Interrupt 16, 16-bit Timer PWM1 counter overflow or Compare interrupt
   Uint32 REQMASK_PWM2_COMP:1;            // 15     Interrupt 15, 16-bit Timer PWM2 counter overflow or Compare interrupt
   Uint32 REQMASK_PWM3_COMP:1;            // 14     Interrupt 14, 16-bit Timer PWM3 counter overflow or Compare interrupt
   Uint32 REQMASK_FRONT_END2:1;           // 13     Interrupt 13, Front End 2 Interrupt
   Uint32 REQMASK_FRONT_END1:1;           // 12     Interrupt 12, Front End 1 Interrupt
   Uint32 REQMASK_FRONT_END0:1;           // 11     Interrupt 11, Front End 0 Interrupt
   Uint32 REQMASK_DIGI_COMP:1;            // 10     Interrupt 10, Digital comparator interrupt
   Uint32 REQMASK_PMBUS:1;                // 9      Interrupt 9, PMBus related interrupt
   Uint32 REQMASK_UART2_TX:1;             // 8      Interrupt 8, UART2 TX buffer empty
   Uint32 REQMASK_UART2_RX:1;             // 7      Interrupt 7, UART2 RX buffer has a byte
   Uint32 REQMASK_UART1_TX:1;             // 6      Interrupt 6, UART1 TX buffer empty
   Uint32 REQMASK_UART1_RX:1;             // 5      Interrupt 5, UART1 RX buffer has a byte
   Uint32 REQMASK_UART_ERR:1;             // 4      Interrupt 4, UART or SCI error Interrupt. Frame, parity or Overrun
   Uint32 REQMASK_WTDG_WAKE:1;            // 3      Interrupt 3, Wakeup interrupt when watchdog equals half of set watch time
   Uint32 REQMASK_WTDG_RSET:1;            // 2      Interrupt 2, Interrupt from watchdog exceeded (reset)
   Uint32 REQMASK_EXT_INT:1;              // 1      Interrupt 1, Interrupt on one or all external input pins
   Uint32 REQMASK_BRWN_OUT:1;             // 0      Interrupt 0, Brownout interrupt
};
union REQMASK_REG {
   Uint32                 all;
   struct REQMASK_BITS    bit;
};


//===========================================================================
// Central Interrupt Manager Module Register File
//
struct CIM_REGS {
   union  IRQIVEC_REG    IRQIVEC;     // IRQ Index Offset Vector Register
   union  FIQIVEC_REG    FIQIVEC;     // FIQ Index Offset Vector Register                        
   Uint32                RSVD;        // Reserved (address spacer)
   union  FIRQPR_REG     FIRQPR;      // FIQ/IRQ Program Control Register
   union  INTREQ_REG     INTREQ;      // Pending Interrupt Read Location
   union  REQMASK_REG    REQMASK;     // Interrupt Mask Register
};

//---------------------------------------------------------------------------
// Central Interrupt Manager Module External References & Function Declarations:
//
extern volatile struct CIM_REGS CimRegs;

//===========================================================================


//===========================================================================
// End of file
//===========================================================================
//###########################################################################
//
// FILE:   cyclone_dec.h
//
// TITLE:  Cyclone Address Manager Register Definitions.
//
// NOTES:
//  1) Bitfields have been defined for big-endian only.
//###########################################################################
//
//  Ver  | dd mmm yyyy | Who  | Description of changes
// ======|=============|======|==============================================
//  1.00 | 12 Aug 2009 | CMF  | Started with Spartan_Dec.h.
//       |             |      | Updated for 1.0 Memory map document.
//       |             |      |
//
//  Texas Instruments, Inc
//  Copyright Texas Instruments 2008. All rights reserved.
//###########################################################################



//===========================================================================
// Address Manager Module Individual Register Bit Definitions
//

  //-----------------------------------------------------------------------------
  // Memory Fine Base Address High Register 0 bit definitions
  //-----------------------------------------------------------------------------
  struct MFBAHR0_BITS {            // bits   description
    Uint32 rsvd0:16;               // 31:16  reserved
    Uint32 ADDRESS:16;             // 15:0   Address[31:16]
  };
  union MFBAHR0_REG {
    Uint32                 all;
    struct MFBAHR0_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // Memory Fine Base Address Low Register 0 bit definitions
  //-----------------------------------------------------------------------------
  struct MFBALR0_BITS {            // bits   description
    Uint32 rsvd2:16;               // 31:16  reserved
    Uint32 ADDRESS:6;              // 15:10  Address[15:10]
    Uint32 rsvd1:1;                // 9      reserved
    Uint32 MS:1;                   // 8      Memory map select
    Uint32 BLOCK_SIZE:4;           // 7:4    Block size
    Uint32 rsvd0:2;                // 3:2    reserved
    Uint32 RONLY:1;                // 1      Read-only protection
    Uint32 PRIV:1;                 // 0      Privilege mode protection
  };
  union MFBALR0_REG {
    Uint32                 all;
    struct MFBALR0_BITS    bit;
  };
  
  //-----------------------------------------------------------------------------
  // Memory Fine Base Address High Registers 1-17 bit definitions
  //-----------------------------------------------------------------------------
  struct MFBAHRX_BITS {            // bits   description
    Uint32 rsvd0:16;               // 31:16  reserved
    Uint32 ADDRESS:16;             // 15:0   Address[31:16]
  };
  union MFBAHRX_REG {
    Uint32                 all;
    struct MFBAHRX_BITS    bit;
  };
  
  //-----------------------------------------------------------------------------
  // Memory Fine Base Address Low Registers 1-3 bit definitions
  //-----------------------------------------------------------------------------
  struct MFBALRX_BITS {            // bits   description
    Uint32 rsvd2:16;               // 31:16  reserved
    Uint32 ADDRESS:6;              // 15:10  Address[15:10]
    Uint32 AW:1;                   // 9      Auto-wait-on-write
    Uint32 rsvd1:1;                // 8      reserved
    Uint32 BLOCK_SIZE:4;           // 7:4    Block size
    Uint32 rsvd0:2;                // 3:2    reserved
    Uint32 RONLY:1;                // 1      Read-only protection
    Uint32 PRIV:1;                 // 0      Privilege mode protection
  };
  union MFBALRX_REG {
    Uint32                 all;
    struct MFBALRX_BITS    bit;
  };
  
  //-----------------------------------------------------------------------------
  // Memory Fine Base Address Low Registers 4-17 bit definitions
  //-----------------------------------------------------------------------------
  struct MFBALRY_BITS {            // bits   description
    Uint32 rsvd1:16;               // 31:16  reserved
    Uint32 ADDRESS:6;              // 15:10  Address[15:10]
    Uint32 AW:1;                   // 9      Auto-wait-on-write
    Uint32 rsvd0:7;                // 8:2    reserved
    Uint32 RONLY:1;                // 1      Read-only protection
    Uint32 PRIV:1;                 // 0      Privilege mode protection
  };
  union MFBALRY_REG {
    Uint32                 all;
    struct MFBALRY_BITS    bit;
  }; 

  //-----------------------------------------------------------------------------
  // Program Flash Control Register bit definitions
  //-----------------------------------------------------------------------------
  struct PFLASHCTRL_BITS {         // bits   description
    Uint32 rsvd1:20;               // 31:12  reserved
    Uint32 BUSY:1;                 // 11     Flash busy
    Uint32 INFO_BLOCK_ENA:1;       // 10     Info block enable
    Uint32 PAGE_ERASE:1;           // 9      Page erase enable
    Uint32 MASS_ERASE:1;           // 8      Mass erase enable
    Uint32 rsvd0:3;                // 7:5    reserved
    Uint32 PAGE_SEL:5;             // 4:0    Page selection
  };
  union PFLASHCTRL_REG {
    Uint32                     all;
    struct PFLASHCTRL_BITS     bit;
  };
  
  //-----------------------------------------------------------------------------
  // Data Flash Control Register bit definitions
  //-----------------------------------------------------------------------------
  struct DFLASHCTRL_BITS {         // bits   description
    Uint32 rsvd1:20;               // 31:12  reserved
    Uint32 BUSY:1;                 // 11     Flash busy
    Uint32 INFO_BLOCK_ENA:1;       // 10     Info block enable
    Uint32 PAGE_ERASE:1;           // 9      Page erase enable
    Uint32 MASS_ERASE:1;           // 8      Mass erase enable
    Uint32 rsvd0:2;                // 7:6    reserved
    Uint32 PAGE_SEL:6;             // 5:0    Page selection
  };
  union DFLASHCTRL_REG {
    Uint32                     all;
    struct DFLASHCTRL_BITS     bit;
  };

  //-----------------------------------------------------------------------------
  // Flash Interlock Register bit definitions
  //-----------------------------------------------------------------------------
  struct FLASHILOCK_BITS {        // bits   description
    Uint32 INTERLOCK_KEY:32;      // 31:0   Interlock Key
  };
  union FLASHILOCK_REG {
    Uint32                     all;
    struct FLASHILOCK_BITS     bit;
  };

  //=============================================================================
  // Address Manager Module Register File
  //=============================================================================
  struct DEC_REGS {
    union  MFBAHR0_REG        MFBAHR0;        // Memory Fine Base Address High Register 0
    union  MFBALR0_REG        MFBALR0;        // Memory Fine Base Address Low Register 0
    union  MFBAHRX_REG        MFBAHR1;        // Memory Fine Base Address High Register 1
    union  MFBALRX_REG        MFBALR1;        // Memory Fine Base Address Low Register 1
    union  MFBAHRX_REG        MFBAHR2;        // Memory Fine Base Address High Register 2
    union  MFBALRX_REG        MFBALR2;        // Memory Fine Base Address Low Register 2
    union  MFBAHRX_REG        MFBAHR3;        // Memory Fine Base Address High Register 3
    union  MFBALRX_REG        MFBALR3;        // Memory Fine Base Address Low Register 3
    union  MFBAHRX_REG        MFBAHR4;        // Memory Fine Base Address High Register 4
    union  MFBALRY_REG        MFBALR4;        // Memory Fine Base Address Low Register 4
    union  MFBAHRX_REG        MFBAHR5;        // Memory Fine Base Address High Register 5
    union  MFBALRY_REG        MFBALR5;        // Memory Fine Base Address Low Register 5
    union  MFBAHRX_REG        MFBAHR6;        // Memory Fine Base Address High Register 6
    union  MFBALRY_REG        MFBALR6;        // Memory Fine Base Address Low Register 6
    union  MFBAHRX_REG        MFBAHR7;        // Memory Fine Base Address High Register 7
    union  MFBALRY_REG        MFBALR7;        // Memory Fine Base Address Low Register 7
    union  MFBAHRX_REG        MFBAHR8;        // Memory Fine Base Address High Register 8
    union  MFBALRY_REG        MFBALR8;        // Memory Fine Base Address Low Register 8
    union  MFBAHRX_REG        MFBAHR9;        // Memory Fine Base Address High Register 9
    union  MFBALRY_REG        MFBALR9;        // Memory Fine Base Address Low Register 9
    union  MFBAHRX_REG        MFBAHR10;       // Memory Fine Base Address High Register 10
    union  MFBALRY_REG        MFBALR10;       // Memory Fine Base Address Low Register 10
    union  MFBAHRX_REG        MFBAHR11;       // Memory Fine Base Address High Register 11
    union  MFBALRY_REG        MFBALR11;       // Memory Fine Base Address Low Register 11
    union  MFBAHRX_REG        MFBAHR12;       // Memory Fine Base Address High Register 12
    union  MFBALRY_REG        MFBALR12;       // Memory Fine Base Address Low Register 12
    union  MFBAHRX_REG        MFBAHR13;       // Memory Fine Base Address High Register 13
    union  MFBALRY_REG        MFBALR13;       // Memory Fine Base Address Low Register 13
    union  MFBAHRX_REG        MFBAHR14;       // Memory Fine Base Address High Register 14
    union  MFBALRY_REG        MFBALR14;       // Memory Fine Base Address Low Register 14
    union  MFBAHRX_REG        MFBAHR15;       // Memory Fine Base Address High Register 15
    union  MFBALRY_REG        MFBALR15;       // Memory Fine Base Address Low Register 15
    union  MFBAHRX_REG        MFBAHR16;       // Memory Fine Base Address High Register 16
    union  MFBALRY_REG        MFBALR16;       // Memory Fine Base Address Low Register 16
    union  MFBAHRX_REG        MFBAHR17;       // Memory Fine Base Address High Register 17
    union  MFBALRY_REG        MFBALR17;       // Memory Fine Base Address Low Register 17
    union  PFLASHCTRL_REG     PFLASHCTRL;     // Program Flash Control Register
    union  DFLASHCTRL_REG     DFLASHCTRL;     // Data Flash Control Register
    union  FLASHILOCK_REG     FLASHILOCK;     // Program Flash Interlock Register
  };
  
  //---------------------------------------------------------------------------
  // Address Manager Module External References & Function Declarations:
  //
  extern volatile struct DEC_REGS DecRegs;
  
//===========================================================================


//===========================================================================
// End of file
//===========================================================================
//###############################################################################
//
// FILE:   cyclone_dpwm.h
//
// TITLE:  Cyclone Digital PWM Module Register Definitions.
//
// NOTES:
//  1) Bitfields have been defined for big-endian only.
//###############################################################################
//
//  Ver  | dd mmm yyyy | Who  | Description of changes
// ======|=============|======|==============================================
//  1.00 | 07 Oct 2009 | CMF  | Started with Spartan_Dpwm.h.
//       |             |      | Updated for 1.0 Memory map document.
//       |             |      |
//
//  Texas Instruments, Inc
//  Copyright Texas Instruments 2009. All rights reserved.
//###############################################################################



  //=============================================================================
  // DPWM Individual Register Bit Definitions
  //=============================================================================
  
  //-----------------------------------------------------------------------------
  // DPWM Control Register 0 bit definitions
  //-----------------------------------------------------------------------------
  struct DPWMCTRL0_BITS {                // bits   Description
    Uint32 PWM_B_INTRA_MUX:4;            // 31:28  PWM B Intramux Configuration
    Uint32 PWM_A_INTRA_MUX:4;            // 27:24  PWM A Intramux Configuration
    Uint32 CBC_PWM_C_EN:1;               // 23     Cycle-by-Cycle PWM C Enable
    Uint32 MULTI_MODE_CLA_B_OFF:1;       // 22     Controls PWM-B Output in Multi-Output Mode
    Uint32 MULTI_MODE_CLA_A_OFF:1;       // 21     Controls PWM-A Output in Multi-Output Mode
    Uint32 CBC_PWM_AB_EN:1;              // 20     Cycle-by-Cycle Current Limit Mode
    Uint32 CBC_ADV_CNT_EN:1;             // 19     Cycle-by-Cycle Current Limit Enable
    Uint32 MIN_DUTY_MODE:2;              // 18:17  Minimum Duty Cycle Clamp Select
    Uint32 MASTER_SYNC_CNTL_SEL:1;       // 16     Master Sync Control
    Uint32 MSYNC_SLAVE_EN:1;             // 15     Internal sync enable
    Uint32 D_ENABLE:1;                   // 14     1-D Enable
    Uint32 CBC_SYNC_CUR_LIMIT_EN:1;      // 13     Cycle-by-Cycle Sync Current Limit
    Uint32 RESON_MODE_FIXED_DUTY_EN:1;   // 12     Controls Pulse Width in Resonance Mode 
    Uint32 PWM_B_FLT_POL:1;              // 11     PWM B Fault Polarity
    Uint32 PWM_A_FLT_POL:1;              // 10     PWM A Fault Polarity        
    Uint32 BLANK_B_EN:1;                 // 9      PWM B Comparator Blanking Enable
    Uint32 BLANK_A_EN:1;                 // 8      PWM A Comparator Blanking Enable
    Uint32 PWM_MODE:4;                   // 7:4    Configures DPWM mode of operation
    Uint32 PWM_B_INV:1;                  // 3      PWM B polarity inversion
    Uint32 PWM_A_INV:1;                  // 2      PWM A polarity inversion
    Uint32 CLA_EN:1;                     // 1      PWM input selection - enable CLA input
    Uint32 PWM_EN:1;                     // 0      PWM enable
  };
  union DPWMCTRL0_REG {
    Uint32                 all;
    struct DPWMCTRL0_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Control Register 1 bit definitions
  //-----------------------------------------------------------------------------
  struct DPWMCTRL1_BITS {            // bits   description
    Uint32 PRESET_EN:1;              // 31     Preset Counter Enable
    Uint32 SYNC_FET_EN:1;            // 30     SyncFET Mode Enable
    Uint32 BURST_EN:1;               // 29     Burst (Light Load) Mode enable
    Uint32 CLA_DUTY_ADJ_EN:1;        // 28     Current/Flux Balancing Adjustment Enable
    Uint32 SYNC_OUT_DIV_SEL:4;       // 27:24  Sync out divider select
    Uint32 CLA_SCALE:3;              // 23:21  CLA scaling select
    Uint32 EXT_SYNC_EN:1;	         // 20     Slave DPWM to external sync
    Uint32 CBC_BSIDE_ACTIVE_EN:1;    // 19     Cycle-by-Cycle B Side Active Enable
    Uint32 AUTO_MODE_SEL:1;          // 18     Auto Mode Switching Select
    Uint32 EVENT_UP_SEL:2;           // 17:16  PWM Update mode
    Uint32 CHECK_OVERRIDE:1;         // 15     Override PWM checks for invalid config
    Uint32 GLOBAL_PERIOD_EN:1;       // 14     PWM Global Period Enable
    Uint32 PWM_B_OE:1;               // 13     PWM B output enable
    Uint32 PWM_A_OE:1;               // 12     PWM A output enable
    Uint32 GPIO_B_VAL:1;             // 11     PWM B output in GPIO mode
    Uint32 GPIO_B_EN:1;              // 10     PWM B output enable in GPIO mode
    Uint32 GPIO_A_VAL:1;             // 9      PWM A output in GPIO mode
    Uint32 GPIO_A_EN:1;              // 8      PWM A output enable in GPIO mode
    Uint32 PWM_HR_MULTI_OUT_EN:1;    // 7      PWM High Res Multi-Mode Output Enable
    Uint32 SFRAME_EN:1;              // 6      PWM single frame mode select
    Uint32 PWM_B_PROT_DIS:1;         // 5      PWM B async protection disable
    Uint32 PWM_A_PROT_DIS:1;         // 4      PWM A async protection disable
    Uint32 HIRES_SCALE:2;            // 3:2    Hi-resolution scale select
    Uint32 ALL_PHASE_CLK_ENA:1;      // 1      All phase clock enable
    Uint32 HIRES_DIS:1;              // 0      Hi-resolution disable
  };
  union DPWMCTRL1_REG {
    Uint32                 all;
    struct DPWMCTRL1_BITS  bit;
  };
  
  //-----------------------------------------------------------------------------
  // DPWM Control Register 2 Bit Definitions
  //-----------------------------------------------------------------------------
  struct DPWMCTRL2_BITS {              // bits   description
    Uint32 rsvd0:16;                   // 31:16  Reserved
    Uint32 SYNC_IN_DIV_RATIO:4;        // 15:12  External Sync In Divide Ratio
    Uint32 rsvd1:1;                    // 11     Reserved
    Uint32 RESON_DEADTIME_COMP_EN:1;   // 10     Selects how CLA Duty used in calculations
    Uint32 FILTER_DUTY_SEL:2;          // 9:8    Selects DPWM Duty for Mode Switching
    Uint32 IDE_DUTY_B_EN:1;            // 7      IDE Duty Cycle Side B Enable
    Uint32 rsvd2:1;                    // 6      Reserved
    Uint32 SAMPLE_TRIG1_OVERSAMPLE:2;  // 5:4    Configures Oversampling function
    Uint32 SAMPLE_TRIG1_MODE:2;        // 3:2    Sample Trigger Configuration
    Uint32 SAMPLE_TRIG_2_EN:1;         // 1      Sample Trigger 2 Enable
    Uint32 SAMPLE_TRIG_1_EN:1;         // 0      Sample Trigger 1 Enable
  };
  union DPWMCTRL2_REG {
    Uint32                 all;
    struct DPWMCTRL2_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Period Register bit definitions
  //-----------------------------------------------------------------------------
  struct DPWMPRD_BITS {              // bits   description
    Uint32 rsvd1:14;                 // 31:18  reserved
    Uint32 PRD:14;                   // 17:4   PWM Period - clock periods + 1
    Uint32 rsvd0:4;                  // 3:0    Reserved
  };
  union DPWMPRD_REG {
    Uint32                 all;
    struct DPWMPRD_BITS    bit;
  };
  
  //-----------------------------------------------------------------------------
  // DPWM Event 1 Register bit definitions
  //-----------------------------------------------------------------------------
  struct DPWMEV1_BITS {              // bits   description
    Uint32 rsvd1:14;                 // 31:18  reserved
    Uint32 EVENT1:14;                // 17:4   Event 1 configuration
    Uint32 rsvd0:4;                  // 3:0    Reserved
  };
  union DPWMEV1_REG {
    Uint32                 all;
    struct DPWMEV1_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Event 2 Register bit definitions
  //-----------------------------------------------------------------------------
  struct DPWMEV2_BITS {              // bits   description
    Uint32 rsvd0:14;                 // 31:18  reserved
    Uint32 EVENT2:18;                // 17:0   Event 2 configuration
  };
  union DPWMEV2_REG {
    Uint32                 all;
    struct DPWMEV2_BITS    bit;
  };
  
  //-----------------------------------------------------------------------------
  // DPWM Event 3 Register bit definitions
  //-----------------------------------------------------------------------------
  struct DPWMEV3_BITS {              // bits   description
    Uint32 rsvd0:14;                 // 31:18  reserved
    Uint32 EVENT3:18;                // 17:0   Event 3 configuration
  };
  union DPWMEV3_REG {
    Uint32                 all;
    struct DPWMEV3_BITS    bit;
  };
  
  //-----------------------------------------------------------------------------
  // DPWM Event 4 Register bit definitions
  //-----------------------------------------------------------------------------
  struct DPWMEV4_BITS {              // bits   description
    Uint32 rsvd0:14;                 // 31:18  reserved
    Uint32 EVENT4:18;                // 17:0   Event 4 configuration
  };
  union DPWMEV4_REG {
    Uint32                 all;
    struct DPWMEV4_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Sample Trigger 1 Register bit definitions
  //-----------------------------------------------------------------------------
  struct DPWMSAMPTRIG1_BITS {        // bits   description
    Uint32 rsvd1:14;                 // 31:12  reserved
    Uint32 SAMPLE_TRIGGER:12;        // 17:6   Sample trigger configuration
    Uint32 rsvd0:6;                  // 5:0    reserved
  };
  union DPWMSAMPTRIG1_REG {
    Uint32                       all;
    struct DPWMSAMPTRIG1_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Sample Trigger 2 Register bit definitions
  //-----------------------------------------------------------------------------
  struct DPWMSAMPTRIG2_BITS {        // bits   description
    Uint32 rsvd1:14;                 // 31:12  reserved
    Uint32 SAMPLE_TRIGGER:12;        // 17:6   Sample trigger configuration
    Uint32 rsvd0:6;                  // 5:0    reserved
  };
  union DPWMSAMPTRIG2_REG {
    Uint32                       all;
    struct DPWMSAMPTRIG2_BITS    bit;
  };  

  //-----------------------------------------------------------------------------
  // DPWM Phase Trigger Register bit definitions
  //-----------------------------------------------------------------------------
  struct DPWMPHASETRIG_BITS {        // bits   description
    Uint32 rsvd1:14;                 // 31:14  reserved
    Uint32 PHASE_TRIGGER:14;         // 17:4   Phase trigger configuration
    Uint32 rsvd0:4;                  // 3:0    Reserved
  };
  union DPWMPHASETRIG_REG {
    Uint32                       all;
    struct DPWMPHASETRIG_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Cycle Adjust A Register bit definitions
  //-----------------------------------------------------------------------------
  struct DPWMCYCADJA_BITS {          // bits   description
    Uint32 rsvd0:16;                 // 31:16  Reserved
    int32 CYCLE_ADJUST_A:16;        // 15:0   Cycle Adjust A
  };
  union DPWMCYCADJA_REG {
    int32                    all;
    struct DPWMCYCADJA_BITS   bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Cycle Adjust B Register bit definitions
  //-----------------------------------------------------------------------------
  struct DPWMCYCADJB_BITS {          // bits   description
    Uint32 rsvd0:16;                 // 31:16  Reserved
    int32 CYCLE_ADJUST_B:16;        // 15:0   Cycle Adjust B
  };
  union DPWMCYCADJB_REG {
    int32                    all;
    struct DPWMCYCADJB_BITS   bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Resonant Duty Register bit definitions
  //-----------------------------------------------------------------------------
  struct DPWMRESDUTY_BITS {          // bits   description
    Uint32 rsvd0:16;                // 31:16  Reserved
    int32 RESONANT_DUTY:16;        // 15:0   Period Adjust 
  };
  union DPWMRESDUTY_REG {
    Uint32                   all;
    struct DPWMRESDUTY_BITS   bit;
  };  

  //-----------------------------------------------------------------------------
  // DPWM Fault Control Register bit definitions
  //-----------------------------------------------------------------------------
  struct DPWMFLTCTRL_BITS {          // bits   description
    Uint32 ALL_FAULT_EN:1;           // 31     Fault Module Enable
    Uint32 CBC_FAULT_EN:1;           // 30     CBC Fault Module Enable
    Uint32 rsvd0:1;                  // 29     Reserved
    Uint32 CBC_MAX_COUNT:5;          // 28:24  Cycle-by-Cycle Max Count
    Uint32 rsvd1:3;                  // 23:21  Reserved
    Uint32 AB_MAX_COUNT:5;           // 20:16  Fault AB Cycle Max Count
    Uint32 rsvd2:3;                  // 15:13  Reserved
    Uint32 A_MAX_COUNT:5;            // 12:8   Fault AB Cycle Max Count
    Uint32 rsvd3:3;                  // 7:5    Reserved
    Uint32 B_MAX_COUNT:5;            // 4:0    Fault AB Cycle Max Count
  };
  union DPWMFLTCTRL_REG {
    Uint32                    all;
    struct DPWMFLTCTRL_BITS   bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Overflow Register
  //-----------------------------------------------------------------------------
  struct DPWMOVERFLOW_BITS {         // bits   description
    Uint32 rsvd0:24;                 // 31:8   Reserved
    Uint32 PWM_B_CHECK:1;            // 7      Value of PWM B Internal Check
    Uint32 PWM_A_CHECK:1;            // 6      Value of PWM A Internal Check
    Uint32 GPIO_B_IN:1;              // 5      Input value of PWM B 
    Uint32 GPIO_A_IN:1;              // 4      Input value of PWM A
    Uint32 OVERFLOW:4;               // 3:0    DPWM Overflow status
  };
  union DPWMOVERFLOW_REG {
    Uint32                   all;
    struct DPWMOVERFLOW_BITS bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Interrupt Register
  //-----------------------------------------------------------------------------
  struct DPWMINT_BITS {              // bits   description
    Uint32 rsvd0:9;                  // 31:23  Reserved
    Uint32 MODE_SWITCH:1;            // 22     Mode Switching Flag
    Uint32 FLT_A:1;                  // 21     Fault A Flag
    Uint32 FLT_B:1;                  // 20     Fault B Flag
    Uint32 FLT_AB:1;                 // 19     Fault AB Flag
    Uint32 FLT_CBC:1;                // 18     Fault CBC Flag 
    Uint32 PRD:1;                    // 17     PWM Period Interrupt Flag
    Uint32 INT:1;                    // 16     Interrupt Status
    Uint32 rsvd1:4;                  // 15:12  Reserved
    Uint32 MODE_SWITCH_FLAG_CLR:1;   // 11     Mode Switching Flag Clear
    Uint32 MODE_SWITCH_FLAG_EN:1;    // 10     Mode Switching Flag Enable
    Uint32 MODE_SWITCH_INT_EN:1;     // 9      Mode Switching Interrupt Enable
    Uint32 FLT_A_INT_EN:1;           // 8      Fault A Interrupt Enable
    Uint32 FLT_B_INT_EN:1;           // 7      Fault B Interrupt Enable
    Uint32 FLT_AB_INT_EN:1;          // 6      Fault AB Interrupt Enable
    Uint32 FLT_CBC_INT_EN:1;         // 5      Fault CBC Interrupt Enable
    Uint32 PRD_INT_EN:1;             // 4      End-of-Period Interrupt Enable
    Uint32 PRD_INT_SCALE:4;          // 3:0    End-of-Period Interrupt Scale
  };
  union DPWMINT_REG {
    Uint32                   all;
    struct DPWMINT_BITS      bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Counter Preset Register
  //-----------------------------------------------------------------------------
  struct DPWMCNTPRE_BITS {          // bits     Description
    Uint32 rsvd1:14;                // 31:14    Reserved
    Uint32 PRESET:14;               // 17:4     Preset DPWM Counter value
    Uint32 rsvd0:4;                 // 3:0      Reserved
  };
  union DPWMCNTPRE_REG {
    Uint32                  all;
    struct DPWMCNTPRE_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Blanking A Begin Register
  //-----------------------------------------------------------------------------
  struct DPWMBLKABEG_BITS {          // bits     Description
    Uint32 rsvd1:14;                 // 31:18    Reserved
    Uint32 BLANK_A_BEGIN:14;         // 17:4     Start of PWM A Comparator Blanking
    Uint32 rsvd0:4;                  // 3:0      Reserved
  };
  union DPWMBLKABEG_REG {
    Uint32                  all;
    struct DPWMBLKABEG_BITS bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Blanking A End Register
  //-----------------------------------------------------------------------------
  struct DPWMBLKAEND_BITS {          // bits     Description
    Uint32 rsvd1:14;                 // 31:18    Reserved
    Uint32 BLANK_A_END:14;           // 17:4     End of PWM A Comparator Blanking
    Uint32 rsvd0:4;                  // 3:0      Reserved
  };
  union DPWMBLKAEND_REG {
    Uint32                  all;
    struct DPWMBLKAEND_BITS bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Blanking B Begin Register
  //-----------------------------------------------------------------------------
  struct DPWMBLKBBEG_BITS {          // bits     Description
    Uint32 rsvd1:14;                 // 31:18    Reserved
    Uint32 BLANK_B_BEGIN:14;         // 17:4     Start of PWM B Comparator Blanking
    Uint32 rsvd0:4;                  // 3:0      Reserved
  };
  union DPWMBLKBBEG_REG {
    Uint32                  all;
    struct DPWMBLKBBEG_BITS bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Blanking A End Register
  //-----------------------------------------------------------------------------
  struct DPWMBLKBEND_BITS {          // bits     Description
    Uint32 rsvd1:14;                 // 31:18    Reserved
    Uint32 BLANK_B_END:14;           // 17:4     End of PWM B Comparator Blanking
    Uint32 rsvd0:4;                  // 3:0      Reserved
  };
  union DPWMBLKBEND_REG {
    Uint32                  all;
    struct DPWMBLKBEND_BITS bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Minimum Duty Cycle High Register
  //-----------------------------------------------------------------------------
  struct DPWMMINDUTYHI_BITS {       // bits     Description
    Uint32 rsvd1:14;                // 31:18    Reserved
    Uint32 MIN_DUTY_HIGH:14;        // 17:4     Minimum Duty High Threshold
    Uint32 rsvd0:4;                 // 3:0      Reserved
  };
  union DPWMMINDUTYHI_REG {
    Uint32                    all;
    struct DPWMMINDUTYHI_BITS bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Minimum Duty Cycle Low Register
  //-----------------------------------------------------------------------------
  struct DPWMMINDUTYLO_BITS {       // bits     Description
    Uint32 rsvd1:14;                // 31:18    Reserved
    Uint32 MIN_DUTY_LOW:14;         // 17:4     Minimum Duty Low Threshold
    Uint32 rsvd0:4;                 // 3:0      Reserved
  };
  union DPWMMINDUTYLO_REG {
    Uint32                    all;
    struct DPWMMINDUTYLO_BITS bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Adaptive Sample Register
  //-----------------------------------------------------------------------------
  struct DPWMADAPTIVE_BITS {        // bits    Description
    Uint32 rsvd0:20;                // 31:12   Reserved
    int32 ADAPT_SAMP:12;           // 11:0    Adaptive Sample Adjust
  };
  union DPWMADAPTIVE_REG {
    Uint32                   all;
    struct DPWMADAPTIVE_BITS bit;
  }; 
  
  //-----------------------------------------------------------------------------
  // DPWM Fault Status Register
  //-----------------------------------------------------------------------------
  struct DPWMFLTSTAT_BITS {         // bits    Description
    Uint32 rsvd0:26;                // 31:6    Reserved
    Uint32 BURST:1;                 // 5       Burst Mode
    Uint32 IDE_DETECT:1;            // 4       IDE Detect Indication
    Uint32 FLT_A:1;                 // 3       Fault A Detection
    Uint32 FLT_B:1;                 // 2       Fault B Detection
    Uint32 FLT_AB:1;                // 1       Fault AB Detection
    Uint32 FLT_CBC:1;               // 0       Current Limit Detection
  };
  union DPWMFLTSTAT_REG {
    Uint32                   all;
    struct DPWMFLTSTAT_BITS  bit;
  };   

  //-----------------------------------------------------------------------------
  // DPWM Auto Switch High Upper Thresh Register
  //-----------------------------------------------------------------------------
  struct DPWMAUTOSWHIUPTHRESH_BITS {  // bits    Description
    Uint32 rsvd1:14;                  // 31:18   Reserved
    Uint32 AUTO_SWITCH_HIGH_UPPER:14; // 17:4    Auto Switch High Threshold
    Uint32 rsvd0:4;                   // 3:0     Reserved
  };
  union DPWMAUTOSWHIUPTHRESH_REG {
    Uint32                           all;
    struct DPWMAUTOSWHIUPTHRESH_BITS bit;
  };
  
  //-----------------------------------------------------------------------------
  // DPWM Auto Switch High Lower Thresh Register
  //-----------------------------------------------------------------------------
  struct DPWMAUTOSWHILOWTHRESH_BITS { // bits    Description
    Uint32 rsvd1:14;                  // 31:18   Reserved
    Uint32 AUTO_SWITCH_HIGH_LOWER:14; // 17:4    Auto Switch High Threshold
    Uint32 rsvd0:4;                   // 3:0     Reserved
  };
  union DPWMAUTOSWHILOWTHRESH_REG {
    Uint32                            all;
    struct DPWMAUTOSWHILOWTHRESH_BITS bit;
  };  

  //-----------------------------------------------------------------------------
  // DPWM Auto Switch Low Upper Thresh Register
  //-----------------------------------------------------------------------------
  struct DPWMAUTOSWLOUPTHRESH_BITS{   // bits    Description
    Uint32 rsvd1:14;                  // 31:18   Reserved
    Uint32 AUTO_SWITCH_LOW_UPPER:14;  // 17:4    Auto Switch Low Threshold
    Uint32 rsvd0:4;                   // 3:0     Reserved
  };
  union DPWMAUTOSWLOUPTHRESH_REG {
    Uint32                           all;
    struct DPWMAUTOSWLOUPTHRESH_BITS bit;
  };  

  //-----------------------------------------------------------------------------
  // DPWM Auto Switch Low Lower Thresh Register
  //-----------------------------------------------------------------------------
  struct DPWMAUTOSWLOLOWTHRESH_BITS{  // bits    Description
    Uint32 rsvd1:14;                  // 31:18   Reserved
    Uint32 AUTO_SWITCH_LOW_LOWER:14;  // 17:4    Auto Switch Low Threshold
    Uint32 rsvd0:4;                   // 3:0     Reserved
  };
  union DPWMAUTOSWLOLOWTHRESH_REG {
    Uint32                            all;
    struct DPWMAUTOSWLOLOWTHRESH_BITS bit;
  };  

  //-----------------------------------------------------------------------------
  // DPWM Auto Config Max Register
  //-----------------------------------------------------------------------------
  struct DPWMAUTOMAX_BITS {              // bits    Description
    Uint32 PWM_B_INTRA_MUX:4;            // 31:28   PWM B Intramux Configuration
    Uint32 PWM_A_INTRA_MUX:4;            // 27:24   PWM A Intramux Configuration
    Uint32 CBC_PWM_C_EN:1;               // 23      Cycle-by-Cycle PWM C Enable
    Uint32 MULTI_MODE_CLA_B_OFF:1;       // 22      Controls PWM-B Output in Multi-Output Mode
    Uint32 rsvd1:1;                      // 21      Reserved
    Uint32 CBC_PWM_AB_EN:1;              // 20      Cycle-by-Cycle Current Limit Mode
    Uint32 CBC_ADV_CNT_EN:1;             // 19      Cycle-by-Cycle Current Limit Enable
    Uint32 rsvd2:2;                      // 18:17   Reserved
    Uint32 MASTER_SYNC_CNTL_SEL:1;       // 16      Master Sync Control
    Uint32 rsvd3:2;                      // 15:14   Reserved
    Uint32 CBC_SYNC_CUR_LIMIT_EN:1;      // 13      Cycle-by-Cycle Sync Current Limit Enable
    Uint32 RESON_MODE_FIXED_DUTY_EN:1;   // 12      Controls Pulse Width in Resonance Mode
    Uint32 rsvd4:4;                      // 11:8     Reserved
    Uint32 PWM_MODE:4;                   // 7:4     Configures DPWM mode of operation
    Uint32 rsvd5:2;                      // 3:2     Reserved
    Uint32 CLA_EN:1;                     // 1       PWM input selection - enable CLA input
    Uint32 rsvd6:1;                      // 0       Reserved
  };
  union DPWMAUTOMAX_REG {
    Uint32                  all;
    struct DPWMAUTOMAX_BITS bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Auto Config Mid Register
  //-----------------------------------------------------------------------------
  struct DPWMAUTOMID_BITS {              // bits    Description
    Uint32 PWM_B_INTRA_MUX:4;            // 31:28   PWM B Intramux Configuration
    Uint32 PWM_A_INTRA_MUX:4;            // 27:24   PWM A Intramux Configuration
    Uint32 CBC_PWM_C_EN:1;               // 23      Cycle-by-Cycle PWM C Enable
    Uint32 MULTI_MODE_CLA_B_OFF:1;       // 22      Controls PWM-B Output in Multi-Output Mode
    Uint32 rsvd1:1;                      // 21      Reserved
    Uint32 CBC_PWM_AB_EN:1;              // 20      Cycle-by-Cycle Current Limit Mode
    Uint32 CBC_ADV_CNT_EN:1;             // 19      Cycle-by-Cycle Current Limit Enable
    Uint32 rsvd2:2;                      // 18:17   Reserved
    Uint32 MASTER_SYNC_CNTL_SEL:1;       // 16      Master Sync Control
    Uint32 rsvd3:2;                      // 15:14   Reserved
    Uint32 CBC_SYNC_CUR_LIMIT_EN:1;      // 13      Cycle-by-Cycle Sync Current Limit Enable
    Uint32 RESON_MODE_FIXED_DUTY_EN:1;   // 12      Controls Pulse Width in Resonance Mode
    Uint32 rsvd4:4;                      // 11:8     Reserved
    Uint32 PWM_MODE:4;                   // 7:4     Configures DPWM mode of operation
    Uint32 rsvd5:2;                      // 3:2     Reserved
    Uint32 CLA_EN:1;                     // 1       PWM input selection - enable CLA input
    Uint32 rsvd6:1;                      // 0       Reserved
  };
  union DPWMAUTOMID_REG {
    Uint32                  all;
    struct DPWMAUTOMID_BITS bit;
  };  

  //-----------------------------------------------------------------------------
  // DPWM Edge PWM Generation Control Register
  //-----------------------------------------------------------------------------
  struct DPWMEDGEGEN_BITS {              // bits    Description
    Uint32 rsvd0:15;                     // 31:17   Reserved
    Uint32 EDGE_EN:1;                    // 16      Enables Edge Generate Module
    Uint32 rsvd1:1;                      // 15      Reserved
    Uint32 A_ON_EDGE:3;                  // 14:12   A On Edge Trigger Select
    Uint32 rsvd2:1;                      // 11      Reserved
    Uint32 A_OFF_EDGE:3;                 // 10:8    A Off Edge Trigger Select
    Uint32 rsvd3:1;                      // 7       Reserved
    Uint32 B_ON_EDGE:3;                  // 6:4     B On Edge Trigger Select
    Uint32 rsvd4:1;                      // 3       Reserved
    Uint32 B_OFF_EDGE:3;                 // 2:0     B Off Edge Trigger Select
  };
  union DPWMEDGEGEN_REG {
    Uint32                  all;
    struct DPWMEDGEGEN_BITS bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM Filter Duty Read Register
  //-----------------------------------------------------------------------------
  struct DPWMFILTERDUTYREAD_BITS {       // bits    Description
    Uint32 rsvd0:14;                     // 31:18   Reserved
    Uint32 FILTER_DUTY:18;               // 17:0    Filter Duty
  };
  union DPWMFILTERDUTYREAD_REG {
    Uint32                         all;
    struct DPWMFILTERDUTYREAD_BITS bit;
  };  

  //-----------------------------------------------------------------------------
  // DPWM BIST Status Register
  //-----------------------------------------------------------------------------
  struct DPWMBISTSTAT_BITS {            // bits     Description
    Uint32 rsvd0:17;                    // 31:15    Reserved
    Uint32 BIST_CNT:15;                 // 14:0     BIST Count
  };
  union DPWMBISTSTAT_REG {
    Uint32                         all;
    struct DPWMBISTSTAT_BITS       bit;
  };

  //=============================================================================
  // DPWM Module Register File
  //=============================================================================
  struct DPWM_REGS {
    union DPWMCTRL0_REG               DPWMCTRL0;
    union DPWMCTRL1_REG               DPWMCTRL1;
    union DPWMCTRL2_REG               DPWMCTRL2;
    union DPWMPRD_REG	              DPWMPRD;
    union DPWMEV1_REG	              DPWMEV1;
    union DPWMEV2_REG	              DPWMEV2;
    union DPWMEV3_REG	              DPWMEV3;
    union DPWMEV4_REG	              DPWMEV4;
    union DPWMSAMPTRIG1_REG           DPWMSAMPTRIG1;
    union DPWMSAMPTRIG2_REG           DPWMSAMPTRIG2;
    union DPWMPHASETRIG_REG           DPWMPHASETRIG;
    union DPWMCYCADJA_REG             DPWMCYCADJA;
    union DPWMCYCADJB_REG             DPWMCYCADJB;
    union DPWMRESDUTY_REG             DPWMRESDUTY;
    union DPWMFLTCTRL_REG             DPWMFLTCTRL;
    union DPWMOVERFLOW_REG            DPWMOVERFLOW;
    union DPWMINT_REG                 DPWMINT;
    union DPWMCNTPRE_REG              DPWMCNTPRE;
    union DPWMBLKABEG_REG             DPWMBLKABEG;
    union DPWMBLKAEND_REG             DPWMBLKAEND;
    union DPWMBLKBBEG_REG             DPWMBLKBBEG;
    union DPWMBLKBEND_REG             DPWMBLKBEND;
    union DPWMMINDUTYHI_REG           DPWMMINDUTYHI;
    union DPWMMINDUTYLO_REG           DPWMMINDUTYLO;
    union DPWMADAPTIVE_REG            DPWMADAPTIVE;
    union DPWMFLTSTAT_REG             DPWMFLTSTAT;
    union DPWMAUTOSWHIUPTHRESH_REG    DPWMAUTOSWHIUPTHRESH;
    union DPWMAUTOSWHILOWTHRESH_REG   DPWMAUTOSWHILOWTHRESH;
    union DPWMAUTOSWLOUPTHRESH_REG    DPWMAUTOSWLOUPTHRESH;
    union DPWMAUTOSWLOLOWTHRESH_REG   DPWMAUTOSWLOLOWTHRESH;
    union DPWMAUTOMAX_REG             DPWMAUTOMAX;
    union DPWMAUTOMID_REG             DPWMAUTOMID;
    union DPWMEDGEGEN_REG             DPWMEDGEGEN;
    union DPWMFILTERDUTYREAD_REG      DPWMFILTERDUTYREAD;
    union DPWMBISTSTAT_REG            DPWMBISTSTAT;
  };

  //-----------------------------------------------------------------------------
  // DPWM Module External References & Function Declarations:
  //-----------------------------------------------------------------------------
  extern volatile struct DPWM_REGS Dpwm0Regs;
  extern volatile struct DPWM_REGS Dpwm1Regs;
  extern volatile struct DPWM_REGS Dpwm2Regs;
  extern volatile struct DPWM_REGS Dpwm3Regs;

//===========================================================================


//===========================================================================
// End of file
//===========================================================================
//#include "../header files/cyclone_errlog.h"      // ERRLOG Register (for simulation only)
//###############################################################################
//
// FILE:   cyclone_fault_mux.h
//
// TITLE:  Cyclone Fault Mux Register Definitions.
//
// NOTES:
//  1) Bitfields have been defined for big-endian only.
//###############################################################################
//
//  Ver  | dd mmm yyyy | Who  | Description of changes
// ======|=============|======|==============================================
//  1.00 | 20 Aug 2009 | CMF  | Initial Revision
//       |             |      | 
//       |             |      |
//
//  Texas Instruments, Inc
//  Copyright Texas Instruments 2009. All rights reserved.
//###############################################################################



  //=============================================================================
  // Fault Mux Individual Register Bit Definitions
  //=============================================================================

  //-----------------------------------------------------------------------------
  // Analog Comparator Control 0 Register
  //-----------------------------------------------------------------------------
  struct ACOMPCTRL0_BITS {          // bits   description
    Uint32 rsvd3:1;                 // 31     Reserved
    Uint32 ACOMP_B_THRESH:7;        // 30:24  Analog Comparator B Threshold
    Uint32 rsvd2:2;                 // 23:22  Reserved
    Uint32 ACOMP_B_SEL:3;           // 21:19  Analog Comparator B Select
    Uint32 ACOMP_B_POL:1;           // 18     Analog Comparator B Polarity
    Uint32 ACOMP_B_INT_EN:1;        // 17     Analog Comparator B Interrupt Enable
    Uint32 rsvd1:2;                 // 16:15  Reserved
    Uint32 ACOMP_A_THRESH:7;        // 14:8   Analog Comparator A Threshold
    Uint32 rsvd0:2;                 // 7:6    Reserved
    Uint32 ACOMP_A_SEL:3;           // 5:3    Analog Comparator A Select
    Uint32 ACOMP_A_POL:1;           // 2      Analog Comparator A Polarity
    Uint32 ACOMP_A_INT_EN:1;        // 1      Analog Comparator A Interrupt Enable
    Uint32 ACOMP_EN:1;              // 0      Analog Comparator A Enable
  }; 
  union ACOMPCTRL0_REG {
    Uint32                    all;
    struct ACOMPCTRL0_BITS    bit;
  };
  
  //-----------------------------------------------------------------------------
  // Analog Comparator Control 1 Register
  //-----------------------------------------------------------------------------
  struct ACOMPCTRL1_BITS {          // bits   description
    Uint32 rsvd4:1;                 // 31     Reserved
    Uint32 ACOMP_D_THRESH:7;        // 30:24  Analog Comparator D Threshold
    Uint32 rsvd3:2;                 // 23:22  Reserved
    Uint32 ACOMP_D_SEL:3;           // 21:19  Analog Comparator D Select
    Uint32 ACOMP_D_POL:1;           // 18     Analog Comparator D Polarity
    Uint32 ACOMP_D_INT_EN:1;        // 17     Analog Comparator D Interrupt Enable
    Uint32 ACOMP_D_OUT_EN:1;        // 16     Analog Comparator D DAC Output Enable
    Uint32 rsvd2:1;                 // 15     Reserved
    Uint32 ACOMP_C_THRESH:7;        // 14:8   Analog Comparator C Threshold
    Uint32 rsvd1:2;                 // 7:6    Reserved
    Uint32 ACOMP_C_SEL:3;           // 5:3    Analog Comparator C Select
    Uint32 ACOMP_C_POL:1;           // 2      Analog Comparator C Polarity
    Uint32 ACOMP_C_INT_EN:1;        // 1      Analog Comparator C Interrupt Enable
    Uint32 rsvd0:1;                 // 0      Reserved
  }; 
  union ACOMPCTRL1_REG {
    Uint32                    all;
    struct ACOMPCTRL1_BITS    bit;
  };
  
  //-----------------------------------------------------------------------------
  // Analog Comparator Control 2 Register
  //-----------------------------------------------------------------------------
  struct ACOMPCTRL2_BITS {          // bits   description
    Uint32 rsvd4:1;                 // 31     Reserved
    Uint32 ACOMP_F_THRESH:7;        // 30:24  Analog Comparator F Threshold
    Uint32 rsvd3:1;                 // 23     Reserved
    Uint32 ACOMP_F_REF_SEL:1;       // 22     Analog Comparator F Ref Select
    Uint32 ACOMP_F_SEL:3;           // 21:19  Analog Comparator F Select
    Uint32 ACOMP_F_POL:1;           // 18     Analog Comparator F Polarity
    Uint32 ACOMP_F_INT_EN:1;        // 17     Analog Comparator F Interrupt Enable
    Uint32 ACOMP_F_OUT_EN:1;        // 16     Analog Comparator F DAC Output Enable
    Uint32 rsvd2:1;                 // 15     Reserved
    Uint32 ACOMP_E_THRESH:7;        // 14:8   Analog Comparator E Threshold
    Uint32 rsvd1:2;                 // 7:6    Reserved
    Uint32 ACOMP_E_SEL:3;           // 5:3    Analog Comparator E Select
    Uint32 ACOMP_E_POL:1;           // 2      Analog Comparator E Polarity
    Uint32 ACOMP_E_INT_EN:1;        // 1      Analog Comparator E Interrupt Enable
    Uint32 ACOMP_E_OUT_EN:1;        // 0      Analog Comparator E DAC Output Enable
  }; 
  union ACOMPCTRL2_REG {
    Uint32                    all;
    struct ACOMPCTRL2_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // Analog Comparator Control 3 Register
  //-----------------------------------------------------------------------------
  struct ACOMPCTRL3_BITS {          // bits   description
    Uint32 rsvd2:17;                // 31:15  Reserved
    Uint32 ACOMP_G_THRESH:7;        // 14:8   Analog Comparator G Threshold
    Uint32 rsvd1:2;                 // 7:6    Reserved
    Uint32 ACOMP_G_SEL:3;           // 5:3    Analog Comparator G Select
    Uint32 ACOMP_G_POL:1;           // 2      Analog Comparator G Polarity
    Uint32 ACOMP_G_INT_EN:1;        // 1      Analog Comparator G Interrupt Enable
    Uint32 ACOMP_G_OUT_EN:1;        // 0      Analog Comparator G DAC Output Enable
  }; 
  union ACOMPCTRL3_REG {
    Uint32                    all;
    struct ACOMPCTRL3_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // External Fault Control Register
  //-----------------------------------------------------------------------------
  struct EXTFAULTCTRL_BITS {       // Bits   Description
    Uint32 rsvd0:20;               // 31:12  Reserved
    Uint32 FAULT3_POL:1;           // 11     External FAULT[3] Polarity
    Uint32 FAULT2_POL:1;           // 10     External FAULT[2] Polarity
    Uint32 FAULT1_POL:1;           // 9      External FAULT[1] Polarity
    Uint32 FAULT0_POL:1;           // 8      External FAULT[0] Polarity
    Uint32 FAULT3_INT_EN:1;        // 7      External FAULT[3] Interrupt Enable
    Uint32 FAULT2_INT_EN:1;        // 6      External FAULT[2] Interrupt Enable
    Uint32 FAULT1_INT_EN:1;        // 5      External FAULT[1] Interrupt Enable
    Uint32 FAULT0_INT_EN:1;        // 4      External FAULT[0] Interrupt Enable
    Uint32 FAULT3_DET_EN:1;        // 3      External FAULT[3] Detection Enable
    Uint32 FAULT2_DET_EN:1;        // 2      External FAULT[2] Detection Enable
    Uint32 FAULT1_DET_EN:1;        // 1      External FAULT[1] Detection Enable
    Uint32 FAULT0_DET_EN:1;        // 0      External FAULT[0] Detection Enable
  };
  union EXTFAULTCTRL_REG {
    Uint32                    all;
    struct EXTFAULTCTRL_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // Fault Mux Interrupt Status Register
  //-----------------------------------------------------------------------------
  struct FAULTMUXINTSTAT_BITS {     // bits   description
    Uint32 rsvd0:15;                // 31:17  Reserved
    Uint32 DCOMP3:1;                // 16     Digital Comparator 3 Interrupt Status
    Uint32 DCOMP2:1;                // 15     Digital Comparator 2 Interrupt Status
    Uint32 DCOMP1:1;                // 14     Digital Comparator 1 Interrupt Status
    Uint32 DCOMP0:1;                // 13     Digital Comparator 0 Interrupt Status
    Uint32 LFO_FAIL:1;              // 12     Low Frequency Oscillator Failure
    Uint32 FAULT3:1;                // 11     External FAULT[3] Detect Interrupt Status
    Uint32 FAULT2:1;                // 10     External FAULT[2] Detect Interrupt Status
    Uint32 FAULT1:1;                // 9      External FAULT[1] Detect Interrupt Status
    Uint32 FAULT0:1;                // 8      External FAULT[0] Detect Interrupt Status
    Uint32 DCM_DETECT:1;            // 7      Discontinuous Conduction Mode
    Uint32 ACOMP_G:1;               // 6      Analog Comparator G Interrupt Status
    Uint32 ACOMP_F:1;               // 5      Analog Comparator F Interrupt Status
    Uint32 ACOMP_E:1;               // 4      Analog Comparator E Interrupt Status
    Uint32 ACOMP_D:1;               // 3      Analog Comparator D Interrupt Status
    Uint32 ACOMP_C:1;               // 2      Analog Comparator C Interrupt Status
    Uint32 ACOMP_B:1;               // 1      Analog Comparator B Interrupt Status
    Uint32 ACOMP_A:1;               // 0      Analog Comparator A Interrupt Status
  };
  union FAULTMUXINTSTAT_REG {
    Uint32                        all;
    struct FAULTMUXINTSTAT_BITS   bit;
  };

  //-----------------------------------------------------------------------------
  // Fault Mux Raw Status Register
  //-----------------------------------------------------------------------------
  struct FAULTMUXRAWSTAT_BITS {     // bits   description
    Uint32 rsvd0:15;                // 31:17  Reserved
    Uint32 DCOMP3:1;                // 16     Digital Comparator 3 Raw Status
    Uint32 DCOMP2:1;                // 15     Digital Comparator 2 Raw Status
    Uint32 DCOMP1:1;                // 14     Digital Comparator 1 Raw Status
    Uint32 DCOMP0:1;                // 13     Digital Comparator 0 Raw Status
    Uint32 LFO_FAIL:1;              // 12     Low Frequency Oscillator Failure
    Uint32 FAULT3:1;                // 11     External FAULT[2] Detect Raw Status
    Uint32 FAULT2:1;                // 10     External FAULT[2] Detect Raw Status
    Uint32 FAULT1:1;                // 9      External FAULT[1] Detect Raw Status
    Uint32 FAULT0:1;                // 8      External FAULT[0] Detect Raw Status
    Uint32 DCM_DETECT:1;            // 7      Discontinuous Conduction Mode
    Uint32 ACOMP_G:1;               // 6      Analog Comparator G Raw Status
    Uint32 ACOMP_F:1;               // 5      Analog Comparator F Raw Status
    Uint32 ACOMP_E:1;               // 4      Analog Comparator E Raw Status
    Uint32 ACOMP_D:1;               // 3      Analog Comparator D Raw Status
    Uint32 ACOMP_C:1;               // 2      Analog Comparator C Raw Status
    Uint32 ACOMP_B:1;               // 1      Analog Comparator B Raw Status
    Uint32 ACOMP_A:1;               // 0      Analog Comparator A Raw Status
  };
  union FAULTMUXRAWSTAT_REG {
    Uint32                        all;
    struct FAULTMUXRAWSTAT_BITS   bit;
  };

  //-----------------------------------------------------------------------------
  // Comparator Ramp Control 0 Register
  //-----------------------------------------------------------------------------
  struct COMPRAMP0_BITS {           // Bits   Description
    Uint32 START_VALUE_SEL:4;       // 31:28  Selects Ramp Start Value
    Uint32 STEP_SIZE:18;            // 27:10  Comparator Ramp Step Size
    Uint32 CLKS_PER_STEP:5;         // 9:5    Clocks per Ramp Step
    Uint32 DPWM3_TRIG_EN:1;         // 4      DPWM3 Trigger Enable
    Uint32 DPWM2_TRIG_EN:1;         // 3      DPWM2 Trigger Enable
    Uint32 DPWM1_TRIG_EN:1;         // 2      DPWM1 Trigger Enable
    Uint32 DPWM0_TRIG_EN:1;         // 1      DPWM0 Trigger Enable
    Uint32 RAMP_EN:1;               // 0      Ramp Enable
  };
  union COMPRAMP0_REG {
    Uint32                   all;
    struct COMPRAMP0_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // Digital Comparator Control 0 Register 
  //-----------------------------------------------------------------------------
  struct DCOMPCTRL0_BITS {          // Bits   Description
    Uint32 CNT_THRESH:8;            // 31:24  Digital Comparator Counter Threshold
    Uint32 rsvd0:5;                 // 23:19  Reserved
    Uint32 COMP_POL:1;              // 18     Digital Comparator Polarity Select
    Uint32 FE_SEL:3;                // 17:15  Digital Comparator Front End Select
    Uint32 CNT_CLR:1;               // 14     Digital Comparator Counter Clear
    Uint32 CNT_CONFIG:1;            // 13     Digital Comparator Counter Configuration
    Uint32 INT_EN:1;                // 12     Digital Comparator Interrupt Enable
    Uint32 COMP_EN:1;               // 11     Digital Comparator Enable
    int32 THRESH:11;               // 10:0   Digital Comparator Threshold
  };
  union DCOMPCTRL0_REG {         
    Uint32                    all;
    struct DCOMPCTRL0_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // Digital Comparator Control 1 Register 
  //-----------------------------------------------------------------------------
  struct DCOMPCTRL1_BITS {          // Bits   Description
    Uint32 CNT_THRESH:8;            // 31:24  Digital Comparator Counter Threshold
    Uint32 rsvd0:5;                 // 23:19  Reserved
    Uint32 COMP_POL:1;              // 18     Digital Comparator Polarity Select
    Uint32 FE_SEL:3;                // 17:15  Digital Comparator Front End Select
    Uint32 CNT_CLR:1;               // 14     Digital Comparator Counter Clear
    Uint32 CNT_CONFIG:1;            // 13     Digital Comparator Counter Configuration
    Uint32 INT_EN:1;                // 12     Digital Comparator Interrupt Enable
    Uint32 COMP_EN:1;               // 11     Digital Comparator Enable
    int32 THRESH:11;               // 10:0   Digital Comparator Threshold
  };
  union DCOMPCTRL1_REG {         
    Uint32                    all;
    struct DCOMPCTRL1_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // Digital Comparator Control 2 Register 
  //-----------------------------------------------------------------------------
  struct DCOMPCTRL2_BITS {          // Bits   Description
    Uint32 CNT_THRESH:8;            // 31:24  Digital Comparator Counter Threshold
    Uint32 rsvd0:5;                 // 23:19  Reserved
    Uint32 COMP_POL:1;              // 18     Digital Comparator Polarity Select
    Uint32 FE_SEL:3;                // 17:15  Digital Comparator Front End Select
    Uint32 CNT_CLR:1;               // 14     Digital Comparator Counter Clear
    Uint32 CNT_CONFIG:1;            // 13     Digital Comparator Counter Configuration
    Uint32 INT_EN:1;                // 12     Digital Comparator Interrupt Enable
    Uint32 COMP_EN:1;               // 11     Digital Comparator Enable
    int32 THRESH:11;               // 10:0   Digital Comparator Threshold
  };
  union DCOMPCTRL2_REG {         
    Uint32                    all;
    struct DCOMPCTRL2_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // Digital Comparator Control 3 Register 
  //-----------------------------------------------------------------------------
  struct DCOMPCTRL3_BITS {          // Bits   Description
    Uint32 CNT_THRESH:8;            // 31:24  Digital Comparator Counter Threshold
    Uint32 rsvd0:5;                 // 23:19  Reserved
    Uint32 COMP_POL:1;              // 18     Digital Comparator Polarity Select
    Uint32 FE_SEL:3;                // 17:15  Digital Comparator Front End Select
    Uint32 CNT_CLR:1;               // 14     Digital Comparator Counter Clear
    Uint32 CNT_CONFIG:1;            // 13     Digital Comparator Counter Configuration
    Uint32 INT_EN:1;                // 12     Digital Comparator Interrupt Enable
    Uint32 COMP_EN:1;               // 11     Digital Comparator Enable
    int32 THRESH:11;               // 10:0   Digital Comparator Threshold
  };
  union DCOMPCTRL3_REG {         
    Uint32                    all;
    struct DCOMPCTRL3_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // Digital Comparator Counter Status Register
  //-----------------------------------------------------------------------------
  struct DCOMPCNTSTAT_BITS {        // Bits    Description
    Uint32 DCOMP3_CNT:8;            // 31:24   Digital Comparator 3 Counter
    Uint32 DCOMP2_CNT:8;            // 23:16   Digital Comparator 2 Counter
    Uint32 DCOMP1_CNT:8;            // 31:24   Digital Comparator 3 Counter
    Uint32 DCOMP0_CNT:8;            // 23:16   Digital Comparator 2 Counter
  };
  union DCOMPCNTSTAT_REG {
    Uint32                    all;
    struct DCOMPCNTSTAT_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM 0 Current Limit Control Register
  //-----------------------------------------------------------------------------
  struct DPWM0CLIM_BITS {            // Bits   Description
    Uint32 rsvd0:15;                 // 31:17  Reserved
    Uint32 ANALOG_PCM_EN:1;          // 16     Analog Peak Current Detection Enable
    Uint32 DCOMP3_EN:1;              // 15     Digital Comparator 3 Enable
    Uint32 DCOMP2_EN:1;              // 14     Digital Comparator 2 Enable
    Uint32 DCOMP1_EN:1;              // 13     Digital Comparator 1 Enable
    Uint32 DCOMP0_EN:1;              // 12     Digital Comparator 0 Enable
    Uint32 rsvd1:1;                  // 11     Reserved - leave as zero
    Uint32 FAULT3_EN:1;              // 10     External FAULT[3] Current Limit Enable
    Uint32 FAULT2_EN:1;              // 9      External FAULT[2] Current Limit Enable
    Uint32 FAULT1_EN:1;              // 8      External FAULT[1] Current Limit Enable
    Uint32 FAULT0_EN:1;              // 7      External FAULT[0] Current Limit Enable
    Uint32 ACOMP_G_EN:1;             // 6      Analog Comparator G Enable
    Uint32 ACOMP_F_EN:1;             // 5      Analog Comparator F Enable
    Uint32 ACOMP_E_EN:1;             // 4      Analog Comparator E Enable
    Uint32 ACOMP_D_EN:1;             // 3      Analog Comparator D Enable
    Uint32 ACOMP_C_EN:1;             // 2      Analog Comparator C Enable
    Uint32 ACOMP_B_EN:1;             // 1      Analog Comparator B Enable
    Uint32 ACOMP_A_EN:1;             // 0      Analog Comparator A Enable
  };
  union DPWM0CLIM_REG {
    Uint32                    all;
    struct DPWM0CLIM_BITS     bit;
  };
  
  //-----------------------------------------------------------------------------
  // DPWM 0 Fault AB Detction Register
  //-----------------------------------------------------------------------------
  struct DPWM0FLTABDET_BITS {        // Bits   Description
    Uint32 rsvd0:17;                 // 31:15  Reserved
    Uint32 DCOMP3_EN:1;              // 14     Digital Comparator 3 Enable
    Uint32 DCOMP2_EN:1;              // 13     Digital Comparator 2 Enable
    Uint32 DCOMP1_EN:1;              // 12     Digital Comparator 1 Enable
    Uint32 DCOMP0_EN:1;              // 11     Digital Comparator 0 Enable
    Uint32 FAULT3_EN:1;              // 10     External FAULT[2] Enable
    Uint32 FAULT2_EN:1;              // 9      External FAULT[2] Enable
    Uint32 FAULT1_EN:1;              // 8      External FAULT[1] Enable
    Uint32 FAULT0_EN:1;              // 7      External FAULT[0] Enable
    Uint32 ACOMP_G_EN:1;             // 6      Analog Comparator G Enable
    Uint32 ACOMP_F_EN:1;             // 5      Analog Comparator F Enable
    Uint32 ACOMP_E_EN:1;             // 4      Analog Comparator E Enable
    Uint32 ACOMP_D_EN:1;             // 3      Analog Comparator D Enable
    Uint32 ACOMP_C_EN:1;             // 2      Analog Comparator C Enable
    Uint32 ACOMP_B_EN:1;             // 1      Analog Comparator B Enable
    Uint32 ACOMP_A_EN:1;             // 0      Analog Comparator A Enable
  };
  union DPWM0FLTABDET_REG {
    Uint32                      all;
    struct DPWM0FLTABDET_BITS   bit;
  };
  
  //-----------------------------------------------------------------------------
  // DPWM 0 Fault Detection Register
  //-----------------------------------------------------------------------------
  struct DPWM0FAULTDET_BITS {        // Bits   Description
    Uint32 rsvd1:1;                  // 31     Reserved
    Uint32 PWMB_DCOMP3_EN:1;         // 30     PWM B Digital Comparator 3 Enable
    Uint32 PWMB_DCOMP2_EN:1;         // 29     PWM B Digital Comparator 2 Enable
    Uint32 PWMB_DCOMP1_EN:1;         // 28     PWM B Digital Comparator 1 Enable
    Uint32 PWMB_DCOMP0_EN:1;         // 27     PWM B Digital Comparator 0 Enable
    Uint32 PWMB_FAULT3_EN:1;         // 26     PWM B Fault[3] Enable
    Uint32 PWMB_FAULT2_EN:1;         // 25     PWM B Fault[2] Enable
    Uint32 PWMB_FAULT1_EN:1;         // 24     PWM B Fault[1] Enable
    Uint32 PWMB_FAULT0_EN:1;         // 23     PWM B Fault[0] Enable
    Uint32 PWMB_ACOMP_G_EN:1;        // 22     PWM B Analog Comparator G Enable
    Uint32 PWMB_ACOMP_F_EN:1;        // 21     PWM B Analog Comparator F Enable
    Uint32 PWMB_ACOMP_E_EN:1;        // 20     PWM B Analog Comparator E Enable
    Uint32 PWMB_ACOMP_D_EN:1;        // 19     PWM B Analog Comparator D Enable
    Uint32 PWMB_ACOMP_C_EN:1;        // 18     PWM B Analog Comparator C Enable
    Uint32 PWMB_ACOMP_B_EN:1;        // 17     PWM B Analog Comparator B Enable
    Uint32 PWMB_ACOMP_A_EN:1;        // 16     PWM B Analog Comparator A Enable
    Uint32 rsvd0:1;                  // 15     Reserved
    Uint32 PWMA_DCOMP3_EN:1;         // 14     PWM B Digital Comparator 3 Enable
    Uint32 PWMA_DCOMP2_EN:1;         // 13     PWM B Digital Comparator 2 Enable
    Uint32 PWMA_DCOMP1_EN:1;         // 12     PWM B Digital Comparator 1 Enable
    Uint32 PWMA_DCOMP0_EN:1;         // 11     PWM B Digital Comparator 0 Enable
    Uint32 PWMA_FAULT3_EN:1;         // 10     PWM A Fault[2] Enable    
    Uint32 PWMA_FAULT2_EN:1;         // 9      PWM A Fault[2] Enable
    Uint32 PWMA_FAULT1_EN:1;         // 8      PWM A Fault[1] Enable
    Uint32 PWMA_FAULT0_EN:1;         // 7      PWM A Fault[0] Enable
    Uint32 PWMA_ACOMP_G_EN:1;        // 6      PWM A Analog Comparator G Enable
    Uint32 PWMA_ACOMP_F_EN:1;        // 5      PWM A Analog Comparator F Enable
    Uint32 PWMA_ACOMP_E_EN:1;        // 4      PWM A Analog Comparator E Enable
    Uint32 PWMA_ACOMP_D_EN:1;        // 3      PWM A Analog Comparator D Enable
    Uint32 PWMA_ACOMP_C_EN:1;        // 2      PWM A Analog Comparator C Enable
    Uint32 PWMA_ACOMP_B_EN:1;        // 1      PWM A Analog Comparator B Enable
    Uint32 PWMA_ACOMP_A_EN:1;        // 0      PWM A Analog Comparator A Enable    
  };
  union DPWM0FAULTDET_REG {
    Uint32                   all;
    struct DPWM0FAULTDET_BITS  bit;
  };
  
  //-----------------------------------------------------------------------------
  // DPWM 1 Current Limit Control Register
  //-----------------------------------------------------------------------------
  struct DPWM1CLIM_BITS {            // Bits   Description
    Uint32 rsvd0:15;                 // 31:17  Reserved
    Uint32 ANALOG_PCM_EN:1;          // 16     Analog Peak Current Detection Enable
    Uint32 DCOMP3_EN:1;              // 15     Digital Comparator 3 Enable
    Uint32 DCOMP2_EN:1;              // 14     Digital Comparator 2 Enable
    Uint32 DCOMP1_EN:1;              // 13     Digital Comparator 1 Enable
    Uint32 DCOMP0_EN:1;              // 12     Digital Comparator 0 Enable
    Uint32 rsvd1:1;                  // 11     Reserved - leave as zero
    Uint32 FAULT3_EN:1;              // 10     External FAULT[3] Current Limit Enable
    Uint32 FAULT2_EN:1;              // 9      External FAULT[2] Current Limit Enable
    Uint32 FAULT1_EN:1;              // 8      External FAULT[1] Current Limit Enable
    Uint32 FAULT0_EN:1;              // 7      External FAULT[0] Current Limit Enable
    Uint32 ACOMP_G_EN:1;             // 6      Analog Comparator G Enable
    Uint32 ACOMP_F_EN:1;             // 5      Analog Comparator F Enable
    Uint32 ACOMP_E_EN:1;             // 4      Analog Comparator E Enable
    Uint32 ACOMP_D_EN:1;             // 3      Analog Comparator D Enable
    Uint32 ACOMP_C_EN:1;             // 2      Analog Comparator C Enable
    Uint32 ACOMP_B_EN:1;             // 1      Analog Comparator B Enable
    Uint32 ACOMP_A_EN:1;             // 0      Analog Comparator A Enable    
  };
  union DPWM1CLIM_REG {
    Uint32                    all;
    struct DPWM1CLIM_BITS     bit;
  };
  
  //-----------------------------------------------------------------------------
  // DPWM 1 Fault AB Detction Register
  //-----------------------------------------------------------------------------
  struct DPWM1FLTABDET_BITS {        // Bits   Description
    Uint32 rsvd0:17;                 // 31:15  Reserved
    Uint32 DCOMP3_EN:1;              // 14     Digital Comparator 3 Enable
    Uint32 DCOMP2_EN:1;              // 13     Digital Comparator 2 Enable
    Uint32 DCOMP1_EN:1;              // 12     Digital Comparator 1 Enable
    Uint32 DCOMP0_EN:1;              // 11     Digital Comparator 0 Enable
    Uint32 FAULT3_EN:1;              // 10     External FAULT[3] Enable
    Uint32 FAULT2_EN:1;              // 9      External FAULT[2] Enable
    Uint32 FAULT1_EN:1;              // 8      External FAULT[1] Enable
    Uint32 FAULT0_EN:1;              // 7      External FAULT[0] Enable
    Uint32 ACOMP_G_EN:1;             // 6      Analog Comparator G Enable
    Uint32 ACOMP_F_EN:1;             // 5      Analog Comparator F Enable
    Uint32 ACOMP_E_EN:1;             // 4      Analog Comparator E Enable
    Uint32 ACOMP_D_EN:1;             // 3      Analog Comparator D Enable
    Uint32 ACOMP_C_EN:1;             // 2      Analog Comparator C Enable
    Uint32 ACOMP_B_EN:1;             // 1      Analog Comparator B Enable
    Uint32 ACOMP_A_EN:1;             // 0      Analog Comparator A Enable
  };
  union DPWM1FLTABDET_REG {
    Uint32                      all;
    struct DPWM1FLTABDET_BITS   bit;
  };
  
  //-----------------------------------------------------------------------------
  // DPWM 1 Fault Detection Register
  //-----------------------------------------------------------------------------
  struct DPWM1FAULTDET_BITS {        // Bits   Description
    Uint32 rsvd1:1;                  // 31     Reserved
    Uint32 PWMB_DCOMP3_EN:1;         // 30     PWM B Digital Comparator 3 Enable
    Uint32 PWMB_DCOMP2_EN:1;         // 29     PWM B Digital Comparator 2 Enable
    Uint32 PWMB_DCOMP1_EN:1;         // 28     PWM B Digital Comparator 1 Enable
    Uint32 PWMB_DCOMP0_EN:1;         // 27     PWM B Digital Comparator 0 Enable
    Uint32 PWMB_FAULT3_EN:1;         // 26     PWM B Fault[3] Enable
    Uint32 PWMB_FAULT2_EN:1;         // 25     PWM B Fault[2] Enable
    Uint32 PWMB_FAULT1_EN:1;         // 24     PWM B Fault[1] Enable
    Uint32 PWMB_FAULT0_EN:1;         // 23     PWM B Fault[0] Enable
    Uint32 PWMB_ACOMP_G_EN:1;        // 22     PWM B Analog Comparator G Enable
    Uint32 PWMB_ACOMP_F_EN:1;        // 21     PWM B Analog Comparator F Enable
    Uint32 PWMB_ACOMP_E_EN:1;        // 20     PWM B Analog Comparator E Enable
    Uint32 PWMB_ACOMP_D_EN:1;        // 19     PWM B Analog Comparator D Enable
    Uint32 PWMB_ACOMP_C_EN:1;        // 18     PWM B Analog Comparator C Enable
    Uint32 PWMB_ACOMP_B_EN:1;        // 17     PWM B Analog Comparator B Enable
    Uint32 PWMB_ACOMP_A_EN:1;        // 16     PWM B Analog Comparator A Enable
    Uint32 rsvd0:1;                  // 15     Reserved
    Uint32 PWMA_DCOMP3_EN:1;         // 14     PWM B Digital Comparator 3 Enable
    Uint32 PWMA_DCOMP2_EN:1;         // 13     PWM B Digital Comparator 2 Enable
    Uint32 PWMA_DCOMP1_EN:1;         // 12     PWM B Digital Comparator 1 Enable
    Uint32 PWMA_DCOMP0_EN:1;         // 11     PWM B Digital Comparator 0 Enable
    Uint32 PWMA_FAULT3_EN:1;         // 10     PWM A Fault[3] Enable    
    Uint32 PWMA_FAULT2_EN:1;         // 9      PWM A Fault[2] Enable
    Uint32 PWMA_FAULT1_EN:1;         // 8      PWM A Fault[1] Enable
    Uint32 PWMA_FAULT0_EN:1;         // 7      PWM A Fault[0] Enable
    Uint32 PWMA_ACOMP_G_EN:1;        // 6      PWM A Analog Comparator G Enable
    Uint32 PWMA_ACOMP_F_EN:1;        // 5      PWM A Analog Comparator F Enable
    Uint32 PWMA_ACOMP_E_EN:1;        // 4      PWM A Analog Comparator E Enable
    Uint32 PWMA_ACOMP_D_EN:1;        // 3      PWM A Analog Comparator D Enable
    Uint32 PWMA_ACOMP_C_EN:1;        // 2      PWM A Analog Comparator C Enable
    Uint32 PWMA_ACOMP_B_EN:1;        // 1      PWM A Analog Comparator B Enable
    Uint32 PWMA_ACOMP_A_EN:1;        // 0      PWM A Analog Comparator A Enable   
  };
  union DPWM1FAULTDET_REG {
    Uint32                   all;
    struct DPWM1FAULTDET_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM 2 Current Limit Control Register
  //-----------------------------------------------------------------------------
  struct DPWM2CLIM_BITS {            // Bits   Description
    Uint32 rsvd0:15;                 // 31:17  Reserved
    Uint32 ANALOG_PCM_EN:1;          // 16     Analog Peak Current Detection Enable
    Uint32 DCOMP3_EN:1;              // 15     Digital Comparator 3 Enable
    Uint32 DCOMP2_EN:1;              // 14     Digital Comparator 2 Enable
    Uint32 DCOMP1_EN:1;              // 13     Digital Comparator 1 Enable
    Uint32 DCOMP0_EN:1;              // 12     Digital Comparator 0 Enable
    Uint32 rsvd1:1;                  // 11     Reserved - leave as zero
    Uint32 FAULT3_EN:1;              // 10     External FAULT[3] Current Limit Enable
    Uint32 FAULT2_EN:1;              // 9      External FAULT[2] Current Limit Enable
    Uint32 FAULT1_EN:1;              // 8      External FAULT[1] Current Limit Enable
    Uint32 FAULT0_EN:1;              // 7      External FAULT[0] Current Limit Enable
    Uint32 ACOMP_G_EN:1;             // 6      Analog Comparator G Enable
    Uint32 ACOMP_F_EN:1;             // 5      Analog Comparator F Enable
    Uint32 ACOMP_E_EN:1;             // 4      Analog Comparator E Enable
    Uint32 ACOMP_D_EN:1;             // 3      Analog Comparator D Enable
    Uint32 ACOMP_C_EN:1;             // 2      Analog Comparator C Enable
    Uint32 ACOMP_B_EN:1;             // 1      Analog Comparator B Enable
    Uint32 ACOMP_A_EN:1;             // 0      Analog Comparator A Enable  
  };
  union DPWM2CLIM_REG {
    Uint32                    all;
    struct DPWM2CLIM_BITS     bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM 2 Fault AB Detction Register
  //-----------------------------------------------------------------------------
  struct DPWM2FLTABDET_BITS {        // Bits   Description
    Uint32 rsvd0:17;                 // 31:15  Reserved
    Uint32 DCOMP3_EN:1;              // 14     Digital Comparator 3 Enable
    Uint32 DCOMP2_EN:1;              // 13     Digital Comparator 2 Enable
    Uint32 DCOMP1_EN:1;              // 12     Digital Comparator 1 Enable
    Uint32 DCOMP0_EN:1;              // 11     Digital Comparator 0 Enable
    Uint32 FAULT3_EN:1;              // 10     External FAULT[3] Enable
    Uint32 FAULT2_EN:1;              // 9      External FAULT[2] Enable
    Uint32 FAULT1_EN:1;              // 8      External FAULT[1] Enable
    Uint32 FAULT0_EN:1;              // 7      External FAULT[0] Enable
    Uint32 ACOMP_G_EN:1;             // 6      Analog Comparator G Enable
    Uint32 ACOMP_F_EN:1;             // 5      Analog Comparator F Enable
    Uint32 ACOMP_E_EN:1;             // 4      Analog Comparator E Enable
    Uint32 ACOMP_D_EN:1;             // 3      Analog Comparator D Enable
    Uint32 ACOMP_C_EN:1;             // 2      Analog Comparator C Enable
    Uint32 ACOMP_B_EN:1;             // 1      Analog Comparator B Enable
    Uint32 ACOMP_A_EN:1;             // 0      Analog Comparator A Enable
  };
  union DPWM2FLTABDET_REG {
    Uint32                      all;
    struct DPWM2FLTABDET_BITS   bit;
  };
  
  //-----------------------------------------------------------------------------
  // DPWM 2 Fault Detection Register
  //-----------------------------------------------------------------------------
  struct DPWM2FAULTDET_BITS {        // Bits   Description
    Uint32 rsvd1:1;                  // 31     Reserved
    Uint32 PWMB_DCOMP3_EN:1;         // 30     PWM B Digital Comparator 3 Enable
    Uint32 PWMB_DCOMP2_EN:1;         // 29     PWM B Digital Comparator 2 Enable
    Uint32 PWMB_DCOMP1_EN:1;         // 28     PWM B Digital Comparator 1 Enable
    Uint32 PWMB_DCOMP0_EN:1;         // 27     PWM B Digital Comparator 0 Enable
    Uint32 PWMB_FAULT3_EN:1;         // 25     PWM B Fault[3] Enable
    Uint32 PWMB_FAULT2_EN:1;         // 25     PWM B Fault[2] Enable
    Uint32 PWMB_FAULT1_EN:1;         // 24     PWM B Fault[1] Enable
    Uint32 PWMB_FAULT0_EN:1;         // 23     PWM B Fault[0] Enable
    Uint32 PWMB_ACOMP_G_EN:1;        // 22     PWM B Analog Comparator G Enable
    Uint32 PWMB_ACOMP_F_EN:1;        // 21     PWM B Analog Comparator F Enable
    Uint32 PWMB_ACOMP_E_EN:1;        // 20     PWM B Analog Comparator E Enable
    Uint32 PWMB_ACOMP_D_EN:1;        // 19     PWM B Analog Comparator D Enable
    Uint32 PWMB_ACOMP_C_EN:1;        // 18     PWM B Analog Comparator C Enable
    Uint32 PWMB_ACOMP_B_EN:1;        // 17     PWM B Analog Comparator B Enable
    Uint32 PWMB_ACOMP_A_EN:1;        // 16     PWM B Analog Comparator A Enable
    Uint32 rsvd0:1;                  // 15     Reserved
    Uint32 PWMA_DCOMP3_EN:1;         // 14     PWM B Digital Comparator 3 Enable
    Uint32 PWMA_DCOMP2_EN:1;         // 13     PWM B Digital Comparator 2 Enable
    Uint32 PWMA_DCOMP1_EN:1;         // 12     PWM B Digital Comparator 1 Enable
    Uint32 PWMA_DCOMP0_EN:1;         // 11     PWM B Digital Comparator 0 Enable    
    Uint32 PWMA_FAULT3_EN:1;         // 10     PWM A Fault[3] Enable
    Uint32 PWMA_FAULT2_EN:1;         // 9      PWM A Fault[2] Enable
    Uint32 PWMA_FAULT1_EN:1;         // 8      PWM A Fault[1] Enable
    Uint32 PWMA_FAULT0_EN:1;         // 7      PWM A Fault[0] Enable
    Uint32 PWMA_ACOMP_G_EN:1;        // 6      PWM A Analog Comparator G Enable
    Uint32 PWMA_ACOMP_F_EN:1;        // 5      PWM A Analog Comparator F Enable
    Uint32 PWMA_ACOMP_E_EN:1;        // 4      PWM A Analog Comparator E Enable
    Uint32 PWMA_ACOMP_D_EN:1;        // 3      PWM A Analog Comparator D Enable
    Uint32 PWMA_ACOMP_C_EN:1;        // 2      PWM A Analog Comparator C Enable
    Uint32 PWMA_ACOMP_B_EN:1;        // 1      PWM A Analog Comparator B Enable
    Uint32 PWMA_ACOMP_A_EN:1;        // 0      PWM A Analog Comparator A Enable   
  };
  union DPWM2FAULTDET_REG {
    Uint32                   all;
    struct DPWM2FAULTDET_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM 3 Current Limit Control Register
  //-----------------------------------------------------------------------------
  struct DPWM3CLIM_BITS {            // Bits   Description
    Uint32 rsvd0:15;                 // 31:17  Reserved
    Uint32 ANALOG_PCM_EN:1;          // 16     Analog Peak Current Detection Enable
    Uint32 DCOMP3_EN:1;              // 15     Digital Comparator 3 Enable
    Uint32 DCOMP2_EN:1;              // 14     Digital Comparator 2 Enable
    Uint32 DCOMP1_EN:1;              // 13     Digital Comparator 1 Enable
    Uint32 DCOMP0_EN:1;              // 12     Digital Comparator 0 Enable
    Uint32 rsvd1:1;                  // 11     Reserved - leave as zero
    Uint32 FAULT3_EN:1;              // 10     External FAULT[3] Current Limit Enable
    Uint32 FAULT2_EN:1;              // 9      External FAULT[2] Current Limit Enable
    Uint32 FAULT1_EN:1;              // 8      External FAULT[1] Current Limit Enable
    Uint32 FAULT0_EN:1;              // 7      External FAULT[0] Current Limit Enable
    Uint32 ACOMP_G_EN:1;             // 6      Analog Comparator G Enable
    Uint32 ACOMP_F_EN:1;             // 5      Analog Comparator F Enable
    Uint32 ACOMP_E_EN:1;             // 4      Analog Comparator E Enable
    Uint32 ACOMP_D_EN:1;             // 3      Analog Comparator D Enable
    Uint32 ACOMP_C_EN:1;             // 2      Analog Comparator C Enable
    Uint32 ACOMP_B_EN:1;             // 1      Analog Comparator B Enable
    Uint32 ACOMP_A_EN:1;             // 0      Analog Comparator A Enable  
  };
  union DPWM3CLIM_REG {
    Uint32                    all;
    struct DPWM3CLIM_BITS     bit;
  };

  //-----------------------------------------------------------------------------
  // DPWM 3 Fault AB Detction Register
  //-----------------------------------------------------------------------------
  struct DPWM3FLTABDET_BITS {        // Bits   Description
    Uint32 rsvd0:17;                 // 31:15  Reserved
    Uint32 DCOMP3_EN:1;              // 14     Digital Comparator 3 Enable
    Uint32 DCOMP2_EN:1;              // 13     Digital Comparator 2 Enable
    Uint32 DCOMP1_EN:1;              // 12     Digital Comparator 1 Enable
    Uint32 DCOMP0_EN:1;              // 11     Digital Comparator 0 Enable
    Uint32 FAULT3_EN:1;              // 10     External FAULT[3] Enable
    Uint32 FAULT2_EN:1;              // 9      External FAULT[2] Enable
    Uint32 FAULT1_EN:1;              // 8      External FAULT[1] Enable
    Uint32 FAULT0_EN:1;              // 7      External FAULT[0] Enable
    Uint32 ACOMP_G_EN:1;             // 6      Analog Comparator G Enable
    Uint32 ACOMP_F_EN:1;             // 5      Analog Comparator F Enable
    Uint32 ACOMP_E_EN:1;             // 4      Analog Comparator E Enable
    Uint32 ACOMP_D_EN:1;             // 3      Analog Comparator D Enable
    Uint32 ACOMP_C_EN:1;             // 2      Analog Comparator C Enable
    Uint32 ACOMP_B_EN:1;             // 1      Analog Comparator B Enable
    Uint32 ACOMP_A_EN:1;             // 0      Analog Comparator A Enable
  };
  union DPWM3FLTABDET_REG {
    Uint32                      all;
    struct DPWM3FLTABDET_BITS   bit;
  };
  
  //-----------------------------------------------------------------------------
  // DPWM 3 Fault Detection Register
  //-----------------------------------------------------------------------------
  struct DPWM3FAULTDET_BITS {        // Bits   Description
    Uint32 rsvd1:1;                  // 31     Reserved
    Uint32 PWMB_DCOMP3_EN:1;         // 30     PWM B Digital Comparator 3 Enable
    Uint32 PWMB_DCOMP2_EN:1;         // 29     PWM B Digital Comparator 2 Enable
    Uint32 PWMB_DCOMP1_EN:1;         // 28     PWM B Digital Comparator 1 Enable
    Uint32 PWMB_DCOMP0_EN:1;         // 27     PWM B Digital Comparator 0 Enable
    Uint32 PWMB_FAULT3_EN:1;         // 26     PWM B Fault[3] Enable
    Uint32 PWMB_FAULT2_EN:1;         // 25     PWM B Fault[2] Enable
    Uint32 PWMB_FAULT1_EN:1;         // 24     PWM B Fault[1] Enable
    Uint32 PWMB_FAULT0_EN:1;         // 23     PWM B Fault[0] Enable
    Uint32 PWMB_ACOMP_G_EN:1;        // 22     PWM B Analog Comparator G Enable
    Uint32 PWMB_ACOMP_F_EN:1;        // 21     PWM B Analog Comparator F Enable
    Uint32 PWMB_ACOMP_E_EN:1;        // 20     PWM B Analog Comparator E Enable
    Uint32 PWMB_ACOMP_D_EN:1;        // 19     PWM B Analog Comparator D Enable
    Uint32 PWMB_ACOMP_C_EN:1;        // 18     PWM B Analog Comparator C Enable
    Uint32 PWMB_ACOMP_B_EN:1;        // 17     PWM B Analog Comparator B Enable
    Uint32 PWMB_ACOMP_A_EN:1;        // 16     PWM B Analog Comparator A Enable
    Uint32 rsvd0:1;                  // 15     Reserved
    Uint32 PWMA_DCOMP3_EN:1;         // 14     PWM B Digital Comparator 3 Enable
    Uint32 PWMA_DCOMP2_EN:1;         // 13     PWM B Digital Comparator 2 Enable
    Uint32 PWMA_DCOMP1_EN:1;         // 12     PWM B Digital Comparator 1 Enable
    Uint32 PWMA_DCOMP0_EN:1;         // 11     PWM B Digital Comparator 0 Enable
    Uint32 PWMA_FAULT3_EN:1;         // 10     PWM A Fault[3] Enable
    Uint32 PWMA_FAULT2_EN:1;         // 9      PWM A Fault[2] Enable
    Uint32 PWMA_FAULT1_EN:1;         // 8      PWM A Fault[1] Enable
    Uint32 PWMA_FAULT0_EN:1;         // 7      PWM A Fault[0] Enable
    Uint32 PWMA_ACOMP_G_EN:1;        // 6      PWM A Analog Comparator G Enable
    Uint32 PWMA_ACOMP_F_EN:1;        // 5      PWM A Analog Comparator F Enable
    Uint32 PWMA_ACOMP_E_EN:1;        // 4      PWM A Analog Comparator E Enable
    Uint32 PWMA_ACOMP_D_EN:1;        // 3      PWM A Analog Comparator D Enable
    Uint32 PWMA_ACOMP_C_EN:1;        // 2      PWM A Analog Comparator C Enable
    Uint32 PWMA_ACOMP_B_EN:1;        // 1      PWM A Analog Comparator B Enable
    Uint32 PWMA_ACOMP_A_EN:1;        // 0      PWM A Analog Comparator A Enable    
  };
  union DPWM3FAULTDET_REG {
    Uint32                     all;
    struct DPWM3FAULTDET_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // HFO Fail Detect Register
  //-----------------------------------------------------------------------------
  struct HFOFAILDET_BITS {           // Bits   Description
    Uint32 rsvd0:14;                 // 31:18  Reserved
    Uint32 HFO_FAIL_THRESH:17;       // 17:1   High Frequency Oscillator Fail Threshold
    Uint32 HFO_DETECT_EN:1;          // 0      High Frequency Oscillator Fail Detect Enable
  };
  union HFOFAILDET_REG {
    Uint32                   all;
    struct HFOFAILDET_BITS   bit;
  };

  //-----------------------------------------------------------------------------
  // LFO Fail Detect Register
  //-----------------------------------------------------------------------------
  struct LFOFAILDET_BITS {           // Bits   Description
    Uint32 rsvd0:25;                 // 31:6   Reserved
    Uint32 LFO_FAIL_THRESH:5;        // 6:2    Low Frequency Oscillator Fail Threshold
    Uint32 LFO_FAIL_INT_EN:1;        // 1      Low Frequency Oscillator Fail Interrupt Enable
    Uint32 LFO_DETECT_EN:1;          // 0      Low Frequency Oscillator Fail Detect Enable
  };
  union LFOFAILDET_REG {
    Uint32                   all;
    struct LFOFAILDET_BITS   bit;
  };

  //-----------------------------------------------------------------------------
  // IDE Control Register
  //-----------------------------------------------------------------------------
  struct IDECTRL_BITS {              // Bits   Description
    Uint32 DCM_LIMIT_H:8;            // 31:24  DCM Upper Hysteresis
    Uint32 DCM_LIMIT_L:8;            // 23:16  DCM Lower Hysteresis
    Uint32 rsvd0:2;                  // 15:14  Reserved
    Uint32 DCM_INT_EN:1;             // 13     DCM Interrupt Enable
    Uint32 IDE_KD:13;                // 12:0   IDE KD Factor used to calculate Db
  };
  union IDECTRL_REG {
    Uint32                   all;
    struct IDECTRL_BITS      bit;
  };

  //=============================================================================
  // Fault Mux Module Register File
  //=============================================================================
  struct FAULT_MUX_REGS {
    union ACOMPCTRL0_REG        ACOMPCTRL0;       // Analog Comparator Control 0 Register
    union ACOMPCTRL1_REG        ACOMPCTRL1;       // Analog Comparator Control 1 Register
    union ACOMPCTRL2_REG        ACOMPCTRL2;       // Analog Comparator Control 2 Register
    union ACOMPCTRL3_REG        ACOMPCTRL3;       // Analog Comparator Control 3 Register
    union EXTFAULTCTRL_REG      EXTFAULTCTRL;     // External Fault Control Register
    union FAULTMUXINTSTAT_REG   FAULTMUXINTSTAT;  // Fault Mux Interrupt Status Register
    union FAULTMUXRAWSTAT_REG   FAULTMUXRAWSTAT;  // Fault Mux Raw Status Register
    union COMPRAMP0_REG         COMPRAMP0;        // Comparator Ramp Control 0 Register
    union DCOMPCTRL0_REG        DCOMPCTRL0;       // Digital Comparator Control 0 Register
    union DCOMPCTRL1_REG        DCOMPCTRL1;       // Digital Comparator Control 1 Register
    union DCOMPCTRL2_REG        DCOMPCTRL2;       // Digital Comparator Control 2 Register
    union DCOMPCTRL3_REG        DCOMPCTRL3;       // Digital Comparator Control 3 Register
    union DCOMPCNTSTAT_REG      DCOMPCNTSTAT;     // Digital Comparator Counter Status Register
    union DPWM0CLIM_REG         DPWM0CLIM;        // DPWM 0 Current Limit Control Register
    union DPWM0FLTABDET_REG     DPWM0FLTABDET;    // DPWM 0 Fault AB Detection Register
    union DPWM0FAULTDET_REG     DPWM0FAULTDET;    // DPWM 0 Fault Detection Register
    Uint32                      RESERVED0;        // Reserved
    union DPWM1CLIM_REG         DPWM1CLIM;        // DPWM 1 Current Limit Control Register
    union DPWM1FLTABDET_REG     DPWM1FLTABDET;    // DPWM 1 Fault AB Detection Register
    union DPWM1FAULTDET_REG     DPWM1FAULTDET;    // DPWM 1 Fault Detection Register
    Uint32                      RESERVED1;        // Reserved
    union DPWM2CLIM_REG         DPWM2CLIM;        // DPWM 2 Current Limit Control Register
    union DPWM2FLTABDET_REG     DPWM2FLTABDET;    // DPWM 2 Fault AB Detection Register
    union DPWM2FAULTDET_REG     DPWM2FAULTDET;    // DPWM 2 Fault Detection Register
    Uint32                      RESERVED2;        // Reserved
    union DPWM3CLIM_REG         DPWM3CLIM;        // DPWM 3 Current Limit Control Register
    union DPWM3FLTABDET_REG     DPWM3FLTABDET;    // DPWM 3 Fault AB Detection Register
    union DPWM3FAULTDET_REG     DPWM3FAULTDET;    // DPWM 3 Fault Detection Register
    Uint32                      RESERVED3;        // Reserved
    union HFOFAILDET_REG        HFOFAILDET;       // High Frequency Oscillator Fail Detect Register
    union LFOFAILDET_REG        LFOFAILDET;       // Low Frequency Oscillator Fail Detect Register
    union IDECTRL_REG           IDECTRL;          // IDE Control Register
  };
  
  //-----------------------------------------------------------------------------
  // Fault Mux Module External References & Function Declarations:
  //-----------------------------------------------------------------------------
  extern volatile struct FAULT_MUX_REGS FaultMuxRegs;




//===========================================================================
// End of file
//===========================================================================
//###############################################################################
//
// FILE:   cyclone_fe_ctrl.h
//
// TITLE:  Cyclone Front End Control Register Definitions.
//
// NOTES:
//  1) Bitfields have been defined for big-endian only.
//###############################################################################
//
//  Ver  | dd mmm yyyy | Who  | Description of changes
// ======|=============|======|==============================================
//  1.00 | 19 Aug 2009 | CMF  | Initial Revision
//       |             |      | 
//       |             |      |
//
//  Texas Instruments, Inc
//  Copyright Texas Instruments 2009. All rights reserved.
//###############################################################################



  //=============================================================================
  // Front End Control Individual Register Bit Definitions
  //=============================================================================

  //-----------------------------------------------------------------------------
  // Ramp Control Register
  //-----------------------------------------------------------------------------
  struct RAMPCTRL_BITS {            // bits   description
    Uint32 rsvd1:2;                 // 31:30  Reserved
    Uint32 SYNC_FET_RAMP_START:14;  // 29:16  SyncFET Ramp Start Value
    Uint32 rsvd0:2;                 // 15:14  Reserved
    Uint32 ANALOG_PCM_INT_EN:1;     // 13     Analog Peak Current Interrupt Enable
    Uint32 RAMP_SAT_EN:1;           // 12     Ramp Saturation Enable
    Uint32 RAMP_COMP_INT_EN:1;      // 11     Ramp Complete Interrupt Enable
    Uint32 RAMP_DLY_INT_EN:1;       // 10     Ramp Delay Complete Interrupt Enable
    Uint32 PREBIAS_INT_EN:1;        // 9      Pre-Bias Complete Interrupt Enable
    Uint32 PCM_START_SEL:1;         // 8      Peak Current Mode Start Select
    Uint32 SYNC_FET_EN:1;           // 7      Enable use of Ramp for SyncFET
    Uint32 MASTER_SEL:2;            // 6:5    Master Ramp I/F Select
    Uint32 SLAVE_COMP_EN:1;         // 4      Sync ramp to Master Complete
    Uint32 SLAVE_DELAY_EN:1;        // 3      Sync ramp to Master Delay Complete
    Uint32 CONTROL_EN:1;            // 2      Sync ramp to Control assertion
    Uint32 FIRMWARE_START:1;        // 1      Start ramp with firmware
    Uint32 RAMP_EN:1;               // 0      Ramp Enable
  }; 
  union RAMPCTRL_REG {
    Uint32                   all;
    struct RAMPCTRL_BITS     bit;
  };
  
  //-----------------------------------------------------------------------------
  // Ramp Status Register
  //-----------------------------------------------------------------------------
  struct RAMPSTAT_BITS {            // bits   description
    Uint32 rsvd0:19;                // 31:13  Reserved
    Uint32 EADC_DONE_RAW:1;         // 12     EADC Conversion Raw Status
    Uint32 ANALOG_PCM_INT_STATUS:1; // 11     Analog Peak Current Latched Status
    Uint32 RAMP_COMP_INT_STATUS:1;  // 10     Ramp Complete Latched Status
    Uint32 RAMP_DLY_INT_STATUS:1;   // 9      Ramp Delay Complete Latched Status
    Uint32 PREBIAS_INT_STATUS:1;    // 8      Prebias Complete Latched Status
    Uint32 EADC_SAT_HIGH:1;         // 7      EADC Saturation High
    Uint32 EADC_SAT_LOW:1;          // 6      EADC Saturation Low
    Uint32 EADC_EOC:1;              // 5      EADC End of Conversion 
    Uint32 PREBIAS_BUSY:1;          // 4      Prebias Busy Indication
    Uint32 RAMP_BUSY:1;             // 3      Ramp Busy Indication
    Uint32 RAMP_COMP_STATUS:1;      // 2      Ramp Complete Indication
    Uint32 RAMP_DLY_STATUS:1;       // 1      Ramp Delay Indication
    Uint32 PREBIAS_STATUS:1;        // 0      Prebias Indication
  };
  union RAMPSTAT_REG {
    Uint32                   all;
    struct RAMPSTAT_BITS     bit;
  };
  
  //-----------------------------------------------------------------------------
  // Ramp Cycle Register
  //-----------------------------------------------------------------------------
  struct RAMPCYCLE_BITS {           // bits   Description
    Uint32 rsvd1:8;                 // 31:24  Reserved
    Uint32 DELAY_CYCLES:16;         // 23:8   Number of Delay Cycles before ramp
    Uint32 rsvd0:1;                 // 7      Reserved
    Uint32 SWITCH_CYC_PER_STEP:7;   // 6:0    Number of switching cycles per step
  };
  union RAMPCYCLE_REG {
    Uint32                   all;
    struct RAMPCYCLE_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // EADC DAC Value Register
  //-----------------------------------------------------------------------------
  struct EADCDAC_BITS {             // Bits   Description
    Uint32 rsvd1:16;                // 31:16  Reserved
    Uint32 DAC_DITHER_EN:1;         // 15     DAC Dithering Enable
    Uint32 rsvd0:1;                 // 14     Reserved
    Uint32 DAC_VALUE:14;            // 13:0   DAC Value
  };
  union EADCDAC_REG {
    Uint32                  all;
    struct EADCDAC_BITS     bit;
  };

  //-----------------------------------------------------------------------------
  // Ramp DAC Ending Value Register
  //-----------------------------------------------------------------------------
  struct RAMPDACEND_BITS {          // Bits   Description
    Uint32 rsvd1:18;                // 31:14  Reserved
    Uint32 RAMP_DAC_VALUE:14;       // 13:0   Ramp Ending DAC Value
  };
  union RAMPDACEND_REG {
    Uint32                  all;
    struct RAMPDACEND_BITS  bit;
  };
  
  //-----------------------------------------------------------------------------
  // DAC Step Register
  //-----------------------------------------------------------------------------
  struct DACSTEP_BITS {            // Bits   Description
    Uint32 rsvd0:14;               // 31:18  Reserved
    Uint32 DAC_STEP:18;            // 17:0   DAC Step
  };
  union DACSTEP_REG {
    Uint32               all;
    struct DACSTEP_BITS  bit;
  };
  
  //-----------------------------------------------------------------------------
  // DAC Saturation Step Register 
  //-----------------------------------------------------------------------------
  struct DACSATSTEP_BITS {         // Bits   Description 
    Uint32 rsvd0:18;               // 31:14  Reserved
    Uint32 DAC_SAT_STEP:14;        // 13:0   DAC SaturationStep
  };
  union DACSATSTEP_REG {
    Uint32                  all;
    struct DACSATSTEP_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // EADC Trim Register
  //-----------------------------------------------------------------------------
  struct EADCTRIM_BITS {          // Bits   Description 
    Uint32 rsvd3:2;               // 31:30  Reserved
    Uint32 GAIN3_TRIM:6;          // 29:24  Gain3 Trim
    Uint32 rsvd2:2;               // 23:22  Reserved
    Uint32 GAIN2_TRIM:6;          // 21:16  Gain2 Trim
    Uint32 rsvd1:2;               // 15:14  Reserved
    Uint32 GAIN1_TRIM:6;          // 13:8   Gain1 Trim
    Uint32 rsvd0:2;               // 7:6    Reserved
    Uint32 GAIN0_TRIM:6;          // 5:0    Gain0 Trim
  };
  union EADCTRIM_REG {
    Uint32                  all;
    struct EADCTRIM_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // EADC Control Register 
  //-----------------------------------------------------------------------------
  struct EADCCTRL_BITS {           // Bits   Description 
    Uint32 rsvd0:3;                // 31:29  Reserved
    Uint32 D2S_COMP_EN:1;          // 28     Analog Front End Ramp Comparator Enable
    Uint32 EN_HYST_HIGH:1;         // 27     Increase comparator trip point
    Uint32 EN_HYST_LOW:1;          // 26     Decrease comparator trip point
    Uint32 SAMP_TRIG_SCALE:4;      // 25:22  Sample Trigger Scale
    Uint32 FRAME_SYNC_EN:1;        // 21     Frame Sync Enable
    Uint32 SCFE_CNT_RST:1;         // 20     Switched Cap Front End Counter Reset
    Uint32 SCFE_CNT_INIT:4;        // 19:16  Initial Value for Switched Cap Front End Counter
    Uint32 EADC_INV:1;             // 15     Invert EADC Data
    Uint32 AUTO_GAIN_SHIFT_MODE:1; // 14     Auto Gain Shifting Mode Select
    Uint32 AUTO_GAIN_SHIFT_EN:1;   // 13     Auto Gain Shifting Enable
    Uint32 AVG_WEIGHT_EN:1;        // 12     Averaging Weight Enable
    Uint32 AVG_SPATIAL_EN:1;       // 11     Averaging Spatial Enable
    Uint32 AVG_MODE_SEL:2;         // 10:9   Averaging Mode Select
    Uint32 EADC_MODE:3;            // 8:6    EADC Mode Select
    Uint32 AFE_GAIN:2;             // 5:4    AFE Gain Setting
    Uint32 SCFE_GAIN_FILTER_SEL:1; // 3      SCFE Gain Filter Enable
    Uint32 SCFE_CLK_DIV_2:1;       // 2      Front End sampling select
    Uint32 SCFE_ENA:1;             // 1      SCFE Enable
    Uint32 EADC_ENA:1;             // 0      EADC Enable
  };
  union EADCCTRL_REG {
    Uint32                 all;
    struct EADCCTRL_BITS   bit;
  };
    
  //-----------------------------------------------------------------------------
  // Analog Control Register
  //-----------------------------------------------------------------------------
  struct ACTRL_BITS {              // Bits   Description 
    Uint32 rsvd1:16;               // 31:16  Reserved
    Uint32 EADC_REF_TRIM:6;        // 15:10  EADC Reference Trim
    Uint32 EADC_REF_RESET:1;       // 9      EADC Reference Reset
    Uint32 EADC_REF_EN:1;          // 8      EADC Reference Enable
    Uint32 rsvd0:3;                // 7:5    Reserved
    Uint32 EADC_GAIN_CAL:1;        // 4      EADC Gain Calibration
    Uint32 EADC_OFFSET_CAL:1;      // 3      EADC Offset Calibration
    Uint32 INT_REF_SEL:1;          // 2      Internal Reference Select
    Uint32 EXT_V_SE_SEL:1;         // 1      Selects V_SE
    Uint32 ANALOG_ENA:1;           // 0      Analog Front Enable
  };
  union ACTRL_REG {
    Uint32                all;
    struct ACTRL_BITS     bit;
  };

  //-----------------------------------------------------------------------------
  // Pre-Bias Control Register 0 
  //-----------------------------------------------------------------------------
  struct PREBIASCTRL0_BITS {       // Bits   Description 
    Uint32 rsvd0:14;               // 31:18  Reserved
    Uint32 PRE_BIAS_POL:1;         // 17     Prebias polarity
    Uint32 PRE_BIAS_EN:1;          // 16     Prebias Enable
    Uint32 PRE_BIAS_RANGE:8;       // 15:8   Prebias Range
    Uint32 PRE_BIAS_LIMIT:8;       // 7:0    Prebias Limit
  };
  union PREBIASCTRL0_REG {
    Uint32                    all;
    struct PREBIASCTRL0_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // Pre-Bias Control Register 1 
  //-----------------------------------------------------------------------------
  struct PREBIASCTRL1_BITS {       // Bits   Description 
    Uint32 rsvd1:8;                // 31:24  Reserved
    Uint32 SAMPLES_PER_ADJ:8;      // 23:16  Samples per adjustment
    Uint32 rsvd0:2;                // 15:14  Reserved
    Uint32 MAX_DAC_ADJ:14;         // 13:0   Maximum DAC Adjustment
  };
  union PREBIASCTRL1_REG {
    Uint32                    all;
    struct PREBIASCTRL1_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // SAR Control Register
  //-----------------------------------------------------------------------------
  struct SARCTRL_BITS {              // Bits   Description 
    Uint32 EADC_WINDOW_2:8;          // 31:24  EADC Window 2 Setting
    Uint32 EADC_WINDOW_1:8;          // 23:16  EADC Window 1 Setting
    Uint32 SAR_RANGE:8;              // 15:8   SAR Range Setting
    Uint32 rsvd0:6;                  // 7:2    Reserved
    Uint32 SAR_RESOLUTION:2;         // 1:0    SAR Final Resolution
  };
  union SARCTRL_REG {
    Uint32                    all;
    struct SARCTRL_BITS       bit;
  };
  
  //-----------------------------------------------------------------------------
  // SAR Timing Register
  //-----------------------------------------------------------------------------
  struct SARTIMING_BITS {           // Bits   Description
    Uint32 rsvd2:21;                // 31:11  Reserved
    Uint32 SAR_TIMING_UPPER:3;      // 10:8   SAR Timing setting for upper bits
    Uint32 rsvd1:1;                 // 7      Reserved
    Uint32 SAR_TIMING_MID:3;        // 6:4    SAR Timing setting for mid bits
    Uint32 rsvd0:1;                 // 3      Reserved
    Uint32 SAR_TIMING_LOWER:3;      // 2:0    SAR Timing setting for lower bits
  };
  union SARTIMING_REG {
    Uint32                   all;
    struct SARTIMING_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // EADC Value Register
  //-----------------------------------------------------------------------------
  struct EADCVALUE_BITS {           // Bits   Description 
    Uint32 rsvd1:6;                 // 31:26  Reserved
    Uint32 ABS_VALUE:10;            // 25:16  Absolute Value
	Uint32 EADC_SAT_HIGH:1;          // 15     Saturation High Indicator
	Uint32 EADC_SAT_LOW:1;           // 14     Saturation Low Indicator
    Uint32 rsvd0:5;                 // 13:9   Reserved
    int32 ERROR_VALUE:9;           // 8:0    Error Value
  };
  union EADCVALUE_REG {
    Uint32                  all;
    struct EADCVALUE_BITS   bit;
  };

  //-----------------------------------------------------------------------------
  // EADC Raw Value Register
  //-----------------------------------------------------------------------------
  struct EADCRAWVALUE_BITS {        // Bits   Description
    Uint32 rsvd0:23;                // 31:9   Reserved
    int32 RAW_ERROR_VALUE:9;       // 8:0    Raw Error Value
  };
  union EADCRAWVALUE_REG {
    Uint32                    all;
    struct EADCRAWVALUE_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // DAC Status Register 
  //-----------------------------------------------------------------------------
  struct DACSTAT_BITS {             // Bits   Description 
    Uint32 rsvd0:22;                // 31:10  Reserved
    Uint32 DAC_VALUE:10;            // 9:0    Current DAC Value
  };
  union DACSTAT_REG {
    Uint32                all;
    struct DACSTAT_BITS   bit;
  };

  //=============================================================================
  // Front End Control Module Register File
  //=============================================================================
  struct FE_CTRL_REGS {
    union RAMPCTRL_REG        RAMPCTRL;         // Ramp Control Register
    union RAMPSTAT_REG        RAMPSTAT;         // Ramp Status Register
    union RAMPCYCLE_REG       RAMPCYCLE;        // Ramp Cycle Register
    union EADCDAC_REG         EADCDAC;          // EADC DAC Value Register
    union RAMPDACEND_REG      RAMPDACEND;       // Ramp DAC Ending Value Register
    union DACSTEP_REG         DACSTEP;          // DAC Step Register
    union DACSATSTEP_REG      DACSATSTEP;       // DAC Saturation Step Register
    union EADCTRIM_REG        EADCTRIM;         // EADC Trim Register
    union EADCCTRL_REG        EADCCTRL;         // EADC Control Register
    union ACTRL_REG           ACTRL;            // Analog Control Register
    union PREBIASCTRL0_REG    PREBIASCTRL0;     // Pre-bias Control Register 0
    union PREBIASCTRL1_REG    PREBIASCTRL1;     // Pre-bias Control Register 1
    union SARCTRL_REG         SARCTRL;          // SAR Control Register
    union SARTIMING_REG       SARTIMING;        // SAR Timing Register
    union EADCVALUE_REG       EADCVALUE;        // EADC Value Register
    union EADCRAWVALUE_REG    EADCRAWVALUE;     // EADC Raw Value Register
    union DACSTAT_REG         DACSTAT;          // Current DAC Value Register
  };
  
  //-----------------------------------------------------------------------------
  // ADC Module External References & Function Declarations:
  //-----------------------------------------------------------------------------
  extern volatile struct FE_CTRL_REGS FeCtrl0Regs;
  extern volatile struct FE_CTRL_REGS FeCtrl1Regs;
  extern volatile struct FE_CTRL_REGS FeCtrl2Regs;




//===========================================================================
// End of file
//===========================================================================
//###############################################################################
//
// FILE:   cyclone_filter.h
//
// TITLE:  Cyclone Filter Register Definitions.
//
// NOTES:
//  1) Bitfields have been defined for big-endian only.
//###############################################################################
//
//  Ver  | dd mmm yyyy | Who  | Description of changes
// ======|=============|======|==============================================
//  1.00 | 19 Aug 2009 | CMF  | Initial Revision
//       |             |      | 
//       |             |      |
//
//  Texas Instruments, Inc
//  Copyright Texas Instruments 2009. All rights reserved.
//###############################################################################



  //=============================================================================
  // Filter Individual Register Bit Definitions
  //=============================================================================

  //-----------------------------------------------------------------------------
  // Filter Status Register
  //-----------------------------------------------------------------------------
  struct FILTERSTATUS_BITS {        // bits   description
    Uint32 rsvd0:27;                // 31:5   Reserved
    Uint32 FILTER_BUSY:1;           // 4      Filter Busy Indication
    Uint32 YN_LOW_CLAMP:1;          // 3      Output Clamp Low Indication
    Uint32 YN_HIGH_CLAMP:1;         // 2      Output Clamp High Indication
    Uint32 KI_YN_LOW_CLAMP:1;       // 1      KI Feedback Clamp Low Indication
    Uint32 KI_YN_HIGH_CLAMP:1;      // 0      KI Feedback Clamp High Indication
  }; 
  union FILTERSTATUS_REG {
    struct FILTERSTATUS_BITS     bit;
    Uint32                       all; 
  };
  
  //-----------------------------------------------------------------------------
  // Filter Control Register
  //-----------------------------------------------------------------------------
  struct FILTERCTRL_BITS {          // bits   description
    Uint32 rsvd0:16;                // 31:16  Reserved
	Uint32 KI_ADDER_MODE:1;         // 15     KI Adder Mode Select
    Uint32 PERIOD_MULT_SEL:1;       // 14     Period Multiplier Select
    Uint32 OUTPUT_MULT_SEL:2;       // 13:12  Output Multiplicand Select
    int32 OUTPUT_SCALE:3;          // 11:9    Output Scaling
    Uint32 NL_MODE:1;               // 8      Selects Non-linear Mode
    Uint32 KD_STALL:1;              // 7      Stalls KD Branch
    Uint32 KI_STALL:1;              // 6      Stalls KI Branch
    Uint32 KP_OFF:1;                // 5      Turns off KP Branch
    Uint32 KD_OFF:1;                // 4      Turns off KD Branch
    Uint32 KI_OFF:1;                // 3      Turns off KI Branch
    Uint32 FORCE_START:1;           // 2      Software Filter Calculation
    Uint32 USE_CPU_SAMPLE:1;        // 1      Use CPU Sample
    Uint32 FILTER_EN:1;             // 0      Filter Enable
  };
  union FILTERCTRL_REG {
    struct FILTERCTRL_BITS     bit;
    Uint32                     all;
  };
  
  //-----------------------------------------------------------------------------
  // CPU XN Register 
  //-----------------------------------------------------------------------------
  struct CPUXN_BITS {               // bits   description
    Uint32 rsvd0:23;                // 31:9   Reserved
    int32 CPU_SAMPLE:9;            // 8:0    CPU Sample
  };
  union CPUXN_REG {
    struct CPUXN_BITS       bit;
    Uint32                  all;
  };

  //-----------------------------------------------------------------------------
  // Filter XN Read Register
  //-----------------------------------------------------------------------------
  struct FILTERXNREAD_BITS {           // bits   description
    Uint32 rsvd1:7;                 // 31:25  Reserved
    int32 XN_M1:9;                 // 24:16  XN_M1 Value
    Uint32 rsvd0:7;                 // 15:9   Reserved
    int32 XN:9;                    // 8:0    XN Value
  };
  union FILTERXNREAD_REG {
    struct FILTERXNREAD_BITS bit;
    Uint32                   all;
  };
  
  //-----------------------------------------------------------------------------
  // Filter KI_YN Read Register
  //-----------------------------------------------------------------------------
  struct FILTERKIYNREAD_BITS {         // bits   description
    Uint32 rsvd0:8;                 // 31:24  Reserved
    int32 KI_YN:24;                // 23:0   KI_YN Value
  };
  union FILTERKIYNREAD_REG {
    struct FILTERKIYNREAD_BITS bit;
    Uint32                     all;   
  };    
    
  //-----------------------------------------------------------------------------
  // Filter KD_YN Read Register
  //-----------------------------------------------------------------------------
  struct FILTERKDYNREAD_BITS {         // bits   description
    Uint32 rsvd0:8;                    // 31:24  Reserved
    int32 KD_YN:24;                   // 23:0   KD_YN Value
  };
  union FILTERKDYNREAD_REG {
    struct FILTERKDYNREAD_BITS bit;
    Uint32                     all; 
  };    

  //-----------------------------------------------------------------------------
  // Filter YN Read Register
  //-----------------------------------------------------------------------------
  struct FILTERYNREAD_BITS {           // bits   description
    Uint32 rsvd0:8;                    // 31:24  Reserved
    int32 YN:24;                      // 23:0   YN Value
  };
  union FILTERYNREAD_REG {
    struct FILTERYNREAD_BITS   bit;
    Uint32                     all;  
  };  

  //-----------------------------------------------------------------------------
  // Coefficient Configuration Register
  //-----------------------------------------------------------------------------
  struct COEFCONFIG_BITS {         // bits   description
    Uint32 rsvd0:4;                // 31:28  Reserved
    Uint32 BIN6_ALPHA:1;           // 27     Bin6 Alpha Configuration
    Uint32 BIN6_CONFIG:3;          // 26:24  Bin6 Configuration
    Uint32 BIN5_ALPHA:1;           // 23     Bin5 Alpha Configuration
    Uint32 BIN5_CONFIG:3;          // 22:20  Bin5 Configuration
    Uint32 BIN4_ALPHA:1;           // 19     Bin4 Alpha Configuration
    Uint32 BIN4_CONFIG:3;          // 18:16  Bin4 Configuration
    Uint32 BIN3_ALPHA:1;           // 15     Bin3 Alpha Configuration
    Uint32 BIN3_CONFIG:3;          // 14:12  Bin3 Configuration
    Uint32 BIN2_ALPHA:1;           // 11     Bin2 Alpha Configuration
    Uint32 BIN2_CONFIG:3;          // 10:8   Bin2 Configuration
    Uint32 BIN1_ALPHA:1;           // 7      Bin1 Alpha Configuration
    Uint32 BIN1_CONFIG:3;          // 6:4    Bin1 Configuration
    Uint32 BIN0_ALPHA:1;           // 3      Bin0 Alpha Configuration
    Uint32 BIN0_CONFIG:3;          // 2:0    Bin0 Configuration
  };
  union COEFCONFIG_REG {
    struct COEFCONFIG_BITS bit;
    Uint32                 all;  
  };
  
  //-----------------------------------------------------------------------------
  // Filter KP Coefficient 0 Register
  //-----------------------------------------------------------------------------
  struct FILTERKPCOEF0_BITS {        // bits   description
    int32 KP_COEF_1:16;             // 31:16  KP Coefficient 1
    int32 KP_COEF_0:16;             // 15:0   KP Coefficient 0
  };
  union FILTERKPCOEF0_REG {
    struct FILTERKPCOEF0_BITS bit;
    Uint32                    all; 
  };
  
  //-----------------------------------------------------------------------------
  // Filter KP Coefficient 1 Register
  //-----------------------------------------------------------------------------
  struct FILTERKPCOEF1_BITS {        // bits   description
    int32 rsvd0:16;                 // 31:16  Reserved
    int32 KP_COEF_2:16;             // 15:0   KP Coefficient 2
  };
  union FILTERKPCOEF1_REG {
    struct FILTERKPCOEF1_BITS bit;
    Uint32                    all;
  };
  
  //-----------------------------------------------------------------------------
  // Filter KI Coefficient 0 Register
  //-----------------------------------------------------------------------------
  struct FILTERKICOEF0_BITS {        // bits   description
    int32 KI_COEF_1:16;             // 31:16  KI Coefficient 1
    int32 KI_COEF_0:16;             // 15:0   KI Coefficient 0
  };
  union FILTERKICOEF0_REG {   
    struct FILTERKICOEF0_BITS bit;
	Uint32                    all;
  };
  
  //-----------------------------------------------------------------------------
  // Filter KI Coefficient 1 Register
  //-----------------------------------------------------------------------------
  struct FILTERKICOEF1_BITS {        // bits   description
    int32 KI_COEF_3:16;             // 31:16  KI Coefficient 3
    int32 KI_COEF_2:16;             // 15:0   KI Coefficient 2
  };
  union FILTERKICOEF1_REG {
    struct FILTERKICOEF1_BITS bit;
    Uint32                    all;
  };  

  //-----------------------------------------------------------------------------
  // Filter KD Coefficient 0 Register
  //-----------------------------------------------------------------------------
  struct FILTERKDCOEF0_BITS {        // bits   description
    int32 KD_COEF_1:16;             // 31:16  KD Coefficient 1
    int32 KD_COEF_0:16;             // 15:0   KD Coefficient 0
  };
  union FILTERKDCOEF0_REG {
    struct FILTERKDCOEF0_BITS bit;
    Uint32                    all;
  }; 

  //-----------------------------------------------------------------------------
  // Filter KD Coefficient 1 Register
  //-----------------------------------------------------------------------------
  struct FILTERKDCOEF1_BITS {     // bits   description
    Uint32 rsvd0:16;              // 31:16  Reserved
    int32 KD_COEF_2:16;          // 15:0   KD Coefficient 2
  };
  union FILTERKDCOEF1_REG {
    struct FILTERKDCOEF1_BITS bit;
    Uint32                    all; 
  };  
  
  //-----------------------------------------------------------------------------
  // Filter KD Alpha Register
  //-----------------------------------------------------------------------------
  struct FILTERKDALPHA_BITS {     // bits   description 
    Uint32 rsvd1:7;               // 31:25  Reserved
    int32 KD_ALPHA_1:9;          // 24:16  KD Alpha 1 Value
    Uint32 rsvd0:7;               // 15:9   Reserved
    int32 KD_ALPHA_0:9;          // 8:0    KD Alpha 0 Value
  };
  union FILTERKDALPHA_REG {
    struct FILTERKDALPHA_BITS bit;
    Uint32                    all;   
  };
  
  //-----------------------------------------------------------------------------
  // Filter Non-Linear Limit Register 0
  //-----------------------------------------------------------------------------
  struct FILTERNL0_BITS {         // bits   description 
    Uint32 rsvd1:7;               // 31:25  Reserved
    int32 LIMIT1:9;              // 24:16  Non-Linear Limit 1 Value
    Uint32 rsvd0:7;               // 15:9   Reserved
    int32 LIMIT0:9;              // 8:0    Non-Linear Limit 0 Value
  };
  union FILTERNL0_REG {
    struct FILTERNL0_BITS     bit;
    Uint32                    all; 
  }; 

  //-----------------------------------------------------------------------------
  // Filter Non-Linear Limit Register 1
  //-----------------------------------------------------------------------------
  struct FILTERNL1_BITS {         // bits   description 
    Uint32 rsvd1:7;               // 31:25  Reserved
    int32 LIMIT3:9;              // 24:16  Non-Linear Limit 3 Value
    Uint32 rsvd0:7;               // 15:9   Reserved
    int32 LIMIT2:9;              // 8:0    Non-Linear Limit 2 Value
  };
  union FILTERNL1_REG {
    struct FILTERNL1_BITS  bit;
    Uint32                 all;  
  };   

  //-----------------------------------------------------------------------------
  // Filter Non-Linear Limit Register 2
  //-----------------------------------------------------------------------------
  struct FILTERNL2_BITS {         // bits   description 
    Uint32 rsvd1:7;               // 31:25  Reserved
    int32 LIMIT5:9;              // 24:16  Non-Linear Limit 5 Value
    Uint32 rsvd0:7;               // 15:9   Reserved
    int32 LIMIT4:9;              // 8:0    Non-Linear Limit 4 Value
  };
  union FILTERNL2_REG {
    struct FILTERNL2_BITS  bit;
    Uint32                 all;
  };       

  //-----------------------------------------------------------------------------
  // Filter KI Feedback Clamp High Register
  //-----------------------------------------------------------------------------
  struct FILTERKICLPHI_BITS {        // bits   description 
    Uint32 rsvd0:8;                  // 31:24  Reserved
    int32 KI_CLAMP_HIGH:24;          // 23:0   KI Clamp High
  };
  union FILTERKICLPHI_REG {
    struct FILTERKICLPHI_BITS bit;
    Uint32                    all;
  };

  //-----------------------------------------------------------------------------
  // Filter KI Feedback Clamp Low Register
  //-----------------------------------------------------------------------------
  struct FILTERKICLPLO_BITS {     // bits   description 
    Uint32 rsvd0:8;               // 31:24  Reserved
    int32 KI_CLAMP_LOW:24;        // 23:0   KI Clamp Low
  };
  union FILTERKICLPLO_REG {
    struct FILTERKICLPLO_BITS bit;
    Uint32                    all;
  };

  //-----------------------------------------------------------------------------
  // Filter YN Clamp High Register
  //-----------------------------------------------------------------------------
  struct FILTERYNCLPHI_BITS {     // Bits   Description
    Uint32 rsvd0:8;               // 31:24  Reserved
    int32  YN_CLAMP_HIGH:24;      // 23:0   YN Clamp High
  };
  union FILTERYNCLPHI_REG {
    struct FILTERYNCLPHI_BITS bit;
    int32                     all; 
  };

  //-----------------------------------------------------------------------------
  // Filter YN Clamp Low Register
  //-----------------------------------------------------------------------------
  struct FILTERYNCLPLO_BITS {     // Bits   Description
    Uint32 rsvd0:8;               // 31:24  Reserved
    int32  YN_CLAMP_LOW:24;       // 23:0   YN Clamp High
  };
  union FILTERYNCLPLO_REG {
    struct FILTERYNCLPLO_BITS bit;
    int32                     all;
  };

  //-----------------------------------------------------------------------------
  // Filter Output Clamp High Register
  //-----------------------------------------------------------------------------
  struct FILTEROCLPHI_BITS {         // Bits   description
    Uint32 rsvd0:14;                 // 31:18  Reserved
    Uint32 OUTPUT_CLAMP_HIGH:18;     // 17:0   Output Clamp High
  };
  union FILTEROCLPHI_REG {
    struct FILTEROCLPHI_BITS  bit;
    Uint32                    all;
  };
    
  //-----------------------------------------------------------------------------
  // Filter Output Clamp Low Register
  //-----------------------------------------------------------------------------
  struct FILTEROCLPLO_BITS {         // Bits   description
    Uint32 rsvd0:14;                 // 31:18  Reserved
    Uint32 OUTPUT_CLAMP_LOW:18;      // 17:0   Output Clamp Low
  };
  union FILTEROCLPLO_REG {
    struct FILTEROCLPLO_BITS  bit;
    Uint32                    all;
  };

  //-----------------------------------------------------------------------------
  // Filter Preset Register
  //-----------------------------------------------------------------------------
  struct FILTERPRESET_BITS {       // Bits   Description
    Uint32 rsvd0:4;                // 31:28  Reserved
    Uint32 PRESET_EN:1;            // 27     Filter Preset Enable
    Uint32 PRESET_REG_SEL:3;       // 26:24  Filter Preset Select
    int32  PRESET_VALUE:24;        // 23:0   Filter Preset Value
  };
  union FILTERPRESET_REG {
    struct FILTERPRESET_BITS  bit;
    Uint32                    all;
  };

  //=============================================================================
  // Filter Module Register File
  //=============================================================================
  struct FILTER_REGS {
    union FILTERSTATUS_REG      FILTERSTATUS;       // Filter Status Register
    union FILTERCTRL_REG        FILTERCTRL;         // Filter Control Register
    union CPUXN_REG             CPUXN;              // CPU XN Register
    union FILTERXNREAD_REG      FILTERXNREAD;       // Filter XN Read Register
    union FILTERKIYNREAD_REG    FILTERKIYNREAD;     // Filter KI YN Read Register
    union FILTERKDYNREAD_REG    FILTERKDYNREAD;     // Filter KD YN Read Register
    union FILTERYNREAD_REG      FILTERYNREAD;       // Filter YN Read Register    
    union COEFCONFIG_REG        COEFCONFIG;         // Coefficient Configuration Register
    union FILTERKPCOEF0_REG     FILTERKPCOEF0;      // Filter KP Coefficient 0 Register
    union FILTERKPCOEF1_REG     FILTERKPCOEF1;      // Filter KP Coefficient 1 Register
    union FILTERKICOEF0_REG     FILTERKICOEF0;      // Filter KI Coefficient 0 Register
    union FILTERKICOEF1_REG     FILTERKICOEF1;      // Filter KI Coefficient 1 Register
    union FILTERKDCOEF0_REG     FILTERKDCOEF0;      // Filter KD Coefficient 0 Register
    union FILTERKDCOEF1_REG     FILTERKDCOEF1;      // Filter KD Coefficient 1 Register
    union FILTERKDALPHA_REG     FILTERKDALPHA;      // Filter KD Alpha Register
    union FILTERNL0_REG         FILTERNL0;          // Filter Non-Linear Limit 0 Register
    union FILTERNL1_REG         FILTERNL1;          // Filter Non-Linear Limit 1 Register
    union FILTERNL2_REG         FILTERNL2;          // Filter Non-Linear Limit 2 Register
    union FILTERKICLPHI_REG     FILTERKICLPHI;      // Filter KI Feedback Clamp High Register
    union FILTERKICLPLO_REG     FILTERKICLPLO;      // Filter KI Feedback Clamp Low Register
    union FILTERYNCLPHI_REG     FILTERYNCLPHI;      // Filter Yn Clamp High Register
    union FILTERYNCLPLO_REG     FILTERYNCLPLO;      // Filter Yn Clamp Low Register
    union FILTEROCLPHI_REG      FILTEROCLPHI;       // Filter Output Clamp High Register
    union FILTEROCLPLO_REG      FILTEROCLPLO;       // Filter Output Clamp Low Register
    union FILTERPRESET_REG      FILTERPRESET;       // Filter Preset Register
  };
  
  //-----------------------------------------------------------------------------
  // ADC Module External References & Function Declarations:
  //-----------------------------------------------------------------------------
  extern volatile struct FILTER_REGS Filter0Regs;
  extern volatile struct FILTER_REGS Filter1Regs;
  extern volatile struct FILTER_REGS Filter2Regs;




//===========================================================================
// End of file
//===========================================================================
//###########################################################################
//
// FILE:   cyclone_gio.h
//
// TITLE:  Cyclone Device Gio Module Register Definitions.
//
// NOTES:
//  1) Bitfields have been defined for big-endian only.
//###########################################################################
//
//  Ver  | dd mmm yyyy | Who  | Description of changes
// ======|=============|======|==============================================
//  1.00 | 12 Aug 2009 | CMF  | Started with Spartan_Gio.h.
//       |             |      | Updated for 1.0 Memory map document.
//       |             |      |
//
//  Texas Instruments, Inc
//  Copyright Texas Instruments 2008. All rights reserved.
//###########################################################################



//===============================================================================
// GIO Individual Register Bit Definitions
//===============================================================================

  //-----------------------------------------------------------------------------
  // Fault Port I/O Direction Register bit definitions 
  //-----------------------------------------------------------------------------
  struct FAULTDIR_BITS {            // bits   description
    Uint32 rsvd0:25;                // 31:7   reserved
    Uint32 TMS_DIR:1;               // 6      TMS Pin Direction in GPIO Mode
    Uint32 TDI_DIR:1;               // 5      TDI Pin Direction in GPIO Mode
    Uint32 TDO_DIR:1;               // 4      TDO Pin Direction in GPIO Mode
    Uint32 FLT3_DIR:1;              // 3      FAULT[3] Pin Direction
    Uint32 FLT2_DIR:1;              // 2      FAULT[2] Pin Direction
    Uint32 FLT1_DIR:1;              // 1      FAULT[1] Pin Direction
    Uint32 FLT0_DIR:1;              // 0      FAULT[0] Pin Direction
  };
  union FAULTDIR_REG {
    Uint32                all;
    struct FAULTDIR_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // Fault Port In Register bit definitions 
  //-----------------------------------------------------------------------------
  struct FAULTIN_BITS {             // bits   description
    Uint32 rsvd0:25;                // 31:7   reserved
    Uint32 TMS_IN:1;                // 6      TMS Input Value in GPIO Mode
    Uint32 TDI_IN:1;                // 5      TDI Input Value in GPIO Mode
    Uint32 TDO_IN:1;                // 4      TDO Input Value in GPIO Mode
    Uint32 FLT3_IN:1;               // 3      FAULT[3] Input Value
    Uint32 FLT2_IN:1;               // 2      FAULT[2] Input Value
    Uint32 FLT1_IN:1;               // 1      FAULT[1] Input Value
    Uint32 FLT0_IN:1;               // 0      FAULT[0] Input Value
  };
  union FAULTIN_REG {
    Uint32                all;
    struct FAULTIN_BITS   bit;
  };
  
  //-----------------------------------------------------------------------------
  // Fault Port Output Register bit definitions 
  //-----------------------------------------------------------------------------
  struct FAULTOUT_BITS {            // bits   description
    Uint32 rsvd1:25;                // 31:7   reserved
    Uint32 TMS_OUT:1;               // 6      TMS pin output data
    Uint32 TDI_OUT:1;               // 5      TDI pin output data
    Uint32 rsvd0:1;                 // 4      TDO pin output data
    Uint32 FLT3_OUT:1;              // 3      FAULT[3] pin output data
    Uint32 FLT2_OUT:1;              // 2      FAULT[2] pin output data
    Uint32 FLT1_OUT:1;              // 1      FAULT[1] pin output data
    Uint32 FLT0_OUT:1;              // 0      FAULT[0] pin output data
  };
  union FAULTOUT_REG {
    Uint32                all;
    struct FAULTOUT_BITS  bit;
  };
  
  //-----------------------------------------------------------------------------
  // Fault Port Interrupt Enable Register bit definitions 
  //-----------------------------------------------------------------------------
  struct FAULTINTENA_BITS {         // bits   description
    Uint32 rsvd0:25;                // 31:7   reserved
    Uint32 TMS_INT_EN:1;            // 6      TMS pin interrupt enable
    Uint32 TDI_INT_EN:1;            // 5      TDI pin interrupt enable
    Uint32 TDO_INT_EN:1;            // 4      TDO pin interrupt enable
    Uint32 FLT3_INT_EN:1;           // 3      FAULT[3] pin interrupt enable
    Uint32 FLT2_INT_EN:1;           // 2      FAULT[2] pin interrupt enable
    Uint32 FLT1_INT_EN:1;           // 1      FAULT[1] pin interrupt enable
    Uint32 FLT0_INT_EN:1;           // 0      FAULT[0] pin interrupt enable
  };
  union FAULTINTENA_REG {
    Uint32                   all;
    struct FAULTINTENA_BITS  bit;
  };
  
  //-----------------------------------------------------------------------------
  // Fault Port Interrupt Polarity Register bit definitions 
  //-----------------------------------------------------------------------------
  struct FAULTINTPOL_BITS {         // bits   description
    Uint32 rsvd0:25;                // 31:7   reserved
    Uint32 TMS_INT_POL:1;           // 6      TMS pin interrupt polarity
    Uint32 TDI_INT_POL:1;           // 5      TDI pin interrupt polarity
    Uint32 TDO_INT_POL:1;           // 4      TDO pin interrupt polarity
    Uint32 FLT3_INT_POL:1;          // 3      FAULT[3] pin interrupt polarity
    Uint32 FLT2_INT_POL:1;          // 2      FAULT[2] pin interrupt polarity
    Uint32 FLT1_INT_POL:1;          // 1      FAULT[1] pin interrupt polarity
    Uint32 FLT0_INT_POL:1;          // 0      FAULT[0] pin interrupt polarity
  };
  union FAULTINTPOL_REG {
    Uint32                   all;
    struct FAULTINTPOL_BITS  bit;
  };
  
  //-----------------------------------------------------------------------------
  // Fault Port Interrupt Pending Register bit definitions 
  //-----------------------------------------------------------------------------
  struct FAULTINTPEND_BITS {        // bits   description
    Uint32 rsvd0:25;                // 31:7   reserved
    Uint32 TMS_INT_PEND:1;          // 6      TMS pin interrupt flag
    Uint32 TDI_INT_PEND:1;          // 5      TDI pin interrupt flag
    Uint32 TDO_INT_PEND:1;          // 4      TDO pin interrupt flag
    Uint32 FLT3_INT_PEND:1;         // 3      FAULT[3] pin interrupt flag
    Uint32 FLT2_INT_PEND:1;         // 2      FAULT[2] pin interrupt flag
    Uint32 FLT1_INT_PEND:1;         // 1      FAULT[1] pin interrupt flag
    Uint32 FLT0_INT_PEND:1;         // 0      FAULT[0] pin interrupt flag
  };
  union FAULTINTPEND_REG {
    Uint32                    all;
    struct FAULTINTPEND_BITS  bit;
  };
  
  //-----------------------------------------------------------------------------
  // External Interrupt I/O Direction Register bit definitions 
  //-----------------------------------------------------------------------------
  struct EXTINTDIR_BITS {            // bits   description
    Uint32 rsvd0:31;                 // 31:1   reserved
    Uint32 EXT_INT_DIR:1;            // 0      External Interrupt Pin Direction 
  };
  union EXTINTDIR_REG {
    Uint32                 all;
    struct EXTINTDIR_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // External Interrupt Input Register bit definitions 
  //-----------------------------------------------------------------------------
  struct EXTINTIN_BITS {             // bits   description
    Uint32 rsvd0:31;                 // 31:1   reserved
    Uint32 EXT_INT_IN:1;             // 0      External Interrupt Pin Input Value
  };
  union EXTINTIN_REG {
    Uint32                 all;
    struct EXTINTIN_BITS   bit;
  };
  
  //-----------------------------------------------------------------------------
  // External Interrupt Output Register bit definitions 
  //-----------------------------------------------------------------------------
  struct EXTINTOUT_BITS {           // bits   description
    Uint32 rsvd0:31;                // 31:1   reserved
    Uint32 EXTINT_OUT:1;            // 0      External Interrupt pin output data
  };
  union EXTINTOUT_REG {
    Uint32                 all;
    struct EXTINTOUT_BITS  bit;
  };
  
  //-----------------------------------------------------------------------------
  // External Interrupt Enable Register bit definitions 
  //-----------------------------------------------------------------------------
  struct EXTINTENA_BITS {           // bits   description
    Uint32 rsvd0:31;                // 31:1   reserved
    Uint32 EXT_INT_EN:1;            // 0      External Interrupt pin interrupt enable
  };
  union EXTINTENA_REG {
    Uint32                 all;
    struct EXTINTENA_BITS  bit;
  };
  
  //-----------------------------------------------------------------------------
  // External Interrupt Polarity Register bit definitions 
  //-----------------------------------------------------------------------------
  struct EXTINTPOL_BITS {           // bits   description
    Uint32 rsvd0:31;                // 31:1   reserved
    Uint32 EXT_INT_POL:1;           // 0      External Interrupt pin interrupt polarity
  };
  union EXTINTPOL_REG {
    Uint32                 all;
    struct EXTINTPOL_BITS  bit;
  };
  
  //-----------------------------------------------------------------------------
  // External Interrupt Pending Register bit definitions 
  //-----------------------------------------------------------------------------
  struct EXTINTPEND_BITS {          // bits   description
    Uint32 rsvd0:31;                // 31:1   reserved
    Uint32 EXT_INT_PEND:1;          // 0      External Interrupt pin interrupt flag
  };
  union EXTINTPEND_REG {
    Uint32                  all;
    struct EXTINTPEND_BITS  bit;
  };  

  //=============================================================================
  // GIO Module Register File
  //=============================================================================
  struct GIO_REGS {
    union  FAULTDIR_REG      FAULTDIR;      // Fault Port Direction Register
    union  FAULTIN_REG       FAULTIN;       // Fault Port Input Data
    union  FAULTOUT_REG      FAULTOUT;      // Fault Port Output Data
    Uint32                   RSVD_3;        // Reserved
    Uint32                   RSVD_2;        // Reserved
    union  FAULTINTENA_REG   FAULTINTENA;   // Fault Port Interrupt Enable Register
    union  FAULTINTPOL_REG   FAULTINTPOL;   // Fault Port Interrupt Polarity Register
    union  FAULTINTPEND_REG  FAULTINTPEND;  // Fault Port Interrupt Pending Register
    union  EXTINTDIR_REG     EXTINTDIR;     // External Interrupt Direction Register
    union  EXTINTIN_REG      EXTINTIN;      // External Interrupt Input Data
    union  EXTINTOUT_REG     EXTINTOUT;     // External Interrupt Output Data
    Uint32                   RSVD_1;        // Reserved
    Uint32                   RSVD_0;        // Reserved
    union  EXTINTENA_REG     EXTINTENA;     // External Interrupt Enable Register
    union  EXTINTPOL_REG     EXTINTPOL;     // External Interrupt Polarity Register
    union  EXTINTPEND_REG    EXTINTPEND;    // External Interrupt Pending Register
  };

  //---------------------------------------------------------------------------
  // GIO Module External References & Function Declarations:
  //
  extern volatile struct GIO_REGS GioRegs;
  
  //===========================================================================


//===========================================================================
// End of file
//===========================================================================
//###############################################################################
//
// FILE:   cyclone_loop_mux.h
//
// TITLE:  Cyclone Loop Mux Register Definitions.
//
// NOTES:
//  1) Bitfields have been defined for big-endian only.
//###############################################################################
//
//  Ver  | dd mmm yyyy | Who  | Description of changes
// ======|=============|======|==============================================
//  1.00 | 19 Aug 2009 | CMF  | Initial Revision
//       |             |      | 
//       |             |      |
//
//  Texas Instruments, Inc
//  Copyright Texas Instruments 2009. All rights reserved.
//###############################################################################



  //=============================================================================
  // Loop Mux Individual Register Bit Definitions
  //=============================================================================

  //-----------------------------------------------------------------------------
  // Front End Control 0 Mux Register
  //-----------------------------------------------------------------------------
  struct FECTRL0MUX_BITS {          // bits   description
    Uint32 rsvd0:18;                // 31:14  Reserved
    Uint32 NL_SEL:2;                // 13:12  Front End NL Limit Select
    Uint32 DPWM3_FRAME_SYNC_EN:1;   // 11     Front End DPWM3 Frame Sync Enable
    Uint32 DPWM2_FRAME_SYNC_EN:1;   // 10     Front End DPWM3 Frame Sync Enable
    Uint32 DPWM1_FRAME_SYNC_EN:1;   // 9      Front End DPWM3 Frame Sync Enable
    Uint32 DPWM0_FRAME_SYNC_EN:1;   // 8      Front End DPWM3 Frame Sync Enable
    Uint32 DPWM3_B_TRIG_EN:1;       // 7      Front End DPWM3 PWM-B Trig Enable
    Uint32 DPWM2_B_TRIG_EN:1;       // 6      Front End DPWM2 PWM-B Trig Enable
    Uint32 DPWM1_B_TRIG_EN:1;       // 5      Front End DPWM1 PWM-B Trig Enable
    Uint32 DPWM0_B_TRIG_EN:1;       // 4      Front End DPWM0 PWM-B Trig Enable
    Uint32 DPWM3_A_TRIG_EN:1;       // 3      Front End DPWM3 PWM-A Trig Enable
    Uint32 DPWM2_A_TRIG_EN:1;       // 2      Front End DPWM2 PWM-A Trig Enable
    Uint32 DPWM1_A_TRIG_EN:1;       // 1      Front End DPWM1 PWM-A Trig Enable
    Uint32 DPWM0_A_TRIG_EN:1;       // 0      Front End DPWM0 PWM-A Trig Enable
  }; 
  union FECTRL0MUX_REG {
    Uint32                    all;
    struct FECTRL0MUX_BITS     bit;
  };

  //-----------------------------------------------------------------------------
  // Front End Control 1 Mux Register
  //-----------------------------------------------------------------------------
  struct FECTRL1MUX_BITS {          // bits   description
    Uint32 rsvd0:18;                // 31:14  Reserved
    Uint32 NL_SEL:2;                // 13:12  Front End NL Limit Select
    Uint32 DPWM3_FRAME_SYNC_EN:1;   // 11     Front End DPWM3 Frame Sync Enable
    Uint32 DPWM2_FRAME_SYNC_EN:1;   // 10     Front End DPWM3 Frame Sync Enable
    Uint32 DPWM1_FRAME_SYNC_EN:1;   // 9      Front End DPWM3 Frame Sync Enable
    Uint32 DPWM0_FRAME_SYNC_EN:1;   // 8      Front End DPWM3 Frame Sync Enable
    Uint32 DPWM3_B_TRIG_EN:1;       // 7      Front End DPWM3 PWM-B Trig Enable
    Uint32 DPWM2_B_TRIG_EN:1;       // 6      Front End DPWM2 PWM-B Trig Enable
    Uint32 DPWM1_B_TRIG_EN:1;       // 5      Front End DPWM1 PWM-B Trig Enable
    Uint32 DPWM0_B_TRIG_EN:1;       // 4      Front End DPWM0 PWM-B Trig Enable
    Uint32 DPWM3_A_TRIG_EN:1;       // 3      Front End DPWM3 PWM-A Trig Enable
    Uint32 DPWM2_A_TRIG_EN:1;       // 2      Front End DPWM2 PWM-A Trig Enable
    Uint32 DPWM1_A_TRIG_EN:1;       // 1      Front End DPWM1 PWM-A Trig Enable
    Uint32 DPWM0_A_TRIG_EN:1;       // 0      Front End DPWM0 PWM-A Trig Enable
  }; 
  union FECTRL1MUX_REG {
    Uint32                    all;
    struct FECTRL1MUX_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // Front End Control 2 Mux Register
  //-----------------------------------------------------------------------------
  struct FECTRL2MUX_BITS {          // bits   description
    Uint32 rsvd0:18;                // 31:14  Reserved
    Uint32 NL_SEL:2;                // 13:12  Front End NL Limit Select
    Uint32 DPWM3_FRAME_SYNC_EN:1;   // 11     Front End DPWM3 Frame Sync Enable
    Uint32 DPWM2_FRAME_SYNC_EN:1;   // 10     Front End DPWM3 Frame Sync Enable
    Uint32 DPWM1_FRAME_SYNC_EN:1;   // 9      Front End DPWM3 Frame Sync Enable
    Uint32 DPWM0_FRAME_SYNC_EN:1;   // 8      Front End DPWM3 Frame Sync Enable
    Uint32 DPWM3_B_TRIG_EN:1;       // 7      Front End DPWM3 PWM-B Trig Enable
    Uint32 DPWM2_B_TRIG_EN:1;       // 6      Front End DPWM2 PWM-B Trig Enable
    Uint32 DPWM1_B_TRIG_EN:1;       // 5      Front End DPWM1 PWM-B Trig Enable
    Uint32 DPWM0_B_TRIG_EN:1;       // 4      Front End DPWM0 PWM-B Trig Enable
    Uint32 DPWM3_A_TRIG_EN:1;       // 3      Front End DPWM3 PWM-A Trig Enable
    Uint32 DPWM2_A_TRIG_EN:1;       // 2      Front End DPWM2 PWM-A Trig Enable
    Uint32 DPWM1_A_TRIG_EN:1;       // 1      Front End DPWM1 PWM-A Trig Enable
    Uint32 DPWM0_A_TRIG_EN:1;       // 0      Front End DPWM0 PWM-A Trig Enable
  }; 
  union FECTRL2MUX_REG {
    Uint32                    all;
    struct FECTRL2MUX_BITS    bit;
  };
  
  //-----------------------------------------------------------------------------
  // Sample Trigger Control Register
  //-----------------------------------------------------------------------------
  struct SAMPTRIGCTRL_BITS {       // bits   description
    Uint32 rsvd0:20;               // 31:12  Reserved
    Uint32 FE2_TRIG_DPWM3_EN:1;    // 11     Front End 2 DPWM 3 Trig Enable
    Uint32 FE2_TRIG_DPWM2_EN:1;    // 10     Front End 2 DPWM 2 Trig Enable
    Uint32 FE2_TRIG_DPWM1_EN:1;    // 9      Front End 2 DPWM 1 Trig Enable
    Uint32 FE2_TRIG_DPWM0_EN:1;    // 8      Front End 2 DPWM 1 Trig Enable
    Uint32 FE1_TRIG_DPWM3_EN:1;    // 7      Front End 1 DPWM 3 Trig Enable
    Uint32 FE1_TRIG_DPWM2_EN:1;    // 6      Front End 1 DPWM 2 Trig Enable
    Uint32 FE1_TRIG_DPWM1_EN:1;    // 5      Front End 1 DPWM 1 Trig Enable
    Uint32 FE1_TRIG_DPWM0_EN:1;    // 4      Front End 1 DPWM 1 Trig Enable
    Uint32 FE0_TRIG_DPWM3_EN:1;    // 3      Front End 0 DPWM 3 Trig Enable
    Uint32 FE0_TRIG_DPWM2_EN:1;    // 2      Front End 0 DPWM 2 Trig Enable
    Uint32 FE0_TRIG_DPWM1_EN:1;    // 1      Front End 0 DPWM 1 Trig Enable
    Uint32 FE0_TRIG_DPWM0_EN:1;    // 0      Front End 0 DPWM 1 Trig Enable
  };
  union SAMPTRIGCTRL_REG {
    Uint32                    all;
    struct SAMPTRIGCTRL_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // External DAC Control Register
  //-----------------------------------------------------------------------------
  struct EXTDACCTRL_BITS {         // Bits   Description
    Uint32 rsvd3:5;                // 31:27  Reserved
    Uint32 DAC2_SEL:3;             // 26:24  DAC 2 Select
    Uint32 rsvd2:5;                // 23:19  Reserved
    Uint32 DAC1_SEL:3;             // 18:16  DAC 1 Select
    Uint32 rsvd1:5;                // 15:11  Reserved
    Uint32 DAC0_SEL:3;             // 10:8   DAC 0 Select
    Uint32 rsvd0:5;                // 7:3    Reserved
    Uint32 EXT_DAC2_EN:1;          // 2      External DAC 2 Enable
    Uint32 EXT_DAC1_EN:1;          // 1      External DAC 1 Enable
    Uint32 EXT_DAC0_EN:1;          // 0      External DAC 0 Enable
  };
  union EXTDACCTRL_REG {
    Uint32                   all;
    struct EXTDACCTRL_BITS   bit;
  };

  //-----------------------------------------------------------------------------
  // Filter Mux Register 
  //-----------------------------------------------------------------------------
  struct FILTERMUX_BITS {         // Bits   Description 
    Uint32 rsvd3:2;               // 31:30  Reserved
    Uint32 FILTER2_KCOMP_SEL:2;   // 29:28  Filter 2 KComp Select
    Uint32 FILTER1_KCOMP_SEL:2;   // 27:26  Filter 1 KComp Select
    Uint32 FILTER0_KCOMP_SEL:2;   // 25:24  Filter 0 KComp Select
    Uint32 rsvd2:5;               // 23:19  Reserved
    Uint32 FILTER2_FFWD_SEL:1;    // 18     Filter 2 Feedforward Select
    Uint32 FILTER1_FFWD_SEL:1;    // 17     Filter 1 Feedforward Select
    Uint32 FILTER0_FFWD_SEL:1;    // 16     Filter 0 Feedforward Select
    Uint32 rsvd1:2;               // 15:14  Reserved  
    Uint32 FILTER2_PER_SEL:2;     // 13:12  Filter 2 Switching Period Select
    Uint32 FILTER1_PER_SEL:2;     // 11:10  Filter 1 Switching Period Select
    Uint32 FILTER0_PER_SEL:2;     // 9:8    Filter 0 Switching Period Select
    Uint32 rsvd0:2;               // 7:6    Reserved  
    Uint32 FILTER2_FE_SEL:2;      // 5:4    Filter 2 Front End Select
    Uint32 FILTER1_FE_SEL:2;      // 3:2    Filter 1 Front End Select
    Uint32 FILTER0_FE_SEL:2;      // 1:0    Filter 0 Front End Select
  };
  union FILTERMUX_REG {
    Uint32                    all;
    struct FILTERMUX_BITS     bit;
  };
  
  //-----------------------------------------------------------------------------
  // Filter KComp A Register
  //-----------------------------------------------------------------------------
  struct FILTERKCOMPA_BITS {     // Bits    Description
    Uint32 rsvd1:2;              // 31:30   Reserved
    Uint32 KCOMP1:14;            // 29:16   KCOMP1 Value
    Uint32 rsvd0:2;              // 15:14   Reserved
    Uint32 KCOMP0:14;            // 13:0    KCOMP0 Value
  };
  union FILTERKCOMPA_REG {
    Uint32                    all;
    struct FILTERKCOMPA_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // Filter KComp B Register
  //-----------------------------------------------------------------------------
  struct FILTERKCOMPB_BITS {     // Bits    Description
    Uint32 rsvd1:18;             // 31:14   Reserved
    Uint32 KCOMP2:14;            // 13:0    KCOMP2 Value
  };
  union FILTERKCOMPB_REG {
    Uint32                    all;
    struct FILTERKCOMPB_BITS  bit;
  };    

  //-----------------------------------------------------------------------------
  // DPWM Mux Register 
  //-----------------------------------------------------------------------------
  struct DPWMMUX_BITS {           // Bits    Description
    Uint32 DPWM3_SYNC_FET_SEL:2;  // 31:30   DPWM3 Sync Fet Ramp Select
    Uint32 DPWM2_SYNC_FET_SEL:2;  // 29:28   DPWM2 Sync Fet Ramp Select
    Uint32 DPWM1_SYNC_FET_SEL:2;  // 27:26   DPWM1 Sync Fet Ramp Select
    Uint32 DPWM0_SYNC_FET_SEL:2;  // 25:24   DPWM0 Sync Fet Ramp Select
    Uint32 rsvd0:4;               // 23:20   Reserved
    Uint32 DPWM3_SYNC_SEL:2;      // 19:18   DPWM3 Sync Select
    Uint32 DPWM2_SYNC_SEL:2;      // 17:16   DPWM2 Sync Select
    Uint32 DPWM1_SYNC_SEL:2;      // 15:14   DPWM1 Sync Select
    Uint32 DPWM0_SYNC_SEL:2;      // 13:12   DPWM0 Sync Select
    Uint32 DPWM3_FILTER_SEL:3;    // 11:9    DPWM3 Filter Select
    Uint32 DPWM2_FILTER_SEL:3;    // 8:6     DPWM2 Filter Select
    Uint32 DPWM1_FILTER_SEL:3;    // 5:3     DPWM1 Filter Select
    Uint32 DPWM0_FILTER_SEL:3;    // 2:0     DPWM0 Filter Select
  };
  union DPWMMUX_REG {
    Uint32                    all;
    struct DPWMMUX_BITS       bit;
  };

  //-----------------------------------------------------------------------------
  // Constant Power Control Register (CPCTRL)
  //-----------------------------------------------------------------------------
  struct CPCTRL_BITS {          // Bits    Description
    Uint32 rsvd1:16;            // 31:16   Reserved
    Uint32 DAC_COMP_EN:1;       // 15      Enables DAC Setpoint comparison
    Uint32 FW_DIVISOR_EN:1;     // 14      Enable Firwmare Divisor for Constant Power Calculation
    Uint32 LOWER_COMP_EN:1;     // 13      Enable comparison of duty cycle in loop switching
    Uint32 VLOOP_FREEZE_EN:1;   // 12      Enables freeze of Voltage Loop Integration in CC Mode
    Uint32 VLOOP_SEL:2;         // 11:10   Select Voltage Loop for Loop Switching
    Uint32 CLOOP_SEL:2;         // 9:8     Select Current Loop for Loop Switching
    Uint32 THRESH_SEL:3;        // 7:5     Select Input Threshold for CPCC
    Uint32 DIVISOR_SEL:2;       // 4:3     Select Divisor Value
    Uint32 CPCC_INT_EN:1;       // 2       Constant Power/Current Interrupt Enable
    Uint32 CPCC_CONFIG:1;       // 1       Constant Power/Current Configuration
    Uint32 CPCC_EN:1;           // 0       Constant Power Constant Current Enable
  };
  union CPCTRL_REG {
    Uint32                    all;
    struct CPCTRL_BITS        bit;
  };

  //-----------------------------------------------------------------------------
  // Constant Power Nominal Threshold Register (CPNOM)
  //-----------------------------------------------------------------------------
  struct CPNOM_BITS {              // Bits    Description
    Uint32 rsvd1:6;                // 31:26   Reserved
    Uint32 NOM_CURRENT_UPPER:10;   // 25:16   Nominal Current Upper Threshold
    Uint32 rsvd0:6;                // 15:10   Reserved
    Uint32 NOM_CURRENT_LOWER:10;   // 9:0     Nominal Current Lower Threshold
  };
  union CPNOM_REG {
    Uint32                    all;
    struct CPNOM_BITS         bit;
  };

  //-----------------------------------------------------------------------------
  // Constant Power Max Threshold Register (CPMAX)
  //-----------------------------------------------------------------------------
  struct CPMAX_BITS {             // Bits    Description
    Uint32 rsvd1:6;               // 31:26   Reserved
    Uint32 MAX_CURRENT_UPPER:10;  // 25:16   Maximum Current Upper Threshold
    Uint32 rsvd0:6;               // 15:10   Reserved
    Uint32 MAX_CURRENT_LOWER:10;  // 9:0     Maximum Current Lower Threshold
  };
  union CPMAX_REG {
    Uint32                   all;
    struct CPMAX_BITS        bit;
  };

  //-----------------------------------------------------------------------------
  // Constant Power Configuration Register (CPCONFIG)
  //-----------------------------------------------------------------------------
  struct CPCONFIG_BITS {          // Bits    Description
    Uint32 rsvd1:6;               // 31:26   Reserved
    Uint32 MAX_CURRENT:10;        // 25:16   Maximum Current 
    Uint32 rsvd0:6;               // 15:10   Reserved
    Uint32 NOM_VOLTAGE:10;        // 9:0     Nominal Voltage
  };
  union CPCONFIG_REG {
    Uint32                   all;
    struct CPCONFIG_BITS     bit;
  }; 
  
  //-----------------------------------------------------------------------------
  // Constant Power Max Power Register (CPMAXPWR)
  //-----------------------------------------------------------------------------
  struct CPMAXPWR_BITS {          // Bits    Description
    Uint32 rsvd0:12;              // 31:20   Reserved
    Uint32 MAX_POWER:20;          // 19:0    Maximum Power
  };
  union CPMAXPWR_REG {
    Uint32                   all;
    struct CPMAXPWR_BITS     bit;
  };

  //-----------------------------------------------------------------------------
  // Constant Power Integrator Threshold Register (CPINTTHRESH)
  //-----------------------------------------------------------------------------
  struct CPINTTHRESH_BITS {      // Bits     Description
    Uint32 rsvd0:8;              // 31:24    Reserved
    Uint32 INT_THRESH:24;        // 23:0     Signed Integrator Threshold
  };
  union CPINTTHRESH_REG {
    Uint32                   all;
    struct CPINTTHRESH_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // Constant Power Firmware Divisor Register (CPFWDIVISOR)
  //-----------------------------------------------------------------------------
  struct CPFWDIVISOR_BITS {      // Bits     Description
    Uint32 rsvd0:22;             // 31:10    Reserved
    Uint32 FW_DIVISOR:10;        // 9:0      Firmware configurable divisor
  };
  union CPFWDIVISOR_REG {
    Uint32                   all;
    struct CPFWDIVISOR_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // Constant Power Status Register (CPSTAT)
  //-----------------------------------------------------------------------------
  struct CPSTAT_BITS {           // Bits     Description
    Uint32 rsvd0:23;             // 31:9     Reserved
    Uint32 CONSTANT_CUR:1;       // 8        Constant Current Mode Indication
    Uint32 CONSTANT_PWR:1;       // 7        Constant Power Mode Indication
    Uint32 CONSTANT_VOLT:1;      // 6        Constant Voltage Mode Indication
    Uint32 CC_TO_CV_INT:1;       // 5        Constant Current to Voltage Interrupt
    Uint32 CV_TO_CC_INT:1;       // 4        Constant Voltage to Current Interrupt
    Uint32 CC_TO_CP_INT:1;       // 3        Constant Current to Power Interrupt
    Uint32 CP_TO_CC_INT:1;       // 2        Constant Power to Current Interrupt
    Uint32 CP_TO_CV_INT:1;       // 1        Constant Power to Voltage Interrupt
    Uint32 CV_TO_CP_INT:1;       // 0        Constant Voltage to Power Interrupt
  };
  union CPSTAT_REG {
    Uint32                   all;
    struct CPSTAT_BITS       bit;
  };

  //-----------------------------------------------------------------------------
  // Cycle Adjustment Control Register
  //-----------------------------------------------------------------------------
  struct CYCADJCTRL_BITS {      // Bits    Description
    Uint32 rsvd0:22;            // 31:10   Reserved
    Uint32 CYC_ADJ_GAIN:3;      // 9:7     Cycle Adjustment Gain
    Uint32 CYC_ADJ_SYNC:2;      // 6:5     Cycle Adjustment Sync
    Uint32 SECOND_SAMPLE_SEL:2; // 4:3     Second Cycle Adjustment Select
    Uint32 FIRST_SAMPLE_SEL:2;  // 2:1     First Cycle Adjustment Select
    Uint32 CYC_ADJ_EN:1;        // 0       Cycle Adjustment Enable
  };
  union CYCADJCTRL_REG {
    Uint32                    all;
    struct CYCADJCTRL_BITS    bit;
  };
  
  //-----------------------------------------------------------------------------
  // Cycle Adjustment Limit Register
  //-----------------------------------------------------------------------------
  struct CYCADJLIM_BITS {          // Bits    Description
    Uint32 rsvd1:3;                // 31:29   Reserved
    Uint32 CYC_ADJ_UPPER_LIMIT:13; // 28:16   Cycle Adjustment Upper Limit
    Uint32 rsvd0:3;                // 15:13   Reserved
    Uint32 CYC_ADJ_LOWER_LIMIT:13; // 12:0    Cycle Adjustment Lower Limit
  };
  union CYCADJLIM_REG {
    Uint32                    all;
    struct CYCADJLIM_BITS     bit;
  };

  //-----------------------------------------------------------------------------
  // Cycle Adjustment Status Register
  //-----------------------------------------------------------------------------
  struct CYCADJSTAT_BITS {      // Bits    Description
    Uint32 rsvd1:3;             // 31:29   Reserved
    Uint32 CYC_ADJ_CAL:13;      // 28:16   Cycle Adjustment Calculation
    Uint32 rsvd0:6;             // 15:10   Reserved
    Uint32 CYC_ADJ_ERROR:10;    // 9:0     Cycle Adjustment Error
  };
  union CYCADJSTAT_REG {
    Uint32                    all;
    struct CYCADJSTAT_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // Global Enable Register
  //-----------------------------------------------------------------------------
  struct GLBEN_BITS {           // Bits    Description
    Uint32 rsvd1:21;            // 31:11   Reserved
    Uint32 FE_CTRL2_EN:1;       // 10      Global Enable for Front End Control 2
    Uint32 FE_CTRL1_EN:1;       // 9       Global Enable for Front End Control 1
    Uint32 FE_CTRL0_EN:1;       // 8       Global Enable for Front End Control 0
    Uint32 rsvd0:4;             // 7:4     Reserved
    Uint32 DPWM3_EN:1;          // 3       Global Enable for DPWM Module 3
    Uint32 DPWM2_EN:1;          // 2       Global Enable for DPWM Module 2
    Uint32 DPWM1_EN:1;          // 1       Global Enable for DPWM Module 1
    Uint32 DPWM0_EN:1;          // 0       Global Enable for DPWM Module 0
  };
  union GLBEN_REG {
    Uint32                 all;
    struct GLBEN_BITS      bit;
  };

  //-----------------------------------------------------------------------------
  // PWM Global Period Register
  //-----------------------------------------------------------------------------
  struct PWMGLBPER_BITS {       // Bits    Description
    Uint32 rsvd1:14;            // 31:18   Reserved
    Uint32 PRD:14;              // 17:4    Global DPWM Period Value
    Uint32 rsvd0:4;             // 3:0     Reserved
  };
  union PWMGLBPER_REG {
    Uint32                    all;
    struct PWMGLBPER_BITS     bit;
  };

  //-----------------------------------------------------------------------------
  // Sync Control Register
  //-----------------------------------------------------------------------------
  struct SYNCCTRL_BITS {        // Bits    Description
    Uint32 rsvd0:26;            // 31:6    Reserved
    Uint32 SYNC_IN:1;           // 5       Sync pin value
    Uint32 SYNC_MUX_SEL:3;      // 4:2     Sync Select
    Uint32 SYNC_OUT:1;          // 1       Sync GPIO Value
    Uint32 SYNC_DIR:1;          // 0       Sync Pin Direction
  };
  union SYNCCTRL_REG {
    Uint32                    all;
    struct SYNCCTRL_BITS      bit;
  };

  //-----------------------------------------------------------------------------
  // Light Load Control Register
  //-----------------------------------------------------------------------------
  struct LLCTRL_BITS {         // Bits     Description
    Uint32 rsvd1:6;            // 31:26    Reserved
    Uint32 DPWM_ON_TIME:18;    // 25:8     DPWM On Time during Light Load Mode
    Uint32 rsvd0:4;            // 7:4      Reserved
    Uint32 CYCLE_CNT_EN:1;     // 3        Cycle Counter Enable
    Uint32 LL_FILTER_SEL:2;    // 2:1      Light Load Filter Select
    Uint32 LL_EN:1;            // 0        Light Load Enable
  };
  union LLCTRL_REG {
    Uint32                    all;
    struct LLCTRL_BITS        bit;
  };
  
  //-----------------------------------------------------------------------------
  // Light Load Enable Threshold Register
  //-----------------------------------------------------------------------------
  struct LLENTHRESH_BITS {       // Bits     Description
    Uint32 CYCLE_CNT_THRESH:8;   // 31:24    Switching Cycle Counter Threshold for turning on burst mode
    Uint32 rsvd0:6;              // 23:18    Reserved
    Uint32 TURN_ON_THRESH:18;    // 17:0     Filter Data Threshold to turn on burst mode
  };
  union LLENTHRESH_REG {
    Uint32                    all;
    struct LLENTHRESH_BITS    bit;
  };

  //-----------------------------------------------------------------------------
  // Light Load Disable Threshold Register
  //-----------------------------------------------------------------------------
  struct LLDISTHRESH_BITS {       // Bits     Description
    Uint32 rsvd0:14;              // 31:18    Reserved
    Uint32 TURN_OFF_THRESH:18;    // 17:0     Filter Data Threshold to turn off burst mode
  };
  union LLDISTHRESH_REG {
    Uint32                    all;
    struct LLDISTHRESH_BITS    bit;
  };  

  //-----------------------------------------------------------------------------
  // Digital Peak Current Mode Control Register
  //-----------------------------------------------------------------------------
  struct PCMCTRL_BITS {         // Bits      Description
    Uint32 rsvd1:26;             // 31:6         Reserved
    Uint32 PCM_FILTER_SEL:2;     // 5:4       Peak Current Mode Filter Select
    Uint32 rsvd0:4;             // 3:0        Reserved
  };
  union PCMCTRL_REG {
    Uint32                   all;
    struct PCMCTRL_BITS      bit;
  };

  //-----------------------------------------------------------------------------
  // Analog Peak Current Mode Control Register
  //-----------------------------------------------------------------------------
  struct APCMCTRL_BITS {         // Bits     Description
    Uint32 rsvd0:28;             // 31:4     Reserved
    Uint32 PCM_LATCH_EN:1;       // 3        PCM Latch Enable
    Uint32 PCM_FE_SEL:2;         // 2:1      Analog Peak Current Front End Select
    Uint32 PCM_EN:1;             // 0        Analog Peak Current Mode Enable
  };
  union APCMCTRL_REG {
    Uint32                   all;
    struct APCMCTRL_BITS     bit;
  }; 

  //-----------------------------------------------------------------------------
  // Loop Mux Test Register
  //-----------------------------------------------------------------------------
  struct LOOPMUXTEST_BITS {      // Bits     Description
    Uint32 rsvd0:13;             // 31:19    Reserved
    Uint32 BIST_COMP:1;          // 18       BIST Complete Flag
    Uint32 BIST_EN:1;            // 17       BIST Enable
    Uint32 BIST_TRIM_TEST_EN:1;  // 16       BIST Trim Test Enable
    Uint32 EADC_REF_TRIM:6;      // 15:10    EADC Ref Trim
    Uint32 EADC_REF_RESET:1;     // 9        EADC Reference Reset
    Uint32 EADC_REF_EN:1;        // 8        EADC Reference Enable
    Uint32 GAIN_TRIM:6;          // 7:2      EADC Gain Trim
    Uint32 AFE_GAIN:2;           // 1:0      AFE Gain
  };
  union LOOPMUXTEST_REG {
    Uint32                  all;
    struct LOOPMUXTEST_BITS bit;
  };

  //=============================================================================
  // Loop Mux Module Register File
  //=============================================================================
  struct LOOP_MUX_REGS {
    union FECTRL0MUX_REG       FECTRL0MUX;        // Front End Control 0 Mux Register
    union FECTRL1MUX_REG       FECTRL1MUX;        // Front End Control 1 Mux Register
    union FECTRL2MUX_REG       FECTRL2MUX;        // Front End Control 2 Mux Register
    union SAMPTRIGCTRL_REG     SAMPTRIGCTRL;      // Sample Trigger Control Register
    union EXTDACCTRL_REG       EXTDACCTRL;        // External DAC Control Register
    union FILTERMUX_REG        FILTERMUX;         // Filter Mux Register
    union FILTERKCOMPA_REG     FILTERKCOMPA;      // Filter KCOMP A Register
    union FILTERKCOMPB_REG     FILTERKCOMPB;      // Filter KCOMP B Register
    union DPWMMUX_REG          DPWMMUX;           // DPWM Mux Register
    union CPCTRL_REG           CPCTRL;            // Constant Power Control Register
    union CPNOM_REG            CPNOM;             // Constant Power Nominal Threshold Register
    union CPMAX_REG            CPMAX;             // Constant Power Maximum Threshold Register
    union CPCONFIG_REG         CPCONFIG;          // Constant Power Configuration Register
    union CPMAXPWR_REG         CPMAXPWR;          // Constant Power Maximum Power Register
    union CPINTTHRESH_REG      CPINTTHRESH;       // Constant Power Integrator Threshold Register
    union CPFWDIVISOR_REG      CPFWDIVISOR;       // Constant Power Firmware Divisor Register
    union CPSTAT_REG           CPSTAT;            // Constant Power Status Register
    union CYCADJCTRL_REG       CYCADJCTRL;        // Cycle Adjustment Control
    union CYCADJLIM_REG        CYCADJLIM;         // Cycle Adjustment Limit Register
    union CYCADJSTAT_REG       CYCADJSTAT;        // Cycle Adjustment Status Register
    union GLBEN_REG            GLBEN;             // Global Enable Register
    union PWMGLBPER_REG        PWMGLBPER;         // PWM Global Period Register
    union SYNCCTRL_REG         SYNCCTRL;          // Sync Control Register
    union LLCTRL_REG           LLCTRL;            // Light Load Control Register
    union LLENTHRESH_REG       LLENTHRESH;        // Light Load Enable Threshold Register
    union LLDISTHRESH_REG      LLDISTHRESH;       // Light Load Disable Threshold Register
    union PCMCTRL_REG          PCMCTRL;          // Digital Peak Current Mode Control Register
    Uint32                     RESERVED;         //Reserved
    union APCMCTRL_REG         APCMCTRL;          // Analog Peak Current Mode Control Register
    union LOOPMUXTEST_REG      LOOPMUXTEST;       // Loop Mux Test Register
  };
  
  //-----------------------------------------------------------------------------
  // Loop Mux Module External References & Function Declarations:
  //-----------------------------------------------------------------------------
  extern volatile struct LOOP_MUX_REGS LoopMuxRegs;




//===========================================================================
// End of file
//===========================================================================
//###############################################################################
//
// FILE:   cyclone_misc_analog.h
//
// TITLE:  Cyclone Miscellaneous Analog Register Definitions.
//
// NOTES:
//  1) Bitfields have been defined for big-endian only.
//###############################################################################
//
//  Ver  | dd mmm yyyy | Who  | Description of changes
// ======|=============|======|==============================================
//  1.00 | 19 Aug 2009 | CMF  | Initial Revision
//       |             |      | 
//       |             |      |
//
//  Texas Instruments, Inc
//  Copyright Texas Instruments 2009. All rights reserved.
//###############################################################################



  //=============================================================================
  // Miscellaneous Analog Individual Register Bit Definitions
  //=============================================================================

  //-----------------------------------------------------------------------------
  // Clock Trim Register
  //-----------------------------------------------------------------------------
  struct CLKTRIM_BITS {             // bits   description
    Uint32 rsvd1:17;                // 31:15  Reserved
    Uint32 HFO_CLK_TRIM:7;          // 14:8   HFO Clock Trim
    Uint32 HFO_SEL_RANGE:2;         // 7:6    HFO Select Range
    Uint32 HFO_LN_FILTER_EN:1;      // 5      HFO Filter Enable
    Uint32 LFO_DISABLE:1;           // 4      LFO Disable
    Uint32 HFO_THERM_TRIM:3;        // 3:1    HFO Therm Trim
    Uint32 HFO_ENABLE:1;            // 0      HFO Enable
  }; 
  union CLKTRIM_REG {
    Uint32                  all;
    struct CLKTRIM_BITS     bit;
  };

  //-----------------------------------------------------------------------------
  // Bandgap Trim Register
  //-----------------------------------------------------------------------------
  struct BGTRIM_BITS {              // bits   description 
    Uint32 rsvd0:14;                // 31:18  Reserved
    Uint32 BG_GAIN_TRIM:7;          // 17:11  Bandgap Gain Trim
    Uint32 BG_SPARE_TRIM:2;         // 10:9   Bandgap Spare Trim
    Uint32 BG_TEMP_TRIM:9;          // 8:0    Bandgap Temp Trim
  };
  union BGTRIM_REG {
    Uint32                  all;
    struct BGTRIM_BITS      bit;
  };
  
  //-----------------------------------------------------------------------------
  // AFE Control Register
  //-----------------------------------------------------------------------------
  struct AFECTRL_BITS {            // bits   description 
    Uint32 rsvd0:16;               // 31:16  Reserved
    Uint32 AFE_MUX_CH_SEL:2;       // 15:14  AFE Mux Channel Select
    Uint32 AFE_VIN_MUX:1;          // 13     Isolation Buffer Selection Test
    Uint32 COMP_DAC_TEST:1;        // 12     Comparator DAC Test
    Uint32 ANALOG_MUX_B_SEL:3;     // 11:9   Analog Mux B Select
    Uint32 VREG_3P3_DIS:1;         // 8      3.3V Regulator Disable
    Uint32 VREG_FLASH_DIS:1;       // 7      2.6V Regulator Disable
    Uint32 ANALOG_TEST_EN:1;       // 6      Enable Analog Test Points
    Uint32 AFE_MUX_SEL:3;          // 5:3    Analog Front End Mux Select
    Uint32 ANALOG_MUX_A_SEL:3;     // 2:0    Analog Mux A Select
  };
  union AFECTRL_REG {
    Uint32                  all;
    struct AFECTRL_BITS     bit;
  };

  //-----------------------------------------------------------------------------
  // AFE Miscellaneous Register
  //-----------------------------------------------------------------------------
  struct AFEMISC_BITS {           // bits   description 
    Uint32 rsvd1:24;              // 31:8   Reserved
    Uint32 V33_TRIM:4;            // 7:4    V33 Trim Bits
    Uint32 rsvd0:4;               // 3:0    Reserved
  };
  union AFEMISC_REG {
    Uint32                  all;
    struct AFEMISC_BITS     bit;
  };
  
  //-----------------------------------------------------------------------------
  // Package ID Register
  //-----------------------------------------------------------------------------
  struct PKGID_BITS {             // bits   description 
    Uint32 rsvd0:30;              // 31:1   Reserved
    Uint32 PKG_ID:2;              // 1:0    Package ID
  };
  union PKGID_REG {
    Uint32                  all;
    struct PKGID_BITS       bit;
  };

  //-----------------------------------------------------------------------------
  // Brownout Register
  //-----------------------------------------------------------------------------
  struct BROWNOUT_BITS {         // bits   description 
    Uint32 rsvd0:29;             // 31:3   Reserved
    Uint32 INT:1;                // 2      Brownout Interrupt Latched Status
    Uint32 INT_EN:1;             // 1      Brownout Interrupt Enable
    Uint32 COMP_EN:1;            // 0      Brownout Enable
  };
  union BROWNOUT_REG {
    Uint32                  all;
    struct BROWNOUT_BITS    bit;
  };
  
  //-----------------------------------------------------------------------------
  // Global I/O Enable Register
  //-----------------------------------------------------------------------------
  struct GLBIOEN_BITS {         // bits   description 
    Uint32 rsvd0:2;             // 31:30  Reserved
	Uint32 FAULT3_IO_EN:1;            // bit 29
	Uint32 ADC_EXT_TRIG_IO_EN:1;      // bit 28
	Uint32 TCK_IO_EN:1;               // bit 27
    Uint32 TDO_IO_EN:1;               // bit 26
	Uint32 TMS_IO_EN:1;               // bit 25
	Uint32 TDI_IO_EN:1;               // bit 24
	Uint32 SCI_TX1_IO_EN:1;           // bit 23
    Uint32 SCI_TX0_IO_EN:1;           // bit 22
	Uint32 SCI_RX1_IO_EN:1;           // bit 21
	Uint32 SCI_RX0_IO_EN:1;           // bit 20
	Uint32 TMR_CAP_IO_EN:1;           // bit 19
    Uint32 TMR_PWM1_IO_EN:1;          // bit 18
	Uint32 TMR_PWM0_IO_EN:1;          // bit 17
	Uint32 PMBUS_CLK_IO_EN:1;         // bit 16
	Uint32 PMBUS_DATA_IO_EN:1;        // bit 15
    Uint32 CONTROL_IO_EN:1;           // bit 14
	Uint32 ALERT_IO_EN:1;             // bit 13
	Uint32 EXT_INT_IO_EN:1;           // bit 12
	Uint32 FAULT2_IO_EN:1;            // bit 11
    Uint32 FAULT1_IO_EN:1;            // bit 10
	Uint32 FAULT0_IO_EN:1;            // bit  9
	Uint32 SYNC_IO_EN:1;              // bit  8
	Uint32 DPWM3B_IO_EN:1;            // bit  7
    Uint32 DPWM3A_IO_EN:1;            // bit  6
	Uint32 DPWM2B_IO_EN:1;            // bit  5
	Uint32 DPWM2A_IO_EN:1;            // bit  4
	Uint32 DPWM1B_IO_EN:1;            // bit  3
    Uint32 DPWM1A_IO_EN:1;            // bit  2
	Uint32 DPWM0B_IO_EN:1;            // bit  1
	Uint32 DPWM0A_IO_EN:1;            // bit  0
  };
  union GLBIOEN_REG {
    Uint32                  all;
    struct GLBIOEN_BITS     bit;
  };

  //-----------------------------------------------------------------------------
  // Global I/O Output Enable Register
  //-----------------------------------------------------------------------------
  struct GLBIOOE_BITS {         // bits   description 
    Uint32 rsvd0:2;             // 31:30  Reserved
	Uint32 FAULT3_IO_OE:1;            // bit 29
	Uint32 ADC_EXT_TRIG_IO_OE:1;      // bit 28
	Uint32 TCK_IO_OE:1;               // bit 27
    Uint32 TDO_IO_OE:1;               // bit 26
	Uint32 TMS_IO_OE:1;               // bit 25
	Uint32 TDI_IO_OE:1;               // bit 24
	Uint32 SCI_TX1_IO_OE:1;           // bit 23
    Uint32 SCI_TX0_IO_OE:1;           // bit 22
	Uint32 SCI_RX1_IO_OE:1;           // bit 21
	Uint32 SCI_RX0_IO_OE:1;           // bit 20
	Uint32 TMR_CAP_IO_OE:1;           // bit 19
    Uint32 TMR_PWM1_IO_OE:1;          // bit 18
	Uint32 TMR_PWM0_IO_OE:1;          // bit 17
	Uint32 PMBUS_CLK_IO_OE:1;         // bit 16
	Uint32 PMBUS_DATA_IO_OE:1;        // bit 15
    Uint32 CONTROL_IO_OE:1;           // bit 14
	Uint32 ALERT_IO_OE:1;             // bit 13
	Uint32 EXT_INT_IO_OE:1;           // bit 12
	Uint32 FAULT2_IO_OE:1;            // bit 11
    Uint32 FAULT1_IO_OE:1;            // bit 10
	Uint32 FAULT0_IO_OE:1;            // bit  9
	Uint32 SYNC_IO_OE:1;              // bit  8
	Uint32 DPWM3B_IO_OE:1;            // bit  7
    Uint32 DPWM3A_IO_OE:1;            // bit  6
	Uint32 DPWM2B_IO_OE:1;            // bit  5
	Uint32 DPWM2A_IO_OE:1;            // bit  4
	Uint32 DPWM1B_IO_OE:1;            // bit  3
    Uint32 DPWM1A_IO_OE:1;            // bit  2
	Uint32 DPWM0B_IO_OE:1;            // bit  1
	Uint32 DPWM0A_IO_OE:1;            // bit  0
  };
  union GLBIOOE_REG {
    Uint32                  all;
    struct GLBIOOE_BITS     bit;
  };

  //-----------------------------------------------------------------------------
  // Global I/O Open Drain Enable Register
  //-----------------------------------------------------------------------------
  struct GLBIOOD_BITS {         // bits   description 
    Uint32 rsvd0:2;             // 31:30  Reserved
    Uint32 FAULT3_IO_OD:1;            // bit 29
	Uint32 ADC_EXT_TRIG_IO_OD:1;      // bit 28
	Uint32 TCK_IO_OD:1;               // bit 27
    Uint32 TDO_IO_OD:1;               // bit 26
	Uint32 TMS_IO_OD:1;               // bit 25
	Uint32 TDI_IO_OD:1;               // bit 24
	Uint32 SCI_TX1_IO_OD:1;           // bit 23
    Uint32 SCI_TX0_IO_OD:1;           // bit 22
	Uint32 SCI_RX1_IO_OD:1;           // bit 21
	Uint32 SCI_RX0_IO_OD:1;           // bit 20
	Uint32 TMR_CAP_IO_OD:1;           // bit 19
    Uint32 TMR_PWM1_IO_OD:1;          // bit 18
	Uint32 TMR_PWM0_IO_OD:1;          // bit 17
	Uint32 PMBUS_CLK_IO_OD:1;         // bit 16
	Uint32 PMBUS_DATA_IO_OD:1;        // bit 15
    Uint32 CONTROL_IO_OD:1;           // bit 14
	Uint32 ALERT_IO_OD:1;             // bit 13
	Uint32 EXT_INT_IO_OD:1;           // bit 12
	Uint32 FAULT2_IO_OD:1;            // bit 11
    Uint32 FAULT1_IO_OD:1;            // bit 10
	Uint32 FAULT0_IO_OD:1;            // bit  9
	Uint32 SYNC_IO_OD:1;              // bit  8
	Uint32 DPWM3B_IO_OD:1;            // bit  7
    Uint32 DPWM3A_IO_OD:1;            // bit  6
	Uint32 DPWM2B_IO_OD:1;            // bit  5
	Uint32 DPWM2A_IO_OD:1;            // bit  4
	Uint32 DPWM1B_IO_OD:1;            // bit  3
    Uint32 DPWM1A_IO_OD:1;            // bit  2
	Uint32 DPWM0B_IO_OD:1;            // bit  1
	Uint32 DPWM0A_IO_OD:1;            // bit  0 
  };
  union GLBIOOD_REG {
    Uint32                  all;
    struct GLBIOOD_BITS     bit;
  };

  //-----------------------------------------------------------------------------
  // Global I/O Value Register
  //-----------------------------------------------------------------------------
  struct GLBIOVAL_BITS {        // bits   description 
    Uint32 rsvd0:2;             // 31:30  Reserved
	Uint32 FAULT3_IO_VALUE:1;            // bit 29
	Uint32 ADC_EXT_TRIG_IO_VALUE:1;      // bit 28
	Uint32 TCK_IO_VALUE:1;               // bit 27
    Uint32 TDO_IO_VALUE:1;               // bit 26
	Uint32 TMS_IO_VALUE:1;               // bit 25
	Uint32 TDI_IO_VALUE:1;               // bit 24
	Uint32 SCI_TX1_IO_VALUE:1;           // bit 23
    Uint32 SCI_TX0_IO_VALUE:1;           // bit 22
	Uint32 SCI_RX1_IO_VALUE:1;           // bit 21
	Uint32 SCI_RX0_IO_VALUE:1;           // bit 20
	Uint32 TMR_CAP_IO_VALUE:1;           // bit 19
    Uint32 TMR_PWM1_IO_VALUE:1;          // bit 18
	Uint32 TMR_PWM0_IO_VALUE:1;          // bit 17
	Uint32 PMBUS_CLK_IO_VALUE:1;         // bit 16
	Uint32 PMBUS_DATA_IO_VALUE:1;        // bit 15
	Uint32 CONTROL_IO_VALUE:1;           // bit 14
	Uint32 ALERT_IO_VALUE:1;             // bit 13
	Uint32 EXT_INT_IO_VALUE:1;           // bit 12
	Uint32 FAULT2_IO_VALUE:1;            // bit 11
    Uint32 FAULT1_IO_VALUE:1;            // bit 10
	Uint32 FAULT0_IO_VALUE:1;            // bit  9
	Uint32 SYNC_IO_VALUE:1;              // bit  8
	Uint32 DPWM3B_IO_VALUE:1;            // bit  7
    Uint32 DPWM3A_IO_VALUE:1;            // bit  6
	Uint32 DPWM2B_IO_VALUE:1;            // bit  5
	Uint32 DPWM2A_IO_VALUE:1;            // bit  4
	Uint32 DPWM1B_IO_VALUE:1;            // bit  3
    Uint32 DPWM1A_IO_VALUE:1;            // bit  2
	Uint32 DPWM0B_IO_VALUE:1;            // bit  1
	Uint32 DPWM0A_IO_VALUE:1;            // bit  0
  };
  union GLBIOVAL_REG {
    Uint32                   all;
    struct GLBIOVAL_BITS     bit;
  };  

  //-----------------------------------------------------------------------------
  // Global I/O Read Value Register
  //-----------------------------------------------------------------------------
  struct GLBIOREAD_BITS {        // bits   description 
    Uint32 rsvd0:2;              // 31:30  Reserved
	Uint32 FAULT3_IO_READ:1;            // bit 29
	Uint32 ADC_EXT_TRIG_IO_READ:1;      // bit 28
	Uint32 TCK_IO_READ:1;               // bit 27
    Uint32 TDO_IO_READ:1;               // bit 26
	Uint32 TMS_IO_READ:1;               // bit 25
	Uint32 TDI_IO_READ:1;               // bit 24
	Uint32 SCI_TX1_IO_READ:1;           // bit 23
    Uint32 SCI_TX0_IO_READ:1;           // bit 22
	Uint32 SCI_RX1_IO_READ:1;           // bit 21
	Uint32 SCI_RX0_IO_READ:1;           // bit 20
	Uint32 TMR_CAP_IO_READ:1;           // bit 19
    Uint32 TMR_PWM1_IO_READ:1;          // bit 18
	Uint32 TMR_PWM0_IO_READ:1;          // bit 17
	Uint32 PMBUS_CLK_IO_READ:1;         // bit 16
	Uint32 PMBUS_DATA_IO_READ:1;        // bit 15
    Uint32 CONTROL_IO_READ:1;           // bit 14
	Uint32 ALERT_IO_READ:1;             // bit 13
	Uint32 EXT_INT_IO_READ:1;           // bit 12
	Uint32 FAULT2_IO_READ:1;            // bit 11
    Uint32 FAULT1_IO_READ:1;            // bit 10
	Uint32 FAULT0_IO_READ:1;            // bit  9
	Uint32 SYNC_IO_READ:1;              // bit  8
	Uint32 DPWM3B_IO_READ:1;            // bit  7
    Uint32 DPWM3A_IO_READ:1;            // bit  6
	Uint32 DPWM2B_IO_READ:1;            // bit  5
	Uint32 DPWM2A_IO_READ:1;            // bit  4
	Uint32 DPWM1B_IO_READ:1;            // bit  3
    Uint32 DPWM1A_IO_READ:1;            // bit  2
	Uint32 DPWM0B_IO_READ:1;            // bit  1
	Uint32 DPWM0A_IO_READ:1;            // bit  0
  };
  union GLBIOREAD_REG {
    Uint32                   all;
    struct GLBIOREAD_BITS    bit;
  };  

  //-----------------------------------------------------------------------------
  // Temperature Sensor Register
  //-----------------------------------------------------------------------------
  struct TEMPSENCTRL_BITS {     // bits   description
    Uint32 rsvd0:25;            // 31:7   Reserved
    Uint32 TEMP_SENSE_TRIM:6;   // 6:1    Temperature Sensor Trim
    Uint32 TEMP_SENSE_DIS:1;    // 0      Temperature Sensor Disable
  };
  union TEMPSENCTRL_REG {
    Uint32                   all;
    struct TEMPSENCTRL_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // I/O Mux Control Register
  //-----------------------------------------------------------------------------
  struct IOMUX_BITS {          // bits    description
    Uint32 rsvd0:22;           // 31:10   Reserved
    Uint32 EXT_TRIG_MUX_SEL:2; // 9:8     EXT TRIG Pins Mux Control
    Uint32 JTAG_CLK_MUX_SEL:2; // 7:6     JTAG Data Pins Mux Control
    Uint32 JTAG_DATA_MUX_SEL:2;// 5:4     JTAG Data Pins Mux Control
    Uint32 SYNC_MUX_SEL:2;     // 3:2     SYNC Pins Mux Control
    Uint32 UART_MUX_SEL:1;     // 1       UART Pins Mux Control
    Uint32 PMBUS_MUX_SEL:1;    // 0       PMBus Pins Mux Control
  };
  union IOMUX_REG {
    Uint32                   all;
    struct IOMUX_BITS        bit;
  };

  //-----------------------------------------------------------------------------
  // Current Sharing Trim Register
  //-----------------------------------------------------------------------------
  struct CSTRIM_BITS {         // bits    Description
    Uint32 rsvd1:20;           // 31:12   Reserved
    Uint32 CURRENT_TRIM:4;     // 11:8    Current Sharing Current Trim
    Uint32 rsvd0:3;            // 7:5     Reserved
    Uint32 RESISTOR_TRIM:5;    // 4:0     Current Sharing Resistor Trim
  };
  union CSTRIM_REG {
    Uint32                   all;
    struct CSTRIM_BITS       bit;
  };
  
  //-----------------------------------------------------------------------------
  // Current Sharing Control Register
  //-----------------------------------------------------------------------------
  struct CSCTRL_BITS {               // bits    Description
    Uint32 rsvd1:8;                  // 31:24   Reserved
    Uint32 DPWM_DUTY:8;              // 23:16   DPWM Duty/Pulse Width for Cur Share
    Uint32 DPWM_PERIOD:8;            // 15:8    DPWM Period for Current Share
    Uint32 rsvd0:4;                  // 7:4     Reserved
    Uint32 TEST_MODE:4;              // 3:0     Current Sharing Test Mode
  };
  union CSCTRL_REG {
    Uint32                   all;
    struct CSCTRL_BITS       bit;
  };

  //-----------------------------------------------------------------------------
  // Temperature Reference Register
  //-----------------------------------------------------------------------------
  struct TEMPREF_BITS {        // bits    Description
    Uint32 rsvd0:20;           // 31:12   Reserved
    Uint32 TEMP_REF:12;        // 11:0    Temperature Reference 
  };
  union TEMPREF_REG {
    Uint32                   all;
    struct TEMPREF_BITS      bit;
  };

  //-----------------------------------------------------------------------------
  // Clock Gating Control Register (CLKGATECTRL)
  //-----------------------------------------------------------------------------
  struct PWRDISCTRL_BITS {   // bits    Description
    Uint32 rsvd0:14;          // 31:18   Reserved
    Uint32 PCM_CLK_EN:1;      // 17      Peak Current Mode Clock Enable
    Uint32 CPCC_CLK_EN:1;     // 16      Constant Power/Constant Current Clock Enable
    Uint32 FILTER2_CLK_EN:1;  // 15      Filter 2 Clock Enable
    Uint32 FILTER1_CLK_EN:1;  // 14      Filter 1 Clock Enable
    Uint32 FILTER0_CLK_EN:1;  // 13      Filter 0 Clock Enable
    Uint32 FE_CTRL2_CLK_EN:1; // 12      Front End Control 2 Clock Enable
    Uint32 FE_CTRL1_CLK_EN:1; // 11      Front End Control 2 Clock Enable
    Uint32 FE_CTRL0_CLK_EN:1; // 10      Front End Control 2 Clock Enable
    Uint32 DPWM3_CLK_EN:1;    // 9       DPWM4 Clock Enable
    Uint32 DPWM2_CLK_EN:1;    // 8       DPWM4 Clock Enable
    Uint32 DPWM1_CLK_EN:1;    // 7       DPWM4 Clock Enable
    Uint32 DPWM0_CLK_EN:1;    // 6       DPWM4 Clock Enable
    Uint32 SCI1_CLK_EN:1;     // 5       SCI1 Clock Enable
    Uint32 SCI0_CLK_EN:1;     // 4       SCI0 Clock Enable
    Uint32 ADC12_CLK_EN:1;    // 3       ADC12 Control Clock Enable
    Uint32 PMBUS_CLK_EN:1;    // 2       PMBus I/F Clock Enable
    Uint32 GIO_CLK_EN:1;      // 1       GIO Clock Enable
    Uint32 TIMER_CLK_EN:1;    // 0       Timer Clock Enable
  };
  union PWRDISCTRL_REG {
    Uint32                  all;
    struct PWRDISCTRL_BITS bit;
  };

  //-----------------------------------------------------------------------------
  // Bias Trim Register (BIASTRIM)
  //-----------------------------------------------------------------------------
  struct BIASTRIM_BITS {     // bits     Description
    Uint32 rsvd0:25;         // 31:7     Reserved
    Uint32 ADC12_BOOST:1;    // 6        ADC12 Boost 
    Uint32 IBIAS_TRIM:6;     // 5:0      IBias Trim Bits
  };
  union BIASTRIM_REG {
    Uint32                  all;
    struct BIASTRIM_BITS    bit;
  };

  //=============================================================================
  // Miscellaneous Analog  Module Register File
  //=============================================================================
  struct MISC_ANALOG_REGS {
    union CLKTRIM_REG       CLKTRIM;
    union BGTRIM_REG        BGTRIM;
    union AFECTRL_REG       AFECTRL;
    union AFEMISC_REG       AFEMISC;
    union PKGID_REG         PKGID;
    union BROWNOUT_REG      BROWNOUT;
    union GLBIOEN_REG       GLBIOEN;
    union GLBIOOE_REG       GLBIOOE;
    union GLBIOOD_REG       GLBIOOD;
    union GLBIOVAL_REG      GLBIOVAL;
    union GLBIOREAD_REG     GLBIOREAD;
    union TEMPSENCTRL_REG   TEMPSENCTRL;
    union IOMUX_REG         IOMUX;
    union CSTRIM_REG        CSTRIM;
    union CSCTRL_REG        CSCTRL;
    union TEMPREF_REG       TEMPREF;
    union PWRDISCTRL_REG    PWRDISCTRL;
    union BIASTRIM_REG      BIASTRIM;
  };

  //-----------------------------------------------------------------------------
  // ADC Module External References & Function Declarations:
  //-----------------------------------------------------------------------------
  extern volatile struct MISC_ANALOG_REGS MiscAnalogRegs;




//===========================================================================
// End of file
//===========================================================================
//###########################################################################
//
// FILE:   cyclone_mmc.h
//
// TITLE:  Cyclone Memory Controller Module Register Definitions.
//
// NOTES:
//  1) Bitfields have been defined for big-endian only.
//###########################################################################
//
//  Ver  | dd mmm yyyy | Who  | Description of changes
// ======|=============|======|==============================================
//  1.00 | 12 Aug 2009 | CMF  | Started with Spartan_Mmc.h.
//       |             |      | Updated for 1.0 Memory map document.
//       |             |      |
//
//  Texas Instruments, Inc
//  Copyright Texas Instruments 2008. All rights reserved.
//###########################################################################



//===========================================================================
// Memory Controller Module Individual Register Bit Definitions
//

//-------------------------------------------------
// Static Memory Control Register bit definitions
//
struct SMCTRL_BITS {              // bits   description
   Uint32 rsvd2:18;               // 31:14  reserved
   Uint32 LEAD:2;                 // 13:12  Address setup time cycles (write)
   Uint32 TRAIL:3;                // 11:9   Trailing wait states (read/write)
   Uint32 rsvd1:1;                // 8      reserved
   Uint32 ACTIVE:4;               // 7:4    Wait states (read/write)
   Uint32 ENDIAN:1;               // 3      Endian mode
   Uint32 rsvd0:1;                // 2      reserved
   Uint32 WIDTH:2;                // 1:0    Data width
};
union SMCTRL_REG {
   Uint32                 all;
   struct SMCTRL_BITS     bit;
};

//-------------------------------------------------
// Write Control Register bit definitions
//
struct WCTRL_BITS {               // bits   description
   Uint32 rsvd0:30;               // 31:2   reserved
   Uint32 TRAIL_OVR:1;            // 1      Write trailing wait state override
   Uint32 WBUF_ENA:1;             // 0      Write buffer enable
};
union WCTRL_REG {
   Uint32              all;
   struct WCTRL_BITS   bit;
};

//-------------------------------------------------
// Peripheral Control Register bit definitions
//
struct PCTRL_BITS {               // bits   description
   Uint32 rsvd0:31;               // 31:1   reserved
   Uint32 PBUF_ENA:1;             // 0      Peripheral enable
};
union PCTRL_REG {
   Uint32                all;
   struct PCTRL_BITS     bit;
};

//-------------------------------------------------
// Peripheral Location Register bit definitions
//
struct PLOC_BITS {                // bits   description
   Uint32 rsvd0:16;               // 31:16  reserved
   Uint32 LOC15:1;                // 15     Peripheral 15 location
   Uint32 LOC14:1;                // 14     Peripheral 14 location
   Uint32 LOC13:1;                // 13     Peripheral 13 location
   Uint32 LOC12:1;                // 12     Peripheral 12 location
   Uint32 LOC11:1;                // 11     Peripheral 11 location
   Uint32 LOC10:1;                // 10     Peripheral 10 location
   Uint32 LOC9:1;                 // 9      Peripheral 9 location
   Uint32 LOC8:1;                 // 8      Peripheral 8 location
   Uint32 LOC7:1;                 // 7      Peripheral 7 location
   Uint32 LOC6:1;                 // 6      Peripheral 6 location
   Uint32 LOC5:1;                 // 5      Peripheral 5 location
   Uint32 LOC4:1;                 // 4      Peripheral 4 location
   Uint32 LOC3:1;                 // 3      Peripheral 3 location
   Uint32 LOC2:1;                 // 2      Peripheral 2 location
   Uint32 LOC1:1;                 // 1      Peripheral 1 location
   Uint32 LOC0:1;                 // 0      Peripheral 0 location
};
union PLOC_REG {
   Uint32                all;
   struct PLOC_BITS      bit;
};

//-------------------------------------------------
// Peripheral Protection Register bit definitions
//
struct PPROT_BITS {               // bits   description
   Uint32 rsvd0:16;               // 31:16  reserved
   Uint32 PROT15:1;               // 15     Peripheral 15 protection
   Uint32 PROT14:1;               // 14     Peripheral 14 protection
   Uint32 PROT13:1;               // 13     Peripheral 13 protection
   Uint32 PROT12:1;               // 12     Peripheral 12 protection
   Uint32 PROT11:1;               // 11     Peripheral 11 protection
   Uint32 PROT10:1;               // 10     Peripheral 10 protection
   Uint32 PROT9:1;                // 9      Peripheral 9 protection
   Uint32 PROT8:1;                // 8      Peripheral 8 protection
   Uint32 PROT7:1;                // 7      Peripheral 7 protection
   Uint32 PROT6:1;                // 6      Peripheral 6 protection
   Uint32 PROT5:1;                // 5      Peripheral 5 protection
   Uint32 PROT4:1;                // 4      Peripheral 4 protection
   Uint32 PROT3:1;                // 3      Peripheral 3 protection
   Uint32 PROT2:1;                // 2      Peripheral 2 protection
   Uint32 PROT1:1;                // 1      Peripheral 1 protection
   Uint32 PROT0:1;                // 0      Peripheral 0 protection
};
union PPROT_REG {
   Uint32               all;
   struct PPROT_BITS    bit;
};

//===========================================================================
// Memory Controller Module Register File
//
struct MMC_REGS {
   union  SMCTRL_REG     SMCTRL;      // Static Memory Control Register
   Uint32                RSVD[0xA];   // Reserved (address spacer)
   union  WCTRL_REG      WCTRL;       // Write Control Register
   union  PCTRL_REG      PCTRL;       // Peripheral Control Register
   union  PLOC_REG       PLOC;        // Peripheral Location Register
   union  PPROT_REG      PPROT;       // Peripheral Protection Register
};

//---------------------------------------------------------------------------
// Memory Controller Module External References & Function Declarations:
//
extern volatile struct MMC_REGS MmcRegs;

//===========================================================================


//===========================================================================
// End of file
//===========================================================================
//###############################################################################
//
// FILE:   cyclone_pmbus.h
//
// TITLE:  Cyclone PMBus Interface Register Definitions.
//
// NOTES:
//  1) Bitfields have been defined for big-endian only.
//###############################################################################
//
//  Ver  | dd mmm yyyy | Who  | Description of changes
// ======|=============|======|==============================================
//  1.00 | 19 Aug 2008 | CMF  | Started with Spartan_Pmbus.h.
//       |             |      | Updated for 1.0 Memory map document.
//       |             |      |
//
//  Texas Instruments, Inc
//  Copyright Texas Instruments 2009. All rights reserved.
//###############################################################################



  //=============================================================================
  // PMBus Interface Individual Register Bit Definitions
  //=============================================================================

  //-----------------------------------------------------------------------------
  // PMBus Control Register 1 bit definitions
  //-----------------------------------------------------------------------------
  struct PMBCTRL1_BITS {            // bits   description
    Uint32 rsvd0:11;                // 31:21  reserved
    Uint32 PRC_CALL:1;              // 20     Process call message enable
    Uint32 GRP_CMD:1;               // 19     Group command message enable
    Uint32 PEC_ENA:1;               // 18     PEC byte enable
    Uint32 EXT_CMD:1;               // 17     Extended command enable
    Uint32 CMD_ENA:1;               // 16     Command word enable
    Uint32 BYTE_COUNT:8;            // 15:8   Byte count
    Uint32 SLAVE_ADDR:7;            // 7:1    Slave address
    Uint32 RW:1;                    // 0      Read/write indicator
  };
  union PMBCTRL1_REG {
    Uint32                   all;
    struct PMBCTRL1_BITS     bit;
  };
  
  //-----------------------------------------------------------------------------
  // PMBus Transmit Data Buffer bit definitions
  //
  // No bitfields are defined for PMBTXBUF because writing
  // to any of the four data bytes triggers the PMBus
  // transmission.  Therefore, we force the user to always
  // write to all four bytes at the same time.
  //-----------------------------------------------------------------------------
  struct PMBTXBUF_BITS {            // bits   description
    Uint32 ALL:32;                  // 31:0   All the bits
  };
  union PMBTXBUF_REG {
    Uint32                   all;
    struct PMBTXBUF_BITS     bit;
  };

  //-----------------------------------------------------------------------------
  // PMBus Receive Data Buffer bit definitions
  //-----------------------------------------------------------------------------
  struct PMBRXBUF_BITS {           // bits   description
    Uint32 BYTE3:8;                // 31:24  Byte3
    Uint32 BYTE2:8;                // 16:23  Byte2
    Uint32 BYTE1:8;                // 8:15   Byte1
    Uint32 BYTE0:8;                // 0:7    Byte0
  };
	struct PMBRXBUF_BYTES {              // bits   description
	   Uint8  BYTE3;                  // 31:24  reserved
	   Uint8  BYTE2;                  // 16:23  Byte #2
	   Uint8  BYTE1;                  // 8:15   Byte #1
	   Uint8  BYTE0;                  // 0:7    Byte #0
  };
  union PMBRXBUF_REG {
    Uint32                   all;
    struct PMBRXBUF_BITS     bit;
	struct PMBRXBUF_BYTES	byte;
  };
  
  //-----------------------------------------------------------------------------
  // PMBus Acknowledge Register bit definitions
  //-----------------------------------------------------------------------------
  struct PMBACK_BITS {             // bits   description
    Uint32 rsvd0:31;               // 31:1   reserved
    Uint32 ACK:1;                  // 0      Acknowledge enable
  };
  struct PMBACK_BYTES {              // bits   description
    Uint8  BYTE3;                  // 31:24  reserved
    Uint8  BYTE2;                  // 16:23  Byte #2
    Uint8  BYTE1;                  // 8:15   Byte #1
    Uint8  BYTE0;                  // 0:7    Byte #0
  };
  union PMBACK_REG {
    Uint32                all;
    struct PMBACK_BITS    bit;
	struct PMBACK_BYTES	byte;
  };
  
  //-----------------------------------------------------------------------------
  // PMBus Status Register bit definitions
  //-----------------------------------------------------------------------------
  struct PMBST_BITS {               // bits  Description
    Uint32 rsvd0:10;               // 31:22  reserved
    Uint32 SCL_RAW:1;              // 21     PMBus Clock Status
    Uint32 SDA_RAW:1;              // 20     PMBus Data Status
    Uint32 CONTROL_RAW:1;          // 19     Control Raw Status
    Uint32 ALERT_RAW:1;            // 18     Alert Raw Status
    Uint32 CONTROL_EDGE:1;         // 17     Control Signal Edge Detected
    Uint32 ALERT_EDGE:1;           // 16     Alert signal detected flag
    Uint32 MASTER:1;               // 15     Master/Slave mode flag
    Uint32 LOST_ARB:1;             // 14     Lost arbitration flag
    Uint32 BUS_FREE:1;             // 13     Bus free flag
    Uint32 UNIT_BUSY:1;            // 12     Unit busy flag
    Uint32 RPT_START:1;            // 11     Repeated start condition flag
    Uint32 SLAVE_ADDR_READY:1;     // 10     Slave address ready flag
    Uint32 CLK_HIGH_TIMEOUT:1;     // 9      Clock high timeout flag
    Uint32 CLK_LOW_TIMEOUT:1;      // 8      Clock low timeout flag
    Uint32 PEC_VALID:1;            // 7      PEC valid flag
    Uint32 NACK:1;                 // 6      NACK condition received flag
    Uint32 EOM:1;                  // 5      End of message flag
    Uint32 DATA_REQUEST:1;         // 4      Data request flag
    Uint32 DATA_READY:1;           // 3      Data ready flag
    Uint32 RD_BYTE_COUNT:3;        // 2:0    Read byte count
  };

struct PMBST_BYTES {              // bits   description
   Uint8  rsvd3;                  // 31:24  reserved
   Uint8  BYTE2;                  // 16:23  Byte #2
   Uint8  BYTE1;                  // 8:15   Byte #1
   Uint8  BYTE0;                  // 0:7    Byte #0
};

struct PMBST_HALFS {              // bits   description
   Uint16 HALF1;                  // 31:16  Half #1
   Uint16 HALF0;                  // 15:0   Half #0
};

// Allow access to the bit fields or entire register
union PMBST_REG {
   Uint32                 all;
   struct PMBST_BITS      bit;
   struct PMBST_BYTES     byte;
   struct PMBST_HALFS     half;
};

  //-----------------------------------------------------------------------------
  // PMBus Interrupt Mask Register bit definitions
  //-----------------------------------------------------------------------------
  struct PMBINTM_BITS {             // bits   description
    Uint32 rsvd0:22;                // 31:10  reserved
    Uint32 CLK_HIGH_DETECT:1;       // 9      Clock High Detection Interrupt mask
    Uint32 LOST_ARB:1;              // 8      Lost arbitration interrupt mask
    Uint32 CONTROL:1;               // 7      Remote module control asserted interrupt mask
    Uint32 ALERT:1;                 // 6      Alert signal detected interrupt mask
    Uint32 EOM:1;                   // 5      End of message interrupt mask
    Uint32 SLAVE_ADDR_READY:1;      // 4      Slave address ready interrupt mask
    Uint32 DATA_REQUEST:1;          // 3      Data request interrupt mask
    Uint32 DATA_READY:1;            // 2      Data ready interrupt mask
    Uint32 BUS_LOW_TIMEOUT:1;       // 1      Bus low timeout interrupt mask
    Uint32 BUS_FREE:1;              // 0      Bus free interrupt mask
  };
  union PMBINTM_REG {
    Uint32                  all;
    struct PMBINTM_BITS     bit;
  };

  //-----------------------------------------------------------------------------
  // PMBus Control Register 2 bit definitions
  //-----------------------------------------------------------------------------
  struct PMBCTRL2_BITS {           // bits   description
    Uint32 rsvd0:9;                // 31:23  reserved
    Uint32 RX_BYTE_ACK_CNT:2;      // 22:21  Num bytes to auto acknowledge in slave mode.
    Uint32 MAN_CMD:1;              // 20     Manual command acknowledge mode
    Uint32 TX_PEC:1;               // 19     Transmited PEC flag
    Uint32 TX_COUNT:3;             // 18:16  Transmit byte count
    Uint32 PEC_ENA:1;              // 15     Enable PEC processing
    Uint32 SLAVE_MASK:7;           // 14:8   Slave mask
    Uint32 MAN_SLAVE_ACK:1;        // 7      Manual slave acknowledge mode enable
    Uint32 SLAVE_ADDR:7;           // 6:0    Slave address
  };
  struct PMBCTRL2_BYTES {           // bits   description
   Uint8  rsvd3;                  // 31:24  reserved
   Uint8  BYTE2;                  // 16:23  Byte #2
   Uint8  BYTE1;                  // 8:15   Byte #1
   Uint8  BYTE0;                  // 0:7    Byte #0
};

struct PMBCTRL2_HALFS {           // bits   description
   Uint16 HALF1;                  // 31:16  Half #1
   Uint16 HALF0;                  // 15:0   Half #0
};

// Allow access to the bit fields or entire register
union PMBCTRL2_REG {
   Uint32                   all;
   struct PMBCTRL2_BITS     bit;
   struct PMBCTRL2_BYTES    byte;
   struct PMBCTRL2_HALFS    half;
};
  
  //-----------------------------------------------------------------------------
  // PMBus Hold Slave Address Register bit definitions
  //-----------------------------------------------------------------------------
  struct PMBHSA_BITS {             // bits   description
    Uint32 rsvd0:24;               // 31:8   reserved
    Uint32 SLAVE_ADDR:7;           // 7:1    Stored address acknowledged by slave
    Uint32 SLAVE_RW:1;             // 0      Stored R/W bit from slave acknowledge
  };
  union PMBHSA_REG {
    Uint32                 all;
    struct PMBHSA_BITS     bit;
  };
  
  //-----------------------------------------------------------------------------
  // PMBus Miscellaneous Control Register bit definitions
  //-----------------------------------------------------------------------------
  struct PMBCTRL3_BITS {           // bits   description
    Uint32 rsvd0:9;                // 31:23  reserved
    Uint32 MASTER_EN:1;            // 22     Master Mode Enable
    Uint32 SLAVE_EN:1;             // 21     Slave Mode Enable
    Uint32 CLK_LO_DIS:1;           // 20     Clock Low Timeout Disable
    Uint32 IBIAS_B_EN:1;           // 19     IBias B enable
    Uint32 IBIAS_A_EN:1;           // 18     IBias A enable
    Uint32 SCL_DIR:1;              // 17     Clock Pin GPIO Direction
    Uint32 SCL_VALUE:1;            // 16     Clock Pin GPIO Value
    Uint32 SCL_MODE:1;             // 15     Clock Pin GPIO Mode
    Uint32 SDA_DIR:1;              // 14     Clock Pin GPIO Direction
    Uint32 SDA_VALUE:1;            // 13     Clock Pin GPIO Value
    Uint32 SDA_MODE:1;             // 12     Clock Pin GPIO Mode
    Uint32 CNTL_DIR:1;             // 11     Direction of control pins in GPIO mode
    Uint32 CNTL_VALUE:1;           // 10     Output value of control pins in GPIO mode
    Uint32 CNTL_MODE:1;            // 9      Configures mode of control pins
    Uint32 ALERT_DIR:1;            // 8      Alert Pin GPIO Direction
    Uint32 ALERT_VALUE:1;          // 7      Value of Alert pin in GPIO mode
    Uint32 ALERT_MODE:1;           // 6      Configures mode of Alert pin
    Uint32 CNTL_INT_EDGE:1;        // 5      Control interrupt edge select
    Uint32 FAST_MODE_PLUS:1;       // 4      Fast mode plus enable
    Uint32 FAST_MODE:1;            // 3      Fast mode enable
    Uint32 BUS_LO_INT_EDGE:1;      // 2      Bus low timeout interrupt edge select
    Uint32 ALERT_EN:1;             // 1      Alert enable
    Uint32 RESET:1;                // 0      PMBus Master reset
  };
  union PMBCTRL3_REG {
    Uint32                 all;
    struct PMBCTRL3_BITS   bit;
  };
  
  //=============================================================================
  // PMBus Interface Register File
  //=============================================================================
  struct PMBUS_REGS {
    union  PMBCTRL1_REG   PMBCTRL1;    // PMBus Control Register 1
    union  PMBTXBUF_REG   PMBTXBUF;    // PMBus Transmit Data Buffer
    union  PMBRXBUF_REG   PMBRXBUF;    // PMBus Receive Data Buffer
    union  PMBACK_REG     PMBACK;      // PMBus Acknowledge Register
    union  PMBST_REG      PMBST;       // PMBus Status Register
    union  PMBINTM_REG    PMBINTM;     // PMBus Interrupt Mask Register
    union  PMBCTRL2_REG   PMBCTRL2;    // PMBus Control Register 2
    union  PMBHSA_REG     PMBHSA;      // PMBus Hold Slave Address Register
    union  PMBCTRL3_REG   PMBCTRL3;    // PMBus Control Register 3
  };
  
  //---------------------------------------------------------------------------
  // PMBus Interface External References & Function Declarations:
  //
  extern volatile struct PMBUS_REGS PMBusRegs;
  
  //===========================================================================


//===========================================================================
// End of file
//===========================================================================
//###########################################################################
//
// FILE:   cyclone_sys.h
//
// TITLE:  Cyclone System Module Register Definitions.
//
// NOTES:
//  1) Bitfields have been defined for big-endian only.
//###########################################################################
//
//  Ver  | dd mmm yyyy | Who  | Description of changes
// ======|=============|======|==============================================
//  1.00 | 12 Aug 2009 | CMF  | Started with Spartan_Sys.h.
//       |             |      | Updated for 1.0 Memory map document.
//       |             |      |
//
//  Texas Instruments, Inc
//  Copyright Texas Instruments 2008. All rights reserved.
//###########################################################################



//===========================================================================
// System Module Individual Register Bit Definitions
//

//-------------------------------------------------
// Clock Control Register bit definitions
//
struct CLKCNTL_BITS {            // bits   description
  Uint32 rsvd3:22;               // 31:10  reserved
  Uint32 M_DIV_RATIO:2;          // 9:8    MCLK (processor clock) divide ratio
  Uint32 rsvd2:1;                // 7      reserved
  Uint32 CLKSR:2;                // 6:5    CLKOUT pin source
  Uint32 rsvd1:1;                // 4      reserved
  Uint32 CLKDOUT:1;              // 3      CLKOUT pin output data
  Uint32 rsvd0:1;                // 2      Reserved
  Uint32 ARM_MODE:2;             // 1:0    ARM Mode
};
union CLKCNTL_REG {
   Uint32                 all;
   struct CLKCNTL_BITS    bit;
};

//-------------------------------------------------
// System Exception Control Register bit definitions
//
struct SYSECR_BITS {              // bits   description
   Uint32 rsvd1:16;               // 31:16  reserved
   Uint32 RESET:2;                // 15:14  Software reset
   Uint32 rsvd0:11;               // 13:3   reserved
   Uint32 PACCOVR:1;              // 2      Peripheral access violation override
   Uint32 ACCOVR:1;               // 1      Memory access reset override
   Uint32 ILLOVR:1;               // 0      Illegal address reset override
};
union SYSECR_REG {
   Uint32                 all;
   struct SYSECR_BITS     bit;
};

//-------------------------------------------------
// System Exception Status Register bit definitions
//
struct SYSESR_BITS {              // bits   description
   Uint32 rsvd1:16;               // 31:16  reserved
   Uint32 PORRST:1;               // 15     Power-up reset flag
   Uint32 CLKRST:1;               // 14     Clock fail flag
   Uint32 WDRST:1;                // 13     Watchdog reset flag
   Uint32 ILLMODE:1;              // 12     Illegal mode flag
   Uint32 ILLADR:1;               // 11     Illegal address access flag 
   Uint32 ILLACC:1;               // 10     Illegal memory access flag
   Uint32 PILLACC:1;              // 9      Peripheral illegal access flag
   Uint32 ILLMAP:1;               // 8      Illegal address map flag
   Uint32 SWRST:1;                // 7      Software reset flag
   Uint32 rsvd0:7;                // 6:0    reserved
};
union SYSESR_REG {
   Uint32                 all;
   struct SYSESR_BITS     bit;
};

//-------------------------------------------------
// Abort Exception Status Register bit definitions
//
struct ABRTESR_BITS {             // bits   description
   Uint32 rsvd1:16;               // 31:16  reserved
   Uint32 ADRABT:1;               // 15     Illegal address abort
   Uint32 MEMABT:1;               // 14     Memory access abort
   Uint32 PACCVIO:1;              // 13     Peripheral access violation error
   Uint32 rsvd0:13;               // 12:0   reserved      
};
union ABRTESR_REG {
   Uint32                 all;
   struct ABRTESR_BITS    bit;
};

//-------------------------------------------------
// Global Status Register bit definitions
//
struct GLBSTAT_BITS {             // bits   description
   Uint32 rsvd1:24;               // 31:8   reserved
   Uint32 SYSADDR:1;              // 7      System illegal address flag
   Uint32 SYSACC:1;               // 6      System illegal access flag
   Uint32 MPUADDR:1;              // 5      MPU illegal address flag
   Uint32 MPUACC:1;               // 4      MPU illegal access flag
   Uint32 rsvd0:4;                // 3:0    reserved
};
union GLBSTAT_REG {
   Uint32                 all;
   struct GLBSTAT_BITS    bit;
};

//-------------------------------------------------
// Device Identification Register bit definitions
//
struct DEV_BITS {                 // bits   description
   Uint32 rsvd0:16;               // 31:16  reserved
   Uint32 DEV:16;                 // 15:0   Device identification code
};
union DEV_REG {
   Uint32                 all;
   struct DEV_BITS        bit;
};

//-------------------------------------------------
// System Software Interrupt Flag Register bit definitions
//
struct SSIF_BITS {                // bits   description
   Uint32 rsvd0:31;               // 31:1   reserved
   Uint32 SSIFLAG:1;              // 0      System software interrupt flag
};
union SSIF_REG {
   Uint32                 all;
   struct SSIF_BITS       bit;
};

//-------------------------------------------------
// System Software Interrupt Request Register bit definitions
//
struct SSIR_BITS {                // bits   description
   Uint32 rsvd0:16;               // 31:16  reserved
   Uint32 SSKEY:8;                // 15:8   System software interrupt request key
   Uint32 SSDATA:8;               // 7:0    System software interrupt data
};
union SSIR_REG {
   Uint32                 all;
   struct SSIR_BITS       bit;
};


//===========================================================================
// System Module Register File
//
struct SYS_REGS {
   union  CLKCNTL_REG    CLKCNTL;       // Clock Control Register
   Uint32                RSVD[3];       // Reserved (address spacer)
   union  SYSECR_REG     SYSECR;        // System Exception Control Register
   union  SYSESR_REG     SYSESR;        // System Exception Status Register
   union  ABRTESR_REG    ABRTESR;       // Abort Exception Status Register
   union  GLBSTAT_REG    GLBSTAT;       // Global Status Register
   union  DEV_REG        DEV;           // Device Identification Register
   Uint32                RSVD1[1];      // Reserved (address spacer)
   union  SSIF_REG       SSIF;          // System Software Interrupt Flag Register
   union  SSIR_REG       SSIR;          // System Software Interrupt Request Register
};

//---------------------------------------------------------------------------
// System Module External References & Function Declarations:
//
extern volatile struct SYS_REGS SysRegs;

//===========================================================================


//===========================================================================
// End of file
//===========================================================================
//###############################################################################
//
// FILE:   cyclone_timer.h
//
// TITLE:  Cyclone Timer Module Register Definitions.
//
// NOTES:
//  1) Bitfields have been defined for big-endian only.
//###############################################################################
//
//  Ver  | dd mmm yyyy | Who  | Description of changes
// ======|=============|======|==============================================
//  1.00 | 19 Aug 2009 | CMF  | Started with Spartan_Timer.h.
//       |             |      | Updated for 1.0 Memory map document.
//       |             |      |
//
//  Texas Instruments, Inc
//  Copyright Texas Instruments 2009. All rights reserved.
//###############################################################################



  //=============================================================================
  // TIMER Individual Register Bit Definitions
  //=============================================================================

  //-----------------------------------------------------------------------------
  // T24 Counter Data Register bit definitions
  //-----------------------------------------------------------------------------
  struct T24CNTDAT_BITS {          // bits   description
    Uint32 rsvd0:8;                // 31:24  reserved
    Uint32 CNT_DAT:24;             // 23:0   Counter data
  };
  union T24CNTDAT_REG {
    Uint32                 all;
    struct T24CNTDAT_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // T24 Counter Control/Status Register bit definitions
  //-----------------------------------------------------------------------------
  struct T24CNTCTRL_BITS {         // bits   description
    Uint32 rsvd1:16;               // 31:16  reserved
    Uint32 PRESCALE:8;             // 15:8   Prescale value
    Uint32 rsvd0:5;                // 7:3    reserved
    Uint32 EXT_CLK_SEL:1;          // 2      External clock select
    Uint32 OV_INT_ENA:1;           // 1      Overflow interrupt enable
    Uint32 OV_FLAG:1;              // 0      Overflow event flag
  };
  union T24CNTCTRL_REG {
    Uint32                   all;
    struct T24CNTCTRL_BITS   bit;
  };

  //-----------------------------------------------------------------------------
  // T24 Capture Data Register bit definitions
  //-----------------------------------------------------------------------------
  struct T24CAPDAT_BITS {          // bits   description
    Uint32 rsvd0:8;                // 31:24  reserved
    Uint32 CAP_DAT:24;             // 23:0   Counter data
  };
  union T24CAPDAT_REG {
    Uint32                  all;
    struct T24CAPDAT_BITS   bit;
  };

  //-----------------------------------------------------------------------------
  // T24 Capture Control Register bit definitions
  //-----------------------------------------------------------------------------
  struct T24CAPCTRL_BITS {         // bits   description
    Uint32 rsvd0:26;               // 31:6   reserved
    Uint32 CAP_SEL:2;              // 4:3    Capture Pin Select
    Uint32 EDGE:2;                 // 3:2    Edge select
    Uint32 CAP_INT_ENA:1;          // 1      Capture interrupt enable
    Uint32 CAP_INT_FLAG:1;         // 0      Capture event flag
  };
  union T24CAPCTRL_REG {
    Uint32                   all;
    struct T24CAPCTRL_BITS   bit;
  };
  
  //-----------------------------------------------------------------------------
  // T24 I/O Control and Data Register bit definitions
  //-----------------------------------------------------------------------------
  struct T24CAPIO_BITS {           // bits   description
    Uint32 rsvd0:29;               // 31:3   reserved      
    Uint32 TCAP_IN:1;              // 2      TCAP0 pin input data
    Uint32 TCAP_OUT:1;             // 1      TCAP0 pin output data
    Uint32 TCAP_DIR:1;             // 0      TCAP0 pin direction
  };
  union T24CAPIO_REG {
    Uint32                 all;
    struct T24CAPIO_BITS   bit;
  };

  //-----------------------------------------------------------------------------
  // T24 Compare Data Register bit definitions
  //-----------------------------------------------------------------------------
  struct T24CMPDAT_BITS {          // bits   description
    Uint32 rsvd0:8;                // 31:24  reserved
    Uint32 CMP_DAT:24;             // 23:0   Compare data
  };
  union T24CMPDAT_REG {
    Uint32                  all;
    struct T24CMPDAT_BITS   bit;
  };

  //-----------------------------------------------------------------------------
  // T24 Compare Control Register bit definitions
  //-----------------------------------------------------------------------------
  struct T24CMPCTRL_BITS {         // bits   description
    Uint32 rsvd0:30;               // 31:2   reserved
    Uint32 CMP_INT_ENA:1;          // 1      Compare interrupt enable
    Uint32 CMP_INT_FLAG:1;         // 0      Compare event flag
  };
  union T24CMPCTRL_REG {
    Uint32                   all;
    struct T24CMPCTRL_BITS   bit;
  };

  //-----------------------------------------------------------------------------
  // PWMx Counter Data Register bit definitions
  //-----------------------------------------------------------------------------
  struct T16PWMXCNTDAT_BITS {      // bits   description
    Uint32 rsvd0:16;               // 31:16  reserved
    Uint32 CNT_DAT:16;             // 15:0   Counter data
  };
  union T16PWMXCNTDAT_REG {
    Uint32                     all;
    struct T16PWMXCNTDAT_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // PWMx Counter Control Register bit definitions
  //-----------------------------------------------------------------------------
  struct T16PWMXCNTCTRL_BITS {     // bits   description
    Uint32 rsvd1:16;               // 31:16  reserved
    Uint32 PRESCALE:8;             // 15:8   Prescale value
    Uint32 rsvd0:1;                // 7      Reserved
    Uint32 SYNC_SEL:2;             // 6:5    Counter Sync Select
    Uint32 SYNC_EN:1;              // 4      Counter Sync Enable
    Uint32 SW_RESET:1;             // 3      Software reset
    Uint32 CMP_RESET_ENA:1;        // 2      Counter reset from compare action enable
    Uint32 OV_INT_ENA:1;           // 1      Overflow interrupt enable
    Uint32 OV_INT_FLAG:1;          // 0      Overflow interrupt flag
  };
  union T16PWMXCNTCTRL_REG {
    Uint32                       all;
    struct T16PWMXCNTCTRL_BITS   bit;
  };

  //-----------------------------------------------------------------------------
  // PWMx Compare y Data Register bit definitions
  //-----------------------------------------------------------------------------
  struct T16PWMXCMPYDAT_BITS {     // bits   description
    Uint32 rsvd0:16;               // 31:16  reserved
    Uint32 CMP_DAT:16;             // 15:0   Compare data
  };
  union T16PWMXCMPYDAT_REG {
    Uint32                      all;
    struct T16PWMXCMPYDAT_BITS  bit;
  };
  
  //-----------------------------------------------------------------------------
  // PWM0 Compare Control Register bit definitions
  //-----------------------------------------------------------------------------
  struct T16PWM0CMPCTRL_BITS {     // bits   description
    Uint32 rsvd0:19;               // 31:13  reserved
    Uint32 SHADOW:1;               // 12     PWM update control
    Uint32 PWM_IN:1;               // 11     TPWMx pin state
    Uint32 PWM_OUT:1;              // 10     TPWMx pin output data
    Uint32 PWM_OUT_ENA:1;          // 9      TPWMx pin output enable
    Uint32 PWM_OUT_DRV:1;          // 8      TPMWx pin output control
    Uint32 PWM_OUT_ACTION1:2;      // 7:6    TPWMx pin output action on T16CMP1DR match
    Uint32 PWM_OUT_ACTION0:2;      // 5:4    TPWMx pin output action on T16CMP0DR match
    Uint32 CMP1_INT_ENA:1;         // 3      Compare 1 interrupt enable
    Uint32 CMP1_INT_FLAG:1;        // 2      Compare 1 interrupt flag
    Uint32 CMP0_INT_ENA:1;         // 1      Compare 0 interrupt enable
    Uint32 CMP0_INT_FLAG:1;        // 0      Compare 0 interrupt flag
  };
  union T16PWM0CMPCTRL_REG {
    Uint32                       all;
    struct T16PWM0CMPCTRL_BITS   bit;
  };
  
  //-----------------------------------------------------------------------------
  // PWMx Compare Control Register bit definitions
  //-----------------------------------------------------------------------------
  struct T16PWMXCMPCTRL_BITS {     // bits   description
    Uint32 rsvd1:19;               // 31:13  reserved
    Uint32 SHADOW:1;               // 12     PWM update control
    Uint32 PWM_IN:1;               // 11     TPWMx pin state
    Uint32 PWM_OUT:1;              // 10     TPWMx pin output data
    Uint32 PWM_OUT_ENA:1;          // 9      TPWMx pin output enable
    Uint32 PWM_OUT_DRV:1;          // 8      TPMWx pin output control
    Uint32 PWM_OUT_ACTION1:2;      // 7:6    TPWMx pin output action on T16CMP1DR match
    Uint32 PWM_OUT_ACTION0:2;      // 5:4    TPWMx pin output action on T16CMP0DR match
    Uint32 CMP1_INT_ENA:1;         // 3      Compare 1 interrupt enable
    Uint32 CMP1_INT_FLAG:1;        // 2      Compare 1 interrupt flag
    Uint32 CMP0_INT_ENA:1;         // 1      Compare 0 interrupt enable
    Uint32 CMP0_INT_FLAG:1;        // 0      Compare 0 interrupt flag
  };
  union T16PWMXCMPCTRL_REG {
    Uint32                       all;
    struct T16PWMXCMPCTRL_BITS   bit;
  };
  
  //-----------------------------------------------------------------------------
  // Watchdog Status Register bit definitions
  //-----------------------------------------------------------------------------
  struct WDST_BITS {              // bits   description
    Uint32 rsvd0:28;              // 31:4   reserved
    Uint32 WAKE_EV_RAW:1;         // 3      Watchdog Wake Event Raw Status
    Uint32 WD_EV_RAW:1;           // 2      Watchdog Event Raw Status
    Uint32 WAKE_EV_INT:1;         // 1      Watchdog Wake Event Interrupt Status
    Uint32 WD_EV_INT:1;          // 0      Watchdog Event Interrupt Status
  };
  union WDST_REG {
    Uint32                 all;
    struct WDST_BITS       bit;
  };

  //-----------------------------------------------------------------------------
  // Watchdog Control Register bit definitions
  //-----------------------------------------------------------------------------
  struct WDCTRL_BITS {              // bits   description
    Uint32 rsvd1:17;               // 31:15  reserved
    Uint32 WD_PERIOD:7;               // 14:8   WD period
    Uint32 rsvd0:1;                // 7      reserved
    Uint32 PROTECT:1;              // 6      Watchdog protect bit - active low.
    Uint32 CPU_RESET_EN:1;         // 5      WD reset of CPU enable
    Uint32 WDRST_INT_EN:1;         // 4      WD reset event interrupt enable
    Uint32 WKEV_INT_EN:1;          // 3      WD wake event interrupt enable
    Uint32 WKEV_EN:1;              // 2      WD wake event enable
    Uint32 WDRST_EN:1;             // 1      WD reset event enable
    Uint32 CNT_RESET:1;            // 0      WD reset
  };
  union WDCTRL_REG {
    Uint32                 all;
    struct WDCTRL_BITS     bit;
  };

  //=============================================================================
  // Timer Module Register File
  //=============================================================================
  struct TIMER_REGS {
    union  T24CNTDAT_REG       T24CNTDAT;        // T24 Counter Data Register
    union  T24CNTCTRL_REG      T24CNTCTRL;       // T24 Counter Control/Status Register
    union  T24CAPDAT_REG       T24CAPDAT;        // T24 Capture Data Register
    Uint32                     RSVD[2];          // Reserved (address spacer)
    union  T24CAPCTRL_REG      T24CAPCTRL;       // T24 Capture Control Register
    Uint32                     RSVD1[2];         // Reserved (address spacer)
    union  T24CAPIO_REG        T24CAPIO;         // T24 I/O Control and Data Register
    union  T24CMPDAT_REG       T24CMPDAT0;       // T24 Compare Data Register
    union  T24CMPDAT_REG       T24CMPDAT1;       // T24 Compare Data Register
    union  T24CMPCTRL_REG      T24CMPCTRL0;      // T24 Compare Control Register
    union  T24CMPCTRL_REG      T24CMPCTRL1;      // T24 Compare Control Register
    union  T16PWMXCNTDAT_REG   T16PWM0CNTDAT;    // PWM0 Counter Data Register
    union  T16PWMXCNTCTRL_REG  T16PWM0CNTCTRL;   // PWM0 Counter Control Register
    union  T16PWMXCMPYDAT_REG  T16PWM0CMP0DAT;   // PWM0 Compare Channel 0 Data Register
    union  T16PWMXCMPYDAT_REG  T16PWM0CMP1DAT;   // PWM0 Compare Channel 1 Data Register
    union  T16PWM0CMPCTRL_REG  T16PWM0CMPCTRL;   // PWM0 Compare Control Register
    Uint32                     RSVD4[4];         // Reserved (address spacer)
    union  T16PWMXCNTDAT_REG   T16PWM1CNTDAT;    // PWM1 Counter Data Register
    union  T16PWMXCNTCTRL_REG  T16PWM1CNTCTRL;   // PWM1 Counter Control Register
    union  T16PWMXCMPYDAT_REG  T16PWM1CMP0DAT;   // PWM1 Compare Channel 0 Data Register
    union  T16PWMXCMPYDAT_REG  T16PWM1CMP1DAT;   // PWM1 Compare Channel 1 Data Register
    union  T16PWMXCMPCTRL_REG  T16PWM1CMPCTRL;   // PWM1 Compare Control Register
    union  T16PWMXCNTDAT_REG   T16PWM2CNTDAT;    // PWM2 Counter Data Register
    union  T16PWMXCNTCTRL_REG  T16PWM2CNTCTRL;   // PWM2 Counter Control Register
    union  T16PWMXCMPYDAT_REG  T16PWM2CMP0DAT;   // PWM2 Compare Channel 0 Data Register
    union  T16PWMXCMPYDAT_REG  T16PWM2CMP1DAT;   // PWM2 Compare Channel 1 Data Register
    union  T16PWMXCMPCTRL_REG  T16PWM2CMPCTRL;   // PWM2 Compare Control Register
    union  T16PWMXCNTDAT_REG   T16PWM3CNTDAT;    // PWM3 Counter Data Register
    union  T16PWMXCNTCTRL_REG  T16PWM3CNTCTRL;   // PWM3 Counter Control Register
    union  T16PWMXCMPYDAT_REG  T16PWM3CMP0DAT;   // PWM3 Compare Channel 0 Data Register
    union  T16PWMXCMPYDAT_REG  T16PWM3CMP1DAT;   // PWM3 Compare Channel 1 Data Register
    union  T16PWMXCMPCTRL_REG  T16PWM3CMPCTRL;   // PWM3 Compare Control Register
    union  WDST_REG            WDST;             // Watchdog Status Register
    union  WDCTRL_REG          WDCTRL;           // Watchdog Control Register
  };


  //-----------------------------------------------------------------------------
  // Timer Module External References & Function Declarations:
  //-----------------------------------------------------------------------------
  extern volatile struct TIMER_REGS TimerRegs;

  //===========================================================================


//===========================================================================
// End of file
//===========================================================================
//###############################################################################
//
// FILE:   cyclone_uart.h
//
// TITLE:  Cyclone Uart Register Definitions.
//
// NOTES:
//  1) Bitfields have been defined for big-endian only.
//###############################################################################
//
//  Ver  | dd mmm yyyy | Who  | Description of changes
// ======|=============|======|==============================================
//  1.00 | 19 Aug 2009 | CMF  | Started with Spartan_Uart.h.
//       |             |      | Updated for 1.0 Memory map document.
//       |             |      |
//
//  Texas Instruments, Inc
//  Copyright Texas Instruments 2009. All rights reserved.
//###############################################################################



  //=============================================================================
  // UART Individual Register Bit Definitions
  //=============================================================================

  //-----------------------------------------------------------------------------
  // UART Control Register 0 bit definitions
  //-----------------------------------------------------------------------------
  struct UARTCTRL0_BITS {          // bits   description
    Uint32 rsvd0:24;               // 31:8   reserved  
    Uint32 STOP:1;                 // 7      Prescaler for clock
    Uint32 PARITY:1;               // 6      Parity selection
    Uint32 PARITY_ENA:1;           // 5      Parity enable
    Uint32 SYNC_MODE:1;            // 4      Sync mode selection
    Uint32 ADDR_MODE:1;            // 3      Address mode selection
    Uint32 DATA_SIZE:3;            // 2:0    TX and RX data size
  };
  union UARTCTRL0_REG {
    Uint32                 all;
    struct UARTCTRL0_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // UART Receive Status Register bit definitions
  //-----------------------------------------------------------------------------
  struct UARTRXST_BITS {           // bits   description
    Uint32 rsvd0:27;               // 31:5   reserved
    Uint32 RX_IDLE:1;              // 4      RX idle status 
    Uint32 SLEEP:1;                // 3      Sleep
    Uint32 RX_RDY:1;               // 2      RX ready status
    Uint32 RX_WAKE:1;              // 1      RX wake status
    Uint32 RX_ENA:1;               // 0      RX enable
  };
  union UARTRXST_REG {
    Uint32                 all;
    struct UARTRXST_BITS   bit;
  };

  //-----------------------------------------------------------------------------
  // UART Transmit Status Register bit definitions
  //-----------------------------------------------------------------------------
  struct UARTTXST_BITS {           // bits   description
    Uint32 rsvd1:24;               // 31:8   reserved
    Uint32 CONTINUE:1;             // 7      Continue
    Uint32 LOOPBACK:1;             // 6      Loopback enable
    Uint32 rsvd0:2;                // 5:4    reserved
    Uint32 TX_EMPTY:1;             // 3      TX empty
    Uint32 TX_RDY:1;               // 2      TX ready status
    Uint32 TX_WAKE:1;              // 1      TX wake status
    Uint32 TX_ENA:1;               // 0      TX enable
  };
  union UARTTXST_REG {
    Uint32                 all;
    struct UARTTXST_BITS   bit;
  };

  //-----------------------------------------------------------------------------
  // UART Control Register 3 bit definitions
  //-----------------------------------------------------------------------------
  struct UARTCTRL3_BITS {          // bits   description
    Uint32 rsvd0:24;               // 31:8   reserved
    Uint32 SW_RESET:1;             // 7      Software reset
    Uint32 POWERDOWN:1;            // 6      Power down
    Uint32 CLOCK:1;                // 5      Clock select
    Uint32 RX_INT_ENA:1;           // 4      RX interrupt enable
    Uint32 TX_INT_ENA:1;           // 3      TX interrupt enable
    Uint32 WAKEUP_INT_ENA:1;       // 2      Wakeup interrupt enable
    Uint32 BRKDT_INT_ENA:1;        // 1      Break detect interrupt enable
    Uint32 ERR_INT_ENA:1;          // 0      RX error interrupt enable
  };
  union UARTCTRL3_REG {
    Uint32                 all;
    struct UARTCTRL3_BITS  bit;
  }; 

  //-----------------------------------------------------------------------------
  // UART Interrupt Status Register bit definitions
  //-----------------------------------------------------------------------------
  struct UARTINTST_BITS {          // bits   description
    Uint32 rsvd1:24;               // 31:8   reserved
    Uint32 BUS_BUSY:1;             // 7      RX bus busy flag
    Uint32 rsvd0:1;                // 6      reserved
    Uint32 FRAME_ERR:1;            // 5      RX framing error flag
    Uint32 OVERRUN_ERR:1;          // 4      RX overrun error flag
    Uint32 PARITY_ERR:1;           // 3      RX parity error flag
    Uint32 WAKEUP_INT:1;           // 2      Wakeup interrupt flag
    Uint32 BRKDT_INT:1;            // 1      Break detect interrupt flag
    Uint32 RX_ERR:1;               // 0      RX error flag
  };
  union UARTINTST_REG {
    Uint32                 all;
    struct UARTINTST_BITS  bit;
  }; 

  //-----------------------------------------------------------------------------
  // UART Baud Divisor High Byte Register bit definitions
  //-----------------------------------------------------------------------------
  struct UARTHBAUD_BITS {          // bits   description
    Uint32 rsvd0:24;               // 31:8   reserved
    Uint32 BAUD_DIV_H:8;           // 7:0    High byte of baud divisor
  };
  union UARTHBAUD_REG {
    Uint32                 all;
    struct UARTHBAUD_BITS  bit;
  };
  
  //-----------------------------------------------------------------------------
  // UART Baud Divisor Middle Byte Register bit definitions
  //-----------------------------------------------------------------------------
  struct UARTMBAUD_BITS {          // bits   description
    Uint32 rsvd0:24;               // 31:8   reserved
    Uint32 BAUD_DIV_M:8;           // 7:0    Middle byte of baud divisor
  };
  union UARTMBAUD_REG {
    Uint32                 all;
    struct UARTMBAUD_BITS  bit;
  };
  
  //-----------------------------------------------------------------------------
  // UART Baud Divisor Low Byte Register bit definitions
  //-----------------------------------------------------------------------------
  struct UARTLBAUD_BITS {          // bits   description
    Uint32 rsvd0:24;               // 31:8   reserved
    Uint32 BAUD_DIV_L:8;           // 7:0    Low byte of baud divisor
  };
  union UARTLBAUD_REG {
    Uint32                 all;
    struct UARTLBAUD_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // UART Receive Buffer bit definitions
  //-----------------------------------------------------------------------------
  struct UARTRXBUF_BITS {          // bits   description
    Uint32 rsvd0:24;               // 31:8   reserved
    Uint32 RXDAT:8;                // 7:0    Receive data
  };
  union UARTRXBUF_REG {
    Uint32                 all;
    struct UARTRXBUF_BITS  bit;
  };
  
  //-----------------------------------------------------------------------------
  // UART Transmit Buffer bit definitions
  //-----------------------------------------------------------------------------
  struct UARTTXBUF_BITS {          // bits   description
    Uint32 rsvd0:24;               // 31:8   reserved
    Uint32 TXDAT:8;                // 7:0    Transmit data
  };
  union UARTTXBUF_REG {
    Uint32                 all;
    struct UARTTXBUF_BITS  bit;
  };

  //-----------------------------------------------------------------------------
  // UART Pin Control Register 1 bit definitions
  //-----------------------------------------------------------------------------
  struct UARTIOCTRL_BITS {         // bits   description
    Uint32 rsvd0:28;               // 31:4   reserved
    Uint32 DATA_IN:1;              // 3      Input data from pin
    Uint32 DATA_OUT:1;             // 2      Output data to pin
    Uint32 IO_FUNC:1;              // 1      Pin function
    Uint32 IO_DIR:1;               // 0      Pin direction
  };
  union UARTIOCTRL_REG {
    Uint32                  all;
    struct UARTIOCTRL_BITS  bit;
  };
  
  //=============================================================================
  // UART Module Register File
  //=============================================================================
  struct  UART_REGS { 
    union  UARTCTRL0_REG  UARTCTRL0;       // UART Control Register 0
    union  UARTRXST_REG   UARTRXST;        // UART Receive Status Register
    union  UARTTXST_REG   UARTTXST;        // UART Transmit Status Register
    union  UARTCTRL3_REG  UARTCTRL3;       // UART Control Register 3
    union  UARTINTST_REG  UARTINTST;       // UART Interrupt Status Register
    union  UARTHBAUD_REG  UARTHBAUD;       // UART Baud Divisor High Byte Register
    union  UARTMBAUD_REG  UARTMBAUD;       // UART Baud Divisor Middle Byte Register
    union  UARTLBAUD_REG  UARTLBAUD;       // UART Baud Divisor Low Byte Register
    Uint32                RSVD[1];         // Reserved (address spacer)
    union  UARTRXBUF_REG  UARTRXBUF;       // UART Receive Buffer
    union  UARTTXBUF_REG  UARTTXBUF;       // UART Transmit Buffer
    union  UARTIOCTRL_REG UARTIOCTRLSCLK;  // UART SCLK Pin Control Register
    union  UARTIOCTRL_REG UARTIOCTRLRX;    // UART RX Pin Control Register
    union  UARTIOCTRL_REG UARTIOCTRLTX;    // UART TX Pin Control Register
  };
  
  
  //-----------------------------------------------------------------------------
  // UART Module External References & Function Declarations:
  //-----------------------------------------------------------------------------
  extern volatile struct UART_REGS Uart0Regs;
  extern volatile struct UART_REGS Uart1Regs;
  
  //=============================================================================


//===========================================================================
// End of file
//===========================================================================

//===========================================================================



//===========================================================================
// End of file
//===========================================================================
//include.h


#pragma SWI_ALIAS (swi_single_entry, 0)
void swi_single_entry(Uint32 arg1, Uint32 arg2, Uint32 arg3, Uint8 swi_number);
//software_interrupts.h

void erase_data_flash_segment(Uint8 segment);


void erase_dflash_segment_no_delay(Uint8 segment);


void write_data_flash_word(Uint32 address,unsigned long data);


void enable_fast_interrupt(void);


void disable_fast_interrupt(void);


void enable_interrupt(void);


void disable_interrupt(void);


void write_firqpr(unsigned long value);


void write_reqmask(unsigned long value);


void clear_integrity_word(void);


void write_data_flash_block();


void set_tfa_mode(void);


void clear_tfa_mode(void);

//system_defines.h
//function enable
//#define VOLTAGE_LOOP_DISABLE (1)//for opened voltage loop, comment this out for closed voltage loop

// Memory allocation constants




//Vbus measurement defines



//Vac measurement defines




//feedforward gain
//ADC results assignment


//voltage loop defines


//UART related
void char_out_0(char data);
void char_out_1(char data);
void byte_out_1(char data);
void init_dpwm0(void);
void init_dpwm1(void);
void init_dpwm2(void);
void init_dpwm3(void);
void init_dpwms(void);
void init_fault_mux(void);
void init_Filter0(void);
void init_Filter1(void);
void init_Filter2(void);
void init_Filters(void);
void init_front_end0(void);
void init_front_end1(void);
void init_front_end2(void);
void init_front_ends(void);
void init_loop_mux(void);
void init_uart(void);
void init_watchdog(void);
void init_pmbus(void);
void pmbus_handler(void);
void pmbus_idle_handler(void);
void pmbus_read_block_handler(void);
void pmbus_write_block_handler(void);
void pmbus_read_wait_for_eom_handler(void);
void set_new_switching_frequency(void);
void process_uart_rx_data(void);
int pmbus_read_setup_id(void);
int pmbus_read_device_id(void);
Uint8 pmbus_read_cmd_dcdc_paged(void);
Uint8 pmbus_read_cmd_dcdc_nonpaged(void);
Uint8 pmbus_read_cmd_pfc(void);
Uint8 pmbus_write_store_default_all(void);
Uint8 pmbus_write_restore_default_all(void);
Uint32 calculate_dflash_checksum(Uint8 *start_addr, Uint8 *end_addr);
void copy_configuration_to_registers(volatile struct FILTER_REGS *dest);
void copy_configuration_to_ram(volatile struct FILTER_REGS *source);
Uint8 calc_flash_segments(const void* dest_ptr, Uint16 byte_count, Uint8* first_segment);
Uint32 calculate_dflash_checksum(Uint8 *start_addr, Uint8 *end_addr);
Uint8 start_erase_task(const void* dest_ptr, Uint16 byte_count);
Uint8 update_data_flash(void* dest_ptr, const void* src_ptr, Uint16 byte_count) ;
void erase_task(void);
void turn_off_pfc(void);
void byte_out_pri_sec_com(Uint8 byte);
unsigned usqr_simple(unsigned d, unsigned N);





//standard_interrupt.c
void poll_adc(void);
void turn_on_pfc(void);
void standard_interrupt(void);


//main.c
void handle_serial_in(char rx_byte);
void main();
void c_int00(void);


//init_miscellaneous.c
void init_adc_polled(void);
void init_timer_interrupt(void);
void init_miscellaneous(void);
void reinit_miscellaneous(void);

//uart.c
void init_uart0(void);
void init_uart1(void);
void nybble_out_0(char nybble);
void byte_out_0(char data);
void short_out_0(unsigned short data);
void word_out_0(unsigned int data);
void byte_out_space_0(char data);
void short_out_space_0(Uint16 data);
void word_out_space_0(Uint32 data);
void decimal_out_4_digits_0(int32 data);
void decimal_out_4_digits_tenths_0(int32 data);
void decimal_out_5_digits_0(int32 data);
void decimal_out_6_digits_0(int32 data);
void decimal_out_8_digits_0(int32 data);
void decimal_out_3_digits_0(int32 data);
void on_off_out_0(int value);
void nybble_out_1(char nybble);
void short_out_1(unsigned short data);
void word_out_1(unsigned int data);
void byte_out_space_1(char data);
void short_out_space_1(Uint16 data);
void word_out_space_1(Uint32 data);
void decimal_out_4_digits_1(int32 data);
void decimal_out_4_digits_tenths_1(int32 data);
void decimal_out_5_digits_1(int32 data);
void decimal_out_6_digits_1(int32 data);
void decimal_out_3_digits_1(int32 data);
void on_off_out_1(int value);
void string_out_0(char string[]);



//primary_secondary_communication.c
Uint8 translate_nybble_in(Uint8 nyb);
void translate_text_to_raw(void);
int32 u_to_s(Uint8 u);
void store_calibration_data(void);
void output_ram_calibration_data(void);
void flash_wait(void);
void write_calibration_data(void);
void expand_vac_calibration_data(void);
void expand_power_calibration_data(void);
void expand_calibration_data(void);
void get_calibration_from_flash(void);
void output_ram_calibration_values(void);
void running_calibration_message_test(void);
void test_calibration_message(void);
void output_primary_secondary_message(void);


//pmbus_coefficients.c
Uint8 pmbus_write_pi_coefficients(void);
Uint8 pmbus_read_pi_coefficients(void);


//pmbus.c
Uint8 pmbus_write_parm_info(void);
Uint8 pmbus_read_parm_info(void);
Uint8 pmbus_write_parm_value(void);
Uint8 send_string_memcpy(const char *string, Uint32 length);
Uint8 pmbus_read_parm_value(void);
void watchdog_reset(void);
int32 pmbus_write_rom_mode(void);
int32 pmbus_read_one_byte_handler(Uint8 value);
int32 pmbus_read_two_byte_handler(Uint16 value);
Uint8 pmbus_write_vout_cmd(void);
Uint8 pmbus_read_vout_cmd(void);
int32 pmbus_read_vout_handler(void);
int32 pmbus_read_iin(void);
int32 pmbus_read_pin(void);
Uint8 pmbus_write_vout_ov_fault_limit(void);
Uint8 pmbus_read_vout_ov_fault_limit(void);
int32 pmbus_mfr_id_handler(void);
int32 pmbus_mfr_model_handler(void);
int32 pmbus_mfr_revision_handler(void);
Uint8 pmbus_read_debug_buffer(void);
int pmbus_read_gui_constant(void);
Uint8 pmbus_write_gui_constant(void);
Uint8 pmbus_write_user_ram_00(void);
Uint8 pmbus_read_user_ram_00(void);
int32 sign_extend(int value, int number_of_bits);
int32 simple_translate();
Uint8 pmbus_write_frequency(void);
int32 pmbus_write_message(void);
int32 pmbus_read_message(void);


//interrupts.c
void undefined_instruction_exception(void);
void software_interrupt(Uint32 arg1, Uint32 arg2, Uint32 arg3, Uint8 swi_number);
void abort_prefetch_exception(void);
void abort_data_fetch_exception(void);
void fast_interrupt(void);


//init_filters.c
void init_filter0(void);
void init_filter1(void);
void init_filter2(void);
void init_filters(void);


//flash.c
void write_program_flash_word(int * address, int data);
void look_for_interrupted_dflash_erase(void);
Uint8 update_data_flash(void* dest_ptr, const void* src_ptr, Uint16 byte_count);
void erase_one_section(int first_segment, int byte_count);

void e_metering(void);
void input_power_calculation(void);
void input_current_calculation(void);
void input_voltage_calculation(void);
void input_power_measurement(void);


inline void float_to_L11(float input_val);
void match_baud(Uint32 bit_time);
void measure_baud(void);

void CMD_GEN_CAL_W_Handler(void);


//variables.h
//this file defines all global variables



//---Ernest,define constant value---
/*Iout*/
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
	Uint32 adc_raw[(4)];
	Uint32 adc_avg[(4)];
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

extern union STATUS_0 status_0;
extern union STATUS_1 status_1, status_1_hold;

extern struct INTERRUPT_VARIABLES iv;

extern int32 switching_frequency;

//stuff for UART communication
extern Uint8 uart_rx_buf[(6)];
extern Uint8 uart_text_in_buf[(6)];
extern Uint8 uart_rx_data_rdy; //flag, received a new data packet
extern Uint8 uart_rx_buf_ptr; //point to the buffer which will store the coming data
extern int32 uart_rx_timer; //count IRQ, used to count the UART receive idle period
extern int32 uart_tx_timeout; //used to count the timeout for message transmission
extern int32 uart_tx_checksum; //checksum for transmit
extern int32 primary_secondary_count;

//stuff for memory debugger
extern Uint8 parm_index;
extern int16 parm_offset;	
extern Uint8 parm_count;		
extern Uint8 parm_size;	

extern union{
	   			Uint8	byte[32];	// Byte at a time
		   		Uint32	word[8];	// Same data, a word at a time
			} copy_buffer;	

//stuff for PMBus communication
extern Uint8 pmbus_buffer[40];
extern Uint8 pmbus_state;
extern Uint8 pmbus_number_of_bytes;
extern Uint8 pmbus_buffer_position;
extern Uint16 pmbus_status_half_word_0_value; //save pmbus status, since cleared on read.
extern Uint16 pmbus_status_half_word_0_value_ored; //for debug

extern Uint8 ipm_or_zvs;
extern Uint8 zvs_flag;//turn on/off ZVS
extern Uint8 debug_buffer[8];

extern Uint8 erase_segment_counter;	// Number of DFlash segment remaining to be erased
extern Uint8 erase_segment_number;		// DFlash segment number being erased
extern Uint8 flash_write_status;	// Global status while attempting to write to Data Flash.



//stuff for IPM
extern Uint32 emi_capacitance;
extern Uint32 emi_resistance;
extern Uint32 emi_discharge_resistance;
extern Uint32 iin_rms;
//EXTERN Uint32 iemi_squared;
extern Uint32 pin;
extern Uint32 iin_slope;
extern Uint32 iin_slope_shift;
extern Uint32 iin_offset;
extern Uint32 iin_offset_shift;
extern Uint32 vin_rms;
extern Uint32 vin_slope;
extern Uint32 vin_slope_shift;
extern Uint32 vin_offset;
extern Uint32 vin_offset_shift;

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
extern union HK_P2S_FRAME bufferTX;
extern union HK_S2P_FRAME bufferRX;

extern unsigned char fw_revision[4];
extern Uint32 pfc_voltage;

extern Uint16 output_current;
extern Uint16 standby_output_current;
extern Uint16 vac_from_meter_ic;
extern Uint8 uart_rx_buf_err[(6)];


extern Uint16 PMBUS_L11_Vin;
extern Uint16 PMBUS_L11_Iin;
extern Uint16 PMBUS_L11_Pin;
extern int mantissa;
extern Uint16 uExponent;
extern Uint16 uMantissa;

extern Uint32 ac_frequency;
extern Uint32 rampup_target;
extern Uint32 rampdown_target;
extern Uint32 pri_temp1;
extern Uint32 ext_temp1;

extern Uint8 softstart_flag;
// UART Autobaud Rate Detection
extern Uint32 pulse_width;
extern Uint32 baud_div_value;
extern Uint8 T24SREG;
extern Uint8 edge;
extern Uint32 result;
extern Uint32 ac_recover_counter;
extern Uint32 xflag;
extern Uint32 vbus_ok;
extern Uint32 ac_input;
extern Uint32 dc_input;
extern Uint32 dc_ac_half_load_rampdown_voltage;
extern Uint32 dc_ac_half_load_vbus_good_off;
extern Uint32 vbus_mode;
extern Uint32 pre_vbus_mode;

extern Uint32 rampdown_notcomplete;
extern Uint32 rampup_notcomplete;

extern Uint32 brown_in_voltage;
extern Uint32 brown_out_voltage;
extern Uint32 vin_min_on_sq_avg;
extern Uint32 vin_min_off_sq_avg;
extern Uint32 vin_min_off;
struct MASS_DEBUG_STRUCTURE{//[Ken Zhang]add for mass variable debug
	Uint16 dataLog[500];
	Uint16 dataCnt;
	Uint8  dataLogSW;
	Uint16 freqDivTop;// default 10kHz
	Uint16 freqDivCount;
	Uint8 ptrSelectSW;//value 0:iv.pis.output;1:iv.i_target_average;2:iv.i_target_sensed;3:iv.cir_buff[iv.emi_pointer];4:iv.vff_multiplier;
};
extern struct MASS_DEBUG_STRUCTURE meDebug;

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

extern USER_DATA_PAGE UserData;
extern Uint32 standard_int_freq;
extern Uint32 e_meter_version;

//pmbus.h
//===========================================================================
// PMBus Module (PmbusReg) Constant Definitions
//
//system_defines.h
//function enable
//#define VOLTAGE_LOOP_DISABLE (1)//for opened voltage loop, comment this out for closed voltage loop

// Memory allocation constants




//Vbus measurement defines



//Vac measurement defines




//feedforward gain
//ADC results assignment


//voltage loop defines


//UART related












//=========================================================================================
// PMBus module definitions
//=========================================================================================
	// PMBST Register

// ***KKN***HEM	It would be nice to get rid of these _BYTE0_ and _HALF0_ values.  
// *** 			Requires change to _ALL_ in multiple places in pmbus.c.



	// PMBCTRL2 Register



//=========================================================================================



extern char	status_cml;	 // STATUS_CML (Communication, Logic, and Memory) for entire board


// These error codes are masks based on bits in the CML_STATUS byte.  This allows the
// pmbus_error_handler() function to do a simple 'OR' instead of a big 'switch' statement.






//#define program_flash_integrity_word *((volatile Uint32 *) 0x7ffc)

//	#define SETUP_ID        "VERSION1|PFC003" //FE0 + CLA0 + DPWM0




////////////////////////////////////////////////////////////////
//the commands that shows bit masking of which PMBUS commands 
//are supported
//CMD_DCDC_PAGED, CMD_DCDC_NONPAGED, CMD_PFC 
// 
//cmd-->lower nibble  
// #     0123 4567    89AB CDEF
//higher
//nibble
//0    0b0000 0000, 0b0000 0000, command codes from 0x00 to 0x0F
//1    0b0000 0000, 0b0000 0000, command codes from 0x10 to 0x1F
//2    0b0000 0000, 0b0000 0000, command codes from 0x20 to 0x2F
//3    0b0000 0000, 0b0000 0000, command codes from 0x30 to 0x3F
//4    0b0000 0000, 0b0000 0000, command codes from 0x40 to 0x4F
//5    0b0000 0000, 0b0000 0000, command codes from 0x50 to 0x5F
//6    0b0000 0000, 0b0000 0000, command codes from 0x60 to 0x6F
//7    0b0000 0000, 0b0000 0000, command codes from 0x70 to 0x7F
//8    0b0000 0000, 0b0000 0000, command codes from 0x80 to 0x8F
//9    0b0000 0000, 0b0000 0000, command codes from 0x90 to 0x9F
//A    0b0000 0000, 0b0000 0000, command codes from 0xA0 to 0xAF
//B    0b0000 0000, 0b0000 0000, command codes from 0xB0 to 0xBF
//C    0b0000 0000, 0b0000 0000, command codes from 0xC0 to 0xCF
//D    0b0000 0000, 0b0000 0000, command codes from 0xD0 to 0xDF
//E    0b0000 0000, 0b0000 0000, command codes from 0xE0 to 0xEF
//F    0b0000 0000, 0b0000 0000, command codes from 0xF0 to 0xFF
					
//specify the supported DCDC paged commands

//specify the supported PFC commands

//specify the supported PFC commands - necessary for GUI, even if we're only a PFC


extern Uint8 gui_constant_pointer;
extern Uint8 user_ram_00;


///////////////////////////////////////////////////////////////
//variables for PARM_INFO and PARM_VAR
///////////////////////////////////////////////////////////////
//  Memory limits used by the PARM_INFO and PARM_VALUE commands.

// Allow access to peripherals, but not core ARM regs.

// Allow read-only access to Data Flash

// Allow read-only access to Constants in Program Flash 

// Allow read-only access to Program in Program Flash 


 //Cyclone 2 extra addresses


















//PMBus Version 1.2 command number constants:

                                                                  // 0x07-0x0F Reserved
                                                                  // 0x1C - 0x1F Reserved
                                                                  // 0x2B - 0x2F Reserved
                                                                  // 0x34 Reserved
                                                                  // 0x4D � 0x4E Reserved
                                                                  //0x67 Reserved   Deleted in PMBus Ver 1.1
                                                                  //  0x6C - 0x77 Reserved
                                                                  // 0x83 - 0x85 Reserved
                                                                  // 0xAF Reserved                                                                                               
                                                                  // 0xC3-0xCF Reserved                                                                                       
//pmbus_coefficients.h

struct PFC_SETPOINT_STRUCT	//for PFC configuration
{
	Uint32 VOUT_COMMAND;
	Uint32 VOUT_OV_LIMIT;
	Uint32 FREQUENCY;
};

struct PFC_CAL_STRUCT	//for PFC calibration
{
	Uint32 VOUT_CAL_OFFSET;
};

struct PI_GAINS_STRUCT 		//for voltage loop coefficients
{
	int32 KP;
	int32 KI;
	int32 KP_NL;
	int32 KI_NL;
	int32 NL_THRESHOLD;
};

struct FILTER_MISC_REG_BITS
{
    Uint32 rsvd0:27;                	// 31:5  Reserved
    Uint32 NL_MODE:1;          			// 4     NL_MODE - stored in Filter Control Register
	Uint32 AFE_GAIN:2;					// 3:2	`AFE Gain
	Uint32 SAMPLE_TRIG1_OVERSAMPLE:2;  	// 1:0   Configures Oversampling function
};

union FILTER_MISC_REG
{
    struct FILTER_MISC_REG_BITS bit;
    Uint32                 		all;
};

typedef struct 	//for current loop coefficients
{
	struct PFC_SETPOINT_STRUCT	PFC_SETPOINT;		// PFC setpoint configuration
	struct PFC_CAL_STRUCT		PFC_CAL;			// PFC calibration
	struct PI_GAINS_STRUCT		PI_GAINS;			// voltage loop gains
	union COEFCONFIG_REG        COEFCONFIG;         // Coefficient Configuration Register
	union FILTERKPCOEF0_REG     FILTERKPCOEF0;      // Filter KP Coefficient 0 Register
	union FILTERKPCOEF1_REG     FILTERKPCOEF1;      // Filter KP Coefficient 1 Register
	union FILTERKICOEF0_REG     FILTERKICOEF0;      // Filter KI Coefficient 0 Register
	union FILTERKICOEF1_REG     FILTERKICOEF1;      // Filter KI Coefficient 1 Register
	union FILTERKDCOEF0_REG     FILTERKDCOEF0;      // Filter KD Coefficient 0 Register
	union FILTERKDCOEF1_REG     FILTERKDCOEF1;      // Filter KD Coefficient 1 Register
	union FILTERKDALPHA_REG     FILTERKDALPHA;      // Filter KD Alpha Register
	union FILTERNL0_REG         FILTERNL0;          // Filter Non-Linear Limit 0 Register
	union FILTERNL1_REG         FILTERNL1;          // Filter Non-Linear Limit 1 Register
	union FILTERNL2_REG         FILTERNL2;          // Filter Non-Linear Limit 2 Register
	union FILTER_MISC_REG		FILTERMISC;			// Nonlinear mode,AFE gain,oversample 
}PFC_CONFIG_STRUCT;

extern PFC_CONFIG_STRUCT pfc_config_in_ram;

//							 KP,		ki			kp_nl		ki-nl,		nonlinear threshold		
//#define PI_GAINS_DEFAULT	{50000,	    200,		180000,	    0x0500,		15}
//#define PI_GAINS_DEFAULT	{0x06000,	0x00F5,		180000,		0x0500,		20}
//						reserved BIN6ALPHA BIN6CONFIG BIN5ALPHA BIN5CONFIG BIN4ALPHA BIN4CONFIG BIN3ALPHA BIN3CONFIG BIN2ALPHA BIN2CONFIG BIN1ALPHA BIN1CONFIG BIN0ALPHA BIN0CONFIG

//								researved	KP_COEF_2
//#define FILTERKPCOEF1_DEFAULT	{0,			1600}

//								KI_COEF_3	KI_COEF_2
//#define FILTERKICOEF1_DEFAULT	{0,			290}

//								researved	KD_COEF_2
//#define FILTERKDCOEF1_DEFAULT	{0,			-1}
//								researved	KP_COEF_2//[Ken Zhang]modified 20150326

//								KI_COEF_3	KI_COEF_2//[Ken Zhang]modified 20150326

//								researved	KD_COEF_2//[Ken Zhang]modified 20150326

//								researved	LIMIT1		researved 	LIMIT0

//								researved	LIMIT3		researved 	LIMIT2

//								researved	LIMIT5		researved 	LIMIT4

	//								vout_command,	vout_ov_limit, 	frequency		
	//#define PFC_SETPOINT_DEFAULT	{410,           450, 			65}
//#define FILTERKPCOEF0_DEFAULT	{3500,		2000}//1200,1600,3500
//								KI_COEF_1	KI_COEF_0
//#define FILTERKICOEF0_DEFAULT	{290,		35}//150
//								KD_COEF_1	KD_COEF_0
//#define FILTERKDCOEF0_DEFAULT	{-1,		-1}//0

//								researved	KD_ALPHA_1	researved 	KD_ALPHA_0
//#define FILTERKDALPHA_DEFAULT	{0,			0, 		0,			0}//{0,-1,0,150} 201,0
//								KP_COEF_1	KP_COEF_0
//								KI_COEF_1	KI_COEF_0
//								KD_COEF_1	KD_COEF_0

//								researved	KD_ALPHA_1	researved 	KD_ALPHA_0



	//								researved	NL_MODE		AFE_GAIN 	SAMPLE_TRIG1_OVERSAMPLE




//#ifdef PMBUS_COEFFICIENTS
//#include "pmbus_coefficients.h"
//#endif




#pragma DATA_SECTION(pfc_config_constants_a, ".CONFIG_A");
volatile const PFC_CONFIG_STRUCT pfc_config_constants_a = { {410, 450, 55}, {0}, {0x7000, 0x0e0, 0x20000, 0x0500, 20}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {20000, 15000}, {0, 15000}, {500, 50}, {0, 150}, {-1, -1}, {0, -1}, {0, 0, 0, 0}, {0, 16, 0, 8}, {0, 32, 0, 24}, {0, 48, 0, 40}, {0, 1, 0, 3}};

#pragma DATA_SECTION(pfc_config_checksum_a, ".CONFIG_A");
volatile const Uint32 pfc_config_checksum_a = 0x87654321;

#pragma DATA_SECTION(pfc_config_constants_b, ".CONFIG_B");
volatile const PFC_CONFIG_STRUCT pfc_config_constants_b;

#pragma DATA_SECTION(pfc_config_checksum_b, ".CONFIG_B");
volatile const Uint32 pfc_config_checksum_b;

const PFC_CONFIG_STRUCT pfc_config_hardcoded = { {410, 450, 55}, {0}, {0x7000, 0x0e0, 0x20000, 0x0500, 20}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {20000, 15000}, {0, 15000}, {500, 50}, {0, 150}, {-1, -1}, {0, -1}, {0, 0, 0, 0}, {0, 16, 0, 8}, {0, 32, 0, 24}, {0, 48, 0, 40}, {0, 1, 0, 3}};

Uint8 pmbus_write_pi_coefficients(void)
{                                                                                                                                                          
	int32	byte;	// Byte loop index

	for(byte=0; byte < 19; byte++)
	{
		copy_buffer.byte[byte] = pmbus_buffer[2+byte];
	}

	iv.pis.kp 	 		= copy_buffer.word[0];	// B01 and B11
	iv.pis.ki 	 		= copy_buffer.word[1];	// B21 and COEF_SCALER
	iv.pis.kp_nl 		= copy_buffer.word[2];	// A11 and A21
	iv.pis.ki_nl 		= copy_buffer.word[3];	// B12 and A12
	byte 				= copy_buffer.byte[17] + (copy_buffer.byte[16] << 8);
	iv.pis.nl_threshold = (byte << 12) / (527);
	
	return 0;
}

Uint8 pmbus_read_pi_coefficients(void)
{
	int32 byte;
	pmbus_number_of_bytes = 19;

	copy_buffer.word[0]	 = iv.pis.kp;	
	copy_buffer.word[1]  = iv.pis.ki;
	copy_buffer.word[2]  = iv.pis.kp_nl;
	copy_buffer.word[3]  = iv.pis.ki_nl;
	byte = (((iv.pis.nl_threshold * (527)) + (1 << 11)) >> 12);//round
	copy_buffer.byte[16] = (byte >> 8)& 0xff;			
	copy_buffer.byte[17] = byte & 0xff;
	
	for(byte=0; byte < 18; byte++)
	{
		pmbus_buffer[byte+1] =	copy_buffer.byte[byte];
	}	
	pmbus_buffer[0] = 18;

	return 0;
}

//==========================================================================================
// pmbus_write_store_default_all()
//	Store all PMBus-configurable variables from RAM to Data Flash.   
//==========================================================================================
Uint8 pmbus_write_store_default_all(void)
{
	Uint8	status;
	Uint32	checksum;

	volatile const PFC_CONFIG_STRUCT*	   		   dest_address_pfc_config;
	volatile const Uint32*						   dest_checksum;

	volatile const PFC_CONFIG_STRUCT*	   		   opposite_bank_start;

	// Number of bytes to erase is the total size of all the blocks, including the checksum.
	// Assumes that the _a and _b structures are the same size.
	volatile const	Uint32	bytes_to_erase = sizeof(pfc_config_constants_a)
									  		 + sizeof(pfc_config_checksum_a);
							 
	// NOTE: This is a SEND BYTE command that requires no additional data validation.
	// ----- EXECUTE COMMAND -----
	// Check for DFlash erase operations in progress
	if (erase_segment_counter > 1)
	{
		// There are multiple segments that still need to be erased.  There is no way to 
		// get them erased in time to avoid a PMBus timeout so we will just report an error
		// and return.
		return (1<<(0));	// CML - Other memory or logic fault has occurred
		
	}
	
	// There are one or zero segments left to erase.
	// Wait for any erase that might be in progress to complete.
	// IMPORTANT!  This must be done before attempting to access any DFlash location, 
	// even if it is not in the segment being erased.
	while(DecRegs.DFLASHCTRL.bit.BUSY != 0)
	{
		; //do nothing while busy erasing DFlash
	}

	copy_configuration_to_ram(&Filter1Regs);
	// Test that the selected bank is completely erased by checking the first and last word.
	// If both are all F's, the bank is completeley erased so use it.
	// (Assumes that all words in between are erased; usually a reasonable assumption.)
	if ((pfc_config_checksum_a == 0xFFFFFFFF)&&(pfc_config_constants_a.FILTERKDCOEF0.bit.KD_COEF_0 == (signed short)0xFFFF))	// Test Dflash A 
	{	
		// DFlash A is blank. 
		//Store new values in DFlash A and erase DFlash B when done.
		dest_address_pfc_config   = &pfc_config_constants_a;
		dest_checksum	          = &pfc_config_checksum_a;
		
		opposite_bank_start		  = &pfc_config_constants_b;
	}
	else if ((pfc_config_checksum_b == 0xFFFFFFFF)&&(pfc_config_constants_b.FILTERKDCOEF0.bit.KD_COEF_0 == (signed short)0xFFFF))	// Test DFlash B 
	{
		// DFlash B is blank.
		// Store new values in DFlash B and erase DFlash A when done.
		dest_address_pfc_config   = &pfc_config_constants_b;
		dest_checksum	          = &pfc_config_checksum_b;
		
		opposite_bank_start		  = &pfc_config_constants_a;
	}
	else
	{
		// Neither bank is blank.  Erase one of them so it will be ready for next time
		// and report a Flash failure.
		if (pfc_config_checksum_b == 0xFFFFFFFF)
		{
			// We got here because DFlash B was only partially erased, probably because
			// of a power failure during the erase process.  Re-erase bank B and leave 
			// bank A intact since it might have valid values.
			dest_address_pfc_config	= &pfc_config_constants_b;
			
		}
		else
		{
			// We got here because DFlash A was partly erased and B was intact,
			// or because both banks were never erased.
			// Either way, we will now erase bank A.
			dest_address_pfc_config	= &pfc_config_constants_a;
		}
		goto flash_write_failed;	// Fail: Destination bank not erased.
	}
    
	// --------------- CLA GAINS  ---------------
	// Call Update Flash to write the necessary segments of Data Flash
	status = update_data_flash((void*)dest_address_pfc_config, &pfc_config_in_ram, sizeof(pfc_config_in_ram));
	if (status != (0))
	{
		goto flash_write_failed;	// Clean up after flash write failure
	}
    
	// --------------- CHECKSUM ---------------
	// Calculate checksum for selected Data Flash segment and write to Data Flash
	checksum = calculate_dflash_checksum((Uint8*)dest_address_pfc_config, (Uint8*)dest_checksum);
	status = update_data_flash((void*)dest_checksum, &checksum, sizeof(checksum));
	if (status != (0))
	{
		goto flash_write_failed;	// Clean up after flash write failure
	}

	{

		// ----- Bank written successfully.  Erase opposite bank. -----
		start_erase_task((void*)opposite_bank_start, bytes_to_erase);	
		// If everything works, return success.
		return 0;
	}

flash_write_failed:		// <--- Destination for several goto's above.
	{
		// ----- This bank write failed.  Erase present bank and report the failure.
		start_erase_task((void*)dest_address_pfc_config, bytes_to_erase);	
		return ((1<<(4)));		// Flash write failed
	}
} 

void copy_configuration_to_ram(volatile struct FILTER_REGS *source)
{
	//copy PFC configuration
    pfc_config_in_ram.PFC_SETPOINT.VOUT_COMMAND 	= iv.vbus_voltage - pfc_config_in_ram.PFC_CAL.VOUT_CAL_OFFSET;

    pfc_config_in_ram.PFC_SETPOINT.VOUT_OV_LIMIT 	= ((Uint32)FaultMuxRegs.ACOMPCTRL0.bit.ACOMP_B_THRESH * (527))/127;
	pfc_config_in_ram.PFC_SETPOINT.FREQUENCY 		= switching_frequency;

	//copy voltage loop gains
	pfc_config_in_ram.PI_GAINS.KP 		  		= iv.pis.kp ;
	pfc_config_in_ram.PI_GAINS.KI 		  		= iv.pis.ki ;
	pfc_config_in_ram.PI_GAINS.KP_NL 		  	= iv.pis.kp_nl;
	pfc_config_in_ram.PI_GAINS.KI_NL 		  	= iv.pis.ki_nl ;
	pfc_config_in_ram.PI_GAINS.NL_THRESHOLD 	= ((iv.pis.nl_threshold * (527)) + (1 << 11)) >> 12;

	//copy current loop gains
	pfc_config_in_ram.COEFCONFIG.all	  		= source->COEFCONFIG.all;
	pfc_config_in_ram.FILTERKPCOEF0.all 		= source->FILTERKPCOEF0.all;
	pfc_config_in_ram.FILTERKPCOEF1.all 		= source->FILTERKPCOEF1.all;
	pfc_config_in_ram.FILTERKICOEF0.all 		= source->FILTERKICOEF0.all;
	pfc_config_in_ram.FILTERKICOEF1.all 		= source->FILTERKICOEF1.all;
	pfc_config_in_ram.FILTERKDCOEF0.all 		= source->FILTERKDCOEF0.all;
	pfc_config_in_ram.FILTERKDCOEF1.all 		= source->FILTERKDCOEF1.all;
	pfc_config_in_ram.FILTERKDALPHA.all 		= source->FILTERKDALPHA.all;
	pfc_config_in_ram.FILTERNL0.all 	  		= source->FILTERNL0.all;
	pfc_config_in_ram.FILTERNL1.all     		= source->FILTERNL1.all;
	pfc_config_in_ram.FILTERNL2.all     		= source->FILTERNL2.all;

	pfc_config_in_ram.FILTERMISC.bit.NL_MODE 					= source->FILTERCTRL.bit.NL_MODE;
	pfc_config_in_ram.FILTERMISC.bit.SAMPLE_TRIG1_OVERSAMPLE 	= Dpwm1Regs.DPWMCTRL2.bit.SAMPLE_TRIG1_OVERSAMPLE;
	pfc_config_in_ram.FILTERMISC.bit.AFE_GAIN 				= FeCtrl0Regs.EADCCTRL.bit.AFE_GAIN;
}

Uint8 pmbus_write_restore_default_all(void)//load configuration from data flash to registers
{
	Uint32 	checksum;

	// Pointers to structures in Data Flash 
	volatile const  PFC_CONFIG_STRUCT*  	pfc_config_ptr;

	// ----- Look for a copy of default values in Data FLASH that looks valid. -----
	// If none found, use the hard-coded values from Program FLASH.

	// Wait for any erase that might be in progress to complete.
	// IMPORTANT!  This must be done before attempting to access any DFlash location, 
	// even if it is not in the segment being erased.
	while(DecRegs.DFLASHCTRL.bit.BUSY != 0)
	{
		; //do nothing while busy erasing DFlash
	}	

	// Look in Data Flash A for valid values.
	checksum = calculate_dflash_checksum((Uint8*)&pfc_config_constants_a, (Uint8*)&pfc_config_checksum_a);
	// A zero checksum only occurs when the segment is all zeroes, which is not valid.
	// If the calculated checksum is nonzero and matches the checksum in the DFlash,  
	// that segment is good, so use it.
	if(   (pfc_config_checksum_a == 0x87654321)	// Hardcoded exception for parms written directly to data flash
		// (GUI download tool does not calculate checksum)
		||((checksum != 0) && (checksum == pfc_config_checksum_a)) )	// Checksum is valid and matches.
	{
		// Checksum A Good: Use default values from DFlash A
		pfc_config_ptr = &pfc_config_constants_a;
	}
	else
	{
		// Look in Data Flash B for valid values
		checksum = calculate_dflash_checksum((Uint8*)&pfc_config_constants_b, (Uint8*)&pfc_config_checksum_b);
		// A zero checksum only occurs when the segment is all zeroes, which is not valid.
		// If the calculated checksum is nonzero and matches the checksum in the DFlash,  
		// that segment is good, so use it.
		if ((checksum != 0) && (checksum == pfc_config_checksum_b))
		{
			// Checksum B Good: Use default values from DFlash B
			pfc_config_ptr = &pfc_config_constants_b;
		}
		else// No valid values found in Data Flash.  Use hardcoded values from PFlash instead.
		{
			// Use hardcoded values from Program Flash
			pfc_config_ptr = &pfc_config_hardcoded;
		}	
	}

	// ----- Copy default variables from Flash to RAM -----
	memcpy((void *)&pfc_config_in_ram, (void *)pfc_config_ptr, sizeof(pfc_config_constants_a));	

	copy_configuration_to_registers(&Filter1Regs);

	return 0; 
}

void copy_configuration_to_registers(volatile struct FILTER_REGS *dest)
{
	//copy PFC configuration
    iv.vbus_voltage 	= pfc_config_in_ram.PFC_SETPOINT.VOUT_COMMAND + pfc_config_in_ram.PFC_CAL.VOUT_CAL_OFFSET;
  	iv.vbus_setpoint 	= ((Uint32)((iv.vbus_voltage * 4095)/(527)));
  	if(iv.supply_state >= STATE_PFC_ON)
  	{
  		iv.vbus_target 	= ((int32)((iv.vbus_voltage * 4095)/(527)));
	}

  	FaultMuxRegs.ACOMPCTRL0.bit.ACOMP_B_THRESH = ((Uint32)(pfc_config_in_ram.PFC_SETPOINT.VOUT_OV_LIMIT * 127) / (527));
	switching_frequency = pfc_config_in_ram.PFC_SETPOINT.FREQUENCY;
//	set_new_switching_frequency();

	//copy voltage loop gains
	iv.pis.kp 			= pfc_config_in_ram.PI_GAINS.KP;
	iv.pis.ki 			= pfc_config_in_ram.PI_GAINS.KI;
	iv.pis.kp_nl 		= pfc_config_in_ram.PI_GAINS.KP_NL;
	iv.pis.ki_nl 		= pfc_config_in_ram.PI_GAINS.KI_NL;
	iv.pis.nl_threshold = (pfc_config_in_ram.PI_GAINS.NL_THRESHOLD << 12) / (527);

	//copy current loop gains
	dest->COEFCONFIG.all 			= pfc_config_in_ram.COEFCONFIG.all;
	dest->FILTERKPCOEF0.all 		= pfc_config_in_ram.FILTERKPCOEF0.all;
	dest->FILTERKPCOEF1.all 		= pfc_config_in_ram.FILTERKPCOEF1.all;
	dest->FILTERKICOEF0.all 		= pfc_config_in_ram.FILTERKICOEF0.all;
	dest->FILTERKICOEF1.all 		= pfc_config_in_ram.FILTERKICOEF1.all;
	dest->FILTERKDCOEF0.all 		= pfc_config_in_ram.FILTERKDCOEF0.all;
	dest->FILTERKDCOEF1.all 		= pfc_config_in_ram.FILTERKDCOEF1.all;
	dest->FILTERKDALPHA.all 		= pfc_config_in_ram.FILTERKDALPHA.all;
	dest->FILTERNL0.all 			= pfc_config_in_ram.FILTERNL0.all;
	dest->FILTERNL1.all 			= pfc_config_in_ram.FILTERNL1.all;
	dest->FILTERNL2.all 			= pfc_config_in_ram.FILTERNL2.all;
	dest->FILTERCTRL.bit.NL_MODE 	= pfc_config_in_ram.FILTERMISC.bit.NL_MODE;

	FeCtrl0Regs.EADCCTRL.bit.AFE_GAIN 				= pfc_config_in_ram.FILTERMISC.bit.AFE_GAIN;
	Dpwm1Regs.DPWMCTRL2.bit.SAMPLE_TRIG1_OVERSAMPLE = pfc_config_in_ram.FILTERMISC.bit.SAMPLE_TRIG1_OVERSAMPLE;
}
	

	


