
include "m8c.inc"       ; part specific constants and macros
include "memory.inc"    ; Constants & macros for SMM/LMM and Compiler
include "PSoCAPI.inc"   ; PSoC API definitions for all User Modules

export stopWatchModeStart

area text(ROM)

.SECTION
stopWatchModeStart:
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString19
   	mov   X, <sRomString19
   	lcall LCD_1_PrCString         ; Display string
	mov   A, 1                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString1
   	mov   X, <sRomString1
   	lcall LCD_1_PrCString         ; Display string	
	
	cmp [modeSwitch],0x01
	jz stopWatchModeEnd
	
	cmp [watchSwitch],0x00
	jz startWatch
	
	cmp [watchSwitch],0x02
	jz stopWatchModeStart

startWatch:	
	lcall LCD_1_Init
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString23
   	mov   X, <sRomString23
   	lcall LCD_1_PrCString         ; Display string
	
	cmp [accuracy],0x01
	jz startWatchRes1
	cmp [accuracy],0x02
	jz startWatchRes2Call
	cmp [accuracy],0x04
	jz startWatchRes3Call
	
startWatchRes2Call:
	call startWatchRes2
	jmp stopWatch
	
startWatchRes3Call:
	call startWatchRes3
	jmp stopWatch
	
stopWatch:
	mov [milisec], 0x00
	mov [msec], 0x00
	mov [sec], 0x00
	mov [min], 0x00
	mov [hour], 0x00
		
	cmp [modeSwitch],0x01
	jz stopWatchModeEnd
	
	cmp [watchSwitch],0x00
	jz startWatch
	
	cmp [watchSwitch],0x01
	jz stopWatch



; 1 sec resolution stopwatch function
startWatchRes1:
	lcall Timer32_1_EnableInt				
	lcall Timer32_1_Start
	cmp [watchSwitch],0x00
	jz startWatchRes1
	lcall Timer32_1_Stop
	lcall storeToHistory
	jmp stopWatch


; 1/2 sec resolution stopwatch function
startWatchRes2:
	lcall Timer16_1_EnableInt
	lcall Timer16_1_Start
	cmp [watchSwitch],0x00
	jz startWatchRes2
	lcall Timer16_1_Stop
	lcall storeToHistory
	ret


; 1/10 sec resolution stopwatch function
startWatchRes3:
	lcall Timer16_2_EnableInt				
	lcall Timer16_2_Start
	cmp [watchSwitch],0x00
	jz startWatchRes3
	lcall Timer16_2_Stop
	lcall storeToHistory
	ret

	
stopWatchModeEnd:
	lcall LCD_1_Init
	ret

.ENDSECTION
