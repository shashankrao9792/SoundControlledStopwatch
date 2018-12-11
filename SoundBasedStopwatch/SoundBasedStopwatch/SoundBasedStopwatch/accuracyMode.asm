
include "m8c.inc"       ; part specific constants and macros
include "memory.inc"    ; Constants & macros for SMM/LMM and Compiler
include "PSoCAPI.inc"   ; PSoC API definitions for all User Modules

export accuracyModeStart

area text(ROM)

.SECTION
accuracyModeStart:
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString5
   	mov   X, <sRomString5
   	lcall LCD_1_PrCString         ; Display string	
	
	cmp [modeSwitch],0x01
	jz accuracyModeEnd

	cmp [watchSwitch],0x00
	jz accuracy1

	cmp [watchSwitch],0x02
	jz accuracyModeStart
	
accuracy1:
	mov [accuracy], 0x01
	
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString18
   	mov   X, <sRomString18
   	lcall LCD_1_PrCString         ; Display string
	mov   A, 1                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString6
   	mov   X, <sRomString6
   	lcall LCD_1_PrCString         ; Display string
	
	cmp [modeSwitch],0x01
	jz accuracyModeEnd
	
	cmp [watchSwitch],0x01
	jz accuracy2
	
	cmp [watchSwitch],0x00
	jz accuracy1
	
		
accuracy2:
	mov [accuracy], 0x02
	
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString18
   	mov   X, <sRomString18
   	lcall LCD_1_PrCString         ; Display string
	mov   A, 1                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString7
   	mov   X, <sRomString7
   	lcall LCD_1_PrCString         ; Display string
	
	cmp [modeSwitch],0x01
	jz accuracyModeEnd
	
	cmp [watchSwitch],0x00
	jz accuracy3
	
	cmp [watchSwitch],0x01
	jz accuracy2
	
	
accuracy3:
	mov [accuracy], 0x04
	
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString18
   	mov   X, <sRomString18
   	lcall LCD_1_PrCString         ; Display string
	mov   A, 1                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString8
   	mov   X, <sRomString8
   	lcall LCD_1_PrCString         ; Display string
	
	cmp [modeSwitch],0x01
	jz accuracyModeEnd
	
	cmp [watchSwitch],0x01
	jz resetBeforeAccuracy1
	
	cmp [watchSwitch],0x00
	jz accuracy3
	
resetBeforeAccuracy1:
	mov [watchSwitch],0x00
	jmp accuracy1
		
accuracyModeEnd:
	lcall LCD_1_Init
	ret

.ENDSECTION
