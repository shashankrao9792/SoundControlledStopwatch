
include "m8c.inc"       ; part specific constants and macros
include "memory.inc"    ; Constants & macros for SMM/LMM and Compiler
include "PSoCAPI.inc"   ; PSoC API definitions for all User Modules

export displayMemHistory

area text(ROM)


.SECTION
displayMemHistory:
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString9
   	mov   X, <sRomString9
   	lcall LCD_1_PrCString         ; Display string
	
	cmp [modeSwitch],0x01
	jz endMemoryMode

	cmp [watchSwitch],0x00
	jz checkFordisplayHistory1

	cmp [watchSwitch],0x02
	jz displayMemHistory
	
checkFordisplayHistory1:
	cmp [mem_sec1],0x00
	jnz displayHistory1
	cmp [mem_min1],0x00
	jnz displayHistory1
	cmp [mem_hour1],0x00
	jnz displayHistory1

	mov   A, 1                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString28
   	mov   X, <sRomString28
   	lcall LCD_1_PrCString         ; Display string
	jmp displayMemHistory

displayHistory1:
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString10
   	mov   X, <sRomString10
   	lcall LCD_1_PrCString         ; Display string
	;   hour
   	mov   A, 1                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_hour1]
   	lcall LCD_1_PrHexByte
	;  :
	mov   A, 1                    ; row
   	mov   X, 2                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString2
   	mov   X, <sRomString2
	lcall LCD_1_PrCString         ; Display string
	;  min
	mov   A, 1                    ; row
   	mov   X, 3                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_min1]
   	lcall LCD_1_PrHexByte
	;   :
	mov   A, 1                    ; row
   	mov   X, 5                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString2
   	mov   X, <sRomString2
	lcall LCD_1_PrCString         ; Display string
	;  sec
	mov   A, 1                    ; row
   	mov   X, 6                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_sec1]
   	lcall LCD_1_PrHexByte

	cmp [modeSwitch],0x01
	jz endMemoryMode

	cmp [watchSwitch],0x01
	jz checkFordisplayHistory2

	cmp [watchSwitch],0x00
	jz displayHistory1
	
checkFordisplayHistory2:
	cmp [mem_sec2],0x00
	jnz displayHistory2
	cmp [mem_min2],0x00
	jnz displayHistory2
	cmp [mem_hour2],0x00
	jnz displayHistory2
	jmp displayShortest

displayHistory2:
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString11
   	mov   X, <sRomString11
   	lcall LCD_1_PrCString         ; Display string
	;   hour
   	mov   A, 1                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_hour2]
   	lcall LCD_1_PrHexByte
	;  :
	mov   A, 1                    ; row
   	mov   X, 2                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString2
   	mov   X, <sRomString2
	lcall LCD_1_PrCString         ; Display string
	;  min
	mov   A, 1                    ; row
   	mov   X, 3                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_min2]
   	lcall LCD_1_PrHexByte
	;   :
	mov   A, 1                    ; row
   	mov   X, 5                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString2
   	mov   X, <sRomString2
	lcall LCD_1_PrCString         ; Display string
	;  sec
	mov   A, 1                    ; row
   	mov   X, 6                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_sec2]
   	lcall LCD_1_PrHexByte

	cmp [modeSwitch],0x01
	jz endMemoryMode

	cmp [watchSwitch],0x00
	jz checkFordisplayHistory3
	
	cmp [watchSwitch],0x01
	jz displayHistory2

checkFordisplayHistory3:
	cmp [mem_sec3],0x00
	jnz displayHistory3
	cmp [mem_min3],0x00
	jnz displayHistory3
	cmp [mem_hour3],0x00
	jnz displayHistory3
	jmp displayShortest


displayHistory3:
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString12
   	mov   X, <sRomString12
   	lcall LCD_1_PrCString         ; Display string
	;   hour
   	mov   A, 1                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_hour3]
   	lcall LCD_1_PrHexByte
	;  :
	mov   A, 1                    ; row
   	mov   X, 2                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString2
   	mov   X, <sRomString2
	lcall LCD_1_PrCString         ; Display string
	;  min
	mov   A, 1                    ; row
   	mov   X, 3                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_min3]
   	lcall LCD_1_PrHexByte
	;   :
	mov   A, 1                    ; row
   	mov   X, 5                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString2
   	mov   X, <sRomString2
	lcall LCD_1_PrCString         ; Display string
	;  sec
	mov   A, 1                    ; row
   	mov   X, 6                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_sec3]
   	lcall LCD_1_PrHexByte

	cmp [modeSwitch],0x01
	jz endMemoryMode
	
	cmp [watchSwitch],0x01
	jz checkFordisplayHistory4

	cmp [watchSwitch],0x00
	jz displayHistory3

checkFordisplayHistory4:
	cmp [mem_sec4],0x00
	jnz displayHistory4
	cmp [mem_min4],0x00
	jnz displayHistory4
	cmp [mem_hour4],0x00
	jnz displayHistory4
	jmp displayShortest

