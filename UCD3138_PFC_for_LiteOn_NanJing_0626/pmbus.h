//pmbus.h
//===========================================================================
// PMBus Module (PmbusReg) Constant Definitions
//
#include "system_defines.h"

#define PMBCTRL1_BYTE2_PRC_CALL 0x10	// 20     Process call message enable
#define PMBCTRL1_BYTE2_GRP_CMD	8		// 19     Group command message enable
#define PMBCTRL1_BYTE2_PEC_ENA	4		// 18     PEC byte enable
#define PMBCTRL1_BYTE2_EXT_CMD	2		// 17     Extended command enable
#define PMBCTRL1_BYTE2_CMD_ENA	1		// 16     Command word enable

#define PMBCTRL1_BYTE0_RW		1		// 0      Read/write indicator

#define PMBCTRL1_ALL_PRC_CALL	0x100000	// 20     Process call message enable
#define PMBCTRL1_ALL_GRP_CMD	0x80000		// 19     Group command message enable
#define PMBCTRL1_ALL_PEC_ENA	0x40000		// 18     PEC byte enable
#define PMBCTRL1_ALL_EXT_CMD	0x20000		// 17     Extended command enable
#define PMBCTRL1_ALL_CMD_ENA	0x10000		// 16     Command word enable

#define PMBACK_BYTE0_ACK 1 //0 pmbus acknowledge enable

#define PMBINTM_BYTE1_LOST_ARB			1		// 8      Lost arbitration interrupt mask

#define PMBINTM_BYTE0_CONTROL			0x80	// 7      Remote module control asserted interrupt mask
#define PMBINTM_BYTE0_ALERT				0x40	// 6      Alert signal detected interrupt mask
#define PMBINTM_BYTE0_EOM				0x20	// 5      End of message interrupt mask
#define PMBINTM_BYTE0_SLAVE_ADDR_READY	0x10	// 4      Slave address ready interrupt mask
#define PMBINTM_BYTE0_DATA_REQUEST		8		// 3      Data request interrupt mask
#define PMBINTM_BYTE0_DATA_READY			4		// 2      Data ready interrupt mask
#define PMBINTM_BYTE0_BUS_LOW_TIMEOUT	2		// 1      Bus low timeout interrupt mask
#define PMBINTM_BYTE0_BUS_FREE			1		// 0      Bus free interrupt mask

#define PMBINTM_HALF0_LOST_ARB			0x10000		// 8      Lost arbitration interrupt mask

#define PMBCTRL2_HALF0_PEC_ENA			0x8000	// 15     Enable PEC processing

#define PMBHSA_BYTE0_SLAVE_ADDR_MASK	0xf7	// 7:1    Stored address acknowledged by slave
#define PMBHSA_BYTE0_SLAVE_RW			1		// 0      Stored R/W bit from slave acknowledge

#define PMBCTRL3_BYTE0_CNTL_INT_EDGE		0x20	// 5      Control interrupt edge select
#define PMBCTRL3_BYTE0_FAST_MODE_PLUS_ENA	0x10	// 4      Fast mode plus enable
#define PMBCTRL3_BYTE0_FAST_MODE_ENA		8		// 3      Fast mode enable
#define PMBCTRL3_BYTE0_BUS_LO_INT_EDGE		4		// 2      Bus low timeout interrupt edge select
#define PMBCTRL3_BYTE0_ALERT_ENA			2		// 1      Alert enable
#define PMBCTRL3_BYTE0_RESET				1		// 0      PMBus Master reset


//=========================================================================================
// PMBus module definitions
//=========================================================================================
	// PMBST Register
#define PMBST_ALL_CONTROL_RAW			(0x00080000)	// 19  Control Pin Raw status
#define PMBST_ALL_ALERT_RAW				(0x00040000)	// 18  Alert Pin Raw status 
#define PMBST_ALL_CONTROL_EDGE			(0x00020000)	// 17  Remote module control asserted flag
#define PMBST_ALL_ALERT_EDGE			(0x00010000)	// 16  Alert signal detected flag
#define PMBST_ALL_MASTER					(0x00008000)	// 15  Master/Slave mode flag
#define PMBST_ALL_LOST_ARB					(0x00004000)	// 14  Lost arbitration flag
#define PMBST_ALL_BUS_FREE					(0x00002000)	// 13  Bus free flag
#define PMBST_ALL_UNIT_BUSY					(0x00001000)	// 12  Unit busy flag
#define PMBST_ALL_RPT_START					(0x00000800)	// 11  Repeated start condition flag
#define PMBST_ALL_SLAVE_ADDR_READY			(0x00000400)	// 10  Slave address ready flag
#define PMBST_ALL_CLK_HIGH_TIMEOUT			(0x00000200)	// 9   Clock high timeout flag
#define PMBST_ALL_CLK_LOW_TIMEOUT			(0x00000100)	// 8   Clock low timeout flag
#define PMBST_ALL_PEC_VALID					(0x00000080)	// 7   PEC valid flag
#define PMBST_ALL_NACK						(0x00000040)	// 6   NACK condition received flag
#define PMBST_ALL_EOM						(0x00000020)	// 5   End of message flag
#define PMBST_ALL_DATA_REQUEST				(0x00000010)	// 4   Data request flag
#define PMBST_ALL_DATA_READY				(0x00000008)	// 3   Data ready flag
#define PMBST_ALL_RD_BYTE_COUNT				(0x00000007)	// 2:0 Read byte count mask

