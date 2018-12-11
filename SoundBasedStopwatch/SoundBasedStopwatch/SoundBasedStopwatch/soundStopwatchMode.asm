include "m8c.inc"       ; part specific constants and macros
include "memory.inc"    ; Constants & macros for SMM/LMM and Compiler
include "PSoCAPI.inc"   ; PSoC API definitions for all User Modules

export startSoundWatchMode

area text(ROM)

.SECTION

readFromSensor1:
	lcall ADCINC12_1_fIsDataAvailable ; If conversion complete....
	jz    readFromSensor1
	lcall ADCINC12_1_iGetData     ; Get result, convert to unsigned and clear flag
    mov   [iResult+1], A
    mov   [iResult+0], X	
    add   [iResult+0], 0x08       ; add 0x0800 to result
    lcall ADCINC12_1_ClearFlag	
	mov A,[threshold_lsb]
	cmp A,[iResult+1]			;check LSB
	jc swap1
	mov A,[threshold_msb]
	cmp A,[iResult+0]			;check MSB
	jc swap1
endOfReadFromSensor1:
	ret
swap1:
	mov [watchSwitch],0x00
	jmp endOfReadFromSensor1


readFromSensor2:
	lcall ADCINC12_1_fIsDataAvailable ; If conversion complete....
	jz    readFromSensor2
	lcall ADCINC12_1_iGetData     ; Get result, convert to unsigned and clear flag
    mov   [iResult+1], A
    mov   [iResult+0], X	
    add   [iResult+0], 0x08       ; add 0x0800 to result
    lcall ADCINC12_1_ClearFlag	
	mov A,[threshold_lsb]
	cmp A,[iResult+1]			;check LSB
	jc swap2
	mov A,[threshold_msb]
	cmp A,[iResult+0]			;check MSB
	jc swap2
endOfReadFromSensor2:
	ret
swap2:
	mov [watchSwitch],0x01
	jmp endOfReadFromSensor2
	

startSoundWatchMode:
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString20
   	mov   X, <sRomString20
   	lcall LCD_1_PrCString         ; Display string
	mov   A, 1                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString1
   	mov   X, <sRomString1
   	lcall LCD_1_PrCString         ; Display string	

	call readFromSensor1
	cmp [modeSwitch],0x01
	jz soundWatchModeEnd
	cmp [watchSwitch],0x00
	jz startWatch
	cmp [watchSwitch],0x02
	jz startSoundWatchMode


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
	jz startWatchRes2
	cmp [accuracy],0x04
	jz startWatchRes3
	
stopWatch:
	mov [milisec], 0x00
	mov [msec], 0x00
	mov [sec], 0x00
	mov [min], 0x00
	mov [hour], 0x00
	
	call readFromSensor1
	cmp [modeSwitch],0x01
	jz soundWatchModeEnd		
	cmp [watchSwitch],0x00
	jz startWatch
	cmp [watchSwitch],0x01
	jz stopWatch


; 1 sec resolution stopwatch function
startWatchRes1:
	lcall Timer32_1_EnableInt				
	lcall Timer32_1_Start
	call readFromSensor2
	cmp [watchSwitch],0x00         
	jz startWatchRes1
	lcall Timer32_1_Stop
	lcall storeToHistory
	jmp stopWatch


; 1/2 sec resolution stopwatch function
startWatchRes2:
	lcall Timer16_1_EnableInt
	lcall Timer16_1_Start
	call readFromSensor2
	cmp [watchSwitch],0x00
	jz startWatchRes2
	lcall Timer16_1_Stop
	lcall storeToHistory
	jmp stopWatch


; 1/10 sec resolution stopwatch function
startWatchRes3:
	lcall Timer16_2_EnableInt				
	lcall Timer16_2_Start
	call readFromSensor2
	cmp [watchSwitch],0x00
	jz startWatchRes3
	lcall Timer16_2_Stop
	lcall storeToHistory
	jmp stopWatch

	
soundWatchModeEnd:
	lcall LCD_1_Init
	ret

.ENDSECTION
