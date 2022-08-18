;AVISO: é possível fazer o fatorial de 10,11,12 porém apenas colocando estes valores no código fonte, já que a digitação de CHAR só permite de 0 a 9

.MODEL small
.386
.STACK 100h
.DATA
    texto DB 10, 13, 'Digite um numero (maximo 9): $'
    texto2 DB  10, 13, 'O Fatorial e: $'
    texto3 DB  10, 13, 'Reiniciar? (S/N): $'
    texto4 DB  10, 13, 'O Fatorial de 0 e 1! Isto e uma regra matematica.$'

    alerta DB  10, 13, 'ALERTA! O valor digitado nao foi aceito, tente novamente', 10, 10, 13, '$'
    alertanegativo DB  10, 13, 'ALERTA! Nao e permitido valores negativos!', 10, 10, 13, '$'
    pulaLinha DB 10, 13, '$'

    resultado DB 10 DUP('0'),'$'

    num DW 0

.CODE
    mov ax,@data
    mov ds,ax

mov ax, 0
mov dx, 0

inicio:
    ;printa o texto ("Digite um numero (maximo 5): ")
    mov dx, OFFSET texto
    mov ah,9
    int 21h


digitacao: ;Pega o numero digitado e armazena em um int(numero)
    ;le um caracter e salva no al:
    mov ah, 01h
    int 21h 

    cmp al, 45 ;confere se e '-'
    je negativo

    mov ah,0
    sub al, 48 ;subtrai 48 no al para ficar com o codigo ASCII correto

conferencia: ;confere se o numero digitado esta entre 1 e 9 
    ;ve se o codigo ASCII do valor é maior que 9 ou menor que 0
    cmp al, 0
    je zero
    cmp al, 9
    jg erro
    cmp al, 1
    jl erro

jmp preparativosfatorial

erro: ; calculo do fatorial
    mov dx, OFFSET alerta
    mov ah,9
    int 21h
    jmp inicio

negativo:
    mov dx, OFFSET alertanegativo
    mov ah,9
    int 21h
    jmp inicio

preparativosfatorial:
    mov ecx, 0 ;zera cx para nao ter perigo de ter outra coisa na memoria
    mov ecx, eax ;ecx guarda o numero digitado
    mov eax, 1 ;eax vale 1 para nao atrapalhar a multiplicacao

fatorial: ;calculo do fatorial
    mul ecx ;multiplica ax, que vale 1, por cx que vale o valor digitado ecx
    dec ecx ; decrementa ecx

    ;Verifica se cx já chegou a zero e se nao executa o fatorial novamente:
    cmp ecx,0
    jne fatorial
    

;preparativos printar:
mov ecx, 10
mov bx, 9
mov edx,0

print: ;printando o fatorial na tela
    div ecx ;divide o valor de ax por cx(10), com o resultado ficando no ax e o resto no dx

    add dl, 48 ;soma 48 no dx (resto) para ficar com o codigo ASCII correto
    mov resultado[bx], dl ;adiciona na ultima posição do resultado o resto da divisao
    dec bx

    mov edx,0 ;"apaga" o dx/resto, para a proxima divisão ficar correta

    ;Verifica se a divisao ja acabou, ou seja, se o resultado eh zero, se nao executa o printar novamente
    cmp eax, 0
    jne print


;Printa o texto 2 ("O Fatorial eh: ")
mov dx, OFFSET texto2
mov ah,9
int 21h


;Printa o Resultado
mov dx, OFFSET resultado
mov ah,9
int 21h

mov bx, 0
apagarResultado: ; apaga o resultado caso o usuario queira reiniciar o programa
    mov resultado[bx], '0'
    inc bx

    cmp bx,5
    jne apagarResultado 
    
reiniciar: ;Verifica se o usuario quer reiniciar o programa
    mov dx, OFFSET pulaLinha
    mov ah,9
    int 21h

    mov dx, OFFSET texto3
    mov ah,9
    int 21h
    
    mov ah, 01h
    int 21h

    mov dx, OFFSET pulaLinha
    mov ah,9
    int 21h

    ; Verifica se a resposta foi 's' ou 'S'
    cmp al, 83
    je inicio

    cmp al, 115
    je inicio

final:
    mov ah,4Ch
    int 21h

zero:
    mov dx, OFFSET texto4
    mov ah,9
    int 21h
    mov bx,0

    jmp apagarResultado

END
