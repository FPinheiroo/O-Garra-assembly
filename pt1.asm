; --- Mapeamento de Hardware (8051) ---
RS      equ     P1.3    ;Reg Select ligado em P1.3
EN      equ     P1.2    ;Enable ligado em P1.2

org 0000h
    LJMP START

org 0030h
FEI:
    DB "JOGO"
    DB 00h ;Marca null no fim da String

org 0040h
DISPLAY:
    DB "DA GARRA"
    DB 00h ;Marca null no fim da String

org 0050h
GARRA:
    DB "^"
    DB 00h ;Marca null no fim da String

org 0060h
PREMIO1:
    DB "$"
    DB 00h
org 0070h ;Marca null no fim da String
PREMIO2:
    DB "$"
    DB 00h ;Marca null no fim da String
org 0070h ;Marca null no fim da String
PREMIO3:
    DB "$"
    DB 00h ;Marca null no fim da String
org 0070h ;Marca null no fim da String
PREMIO4:
    DB "$"
    DB 00h ;Marca null no fim da String
org 0070h ;Marca null no fim da String
PREMIO5:
    DB "$"
    DB 00h ;Marca null no fim da String
org 0070h ;Marca null no fim da String
PREMIO6:
    DB "$"
    DB 00h ;Marca null no fim da String
org 0070h ;Marca null no fim da String
PREMIO7:
    DB "$"
    DB 00h ;Marca null no fim da String
org 0070h ;Marca null no fim da String
PREMIO8:
    DB "$"
    DB 00h ;Marca null no fim da String
org 0070h ;Marca null no fim da String
;MAIN
org 0100h
START:

main:
    ACALL lcd_init
    MOV A, #06h
    ACALL posicionaCursor
    MOV DPTR,#FEI            ;endereço inicial de memória da String FEI
    ACALL escreveStringROM
    MOV A, #44h
    ACALL posicionaCursor
    MOV DPTR,#DISPLAY            ;endereço inicial de memória da String Display LCD
    ACALL escreveStringROM
    ACALL clearDisplay
    MOV A, #07H;#0C0h ; Seta endereço de memória para segunda linha do LCD
    ACALL posicionaCursor
    MOV DPTR, #GARRA ; Endereço inicial da string GARRA
    ACALL escreveStringROM
    MOV A, #40H;#04Eh ; Seta endereço de memória para a próxima linha do LCD
    ACALL posicionaCursor
    MOV DPTR, #PREMIO1 ; Endereço inicial da string PREMIOS
    ACALL escreveStringROM
MOV A, #42H;#04Eh ; Seta endereço de memória para a próxima linha do LCD
    ACALL posicionaCursor
    MOV DPTR, #PREMIO2 ; Endereço inicial da string PREMIOS
    ACALL escreveStringROM
MOV A, #44H;#04Eh ; Seta endereço de memória para a próxima linha do LCD
    ACALL posicionaCursor
    MOV DPTR, #PREMIO3 ; Endereço inicial da string PREMIOS
    ACALL escreveStringROM
MOV A, #46H;#04Eh ; Seta endereço de memória para a próxima linha do LCD
    ACALL posicionaCursor
    MOV DPTR, #PREMIO4 ; Endereço inicial da string PREMIOS
    ACALL escreveStringROM
MOV A, #48H;#04Eh ; Seta endereço de memória para a próxima linha do LCD
    ACALL posicionaCursor
    MOV DPTR, #PREMIO5 ; Endereço inicial da string PREMIOS
    ACALL escreveStringROM
MOV A, #04Ah;#04Eh ; Seta endereço de memória para a próxima linha do LCD
    ACALL posicionaCursor
    MOV DPTR, #PREMIO6 ; Endereço inicial da string PREMIOS
    ACALL escreveStringROM
MOV A, #04Dh ; Seta endereço de memória para a próxima linha do LCD
    ACALL posicionaCursor
    MOV DPTR, #PREMIO7 ; Endereço inicial da string PREMIOS
    ACALL escreveStringROM
MOV A, #04Fh ; Seta endereço de memória para a próxima linha do LCD
    ACALL posicionaCursor
    MOV DPTR, #PREMIO7 ; Endereço inicial da string PREMIOS
    ACALL escreveStringROM


    JMP $ ; Loop infinito

escreveStringROM:
    MOV R1, #00h
    ; Inicia a escrita da String no Display LCD
loop:
    MOV A, R1
    MOVC A,@A+DPTR     ;lê da memória de programa
    JZ finish       ; if A is 0, then end of data has been reached - jump out of loop
    ACALL sendCharacter    ; send data in A to LCD module
    INC R1          ; point to next piece of data
    MOV A, R1
    JMP loop        ; repeat
finish:
    RET
   