// ***KKN***HEM	It would be nice to get rid of these _BYTE0_ and _HALF0_ values.  
// *** 			Requires change to _ALL_ in multiple places in pmbus.c.
#define PMBST_HALF0_MASTER					(0x8000)		// 15  Master/Slave mode flag
#define PMBST_HALF0_LOST_ARB				(0x4000)		// 14  Lost arbitration flag
#define PMBST_HALF0_BUS_FREE				(0x2000)		// 13  Bus free flag
#define PMBST_HALF0_UNIT_BUSY				(0x1000)		// 12  Unit busy flag
#define PMBST_HALF0_RPT_START				(0x0800)		// 11  Repeated start condition flag
#define PMBST_HALF0_SLAVE_ADDR_READY		(0x0400)		// 10  Slave address ready flag
#define PMBST_HALF0_CLK_HIGH_TIMEOUT		(0x0200)		// 9   Clock high timeout flag
#define PMBST_HALF0_CLK_LOW_TIMEOUT			(0x0100)		// 8   Clock low timeout flag
#define PMBST_HALF0_PEC_VALID				(0x0080)		// 7   PEC valid flag
#define PMBST_HALF0_NACK					(0x0040)		// 6   NACK condition received flag
#define PMBST_HALF0_EOM						(0x0020)		// 5   End of message flag
#define PMBST_HALF0_DATA_REQUEST			(0x0010)		// 4   Data request flag
#define PMBST_HALF0_DATA_READY				(0x0008)		// 3   Data ready flag
#define PMBST_HALF0_RD_BYTE_COUNT			(0x0007)		// 2:0 Read byte count mask

#define PMBST_BYTE0_PEC_VALID				(0x80)			// 7   PEC valid flag
#define PMBST_BYTE0_NACK					(0x40)			// 6   NACK condition received flag
#define PMBST_BYTE0_EOM						(0x20)			// 5   End of message flag
#define PMBST_BYTE0_DATA_REQUEST			(0x10)			// 4   Data request flag
#define PMBST_BYTE0_DATA_READY				(0x08)			// 3   Data ready flag
#define PMBST_BYTE0_RD_BYTE_COUNT			(0x07)			// 2:0 Read byte count mask


	// PMBCTRL2 Register
#define PMBCTRL2_ALL_RX_BYTE_ACK_CNT		(0x00600000)	// 22:21  Received byte acknowledge count	
#define PMBCTRL2_ALL_MAN_CMD				(0x00100000)	// 20     Manual command acknowledge mode
#define PMBCTRL2_ALL_TX_PEC					(0x00080000)	// 19     Transmited PEC flag
#define PMBCTRL2_ALL_TX_COUNT				(0x00070000)	// 18:16  Transmit byte count
#define PMBCTRL2_ALL_PEC_ENA				(0x00008000)	// 15     Enable PEC processing
#define PMBCTRL2_ALL_SLAVE_MASK				(0x00007F00)	// 14:8   Slave mask
#define PMBCTRL2_ALL_MAN_SLAVE_ACK			(0x00000080)	// 7      Manual slave acknowledge mode enable
#define PMBCTRL2_ALL_SLAVE_ADDR				(0x0000007F)	// 6:0    Slave address

#define PMBCTRL2_BYTE2_RX_BYTE_ACK_CNT		(0x60)			// 22:21  Received byte acknowledge count	
#define PMBCTRL2_BYTE2_MAN_CMD				(0x10)			// 20     Manual command acknowledge mode
#define PMBCTRL2_BYTE2_TX_PEC				(0x08)			// 19     Transmited PEC flag
#define PMBCTRL2_BYTE2_TX_COUNT				(0x07)			// 18:16  Transmit byte count
#define PMBCTRL2_BYTE1_PEC_ENA				(0x80)			// 15     Enable PEC processing
#define PMBCTRL2_BYTE1_SLAVE_MASK			(0x7F)			// 14:8   Slave mask
#define PMBCTRL2_BYTE0_MAN_SLAVE_ACK		(0x80)			// 7      Manual slave acknowledge mode enable
#define PMBCTRL2_BYTE0_SLAVE_ADDR			(0x7F)			// 6:0    Slave address


