;;*****************************************************************************
;;*****************************************************************************
;;  FILENAME:   ADCINC12_1INT.asm
;;  Version: 5.3, Updated on 2012/9/21 at 11:56:49
;;  Generated by PSoC Designer 5.3.2710
;;
;;  DESCRIPTION:
;;    Assembler source for interrupt routines the 12 bit Incremential
;;    A/D converter.
;;-----------------------------------------------------------------------------
;;  Copyright (c) Cypress Semiconductor 2012. All Rights Reserved.
;;*****************************************************************************
;;*****************************************************************************

include "ADCINC12_1.inc"
include "m8c.inc"
include "memory.inc"

;-----------------------------------------------
;  Global Symbols
;-----------------------------------------------
export _ADCINC12_1_CNT_ISR
export _ADCINC12_1_TMR_ISR
export  ADCINC12_1_cTimerU
export  ADCINC12_1_cCounterU
export _ADCINC12_1_iIncr
export  ADCINC12_1_iIncr
export _ADCINC12_1_fIncr
export  ADCINC12_1_fIncr
export  ADCINC12_1_bIncrC

;-----------------------------------------------
; Variable Allocation
;-----------------------------------------------
AREA InterruptRAM (RAM,REL,CON)
    ADCINC12_1_cTimerU:   BLK  1                 ;The Upper byte of the Timer
    ADCINC12_1_cCounterU: BLK  1                 ;The Upper byte of the Counter
   _ADCINC12_1_iIncr:
    ADCINC12_1_iIncr:     BLK  2                 ;A/D value
   _ADCINC12_1_fIncr:
    ADCINC12_1_fIncr:     BLK  1                 ;Data Valid Flag
    ADCINC12_1_bIncrC:    BLK  1                 ;# of times to run A/D


;@PSoC_UserCode_INIT@ (Do not change this line.)
;---------------------------------------------------
; Insert your custom declarations below this banner
;---------------------------------------------------

;------------------------
; Includes
;------------------------

	
;------------------------
;  Constant Definitions
;------------------------


;------------------------
; Variable Allocation
;------------------------


;---------------------------------------------------
; Insert your custom declarations above this banner
;---------------------------------------------------
;@PSoC_UserCode_END@ (Do not change this line.)


AREA UserModules (ROM, REL)
;-----------------------------------------------
;  EQUATES
;-----------------------------------------------
LowByte:   equ 1
HighByte:  equ 0

;-----------------------------------------------------------------------------
;  FUNCTION NAME: _ADCINC12_1_CNT_ISR
;
;  DESCRIPTION:
;    Increment the upper (software) half on the counter whenever the
;    lower (hardware) half of the counter underflows.
;
;-----------------------------------------------------------------------------
;
_ADCINC12_1_CNT_ISR:
   inc [ADCINC12_1_cCounterU]
   ;@PSoC_UserCode_BODY_1@ (Do not change this line.)
   ;---------------------------------------------------
   ; Insert your custom assembly code below this banner
   ;---------------------------------------------------
   ;   NOTE: interrupt service routines must preserve
   ;   the values of the A and X CPU registers.
   
   ;---------------------------------------------------
   ; Insert your custom assembly code above this banner
   ;---------------------------------------------------
   
   ;---------------------------------------------------
   ; Insert a lcall to a C function below this banner
   ; and un-comment the lines between these banners
   ;---------------------------------------------------
   
   ;PRESERVE_CPU_CONTEXT
   ;lcall _My_C_Function
   ;RESTORE_CPU_CONTEXT
   
   ;---------------------------------------------------
   ; Insert a lcall to a C function above this banner
   ; and un-comment the lines between these banners
   ;---------------------------------------------------
   ;@PSoC_UserCode_END@ (Do not change this line.)
   reti

;-----------------------------------------------------------------------------
;  FUNCTION NAME: _ADCINC12_1_TMR_ISR
;
;  DESCRIPTION:
;    This routine allows the counter to collect data for 64 timer cycles
;    This routine then holds the integrater in reset for one cycle while
;    the A/D value is calculated.
;
;-----------------------------------------------------------------------------
;
_ADCINC12_1_TMR_ISR:
   dec [ADCINC12_1_cTimerU]
;  if(upper count >0 )
   jz  else1
      reti
   else1:;(upper count decremented to 0)
      tst reg[ADCINC12_1_AtoDcr3],10h
      jz   else2
;     if(A/D has been in reset mode)
         nop                                     ; Dummy statement to keep time
                                             ; between turning on and off counter
                         ; the same.
         mov reg[ADCINC12_1_CounterCR0],(ADCINC12_1_fDBLK_ENABLE|ADCINC12_1_fPULSE_WIDE)    ; Enable Counter
         and reg[ADCINC12_1_AtoDcr3],~10h        ; Enable Analog Integrator
IF ADCINC12_1_NoAZ
         and reg[ADCINC12_1_AtoDcr2],~20h
