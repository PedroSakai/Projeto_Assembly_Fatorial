.MODEL small
.STACK 100h
.DATA
    texto DB 'Digite um numero (maximo 5): $'
    texto2 DB  10, 13, 'O Fatorial e: $'
    alerta DB  10, 13, 'ALERTA! O valor digitado nao foi aceito, tente novamente', 10, 10, 13, '$'

    resultado DB 3 DUP('0'),'$'

.CODE
    mov ax,@data
    mov ds,ax
    jmp inicio

inicio:
    ;printa o texto ("Digite um numero (maximo 5): ")
    mov dx, OFFSET texto
    mov ah,9
    int 21h

;preparativos digitacao:
mov bx, 0

digitacao: ;Pega o numero digitado e armazena em um int(numero)
    ;le um caracter e salva no al:
    mov ah, 01h
    int 21h 
    sub al, 48 ;subtrai 48 no al para ficar com o codigo ASCII correto

conferencia: ;confere se o numero digitado esta entre 1 e 5
    ;ve se o codigo ASCII do valor é maior que 5 ou menor que 0
    cmp al, 8
    jg erro
    cmp al, 0
    jl erro


;preparativos fatorial:
    mov cl, al ;cl guarda o numero digitado
    mov ax, 1 ;ax vale 1 para nao atrapalhar a multiplicacao


fatorial: ;calculo do fatorial
    mul cl ;multiplica ax, que vale 1, por cl que vale o valor digitado
    dec cl ; decrementa cl

    ;Verifica se cl já chegou a zero e se nao executa o fatorial novamente:
    cmp cl,0
    jne fatorial

;preparativos printar:
mov cl, 10
mov bx,2
jmp printar ;pula o alerta

erro: ;calculo do fatorial
    mov dx, OFFSET alerta
    mov ah,9
    int 21h
    jmp inicio

printar: ;printando o fatorial na tela
    div cl ;divide o valor de ax por cl(10), com o resultado ficando no al e o resto no ah
    add ah, 48 ;soma 48 no ah (resto) para ficar com o codigo ASCII correto
    mov resultado[bx], ah ;adiciona na ultima posição do resultado o resto da divisao
    dec bx
    mov ah, 0 ;"apaga" o ah/resto, para a proxima divisão ficar correta
    
    ;Verifica se a divisao ja acabou, ou seja, se o resultado eh zero, se nao executa o printar novamente
    cmp al, 0 
    jne printar

    ;Printa o texto 2 ("O Fatorial eh: ")
    mov dx, OFFSET texto2
    mov ah,9
    int 21h

    ;Printa o Resultado
    mov dx, OFFSET resultado
    mov ah,9
    int 21h


final:
    mov ah,4Ch
    int 21h
END