//=========================================================================================


#define	NUM_CLA_BYTES				25		// Bytes in CLA gains structure (pmbus use).

EXTERN char	status_cml;	 // STATUS_CML (Communication, Logic, and Memory) for entire board
	#define	CML_INVALID_CMD			(7)		// Invalid or Unsupported Command Received
	#define	CML_INVALID_DATA		(6)		// Invalid or Unsupported Data Received
	#define	CML_PEC_FAILED			(5)		// Packet Error Check Failed
	#define	CML_MEMORY_FAULT	  	(4)		// Memory Fault Detected
	#define	CML_PROC_FAULT			(3)		// Processor Fault Detected
	#define	CML_RSVD2 				(2)		// Reserved
	#define	CML_COMM_OTHER_FAULT	(1)		// Unlisted communication fault
	#define	CML_OTHER_FAULT			(0)		// Other Memory or Logic fault has occurred


// These error codes are masks based on bits in the CML_STATUS byte.  This allows the
// pmbus_error_handler() function to do a simple 'OR' instead of a big 'switch' statement.
#define	PMBUS_INVALID_CMD		(1<<CML_INVALID_CMD)		// bit7 Invalid or Unsupported Command Received
#define	PMBUS_INVALID_DATA		(1<<CML_INVALID_DATA)		// bit6 Invalid or Unsupported Data Received
#define	PMBUS_PEC_FAILED		(1<<CML_PEC_FAILED)			// bit5 Packet Error Check Failed
#define	PMBUS_MEMORY_FAULT	 	(1<<CML_MEMORY_FAULT)	  	// bit4 Memory Fault Detected
#define	PMBUS_PROC_FAULT		(1<<CML_PROC_FAULT)			// bit3 Processor Fault Detected
#define	PMBUS_RSVD2 			(1<<CML_RSVD2) 				// bit2 Reserved
#define	PMBUS_COMM_OTHER_FAULT	(1<<CML_COMM_OTHER_FAULT)	// bit1 Unlisted communication fault
#define	PMBUS_OTHER_FAULT		(1<<CML_OTHER_FAULT)		// bit0 Other Memory or Logic fault has occurred


#define PMBUS_SUCCESS               0
#define NUMBER_OF_BYTES_FAULTS		(1)

#define PMBUS_INVALID_DATA         (1<<CML_INVALID_DATA)

#define PMBUS_BUFFER_SIZE 40
#define PMBST_HALF0_CHECK_BITS (PMBST_BYTE0_EOM + PMBST_BYTE0_DATA_READY + PMBST_BYTE0_DATA_REQUEST + PMBST_BYTE0_PEC_VALID + PMBST_HALF0_CLK_LOW_TIMEOUT + PMBST_HALF0_CLK_HIGH_TIMEOUT)
#define PMBCTRL2_HALF0_SLAVE_ADDRESS_MASK_DISABLE 0x7f00 //any bits cleared in slave address mask make that bit a don't care

#define PMBUS_STATE_IDLE 0
#define PMBUS_STATE_WRITE_BLOCK 1
#define PMBUS_STATE_READ_BLOCK 2
#define PMBUS_STATE_READ_WAIT_FOR_EOM 3

//#define program_flash_integrity_word *((volatile Uint32 *) 0x7ffc)

	#define SETUP_ID        "VERSION1|PFC001" //FE0 + CLA1 + DPWM1
//	#define SETUP_ID        "VERSION1|PFC003" //FE0 + CLA0 + DPWM0

#define DEVICE           	 UCD3100ISO1  				//Device Name
#define MFR_ID				"TI"						//Hardware Manufacturer
#define MFR_MODEL			"UCD3138PFCEVM-028"			//Hardware Model
#define MFR_REVISION    	"A"						//Hardware revision

#define SETUP_ID_LENGTH 	sizeof(SETUP_ID)
#define MFR_ID_LENGTH 		sizeof(MFR_ID)
#define MFR_MODEL_LENGTH 	sizeof(MFR_MODEL)
#define MFR_REVISION_LENGTH sizeof(MFR_REVISION)


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
#define CMD_PFC  \
                           {0x00, 0x00, \
                            0x60, 0x00, \
                            0xC0, 0x00, \
                            0x10, 0x00, \
                            0x80, 0x00, \
                            0x00, 0x00, \
                            0x00, 0x00, \
                            0x00, 0x00, \
                            0x00, 0x50, \
                            0x05, 0xF0, \
                            0x00, 0x00, \
                            0x00, 0x00, \
                            0x00, 0x00, \
                            0x00, 0x60, \
                            0x3F, 0x00, \
                            0x85, 0x04 \
                            } 