displayHistory4:
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString13
   	mov   X, <sRomString13
   	lcall LCD_1_PrCString         ; Display string
	;   hour
   	mov   A, 1                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_hour4]
   	lcall LCD_1_PrHexByte
	;  :
	mov   A, 1                    ; row
   	mov   X, 2                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString2
   	mov   X, <sRomString2
	lcall LCD_1_PrCString         ; Display string
	;  min
	mov   A, 1                    ; row
   	mov   X, 3                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_min4]
   	lcall LCD_1_PrHexByte
	;   :
	mov   A, 1                    ; row
   	mov   X, 5                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString2
   	mov   X, <sRomString2
	lcall LCD_1_PrCString         ; Display string
	;  sec
	mov   A, 1                    ; row
   	mov   X, 6                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_sec4]
   	lcall LCD_1_PrHexByte

	cmp [modeSwitch],0x01
	jz endMemoryMode
	
	cmp [watchSwitch],0x00
	jz checkFordisplayHistory5
	
	cmp [watchSwitch],0x01
	jz displayHistory4

checkFordisplayHistory5:
	cmp [mem_sec5],0x00
	jnz displayHistory5
	cmp [mem_min5],0x00
	jnz displayHistory5
	cmp [mem_hour5],0x00
	jnz displayHistory5
	jmp displayShortest

displayHistory5:
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString14
   	mov   X, <sRomString14
   	lcall LCD_1_PrCString         ; Display string
	;   hour
   	mov   A, 1                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_hour5]
   	lcall LCD_1_PrHexByte
	;  :
	mov   A, 1                    ; row
   	mov   X, 2                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString2
   	mov   X, <sRomString2
	lcall LCD_1_PrCString         ; Display string
	;  min
	mov   A, 1                    ; row
   	mov   X, 3                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_min5]
   	lcall LCD_1_PrHexByte
	;   :
	mov   A, 1                    ; row
   	mov   X, 5                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString2
   	mov   X, <sRomString2
	lcall LCD_1_PrCString         ; Display string
	;  sec
	mov   A, 1                    ; row
   	mov   X, 6                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_sec5]
   	lcall LCD_1_PrHexByte

	cmp [modeSwitch],0x01
	jz endMemoryMode

	cmp [watchSwitch],0x01
	jz displayShortest

	cmp [watchSwitch],0x00
	jz displayHistory5



displayShortest:
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString15
   	mov   X, <sRomString15
   	lcall LCD_1_PrCString         ; Display string
	;   hour
   	mov   A, 1                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_shorthour]
   	lcall LCD_1_PrHexByte
	;  :
	mov   A, 1                    ; row
   	mov   X, 2                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString2
   	mov   X, <sRomString2
	lcall LCD_1_PrCString         ; Display string
	;  min
	mov   A, 1                    ; row
   	mov   X, 3                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_shortmin]
   	lcall LCD_1_PrHexByte
	;   :
	mov   A, 1                    ; row
   	mov   X, 5                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString2
   	mov   X, <sRomString2
	lcall LCD_1_PrCString         ; Display string
	;  sec
	mov   A, 1                    ; row
   	mov   X, 6                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_shortsec]
   	lcall LCD_1_PrHexByte

	cmp [modeSwitch],0x01
	jz endMemoryMode

	cmp [watchSwitch],0x00
	jz displayLongest

	cmp [watchSwitch],0x01
	jz displayShortest



displayLongest:
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString16
   	mov   X, <sRomString16
   	lcall LCD_1_PrCString         ; Display string
	;   hour
   	mov   A, 1                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_longhour]
   	lcall LCD_1_PrHexByte
	;  :
	mov   A, 1                    ; row
   	mov   X, 2                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString2
   	mov   X, <sRomString2
	lcall LCD_1_PrCString         ; Display string
	;  min
	mov   A, 1                    ; row
   	mov   X, 3                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_longmin]
   	lcall LCD_1_PrHexByte
	;   :
	mov   A, 1                    ; row
   	mov   X, 5                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString2
   	mov   X, <sRomString2
	lcall LCD_1_PrCString         ; Display string
	;  sec
	mov   A, 1                    ; row
   	mov   X, 6                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_longsec]
   	lcall LCD_1_PrHexByte

	cmp [modeSwitch],0x01
	jz endMemoryMode

	cmp [watchSwitch],0x01
	jz displayAverage

	cmp [watchSwitch],0x00
	jz displayLongest



displayAverage:
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString17
   	mov   X, <sRomString17
   	lcall LCD_1_PrCString         ; Display string
	;   hour
   	mov   A, 1                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_avghour]
   	lcall LCD_1_PrHexByte
	;  :
	mov   A, 1                    ; row
   	mov   X, 2                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString2
   	mov   X, <sRomString2
	lcall LCD_1_PrCString         ; Display string
	;  min
	mov   A, 1                    ; row
   	mov   X, 3                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_avgmin]
   	lcall LCD_1_PrHexByte
	;   :
	mov   A, 1                    ; row
   	mov   X, 5                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString2
   	mov   X, <sRomString2
	lcall LCD_1_PrCString         ; Display string
	;  sec
	mov   A, 1                    ; row
   	mov   X, 6                    ; column
   	lcall LCD_1_Position          ; display result in hex 
   	mov A,[mem_avgsec]
   	lcall LCD_1_PrHexByte

	cmp [modeSwitch],0x01
	jz endMemoryMode

	cmp [watchSwitch],0x00
	jz displayHistory1

	cmp [watchSwitch],0x01
	jz displayAverage


endMemoryMode:
	lcall LCD_1_Init
	ret
.ENDSECTION
