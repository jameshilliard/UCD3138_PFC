;zero out integrity word - zoiw
;derived from this C program
;#include "..\common\UCD92xx_Device.h"     // UCD92xx Headers Include File
;#include "..\common\UCD92xx_Defines.h"   // UCD92xx Headers Include File
;#include "..\common\UCD9240_specific.h"
;#include "..\common\common_function_prototypes.h"
;#include "function_prototypes.h"
;#include "software_interrupts.h"
;
;#define program_flash_integrity_word *((volatile unsigned long *) 0x7ffc)
;//last word in flash, when executing from Flash.  used to store integrity code

;void zero_out_integrity_word(void)
;{
;	DecRegs.MFBALR1.all = MFBALRX_BYTE0_BLOCK_SIZE_32K; //enable program flash write
;	program_flash_integrity_word = 0;
;	DecRegs.MFBALR1.all = MFBALRX_BYTE0_BLOCK_SIZE_32K + //expand program flash out to 4x real size
;							MFBALRX_BYTE0_RONLY;
;
;	while(DecRegs.DFLASHCTRL.bit.BUSY != 0)
;	{
;		; //do nothing while it programs
;	}
;}
;
	.state32
;	.sect ".dflash"
	.global	_zero_integrity_word
	.global _zoiw_end

;*****************************************************************************
;* FUNCTION NAME: zero_out_integrity_word                                    *
;*                                                                           *
;*   Regs Modified     : A1,V9,SR                                            *
;*   Regs Used         : A1,V9,SR                                            *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                   *
;*****************************************************************************
_zero_integrity_word:
;* --------------------------------------------------------------------------*
        MOV       V9, #96               ; |13| 
        LDR       A1, CON1              ; |13| 
        STR       V9, [A1, #0]          ; |13| 
        MOV       A1, #0                ; |14| 
        MOV       V9, #32768            ; |14| 
        SUB       V9, V9, #4            ; |14| 
        STR       A1, [V9, #0]          ; |14| 
        MOV       V9, #98               ; |15| 
        LDR       A1, CON1              ; |15| 
        STR       V9, [A1, #0]          ; |15| 
;* --------------------------------------------------------------------------*
;*   BEGIN LOOP L1
;*
;*   Loop source line                : 18
;*   Loop closing brace source line  : 21
;*   Known Minimum Trip Count        : 1
;*   Known Maximum Trip Count        : 4294967295
;*   Known Max Trip Count Factor     : 1
;* --------------------------------------------------------------------------*
L1:    
        LDR       V9, CON2              ; |18| 
        LDRB      V9, [V9, #0]          ; |18| 
        MOV       V9, V9, LSR #3        ; |18| 
        MOVS      V9, V9, LSL #31       ; |18| 
        BNE       L1                    ; |18| 
        BX        LR

	.align	4
CON1:	.field  	_DecRegs+12,32
	.align	4
CON2:	.field  	_DecRegs+102,32
_zoiw_end:		;reference point for end of code.
;******************************************************************************
;* UNDEFINED EXTERNAL REFERENCES                                              *
;******************************************************************************
	.global	_DecRegs
	.end