ENDIF
         mov [ADCINC12_1_cTimerU],(1<<(ADCINC12_1_NUMBITS - 6))
                                                 ; This will be the real counter value
         reti
      else2:;(A/D has been in integrate mode)
         M8C_SetBank1
         and reg[ADCINC12_1_CounterSL], 0x0F     ; Disable input to counter
         M8C_SetBank0

         or  F,01h                               ;Enable the interrupts
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         ; Good place to add code to switch inputs for multiplexed input to ADC
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         ;@PSoC_UserCode_BODY_2@ (Do not change this line.)
         ;---------------------------------------------------
         ; Insert your custom assembly code below this banner
         ;---------------------------------------------------
         ;   NOTE: interrupt service routines must preserve
         ;   the values of the A and X CPU registers.
         
         ;---------------------------------------------------
         ; Insert your custom assembly code above this banner
         ;---------------------------------------------------
         
         ;---------------------------------------------------
         ; Insert a lcall to a C function below this banner
         ; and un-comment the lines between these banners
         ;---------------------------------------------------
         
         ;PRESERVE_CPU_CONTEXT
         ;lcall _My_C_Function
         ;RESTORE_CPU_CONTEXT
         
         ;---------------------------------------------------
         ; Insert a lcall to a C function above this banner
         ; and un-comment the lines between these banners
         ;---------------------------------------------------
         ;@PSoC_UserCode_END@ (Do not change this line.)

IF ADCINC12_1_NoAZ
         or  reg[ADCINC12_1_AtoDcr2],20h         ;Reset Integrator
ENDIF
         or  reg[ADCINC12_1_AtoDcr3],10h
         push A
         mov A, reg[ADCINC12_1_CounterDR0]       ;read Counter
         mov A, reg[ADCINC12_1_CounterDR2]       ;now you really read the data

         mov reg[ADCINC12_1_CounterCR0],00h      ;disable counter
     M8C_SetBank1
         or  reg[ADCINC12_1_CounterSL],ADCINC12_1_CNTINPUT  ; Reconnect counter to comparitor
     M8C_SetBank0


         cpl A
         cmp [ADCINC12_1_cCounterU],(1<<(ADCINC12_1_NUMBITS - 7))
         jnz endif10
;        if(max positive value)
            dec [ADCINC12_1_cCounterU]
            mov A,ffh
         endif10:
         asr [ADCINC12_1_cCounterU]              ; divide by 4
         rrc A
         asr [ADCINC12_1_cCounterU]
         rrc A
;
         mov [(ADCINC12_1_iIncr + HighByte)],[ADCINC12_1_cCounterU]
         mov [(ADCINC12_1_iIncr + LowByte)],A
         mov [ADCINC12_1_fIncr],01h              ;Set AD data flag
         pop A
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         ; User code here for interrupt system.
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

         ;@PSoC_UserCode_BODY_3@ (Do not change this line.)
         ;---------------------------------------------------
         ; Insert your custom assembly code below this banner
         ;---------------------------------------------------
         ;   NOTE: interrupt service routines must preserve
         ;   the values of the A and X CPU registers.
         
         ;---------------------------------------------------
         ; Insert your custom assembly code above this banner
         ;---------------------------------------------------
         
         ;---------------------------------------------------
         ; Insert a lcall to a C function below this banner
         ; and un-comment the lines between these banners
         ;---------------------------------------------------
         
         ;PRESERVE_CPU_CONTEXT
         ;lcall _My_C_Function
         ;RESTORE_CPU_CONTEXT
         
         ;---------------------------------------------------
         ; Insert a lcall to a C function above this banner
         ; and un-comment the lines between these banners
         ;---------------------------------------------------
         ;@PSoC_UserCode_END@ (Do not change this line.)

         cmp [ADCINC12_1_bIncrC],00h
         jz  endif3
;        if(ADCINC12_1_bIncrC is not zero)
            dec [ADCINC12_1_bIncrC]
            jnz endif4
;           if(ADCINC12_1_bIncrC has decremented down to zero to 0)
               mov reg[ADCINC12_1_TimerCR0],00h      ;disable the Timer
               mov reg[ADCINC12_1_CounterCR0],00h    ;disable the Counter
               nop
               nop
               and reg[INT_MSK1],~(ADCINC12_1_TimerMask | ADCINC12_1_CounterMask)
                                                           ;Disable both interrupts
IF ADCINC12_1_NoAZ
               or  reg[ADCINC12_1_AtoDcr2],20h       ;Reset Integrator
ENDIF
               or  reg[ADCINC12_1_AtoDcr3],10h
               reti
            endif4:;
         endif3:;
      endif2:;
      mov [ADCINC12_1_cTimerU],1                     ;Set Timer for one cycle of reset
      mov [ADCINC12_1_cCounterU],(-(1<<(ADCINC12_1_NUMBITS - 7)))  ;Set Counter hardware for easy enable
      mov reg[ADCINC12_1_CounterDR1],ffh
      reti
   endif1:;

; end of file ADCINC12_1INT.asm
