include "m8c.inc"       ; part specific constants and macros
include "memory.inc"    ; Constants & macros for SMM/LMM and Compiler
include "PSoCAPI.inc"   ; PSoC API definitions for all User Modules

export startSoundSensitivityMode

area text(ROM)

.SECTION
startSoundSensitivityMode:
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString24
   	mov   X, <sRomString24
   	lcall LCD_1_PrCString         ; Display string
	mov   A, 1                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString25
   	mov   X, <sRomString25
   	lcall LCD_1_PrCString         ; Display string	
	
	cmp [modeSwitch],0x01
	jz soundSensitivityModeEnd
	
	cmp [watchSwitch],0x00
	jz startThresholdDetection
	
	cmp [watchSwitch],0x02
	jz startSoundSensitivityMode
	

startThresholdDetection:
	lcall LCD_1_Init
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString26
   	mov   X, <sRomString26
   	lcall LCD_1_PrCString         ; Display string
	
	mov A,0xFF
	lcall Delay10msTimes	

loop1:
	lcall ADCINC12_1_fIsDataAvailable ; If conversion complete....
    jz    loop1

    lcall ADCINC12_1_iGetData     ; Get result, convert to unsigned and clear flag
    mov   [threshold_lsb], A
    mov   [threshold_msb], X	
    add   [threshold_msb], 0x08       ; add 0x0800 to result
    lcall ADCINC12_1_ClearFlag
	mov [threshold_lsb],0x03
	asl [threshold_lsb]
	mov   A, 1                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov A,[threshold_lsb]
   	lcall LCD_1_PrHexByte
	
	jmp waitForShortPress


waitForShortPress:
	cmp [modeSwitch],0x01
	jz soundSensitivityModeEnd

	cmp [watchSwitch],0x01
	jz soundSensitivityModeEnd

	cmp [watchSwitch],0x00
	jz waitForShortPress
	

soundSensitivityModeEnd:
	lcall LCD_1_Init
	ret

.ENDSECTION
