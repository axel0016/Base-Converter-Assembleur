;PROJECT ARCHI ACAD C 

;CE PROJET A ETE FAIT PAR LES DEUX ETUDIANT 

;ABDERAHMANE MOKDAD           SADJI AMINE ZIGADI
;202031084734                 202031076846 

.STACK 100H

PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     
        POP     AX

ENDM


.DATA
    
    FLAG DW ?
    COUNT DB ?
    LE_RESTE DW 0
    CONTEUR_HEX DW 0
    HI DW ?
    SELECTIONNER DB ?    

    MESSAGE_PRINCIPAL DB 0DH , 0AH , 0DH , 0AH , '          TOUTES LES OPERATIONS : $'
    PREMIER_MESSAGE DB 0DH , 0AH , '1. CONVERSION DE BINAIRE EN (HEXA-DECIMAL / Decimal) $'
    DEUXIEME_MESSAGE DB 0DH , 0AH , '2. CONVERSION HEXA-DECIMALE EN (DECIMAL / BINAIRE) $'
    TROISIEME_MESSAGE DB 0DH , 0AH , '3. CONVERSION DECIMALE EN (BINAIRE / HEXA-DECIMAL) $'    
    
    CHOISIR DB 0DH , 0AH , 'APPUYEZ SUR UN NUMERO (1-3) POUR EFFECTUER CETTE OPERATION : $'
    ERREUR_MESSAGE DB 0DH , 0AH , 'S IL VOUS PLAIT, ENTREZ LE NUMERO DE NOUVEAU DE MANIERE APPROPRIEE... !!! $'       
    INVALID DB 0DH , 0AH , 'NUMERO NON VALIDE. ESSAYEZ DE NOUVEAU... $'   
    REESSAYER DB 0DH , 0AH , 'VOULEZ-VOUS REESSAYER ? PRESSER Y OU N : $' 
       
    BINARY_NUMBER DB 0DH , 0AH , 'SAISIR UN NOMBRE BINAIRE : $'
    NOMBRE_HEXA DB 0DH , 0AH , 'SAISIR LE NUMERO HEXADECIMAL (MAXIMUM DE 2 CHIFFRES OU AU MAXIMUM 399H)  : $' 
    MONTRER_HEX DB 0DH , 0AH , 'EN HEXA-DECIMAL : $'
    MONTRER_DEC DB 0DH , 0AH , 'EN DECIMAL : $'
    MONTRER_BIN DB 0DH , 0AH , 'EN BINARY : $'   
     
    NOUVELLE_LIGNE DB 0DH , 0AH , '$'    
    
    
    
    DECIMAL_VALEUR DB 'Enter une valeur entre (0-9) $'                          
    AFFICHAGE_DECIMAL DB 'VALEUR DECIMAL : $'
      
           

