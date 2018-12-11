include "m8c.inc"       ; part specific constants and macros
include "memory.inc"    ; Constants & macros for SMM/LMM and Compiler
include "PSoCAPI.inc"   ; PSoC API definitions for all User Modules

export storeToHistory

area text(ROM)

.SECTION
calculateshortest:
	MOV A,[mem_shorthour]
	CMP A,[hour]
	JNC movingShortest
	JZ checkminShortest
	JC endCalculations
checkminShortest:
	MOV A,[mem_shortmin]
	CMP A,[min]
	JNC movingShortest
	JZ checksecShortest
	JC endCalculations
checksecShortest:
	MOV A,[mem_shortsec]
	CMP A,[sec]
	JNC movingShortest
	JC endCalculations
movingShortest:
	MOV [mem_shorthour],[hour]
	MOV [mem_shortmin],[min]
	MOV [mem_shortsec],[sec]
	JMP endCalculations
	
	
calculatelongest:
	MOV A,[hour]
	CMP A,[mem_longhour]
	JNC movingLongest
	JZ checkminLongest
	JC endCalculations
checkminLongest:
	MOV A,[min]
	CMP A,[mem_longmin]
	JZ checksecLongest
	JNC movingLongest
	JC endCalculations
checksecLongest:
	MOV A,[sec]
	CMP A,[mem_longsec]
	JNC movingLongest
	JC endCalculations
movingLongest:
	MOV [mem_longhour],[hour]
	MOV [mem_longmin],[min]
	MOV [mem_longsec],[sec]
	JMP endCalculations
	
	
calculateaverage:
	MOV A,[mem_avghour]
	ADD A,[hour]
	ASR A
	MOV [mem_avghour],A
	MOV A,[mem_avgmin]
	ADD A,[min]
	ASR A
	MOV [mem_avgmin],A
	MOV A,[mem_avgsec]
	ADD A,[sec]
	ASR A
	MOV [mem_avgsec],A
	

endCalculations:
	ret
.ENDSECTION


.SECTION
storeToHistory:
	cmp [historyCounter],0x01
	jz storeIn1
	cmp [historyCounter],0x02
	jz storeIn2
	cmp [historyCounter],0x03
	jz storeIn3
	cmp [historyCounter],0x04
	jz storeIn4
	cmp [historyCounter],0x05
	jz storeIn5
retFromStoreHistory:
	ret
	

storeIn1:
	mov [mem_sec1],[sec]
	mov [mem_min1],[min]
	mov [mem_hour1],[hour]
	;cmp [mem_shortsec],0x00
	;jz calcForFirstTimeEver
	;jnz callCalculateFuncs
	jmp calcForFirstTimeEver
retFromCalcFirstTimeEver:
	mov [historyCounter],0x02
	jmp retFromStoreHistory
	

calcForFirstTimeEver:
	mov [mem_shortsec],[sec]
	mov [mem_shortmin],[min]
	mov [mem_shorthour],[hour]
	mov [mem_longsec],[sec]
	mov [mem_longmin],[min]
	mov [mem_longhour],[hour]
	mov [mem_avgsec],[sec]
	mov [mem_avgmin],[min]
	mov [mem_avghour],[hour]
	jmp retFromCalcFirstTimeEver
	
callCalculateFuncs:
	call calculateshortest
	call calculatelongest
	call calculateaverage
	jmp retFromCalcFirstTimeEver
	

storeIn2:
	mov [mem_sec2],[sec]
	mov [mem_min2],[min]
	mov [mem_hour2],[hour]
	call calculateshortest
	call calculatelongest
	call calculateaverage
	mov [historyCounter],0x03
	jmp retFromStoreHistory
	
storeIn3:
	mov [mem_sec3],[sec]
	mov [mem_min3],[min]
	mov [mem_hour3],[hour]
	call calculateshortest
	call calculatelongest
	call calculateaverage
	mov [historyCounter],0x04
	jmp retFromStoreHistory
	
storeIn4:
	mov [mem_sec4],[sec]
	mov [mem_min4],[min]
	mov [mem_hour4],[hour]
	call calculateshortest
	call calculatelongest
	call calculateaverage
	mov [historyCounter],0x05
	jmp retFromStoreHistory
	
storeIn5:
	mov [mem_sec5],[sec]
	mov [mem_min5],[min]
	mov [mem_hour5],[hour]
	call calculateshortest
	call calculatelongest
	call calculateaverage
	mov [historyCounter],0x01
	jmp retFromStoreHistory

.ENDSECTION