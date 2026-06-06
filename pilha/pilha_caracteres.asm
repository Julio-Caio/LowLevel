; ================================== ;
; Esta é uma demonstração de pilha ;
; ==================================;


section .data
	letras db "A", "B", "C"
	tamanho equ $ - letras

section .text ; diretriva que especifica a primeira instrução a ser executada pelo processador
	global _start

_start:
	; pegar valores da memória
	mov rsi, letras ; eu passo aqui o endereço inicial da label letras (sequência dos bytes)
	mov rdx, 1 ; eu delimito que apenas 1 byte será lido e escrito por vez
	mov rcx, tamanho ; especifico que rcx terá 3 bytes, pois iremos utilizá-lo com a instrução loop, no qual este será decrementado

empilhar:
	xor rax, rax ; limpar bits superiores de rax, evita que possua bits lixos durante o loop
	
	mov al, byte [rsi] ; mapeio 1 byte do valor armazenado no endereço de memória especificado por [rsi]
			   ; para os 8 bits menos significativos de rax
 
	inc rsi ; incremento rsi para apontar pro próximo byte de letras "seria o famoso array[i] de uma linguagem de alto nível"
	push rax ; faça um push do valor armazenado em rax, ou seja, aquele caractere de letras, para a pilha
	
	loop empilhar ; loop consulta o valor de rcx, decrementa o valor se não for 0. Se for 0
		      ; ele pula essa instrução e continua executando até o fim do programa
	
	mov rcx, tamanho ; após o loop ter terminado, e o valor de rcx ter ficado 0, precisamos agora desempilhar os valores da pilha
			 ; Para desempilhar, precisamos mover novamente para rcx, a quantidade de bytes daquela sopa de letras

desempilhar:
	push rcx ; fazemos um push do valor atual de rcx, pois syscalls do linux utilizam o 'rcx' e 'r11' para salvar return addresses
	; logo o valor que temos que decrementar pode ser destruído, e dessa forma, é bom ter um backup salvo na pilha
 
	xor rax, rax ; limpar os bits superiores de rax	(evitar que tenha lixo)	
	lea rsi, [rsp + 8] ; apontar para o stack pointer (topo da pilha + 8), ou seja, o 
	; caractere está posicionado após o valor de rcx na pilha
	
	mov rdx, 1 ; escrever apenas 1 byte após o endereço inicial de rsi

	mov rax, 1 ; montar valores para chamar syscall write
	mov rdi, 1 ; file descriptor para saída

	syscall ; invocar chamada de sistema, onde esta consulta os valores dos registradores rax, rdi
	
	pop rcx; restaura o valor de rcx após a chamada e sistema
	pop rax; ; desempilha o caractere da pilha
	
	loop desempilhar ; Decrementa rcx e repete o loop

	mov rax, 0x3c ; mover 60 para rax (syscall exit)
	xor rdi, rdi ; código 0, status ok ao terminar o programa
	syscall