.CODE
    
    MAIN PROC
        
        MOV AX , @DATA
        MOV DS , AX
  

        
        MENU_PRINCIPAL:
        
            Mov ax,0003h
            Int 10h                   
            
            LEA DX , MESSAGE_PRINCIPAL          
            MOV AH , 9
            INT 21H
            
            LEA DX , NOUVELLE_LIGNE
            MOV AH , 9
            INT 21H
            
            LEA DX , PREMIER_MESSAGE      ;AFFICHAGE DES OPERATIONS
            MOV AH , 9
            INT 21H
            
            LEA DX , DEUXIEME_MESSAGE
            MOV AH , 9
            INT 21H
            
            LEA DX , TROISIEME_MESSAGE
            MOV AH , 9
            INT 21H
            
            
            
            LEA DX , NOUVELLE_LIGNE       
            MOV AH , 9
            INT 21H
            
            LEA DX , CHOISIR   
            MOV AH , 9
            INT 21H            
          
        
                
        CHOIX:           ;CHOISIRE UNE OPTION
        
            MOV AH , 1         
            INT 21H
            MOV SELECTIONNER,AL        
            
            CMP AL , 49         
            JE CONVERSION_DE_BINAIRE
            
            CMP AL , 50
            JE CONVERSION_DE_HEXA

            CMP AL , 51
            JE CONVERSION_DE_DECIMAL
            
            
            CMP AL , 49         ;AU CAS D'ERREUR
            JL ERREUR
            
            CMP AL , 51                                            
            JG ERREUR
        
        
        
        ERREUR:                          ;ETIQUETTE D'ERREUR
            
            LEA DX , NOUVELLE_LIGNE
            MOV AH , 9
            INT 21H
            
            LEA DX , ERREUR_MESSAGE      
            MOV AH , 9
            INT 21H
            
            JMP MENU_PRINCIPAL            ;REVENIR AU DEBUT AU CAS D'ERREUR
        
        
        
        ENCORE:                  ;ETIQUETTE D'ENCORE
        
            LEA DX,NOUVELLE_LIGNE     
            MOV AH,9     
            INT 21H 
             
            LEA DX,REESSAYER       
            MOV AH,9     
            INT 21H
             
            MOV AH,1       
            INT 21H         
             
        
            CMP AL,89
            JE  MENU_PRINCIPAL        ;COMPARISON AVEC ASCII CHARACTERE
    
            CMP AL,121
            JE  MENU_PRINCIPAL  
    
            CMP AL,89       
            JNE  EXIT  
    
            CMP AL,121
            JNE  EXIT
        
        
        
        ERREUR_BINAIRE:                ;ERREUR DANS L'INPUT DE BINAIRE
        
            LEA DX , NOUVELLE_LIGNE
            MOV AH , 9
            INT 21H
            
            LEA DX , INVALID    ;NOMBRE INVALID
            MOV AH , 9
            INT 21H
            
        
        
        CONVERSION_DE_BINAIRE:                     ;ETIQUETTE BINAIRE VERS HEXA-DECIMAL
            
            LEA DX , NOUVELLE_LIGNE       
            MOV AH , 9
            INT 21H
            
            LEA DX , BINARY_NUMBER      
            MOV AH , 9
            INT 21H
            
            MOV FLAG , 49
            JMP CHOIX_BINARY    
        
 
        
        CHOIX_BINARY:       ;ETIQUETTE CHOIX DE NOMBRE BINAIRE
         
            XOR AX , AX     ;RESET TOUS LES REGISTRE
            XOR BX , BX
            XOR CX , CX
            XOR DX , DX
            MOV CX , 0      
            
        
        
        CHOIX_BINARY2:          
            
            INC CX
            CMP CX , 17
            JE ENTER
            
            MOV AH , 1          
            INT 21H
            
            CMP AL , 0DH        ;VERIFIRE SI ENTRER EST CLIQUER
            JE ENTER
            
            CMP AL , 48
            JNE BINARY_CHECK
            
        
        
        BINARY_CONTINUE:            ;CONTINUER 
        
            SUB AL , 48
            SHL BX , 1
            OR BL , AL
            JMP CHOIX_BINARY2       ;POUR ENTRER UN AUTRE NOMBRE   
        
        
        
        BINARY_CHECK:               ;VERIFIER SI LE NOMBRE ENTRER EST BINAIRE (1 ET 0 SELEMENT) SINON ERREUR
        
            CMP AL , 49             
            JNE ERREUR_BINAIRE           
            JMP BINARY_CONTINUE    
        
        
        
        ENTER:                  ;ETIQUETTE D'ENTRER
        
            CMP FLAG , 49    
            JE AFFICHAGE_HEXA
            
            CMP FLAG , 50
            JE AFFICHAGE-DECIMAL
            
            CMP FLAG , 51
            JE AFFICHAGE-DECIMAL           

            
        
        AFFICHAGE_HEXA:                ;AFFICHAGE D'EXA
        
            XOR DX , DX
            LEA DX , NOUVELLE_LIGNE
            MOV AH , 9
            INT 21H
            
            LEA DX , MONTRER_HEX       
            MOV AH , 9
            INT 21H
            
            MOV CL , 1              
            MOV CH , 0              
            
            JMP AFFICHAGE_HEXA2
            
        
        
        AFFICHAGE_HEXA2:           
        
            CMP CH , 4          ;MAXIMUM 4 CHARACTERE
            JE BIN_TO_DEC
            INC CH
            
            MOV DL , BH
            SHR DL , 4
            
            CMP DL , 0AH
            JL NOMBRE-HEXA
            
            ADD DL,37H     
            MOV AH,2        
            INT 21H          
            ROL BX,4            ;ROTATION DE 4 BIT VER LA GAUCHE
            
            JMP AFFICHAGE_HEXA2
            
        
        
        NOMBRE-HEXA:             ;ETIQUETTE DES NOMBRE HEXA-DECIMAL 
        
            ADD DL,30H         
            MOV AH,2       
            INT 21H            
            ROL BX,4
                        
            JMP AFFICHAGE_HEXA2 
            
            
        BIN_TO_DEC:                     ;CONVERSION BINAIRE VERS DECIMAL
        
            CMP FLAG , 52
            JE ENCORE
            
            MOV FLAG , 50
           
            
        
        
        AFFICHAGE-DECIMAL:
            
                             ;AFFICHAGE DECIMAL
            MOV HI , BX
            XOR DX , DX
            
            LEA DX , NOUVELLE_LIGNE
            MOV AH , 9
            INT 21H
            
            LEA DX , MONTRER_DEC
            MOV AH , 9
            INT 21H
            
            XOR AX , AX
            
            MOV AX , BX
            
            CMP AX , 9              ;SI MOINS DE 10
            JLE MOINS_9
            
            CMP AX , 99             ;ENTRE 9 ET 100
            JLE ENTRE_9_ET_100
            
            CMP AX , 99             ;SI PLUS QUE 99
            JG PLUS_99
        
        
        
        MOINS_9:        ;LESS_THAN_99 LABEL
                
            MOV AH , 2
            MOV DL , AL   
            ADD DL , 48
            INT 21H
            
            CMP FLAG , 51
            JE  HEX_TO_BIN
            
            JMP ENCORE  
        
        
        
        ENTRE_9_ET_100:              ;ETIQUETTE ENTRE 9 ET 100
        
            MOV DX , 0H
            MOV BX , 10
            DIV BX                 ;DEVISER PAR 10
            
            MOV LE_RESTE , DX      ;SAUVGARDER LE RESTE
            
            MOV AH , 2
            ADD AX , 48
            MOV DX , AX
            INT 21H
            
            MOV AH , 2
            MOV DX , LE_RESTE
            ADD DX , 48
            INT 21H
            
            CMP FLAG , 51
            JE  HEX_TO_BIN
            
            JMP ENCORE
            
        
        
        PLUS_99:                    ;ETIQUETTE PLUS 99
            
            MOV DX , 0H
            MOV BX , 100
            DIV BX                  ;DEVISER PAR 100
            
            MOV LE_RESTE , DX      ;SAUVGARDER LE RESTE
            
            MOV AH , 2
            ADD AX , 48
            MOV DX , AX
            INT 21H
            
            MOV AX , LE_RESTE
            MOV DX , 0
            
            JMP ENTRE_9_ET_100
            
                              
         ;DEUXIEME PARTIE  ;;;;;;;;;;;;;;;;;;;;;;;;;;
         
         
        
        ERREUR_ENTRER_HEXA:        ;ETIQUETTE D'ERREUT EN ENTRANT UN NOMBRE HEXA-DECIMAL
        
            LEA DX , NOUVELLE_LIGNE
            MOV AH , 9
            INT 21H
            
            LEA DX , INVALID    ;MONTRER LE NOMBRE INVALID
            MOV AH , 9
            INT 21H
            
            
        
        CONVERSION_DE_HEXA:                 ;CONVERSION DE HEXA-DECIMAL 
        
            LEA DX , NOUVELLE_LIGNE
            MOV AH , 9
            INT 21H
        
            LEA DX,NOMBRE_HEXA
            MOV AH,9                
            INT 21H 
            
             MOV FLAG , 51
            JMP INPUT_HEX
            
       
       
        INPUT_HEX:          ;ETIQUETTE D'INPUT DECIMAL
       
            XOR AX , AX     ;RESETE DE TOUS LES REGISTRE
            XOR BX , BX
            XOR CX , CX
            XOR DX , DX
            
            MOV CONTEUR_HEX , 0
            
       
       
        INPUT_HEX2:            
        
            CMP CONTEUR_HEX , 4   ;SI ON ENTRE 4 CHARACTERE OU CHIFRE ALORS ENTRER
            JE ENTER
            INC CONTEUR_HEX
           
            MOV AH , 1          
            INT 21H
           
            CMP AL , 0DH
            JE ENTER
           
            CMP AL , 48
            JL ERREUR_ENTRER_HEXA
            
            CMP AL , 65
            JL CONVERT_BIN_SHIFT
            
            CMP AL , 71
            JGE ERREUR_ENTRER_HEXA
            
            SUB AL , 55
             
        
        
        
        CONVERT_BIN_SHIFT:      ;ETIQUETTE DE CONVERTIRE LE BINAIRE
            
            CMP AL , 57
            JG ERREUR_ENTRER_HEXA
            
            AND AL , 0FH        
            SHL AL , 4
            MOV CX , 4
            
        
        
        BIT_SHIFT:             
        
            SHL AL , 1
            RCL BX , 1
            LOOP BIT_SHIFT
            JMP INPUT_HEX2

            
        
        ERREUR_HEX:

            LEA DX,INVALID          ;MESSAGE D'ERREUR
            MOV AH,9                
            INT 21H
            
            
        
        HEX_TO_BIN:                 ;CONVERSION HEXA-DECIMAL VERS BINAIRE
                   
                                            
             
         
        AFFICHAGE_BINAIRE:
            MOV BX,HI
            
            LEA DX , NOUVELLE_LIGNE
            MOV AH , 9
            INT 21H
            
            LEA DX,MONTRER_BIN      ;AFFICHAGE DE MESSAGE
            MOV AH,9
            INT 21H

            MOV CX,16
            MOV AH,2

        
        
        LOOP_2:

            SHL BX,1         
                             ;JUMP SI CARRY=1
            JC ONE
                                              
            MOV DL,30H
            JMP DISPLAY                                          

        
        
        ONE:

            MOV DL,31H
    


        DISPLAY:

            INT 21H  
            LOOP LOOP_2

            JMP ENCORE
       ;TROISIEME PARTIE  ;;;;;;;;;;;;;;;;;;;;;;;;;    

    
    CONVERSION_DE_DECIMAL: 
            MOV FLAG , 52
    
            LEA DX , NOUVELLE_LIGNE
            MOV AH , 9
            INT 21H
            
            LEA DX,DECIMAL_VALEUR
            INT 21H
        
            LEA DX,NOUVELLE_LIGNE
            INT 21H
        
            LEA DX,AFFICHAGE_DECIMAL
            INT 21H
    
        
            call SCAN_NUM
        
            MOV BX , CX
            MOV HI , CX
        
           LEA DX , NOUVELLE_LIGNE
            MOV AH , 9
            INT 21H
            
            LEA DX,MONTRER_BIN      ;AFFICHAGE DE NOMBRE BINAIRE
            MOV AH,9
            INT 21H
        
            MOV CX,16
            MOV AH,2 
            
            
            
       AFFICHER:
       
       
            MOV DL,'0'
            TEST BX,8000h
            JZ ZERO
       
            MOV DL,'1' 
           
           
       ZERO: 
       
           INT 21h
           SHL BX,1
           LOOP AFFICHER
       
           
        
    CONVERSION_DE_DECIMAL2:
       
        
        
           MOV BX , HI
        
           JMP AFFICHAGE_HEXA
           
           
           
           
        
     EXIT:
    
           MOV AH,4CH      ; ignorez l'emulateur en panne 
           INT 21H 
        
        
         SCAN_NUM        PROC    NEAR
        PUSH    DX
        PUSH    AX
        PUSH    SI
        
        MOV     CX, 0

       
        MOV     CS:make_minus, 0

