;  Generated by PSoC Designer 5.3.2710
;
;;*****************************************************************************
;;*****************************************************************************
;;  FILENAME: PSoCGPIOINT.asm
;;   Version: 2.0.0.20, Updated on 2003/07/17 at 12:10:35
;;  @PSOC_VERSION
;;
;;  DESCRIPTION: PSoC GPIO Interrupt Service Routine
;;-----------------------------------------------------------------------------
;;  Copyright (c) Cypress Semiconductor 2012. All Rights Reserved.
;;*****************************************************************************
;;*****************************************************************************

include "m8c.inc"
include "PSoCGPIOINT.inc"

;-----------------------------------------------
;  Global Symbols
;-----------------------------------------------
export   PSoC_GPIO_ISR


;-----------------------------------------------
;  Constant Definitions
;-----------------------------------------------


;-----------------------------------------------
; Variable Allocation
;-----------------------------------------------
	

;@PSoC_UserCode_INIT@ (Do not change this line.)
;---------------------------------------------------
; Insert your custom declarations below this banner
;---------------------------------------------------

;---------------------------------------------------
; Insert your custom declarations above this banner
;---------------------------------------------------
;@PSoC_UserCode_END@ (Do not change this line.)


;-----------------------------------------------------------------------------
;  FUNCTION NAME: PSoC_GPIO_ISR
;
;  DESCRIPTION: Unless modified, this implements only a null handler stub.
;
;-----------------------------------------------------------------------------
;
PSoC_GPIO_ISR:


   ;@PSoC_UserCode_BODY@ (Do not change this line.)
   ;---------------------------------------------------
   ; Insert your custom code below this banner
   ;---------------------------------------------------
	
	mov A,0x32
	lcall Delay10msTimes	
	mov A,reg[PRT1DR]
	and A,0x01
	cmp A,0x01
	jz setLong
	
	cmp [watchSwitch],0x00
	jz setShort
	mov [watchSwitch],0x00
	reti
	
setShort:	
	mov [modeSwitch],0x00
	mov [watchSwitch],0x01
	reti
	
setLong: 
	mov [modeSwitch],0x01
	mov [watchSwitch],0x02
	reti

   ;---------------------------------------------------
   ; Insert your custom code above this banner
   ;---------------------------------------------------
   ;@PSoC_UserCode_END@ (Do not change this line.)

   reti


; end of file PSoCGPIOINT.asm