//specify the supported PFC commands - necessary for GUI, even if we're only a PFC
#define CMD_DCDC  \
 						   {0x00, 0x00, \
                            0x00, 0x00, \
							0x00, 0x00, \
							0x00, 0x00, \
							0x00, 0x00, \
							0x00, 0x00, \
							0x00, 0x00, \
							0x00, 0x00, \
							0x00, 0x00, \
							0x00, 0xD0, \
							0x00, 0x00, \
							0x00, 0x00, \
							0x00, 0x00, \
							0x00, 0x00, \
							0x00, 0x00, \
							0x00, 0x00  \
							}

#define DEBUG_0_TEXT "Debug 0"
#define DEBUG_1_TEXT "Debug 1"
#define DEBUG_2_TEXT "Debug 2"
#define DEBUG_3_TEXT "Debug 3"
#define DEBUG_4_TEXT "Debug 4"
#define DEBUG_5_TEXT "Debug 5"
#define DEBUG_6_TEXT "Debug 6"
#define DEBUG_7_TEXT "Debug 7"

EXTERN Uint8 gui_constant_pointer;
EXTERN Uint8 user_ram_00;


///////////////////////////////////////////////////////////////
//variables for PARM_INFO and PARM_VAR
///////////////////////////////////////////////////////////////
//  Memory limits used by the PARM_INFO and PARM_VALUE commands.
#define	RAM_START_ADDRESS	0x00019000	// Beginning of RAM
#define	RAM_END_ADDRESS		0x00019FFF	// End of RAM
#define RAM_LENGTH			(RAM_END_ADDRESS - RAM_START_ADDRESS + 1)			

// Allow access to peripherals, but not core ARM regs.
#define	REG_START_ADDRESS	0xFFF7d100	// Beginning of Register space
#define	REG_END_ADDRESS		0xFFF7fdff	// End of Register space
#define REG_LENGTH			(REG_END_ADDRESS - REG_START_ADDRESS + 1)

// Allow read-only access to Data Flash
#define	DFLASH_START_ADDRESS	0x00018800	// Beginning of DFLASH
#define	DFLASH_END_ADDRESS		0x00018FFF	// End of DFLASH
#define DFLASH_LENGTH			(DFLASH_END_ADDRESS - DFLASH_START_ADDRESS + 1)			

// Allow read-only access to Constants in Program Flash 
#define	PFLASH_CONST_START_ADDRESS	0x00000000	// Beginning of PFLASH Constants
#define	PFLASH_CONST_END_ADDRESS   	0x00007FFF	// End of PFLASH Constants
#define PFLASH_CONST_LENGTH			(PFLASH_CONST_END_ADDRESS - PFLASH_CONST_START_ADDRESS + 1)			

// Allow read-only access to Program in Program Flash 
#define	PFLASH_PROG_START_ADDRESS	0x00000000	// Beginning of PFLASH Program
#define	PFLASH_PROG_END_ADDRESS   	0x00007FFF	// End of PFLASH Program
#define PFLASH_PROG_LENGTH			(PFLASH_PROG_END_ADDRESS - PFLASH_PROG_START_ADDRESS + 1)			


 //Cyclone 2 extra addresses
#define LOOP_MUX_START_ADDRESS  0x00020000
#define LOOP_MUX_LENGTH         0x00000078

#define FAULT_MUX_START_ADDRESS 0x00030000
#define FAULT_MUX_LENGTH        0x00000080

#define ADC_START_ADDRESS       0x00040000
#define ADC_LENGTH              0x00000098

#define DPWM3_START_ADDRESS     0x00050000
#define DPWM3_LENGTH            0x0000008c

#define FILTER2_START_ADDRESS   0x00060000
#define FILTER2_LENGTH          0x00000064

#define DPWM2_START_ADDRESS     0x00070000
#define DPWM2_LENGTH            0x0000008c

#define FE_CTRL2_START_ADDRESS  0x00080000
#define FE_CTRL2_LENGTH         0x00000044

#define FILTER1_START_ADDRESS   0x00090000
#define FILTER1_LENGTH          0x00000064

#define DPWM1_START_ADDRESS     0x000a0000
#define DPWM1_LENGTH            0x0000008c

#define FE_CTRL1_START_ADDRESS  0x000b0000
#define FE_CTRL1_LENGTH         0x00000044

#define FILTER0_START_ADDRESS   0x000c0000
#define FILTER0_LENGTH          0x00000064

#define DPWM0_START_ADDRESS     0x000d0000
#define DPWM0_LENGTH            0x0000008c

#define FE_CTRL0_START_ADDRESS  0x000e0000
#define FE_CTRL0_LENGTH         0x00000044

#define SYSTEM_REGS_START_ADDRESS 0xfffffd00
#define SYSTEM_REGS_LENGTH        0x2d0

#define	NUM_MEMORY_SEGMENTS	19	// 19 memory segments for Cyclone 2




