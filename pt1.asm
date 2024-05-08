RS      equ     P1.3    ; Reg Select ligado em P1.3
EN      equ     P1.2    ; Enable ligado em P1.2

P2_7    equ     7
P2_6    equ     6
P2_5    equ     5
P2_4    equ     4
P2_3    equ     3
P2_2    equ     2
P2_1    equ     1
P2_0    equ     0

org 0000h
    LJMP START

org 0030h
FEI:
    DB "JOGO"
    DB 00h ; Marca null no fim da String

org 0040h
DISPLAY:
    DB "DA GARRA"
    DB 00h ; Marca null no fim da String

org 0050h
GARRA:
    DB "^"
    DB 00h ; Marca null no fim da String

org 0060h
PREMIO1:
    DB "$"
    DB 00h
org 0070h
PREMIO2:
    DB "$"
    DB 00h
org 0080h
PREMIO3:
    DB "$"
    DB 00h
org 0090h
PREMIO4:
    DB "$"
    DB 00h
org 00A0h
PREMIO5:
    DB "$"
    DB 00h
org 00B0h
PREMIO6:
    DB "$"
    DB 00h
org 00C0h
PREMIO7:
    DB "$"
    DB 00h
org 00D0h
PREMIO8:
    DB "$"
    DB 00h

org 0100h
START:

main:
    ACALL lcd_init
    MOV A, #06h
    ACALL posicionaCursor
    MOV DPTR,#FEI            ; Endereço inicial de memória da String FEI
    ACALL escreveStringROM
    MOV A, #44h
    ACALL posicionaCursor
    MOV DPTR,#DISPLAY        ; Endereço inicial de memória da String Display LCD
    ACALL escreveStringROM
    ACALL clearDisplay
    MOV A, #07H
    ACALL posicionaCursor
    MOV DPTR, #GARRA
    ACALL escreveStringROM
    MOV A, #44H
    ACALL posicionaCursor
    MOV DPTR, #PREMIO3
    ACALL escreveStringROM
    MOV A, #46H
    ACALL posicionaCursor
    MOV DPTR, #PREMIO4
    ACALL escreveStringROM
    MOV A, #48H
    ACALL posicionaCursor
    MOV DPTR, #PREMIO5
    ACALL escreveStringROM

button_check:
    MOV A, P2          ; Ler o estado atual dos pinos do Port 2
    JB ACC.7, check_p26 ; Se P2.7 não está pressionado, pular para verificar P2.6
    ACALL hide_garra   ; Limpa a garra na posição 07h
    SJMP button_check  ; Após ação, continue verificando botões
check_p26:
    JB ACC.6, check_p25 ; Se P2.6 não está pressionado, pular para verificar P2.5
    ACALL show_garra1  ; Mostra a garra na posição 04h
    SJMP button_check  ; Após ação, continue verificando botões
check_p25:
    JB ACC.5, check_p24 ; Se P2.5 não está pressionado, pular para verificar P2.4
    ACALL hide_garra1  ; Limpa a garra na posição 04h
    SJMP button_check  ; Após ação, continue verificando botões
check_p24:
    JB ACC.4, check_p23 ; Se P2.4 não está pressionado, pular para verificar P2.3
    ACALL show_garra2  ; Mostra a garra na posição 06h
    SJMP button_check  ; Após ação, continue verificando botões
check_p23:
    JB ACC.3, check_p22 ; Se P2.3 não está pressionado, pular para verificar P2.2
    ACALL hide_garra2  ; Limpa a garra na posição 06h
    SJMP button_check  ; Após ação, continue verificando botões
check_p22:
    JB ACC.2, check_p21 ; Se P2.2 não está pressionado, pular para verificar P2.1
    ACALL show_garra3  ; Mostra a garra na posição 08h
    SJMP button_check  ; Após ação, continue verificando botões
check_p21:
    JB ACC.1, check_p20 ; Se P2.1 não está pressionado, pular para verificar P2.0
    ACALL hide_garra3  ; Limpa a garra na posição 08h
    SJMP button_check  ; Após ação, continue verificando botões
