	B part3 ; part1 or part2 or part3

buffer	DEFS 100,0

s1	DEFB "one\0"
	ALIGN
s2	DEFB "two\0"
	ALIGN
s3	DEFB "three\0"
	ALIGN
s4	DEFB "four\0"
	ALIGN
s5	DEFB "five\0"
	ALIGN
s6	DEFB "six\0"
	ALIGN
s7	DEFB "seven\0"
	ALIGN
s8	DEFB "twentytwo\0"
	ALIGN
s9	DEFB "twenty\0"
	ALIGN

;************************** part 1 **************************
printstring
	LDRB R0, [R1], #1; Load into R0 the value at R1 and after having executed this increment R1 to get it ready for the next loop cycle
	CMP R0, #0 ;Compare the character R0 to 0
	SVCNE 0 ;If the character is not 0 output it
 BNE printstring ; If the character is not 0 loop
; your code goes here, replacing the previous 2 lines
	MOV  R0, #10	; given - output end-of-line
	SVC  0		; given
	MOV  PC, LR	; given

;************************** part 2 ***************************
strcat
	; your code goes here
	; R2 will hold the address of string2
	; R1 will hold the address of string1
	; R0 will hold a character
	; What we are trying to do in python is string1 = string1 + string2
	; So hence we have to find the address of character 0 and start replacing from it with the characters from string2
findStopCharacter
	LDRB R0, [R1], #1 ; We are going to load R0 with the character currently referenced by the address in R1 and then increment R1 by 1 to get it ready for the next loop cycle
	CMP R0, #0 ; We are going to compare the character in R0 with 0 to check if we have reached the end of string1 and 0 references the stop character
	BNE findStopCharacter; If we haven't reached the end of string1 i.e haven't reached the stop character 0 in string1 keep looping so that R1 will end up with the adr(string1StopCharacter) + 1
	SUB R1, R1, #1 ;Subtract one from R1 as R1 will now point to the address 1 ahead of the stop character

copyString
 LDRB R0, [R2], #1 ; We are going to load R0 with the character currently referenced by the address in R2 and then increment R2 by 1 to get it ready for the next loop cycle
	CMP R0, #0 ;Compare that character to R0 to check whether we have reached the stop character
	STRB R0, [R1], #1 ;We will then append the character from string2 (held in R0), to the end of string1 (the address of the end of string1 is held in R1) and then we will increment R1 to be ready for the loop cycle
	BNE copyString; If the character was not the end of string character 0 in string2 branch back to strcpy and repeat the loop
	MOV  PC, LR

strcpy
	LDRB R0, [R2], #1 ;Let R0 hold the current character being referenced by R2
	CMP R0, #0 ;Compare that character to R0
	STRB R0, [R1], #1 ;If that character is not zero hence we have not reached the end of string store it in the memory addressed referenced by R1 (string2) and then increment R1 by 1 to prepare it for the next cycle
	BNE strcpy; If the character was not the end of string character 0 branch back to strcpy and repeat the loop
	MOV  PC, LR

;************************** part 3 **************************
sorted	STR LR, return2	; given
; your code goes here
	;R2 will hold the address of string1
	;R3 will hold the address of string2
	;R4 will hold the current character for string1
	;R5 will hold the current character for string2
	;R6 will hold the current address of string string1
	;R7 will hold the current address of string string2
	loop
		LDRB R4, [R2], #1 ;Let R4 hold the current character for string1 and then increment R2 to get it ready for the next cycle after this operation has completed
		LDRB R5, [R3], #1 ;Let R5 hold the current character for string2 and then increment R3 to get it ready for the next loop cycle after this operation has completed
		CMP R4, #0
		BEQ loopExit
		CMP R5, #0
		BEQ loopExit
		CMP R4, R5
		BEQ loop 
	loopExit
		CMP R4, R5
	LDR  PC, return2 ; given
return2 DEFW 0		; given

;*********************** the various parts ********************
part1	ADR R1, s1
	BL  printstring
	ADR R1, s2
	BL  printstring
	ADR R1, s3
	BL  printstring
	ADR R1, s4
	BL  printstring
	ADR R1, s5
	BL  printstring
	ADR R1, s6
	BL  printstring
	ADR R1, s7
	BL  printstring
	ADR R1, s8
	BL  printstring
	ADR R1, s9
	BL  printstring
	SVC 2

part2	ADR R2, s1
	ADR R1, buffer
	BL  strcpy
	ADR R1, buffer
	BL  printstring
	ADR R2, s2
	ADR R1, buffer
	BL  strcat
	ADR R1, buffer
	BL  printstring
	ADR R2, s3
	ADR R1, buffer
	BL  strcat
	ADR R1, buffer
	BL  printstring
	SVC 2

; used by part3
return4 DEFW 0,0
test2	STR LR, return4		; This mechanism will be improved later
	STR R3, return4+4	; Assembler will evaluate addition	
	MOV R0, R2
	SVC 3
	BL  sorted
	MOVLT R0, #'<'		; Three-way IF using conditions
	MOVEQ R0, #'='
	MOVGT R0, #'>'
	SVC 0
	LDR R0, return4+4
	SVC 3
	MOV R0, #10
	SVC 0
	LDR PC, return4

part3	ADR R2, s1
	ADR R3, s2
	BL  test2
	ADR R2, s2
	ADR R3, s3
	BL  test2
	ADR R2, s3
	ADR R3, s4
	BL  test2
	ADR R2, s4
	ADR R3, s5
	BL  test2
	ADR R2, s5
	ADR R3, s6
	BL  test2
	ADR R2, s6
	ADR R3, s7
	BL  test2
	ADR R2, s7
	ADR R3, s8
	BL  test2
	ADR R2, s8
	ADR R3, s9
	BL  test2
	ADR R2, s8
	ADR R3, s8
	BL  test2
	SVC 2
