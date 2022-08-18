.MODEL small
.STACK 100h
.DATA
    texto DB 10, 13, 'Digite um numero (maximo 8): $'
    texto2 DB  10, 13, 'O Fatorial e: $'
    texto3 DB  10, 13, 'Reiniciar? (S/N): $'
    alerta DB  10, 13, 'ALERTA! O valor digitado nao foi aceito, tente novamente', 10, 10, 13, '$'
    alertanegativo DB  10, 13, 'ALERTA! Nao e permitido valores negativos!', 10, 10, 13, '$'
    pulaLinha DB 10, 13, '$'

    resultado DB 5 DUP('0'),'$'
    valor BYTE 100 DUP(0)

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

    sub al, 48 ;subtrai 48 no al para ficar com o codigo ASCII correto

conferencia: ;confere se o numero digitado esta entre 1 e 5 
    ;ve se o codigo ASCII do valor é maior que 5 ou menor que 0
    cmp al, 8
    jg erro
    cmp al, 1
    jl erro

jmp preparativosfatorial
erro: ;calculo do fatorial
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
    ;mov num, al
    mov cx, 0
    mov cl, al ;cx guarda o numero digitado
    mov ax, 1 ;ax vale 1 para nao atrapalhar a multiplicacao

fatorial: ;calculo do fatorial
    mul cx ;multiplica ax, que vale 1, por cx que vale o valor digitado cx
    dec cx ; decrementa cx

    ;Verifica se cx já chegou a zero e se nao executa o fatorial novamente:
    cmp cx,0
    jne fatorial
    

;preparativos printar:
mov cx, 10
mov bx, 4
mov dx,0

print: ;printando o fatorial na tela
    div cx ;divide o valor de ax por cx(10), com o resultado ficando no ax e o resto no dx

    add dx, 48 ;soma 48 no dx (resto) para ficar com o codigo ASCII correto
    mov resultado[bx], dl ;adiciona na ultima posição do resultado o resto da divisao
    dec bx

    mov dx,0 ;"apaga" o dx/resto, para a proxima divisão ficar correta

    ;Verifica se a divisao ja acabou, ou seja, se o resultado eh zero, se nao executa o printar novamente
    cmp ax, 0
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
apagarResultado:
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

    cmp al, 83
    je inicio

    cmp al, 115
    je inicio

final:
    mov ah,4Ch
    int 21h

END
