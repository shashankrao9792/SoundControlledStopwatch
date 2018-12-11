;-----------------------------------------------------------------------------
; Assembly main line
;-----------------------------------------------------------------------------

include "m8c.inc"       ; part specific constants and macros
include "memory.inc"    ; Constants & macros for SMM/LMM and Compiler
include "PSoCAPI.inc"   ; PSoC API definitions for all User Modules

area bss(RAM)

msec:: 		BLK 1
milisec:: 	BLK 1
sec:: 		BLK 1
min:: 		BLK 1
hour:: 		BLK 1

watchSwitch:: 	BLK 1
modeSwitch:: 	BLK 1
modeCounter: 	BLK 1

accuracy::	 	BLK 1

historyCounter::BLK 1

mem_sec1:: 		BLK 1
mem_min1:: 		BLK 1
mem_hour1:: 	BLK 1

mem_sec2:: 		BLK 1
mem_min2:: 		BLK 1
mem_hour2::		BLK 1

mem_sec3:: 		BLK 1
mem_min3:: 		BLK 1
mem_hour3::		BLK 1

mem_sec4:: 		BLK 1
mem_min4:: 		BLK 1
mem_hour4::		BLK 1

mem_sec5:: 		BLK 1
mem_min5:: 		BLK 1
mem_hour5::		BLK 1

mem_shortsec:: 	BLK 1
mem_shortmin:: 	BLK 1
mem_shorthour::	BLK 1

mem_longsec:: 	BLK 1
mem_longmin:: 	BLK 1
mem_longhour:: 	BLK 1

mem_avgsec:: 	BLK 1
mem_avgmin:: 	BLK 1
mem_avghour:: 	BLK 1

iResult::		BLK 2                ; ADC result variable
threshold_msb::	BLK 1
threshold_lsb::	BLK 1


area text(ROM,REL)

export _main:

_main:

	mov [watchSwitch],0x00
	mov [modeSwitch],0x00
	mov [modeCounter],0x01
	mov [accuracy],0x01
	mov [historyCounter],0x01
	
	mov [milisec], 0x00
	mov [msec], 0x00
	mov [sec], 0x00
	mov [min], 0x00
	mov [hour], 0x00
	
	mov [mem_sec1],0x00
	mov [mem_min1],0x00
	mov [mem_hour1],0x00
	mov [mem_sec2],0x00
	mov [mem_min2],0x00
	mov [mem_hour2],0x00
	mov [mem_sec3],0x00
	mov [mem_min3],0x00
	mov [mem_hour3],0x00
	mov [mem_sec4],0x00
	mov [mem_min4],0x00
	mov [mem_hour4],0x00
	mov [mem_sec5],0x00
	mov [mem_min5],0x00
	mov [mem_hour5],0x00
	mov [mem_shortsec],0x00
	mov [mem_shortmin],0x00
	mov [mem_shorthour],0x00
	mov [mem_longsec],0x00
	mov [mem_longmin],0x00
	mov [mem_longhour],0x00
	mov [mem_avgsec],0x00
	mov [mem_avgmin],0x00
	mov [mem_avghour],0x00
	
	mov [threshold_lsb],0x15
	mov [threshold_msb],0x01
	
	mov   A, PGA_1_MEDPOWER
    lcall PGA_1_Start             ; Turn on PGA power
    mov   A, ADCINC12_1_MEDPOWER
    lcall ADCINC12_1_Start        ; Turn on ADC power
    mov   A, 0
    lcall ADCINC12_1_GetSamples   ; Sample forever

	lcall LED_1_Start
	lcall LED_2_Start
	lcall LED_3_Start
	lcall LED_4_Start
	
	lcall LCD_1_Start             ; Init the LCD
	
	M8C_SetBank0
	or reg[PRT1IE], 0x01
	
	M8C_EnableGInt
	M8C_EnableIntMask INT_MSK0, INT_MSK0_GPIO
	
	
mainloop:
	mov   A, 0                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString20
   	mov   X, <sRomString20
   	lcall LCD_1_PrCString         ; Display string
	mov   A, 1                    ; row
   	mov   X, 0                    ; column
   	lcall LCD_1_Position
   	mov   A, >sRomString21
   	mov   X, <sRomString21
   	lcall LCD_1_PrCString         ; Display string

	cmp [modeSwitch],0x01
	jz switchMode
	
	cmp [watchSwitch],0x01
	jz mainloop
	
	cmp [watchSwitch],0x00
	jz mainloop
	