check_p20:
    JB ACC.0, button_check ; Se P2.0 não está pressionado, continue verificando botões
    ACALL show_garra   ; Mostra a garra na posição 07h
    SJMP button_check  ; Após ação, continue verificando botões

hide_garra:
    MOV A, #07H
    ACALL posicionaCursor
    MOV DPTR, #SPACE  ; Espaço em branco para substituir a garra
    ACALL escreveStringROM
    RET
hide_garra1:
    MOV A, #04H
    ACALL posicionaCursor
    MOV DPTR, #SPACE  ; Espaço em branco para substituir a garra
    ACALL escreveStringROM
    RET
hide_garra2:
    MOV A, #06H
    ACALL posicionaCursor
    MOV DPTR, #SPACE  ; Espaço em branco para substituir a garra
    ACALL escreveStringROM
    RET
hide_garra3:
    MOV A, #08H
    ACALL posicionaCursor
    MOV DPTR, #SPACE  ; Espaço em branco para substituir a garra
    ACALL escreveStringROM
    RET

show_garra:
    MOV A, #07H
    ACALL posicionaCursor
    MOV DPTR, #GARRA  
    ACALL escreveStringROM
    RET
show_garra1:
    MOV A, #04H
    ACALL posicionaCursor
    MOV DPTR, #GARRA  
    ACALL escreveStringROM
    RET
show_garra2:
    MOV A, #06H
    ACALL posicionaCursor
    MOV DPTR, #GARRA  
    ACALL escreveStringROM
    RET
show_garra3:
    MOV A, #08H
    ACALL posicionaCursor
    MOV DPTR, #GARRA  
    ACALL escreveStringROM
    RET

SPACE:
    DB " "
    DB 00h ; Marca null no fim da String

escreveStringROM:
    MOV R1, #00h
    ; Inicia a escrita da String no Display LCD
loop:
    MOV A, R1
    MOVC A,@A+DPTR     ; Lê da memória de programa
    JZ finish       ; Se A é 0, então o fim dos dados foi alcançado - sair do loop
    ACALL sendCharacter    ; Envia dados em A para o módulo LCD
    INC R1          ; Aponta para o próximo dado
    MOV A, R1
    JMP loop        ; Repetir
finish:
    RET

; initialise the display
; ver instruções para detalhes
lcd_init:

    CLR RS        ; Limpa RS - indica que instruções estão sendo enviadas para o módulo

    ; function set    
    CLR P1.7        ; |
    CLR P1.6        ; |
    SETB P1.5       ; |
    CLR P1.4        ; | high nibble set

    SETB EN        ; |
    CLR EN        ; | borda negativa em E

    CALL delay        ; Espera BF ser limpo    
                    ; função set enviada pela primeira vez - indica ao módulo para entrar no modo de 4 bits
    ; Por que a função set high nibble foi enviada duas vezes? Veja operação de 4 bits nas páginas 39 e 42 de HD44780.pdf.

    SETB EN        ; |
    CLR EN        ; | borda negativa em E
                    ; mesmo conjunto de função alta nibble enviado uma segunda vez

    SETB P1.7        ; conjunto de nibble baixo (apenas P1.7 precisava ser alterado)

    SETB EN        ; |
    CLR EN        ; | borda negativa em E
                ; função definida para baixo nibble enviada
    CALL delay        ; Espera BF ser limpo


    ; entry mode set
    ; definido para incrementar sem deslocamento
    CLR P1.7        ; |
    CLR P1.6        ; |
    CLR P1.5        ; |
    CLR P1.4        ; | high nibble set

    SETB EN        ; |
    CLR EN        ; | borda negativa em E

    SETB P1.6        ; |
    SETB P1.5        ; | low nibble set

    SETB EN        ; |
    CLR EN        ; | borda negativa em E

    CALL delay        ; Espera BF ser limpo


    ; display on/off control
    ; o display é ligado, o cursor é ligado e o piscar é ligado
    CLR P1.7        ; |
    CLR P1.6        ; |
    CLR P1.5        ; |
    CLR P1.4        ; | high nibble set

    SETB EN        ; |
    CLR EN        ; | borda negativa em E

    SETB P1.7        ; |
    SETB P1.6        ; |
    SETB P1.5        ; |
    SETB P1.4        ; | low nibble set

    SETB EN        ; |
    CLR EN        ; | borda negativa em E

    CALL delay        ; Espera BF ser limpo
    RET


