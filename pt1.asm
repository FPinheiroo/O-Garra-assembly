; --- Mapeamento de Hardware (8051) ---
RS      equ     P1.3    ;Reg Select ligado em P1.3
EN      equ     P1.2    ;Enable ligado em P1.2

; Adicione essas variáveis para armazenar a posição atual da garra
GARRA_POS equ 0x07 ; Posição inicial da garra (linha 2, coluna 7)

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
    DB 00h
org 0070h ;Marca null no fim da String
PREMIO3:
    DB "$"
    DB 00h
org 0070h ;Marca null no fim da String
PREMIO4:
    DB "$"
    DB 00h
org 0070h ;Marca null no fim da String
PREMIO5:
    DB "$"
    DB 00h
org 0070h ;Marca null no fim da String
PREMIO6:
    DB "$"
    DB 00h
org 0070h ;Marca null no fim da String
PREMIO7:
    DB "$"
    DB 00h
org 0070h ;Marca null no fim da String
PREMIO8:
    DB "$"
    DB 00h ;Marca null no fim da String

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

; Adicione essa rotina para ler as teclas do teclado matricial do EDSIM 51
read_keys:
    ; Leia as linhas do teclado matricial
    SETB P0.0 ; Seleciona a primeira linha
    JB P1.0, read_keys ; Espere até que a tecla seja solta
    JB P1.1, read_keys ; Espere até que a tecla seja solta
    MOV A, #01h ; Código da tecla na primeira linha
    JMP read_keys_done

    SETB P0.1 ; Seleciona a segunda linha
    JB P1.0, read_keys ; Espere até que a tecla seja solta
    JB P1.1, read_keys ; Espere até que a tecla seja solta
    MOV A, #02h ; Código da tecla na segunda linha
    JMP read_keys_done

    SETB P0.2 ; Seleciona a terceira linha
    JB P1.0, read_keys ; Espere até que a tecla seja solta
    JB P1.1, read_keys ; Espere até que atecla seja solta
    MOV A, #04h ; Código da tecla na terceira linha
    JMP read_keys_done

    SETB P0.3 ; Seleciona a quarta linha
    JB P1.0, read_keys ; Espere até que a tecla seja solta
    JB P1.1, read_keys ; Espere até que a tecla seja solta
    MOV A, #08h ; Código da tecla na quarta linha

read_keys_done:
    ; Decodifique o código da tecla para obter a tecla real
    CJNE A, #01h, not_7
    MOV A, #07h ; Código da tecla 7
    RET

not_7:
    CJNE A, #02h, not_8
    MOV A, #08h ; Código da tecla 8
    RET

not_8:
    CJNE A, #04h, not_9
    MOV A, #09h ; Código da tecla 9
    RET

not_9:
    ; Adicione outras teclas aqui, se necessário

    ; Se nenhuma tecla for pressionada, retorne 0
    MOV A, #00h
    RET

; Adicione essa rotina para atualizar a posição da garra no LCD
update_garra:
    ; Posicione o cursor na linha e coluna atual da garra
    MOV A, GARRA_POS
    ACALL posicionaCursor
    ; Escreva a garra na posição atual
    MOV DPTR, #GARRA
    ACALL escreveStringROM
    RET

;MAIN
main_loop:
    ACALL read_keys
    JZ main_loop ; Se nenhuma tecla for pressionada, espere por mais uma iteração
    CJNE A, #07h, not_left
    ; Se a tecla 7 for pressionada, mova a garra para a esquerda
    DEC GARRA_POS
    CJNE GARRA_POS, #0FFh, not_left_edge
    MOV GARRA_POS, #07h ; Se a garra estiver na extremidade esquerda, mova-a para a posição inicial
not_left_edge:
    JMP update_garra

not_left:
    CJNE A, #08h, not_right
    ; Se a tecla 8 for pressionada, mova a garra para a direita
    INC GARRA_POS
    CJNE GARRA_POS, #010h, not_right_edge
    MOV GARRA_POS, #07h ; Se a garra estiver na extremidade direita, mova-a para a posição inicial
not_right_edge:
    JMP update_garra

not_right:
    ; Se nenhuma tecla for pressionada, espere por mais uma iteração
    JMP main_loop

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
    DJNZ R0, $
    RET*