switchMode:
	mov [modeSwitch],0x00
	cmp [modeCounter],0x01
	jz stopWatchMode
	cmp [modeCounter],0x02
	jz accuracyMode
	cmp [modeCounter],0x03
	jz memoryMode
	cmp [modeCounter],0x04
	jz soundSensitivityMode
	cmp [modeCounter],0x05
	jz soundWatchMode
	
	

stopWatchMode:
	lcall LED_1_On
	mov [modeCounter],0x02
	lcall stopWatchModeStart
	mov [modeSwitch],0x00
	lcall LED_1_Off
	jmp switchMode


accuracyMode:
	lcall LED_2_On
	mov [modeCounter],0x03
	lcall accuracyModeStart
	mov [modeSwitch],0x00
	lcall LED_2_Off
	jmp switchMode
	
	
memoryMode:
	lcall LED_3_On
	mov [modeCounter],0x04
	lcall displayMemHistory
	mov [modeSwitch],0x00
	lcall LED_3_Off
	jmp switchMode
	
	
soundSensitivityMode:
	lcall LED_4_On
	mov [modeCounter],0x05
	lcall startSoundSensitivityMode
	mov [modeSwitch],0x00
	lcall LED_4_Off
	jmp switchMode


soundWatchMode:
	lcall LED_1_On
	lcall LED_3_On
	mov [modeCounter],0x00
	lcall startSoundWatchMode
	mov [modeSwitch],0x00
	lcall LED_1_Off
	lcall LED_3_Off
	jmp switchMode

area    lit

.LITERAL
sRomString1::
DS "Stopwatch Mode: "
db 00h
.ENDLITERAL

.LITERAL
sRomString2::
DS ":"
db 00h
.ENDLITERAL

.LITERAL
sRomString3::
DS "."
db 00h	
.ENDLITERAL

.LITERAL
sRomString4::
DS ".00"
db 00h
.ENDLITERAL

.LITERAL
sRomString5::
DS "Accuracy Mode: "
db 00h
.ENDLITERAL

.LITERAL
sRomString6::
DS "1 second       "
db 00h
.ENDLITERAL

.LITERAL
sRomString7::
DS "1/2 second     "
db 00h
.ENDLITERAL

.LITERAL
sRomString8::
DS "1/10 second    "
db 00h
.ENDLITERAL

.LITERAL
sRomString9::
DS "Memory Mode:   "
db 00h
.ENDLITERAL

.LITERAL
sRomString10::
DS "SavedReading 1:"
db 00h
.ENDLITERAL

.LITERAL
sRomString11::
DS "SavedReading 2:"
db 00h
.ENDLITERAL

.LITERAL
sRomString12::
DS "SavedReading 3:"
db 00h
.ENDLITERAL

.LITERAL
sRomString13::
DS "SavedReading 4:"
db 00h
.ENDLITERAL

.LITERAL
sRomString14::
DS "SavedReading 5:"
db 00h
.ENDLITERAL

.LITERAL
sRomString15::
DS "ShortestReading"
db 00h
.ENDLITERAL

.LITERAL
sRomString16::
DS "LongestReading:"
db 00h
.ENDLITERAL

.LITERAL
sRomString17::
DS "AvgOfReadings: "
db 00h
.ENDLITERAL

.LITERAL
sRomString18::
DS "Resolution=    "
db 00h
.ENDLITERAL

.LITERAL
sRomString19::
DS "Push Button    "
db 00h
.ENDLITERAL

.LITERAL
sRomString20::
DS "Sound-Control  "
db 00h
.ENDLITERAL

.LITERAL
sRomString21::
DS "Stopwatch      "
db 00h
.ENDLITERAL

.LITERAL
sRomString22::
DS "00000"
db 00h
.ENDLITERAL

.LITERAL
sRomString23::
DS "StopWatch Disp:"
db 00h
.ENDLITERAL

.LITERAL
sRomString24::
DS "Sound Sensi-   "
db 00h
.ENDLITERAL

.LITERAL
sRomString25::
DS "tivity Mode:   "
db 00h
.ENDLITERAL

.LITERAL
sRomString26::
DS "Detecting val: "
db 00h
.ENDLITERAL

.LITERAL
sRomString27::
DS "Sound-based    "
db 00h
.ENDLITERAL

.LITERAL
sRomString28::
DS "No history!    "
db 00h
.ENDLITERAL

.LITERAL
sRomString29::
DS "0"
db 00h
.ENDLITERAL

.terminate:
    jmp .terminate