next_digit:

      
        MOV     AH, 00h
        INT     16h
       
        MOV     AH, 0Eh
        INT     10h

        
        CMP     AL, '-'
        JE      set_minus

        
        CMP     AL, 13  
        JNE     not_cr
        JMP     stop_input
not_cr:


        CMP     AL, 8                  
        JNE     backspace_checked
        MOV     DX, 0                  
        MOV     AX, CX                 
        DIV     CS:ten                 
        MOV     CX, AX
        PUTC    ' '                  
        PUTC    8                      
        JMP     next_digit
backspace_checked:


      
        CMP     AL, '0'
        JAE     ok_AE_0
        JMP     remove_not_digit
ok_AE_0:        
        CMP     AL, '9'
        JBE     ok_digit
remove_not_digit:       
        PUTC    8     
        PUTC    ' '     
        PUTC    8       
        JMP     next_digit 
ok_digit:


        
        PUSH    AX
        MOV     AX, CX
        MUL     CS:ten                 
        MOV     CX, AX
        POP     AX

      
      
        CMP     DX, 0
        JNE     too_big

       
        SUB     AL, 30h

       
        MOV     AH, 0
        MOV     DX, CX      
        ADD     CX, AX
        JC      too_big2   

        JMP     next_digit

set_minus:
        MOV     CS:make_minus, 1
        JMP     next_digit

too_big2:
        MOV     CX, DX      
        MOV     DX, 0      
too_big:
        MOV     AX, CX
        DIV     CS:ten  
        MOV     CX, AX
        PUTC    8       
        PUTC    ' '    
        PUTC    8         
        JMP     next_digit
        
        
stop_input:
       
        CMP     CS:make_minus, 0
        JE      not_minus
        NEG     CX
not_minus:

        POP     SI
        POP     AX
        POP     DX
        RET
make_minus      DB      ?      
ten             DW      10     
SCAN_NUM        ENDP
