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

#ifndef CYCLONE_DEVICE_H
#define CYCLONE_DEVICE_H


#ifdef __cplusplus
extern "C" {
#endif

//===========================================================================
// For Portability, It Is Recommended To Use Following Data Type Definitions
//
#ifndef CYCLONE_DATA_TYPES
#define CYCLONE_DATA_TYPES
	typedef signed char          int8;
	typedef char                 Uint8;
	typedef short                int16;
	typedef unsigned short       Uint16;
	typedef int                  int32;
	typedef unsigned int         Uint32;

	typedef	Uint16	PM11;  	// PMBus literal format.  Top 5 bits are exponent, 
			      	// bottom 11 bits are signed integer
#endif


//===========================================================================
// Include All Peripheral Structure Definitions:
//
#include "../header files/cyclone_adc.h"         // ADC Registers
#include "../header files/cyclone_cim.h"         // CIM Registers
#include "../header files/cyclone_dec.h"         // DEC Registers
#include "../header files/cyclone_dpwm.h"        // DPWM Registers
//#include "../header files/cyclone_errlog.h"      // ERRLOG Register (for simulation only)
#include "../header files/cyclone_fault_mux.h"   // Fault Mux Registers
#include "../header files/cyclone_fe_ctrl.h"     // Front End Control Registers
#include "../header files/cyclone_filter.h"      // FLTR Registers
#include "../header files/cyclone_gio.h"         // GIO Registers
#include "../header files/cyclone_loop_mux.h"    // Loop Mux Registers
#include "../header files/cyclone_misc_analog.h" // Misc Analog Registers
#include "../header files/cyclone_mmc.h"         // MMC Registers
#include "../header files/cyclone_pmbus.h"       // PMBus Registers
#include "../header files/cyclone_sys.h"         // SYS Registers
#include "../header files/cyclone_timer.h"       // SYS Registers
#include "../header files/cyclone_uart.h"        // UART Registers

//===========================================================================
#ifdef __cplusplus
}       // end of extern "C"
#endif

#endif  // end of CYCLONE_DEVICE_H definition


//===========================================================================
// End of file
//===========================================================================