; initialise the display
; see instruction set for details
lcd_init:

    CLR RS        ; clear RS - indicates that instructions are being sent to the module

    ; function set    
    CLR P1.7        ; |
    CLR P1.6        ; |
    SETB P1.5       ; |
    CLR P1.4        ; | high nibble set

    SETB EN        ; |
    CLR EN        ; | negative edge on E

    CALL delay        ; wait for BF to clear    
                    ; function set sent for first time - tells module to go into 4-bit mode
    ; Why is function set high nibble sent twice? See 4-bit operation on pages 39 and 42 of HD44780.pdf.

    SETB EN        ; |
    CLR EN        ; | negative edge on E
                    ; same function set high nibble sent a second time

    SETB P1.7        ; low nibble set (only P1.7 needed to be changed)

    SETB EN        ; |
    CLR EN        ; | negative edge on E
                ; function set low nibble sent
    CALL delay        ; wait for BF to clear


    ; entry mode set
    ; set to increment with no shift
    CLR P1.7        ; |
    CLR P1.6        ; |
    CLR P1.5        ; |
    CLR P1.4        ; | high nibble set

    SETB EN        ; |
    CLR EN        ; | negative edge on E

    SETB P1.6        ; |
    SETB P1.5        ; |low nibble set

    SETB EN        ; |
    CLR EN        ; | negative edge on E

    CALL delay        ; wait for BF to clear


    ; display on/off control
    ; the display is turned on, the cursor is turned on and blinking is turned on
    CLR P1.7        ; |
    CLR P1.6        ; |
    CLR P1.5        ; |
    CLR P1.4        ; | high nibble set

    SETB EN        ; |
    CLR EN        ; | negative edge on E

    SETB P1.7        ; |
    SETB P1.6        ; |
    SETB P1.5        ; |
    SETB P1.4        ; | low nibble set

    SETB EN        ; |
    CLR EN        ; | negative edge on E

    CALL delay        ; wait for BF to clear
    RET


sendCharacter:
    SETB RS       ; setb RS - indicates that data is being sent to module
    MOV C, ACC.7        ; |
    MOV P1.7, C            ; |
    MOV C, ACC.6        ; |
    MOV P1.6, C            ; |
    MOV C, ACC.5        ; |
    MOV P1.5, C            ; |
    MOV C, ACC.4        ; |
    MOV P1.4, C            ; | high nibble set

    SETB EN            ; |
    CLR EN            ; | negative edge on E

    MOV C, ACC.3        ; |
    MOV P1.7, C            ; |
    MOV C, ACC.2        ; |
    MOV P1.6, C            ; |
    MOV C, ACC.1        ; |
    MOV P1.5, C            ; |
    MOV C, ACC.0        ; |
    MOV P1.4, C            ; | low nibble set

    SETB EN            ; |
    CLR EN            ; | negative edge on E

    CALL delay            ; wait for BF to clear
    CALL delay            ; wait for BF to clear
    RET

;Posiciona o cursor na linha e coluna desejada.
;Escreva no Acumulador o valor de endereço da linha e coluna.
;|--------------------------------------------------------------------------------------|
;|linha 1 | 00 | 01 | 02 | 03 | 04 |05 | 06 | 07 | 08 | 09 |0A | 0B | 0C | 0D | 0E | 0F |
;|linha 2 | 40 | 41 | 42 | 43 | 44 |45 | 46 | 47 | 48 | 49 |4A | 4B | 4C | 4D | 4E | 4F |
;|--------------------------------------------------------------------------------------|
posicionaCursor:
    CLR RS    
    SETB P1.7            ; |
    MOV C, ACC.6        ; |
    MOV P1.6, C            ; |
    MOV C, ACC.5        ; |
    MOV P1.5, C            ; |
    MOV C, ACC.4        ; |
    MOV P1.4, C            ; | high nibble set

    SETB EN            ; |
    CLR EN            ; | negative edge on E

    MOV C, ACC.3        ; |
    MOV P1.7, C            ; |
    MOV C, ACC.2        ; |
    MOV P1.6, C            ; |
    MOV C, ACC.1        ; |
    MOV P1.5, C            ; |
    MOV C, ACC.0        ; |
    MOV P1.4, C            ; | low nibble set

    SETB EN            ; |
    CLR EN            ; | negative edge on E

    CALL delay            ; wait for BF to clear
    CALL delay            ; wait for BF to clear
    RET


;Retorna o cursor para primeira posição sem limpar o display
retornaCursor:
    CLR RS    
    CLR P1.7        ; |
    CLR P1.6        ; |
    CLR P1.5        ; |
    CLR P1.4        ; | high nibble set

    SETB EN        ; |
    CLR EN        ; | negative edge on E

    CLR P1.7        ; |
    CLR P1.6        ; |
    SETB P1.5        ; |
    SETB P1.4        ; | low nibble set

    SETB EN        ; |
    CLR EN        ; | negative edge on E

    CALL delay        ; wait for BF to clear
    RET


;Limpa o display
clearDisplay:
    CLR RS    
    CLR P1.7        ; |
    CLR P1.6        ; |
    CLR P1.5        ; |
    CLR P1.4        ; | high nibble set

    SETB EN        ; |
    CLR EN        ; | negative edge on E

    CLR P1.7        ; |
    CLR P1.6        ; |
    CLR P1.5        ; |
    SETB P1.4        ; | low nibble set

    SETB EN        ; |
    CLR EN        ; | negative edge on E

    MOV R6, #40
    rotC:
    CALL delay        ; wait for BF to clear
    DJNZ R6, rotC
    RET


delay:
    MOV R0, #50
    DJNZ R0, $
    RET