sendCharacter:
    SETB RS       ; setb RS - indica que os dados estão sendo enviados para o módulo
    MOV C, ACC.7        ; |
    MOV P1.7, C            ; |
    MOV C, ACC.6        ; |
    MOV P1.6, C            ; |
    MOV C, ACC.5        ; |
    MOV P1.5, C            ; |
    MOV C, ACC.4        ; |
    MOV P1.4, C            ; | high nibble set

    SETB EN            ; |
    CLR EN            ; | borda negativa em E

    MOV C, ACC.3        ; |
    MOV P1.7, C            ; |
    MOV C, ACC.2        ; |
    MOV P1.6, C            ; |
    MOV C, ACC.1        ; |
    MOV P1.5, C            ; |
    MOV C, ACC.0        ; |
    MOV P1.4, C            ; | low nibble set

    SETB EN            ; |
    CLR EN            ; | borda negativa em E

    CALL delay            ; Espera BF ser limpo
    CALL delay            ; Espera BF ser limpo
    RET

; Posiciona o cursor na linha e coluna desejada.
; Escreva no acumulador o valor de endereço da linha e coluna.
; |--------------------------------------------------------------------------------------|
; | linha 1 | 00 | 01 | 02 | 03 | 04 |05 | 06 | 07 | 08 | 09 |0A | 0B | 0C | 0D | 0E | 0F |
; | linha 2 | 40 | 41 | 42 | 43 | 44 |45 | 46 | 47 | 48 | 49 |4A | 4B | 4C | 4D | 4E | 4F |
; |--------------------------------------------------------------------------------------|
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
    CLR EN            ; | borda negativa em E

    MOV C, ACC.3        ; |
    MOV P1.7, C            ; |
    MOV C, ACC.2        ; |
    MOV P1.6, C            ; |
    MOV C, ACC.1        ; |
    MOV P1.5, C            ; |
    MOV C, ACC.0        ; |
    MOV P1.4, C            ; | low nibble set

    SETB EN            ; |
    CLR EN            ; | borda negativa em E

    CALL delay            ; Espera BF ser limpo
    CALL delay            ; Espera BF ser limpo
    RET

; Retorna o cursor para primeira posição sem limpar o display
retornaCursor:
    CLR RS    
    CLR P1.7        ; |
    CLR P1.6        ; |
    CLR P1.5        ; |
    CLR P1.4        ; | high nibble set

    SETB EN        ; |
    CLR EN        ; | borda negativa em E

    CLR P1.7        ; |
    CLR P1.6        ; |
    SETB P1.5        ; |
    SETB P1.4        ; | low nibble set

    SETB EN        ; |
    CLR EN        ; | borda negativa em E

    CALL delay        ; Espera BF ser limpo
    RET

; Limpa o display
clearDisplay:
    CLR RS    
    CLR P1.7        ; |
    CLR P1.6        ; |
    CLR P1.5        ; |
    CLR P1.4        ; | high nibble set

    SETB EN        ; |
    CLR EN        ; | borda negativa em E

    CLR P1.7        ; |
    CLR P1.6        ; |
    CLR P1.5        ; |
    SETB P1.4        ; | low nibble set

    SETB EN        ; |
    CLR EN        ; | borda negativa em E

    MOV R6, #40
    rotC:
    CALL delay        ; Espera BF ser limpo
    DJNZ R6, rotC
    RET


delay:
    MOV R5,#40H
d1:
    DJNZ R5,$
    RET