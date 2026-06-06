section .text
	global _start

_start:
	; guardo a posição inicial (onde o rsp está indicando agora no topo)
	; a ideia é que quando eu for adicionando mais elementos na pilha com push
	; eu possa subtrair o endereço do último rsp com o primeiro
	; a partir disso, tenho o tamanho em bytes dos dados empilhados

	mov r12, rsp
	push 0x00000001	
	push 0x00000002
	push 0x00000003
	push 0x00000004 
	
	mov rcx, r12 ; movo o endereço atual do stack pointer
	sub rcx, rsp ; subtraio, e a partir disso, obtenho o tamanho
	
	shr rcx, 3 ; deslocamento de 3 bits para direita --> rcx = 4
	
	; Explicando:
	
	; No nosso exemplo, temos 32 bits na pilha, pois empilhamos 4 bytes (4 * 8 bits)
	; ao deslocarmos 3 bits para direita, temos:

	; 0010 0000 (antes do shift right logical) -> valor: 32 bits
	; 0001 0000 (deslocamento do primeiro bit) -> valor: 32 / 2 = 16
	; 0000 1000 (deslocamento do segundo bit) -> valor: 16 / 2 = 8
	; 0000 0100 (deslocamento do terceiro bit) -> valor: 8 / 2 = 4
	
	
	; lógica antiga de soma, informando os endereços manualmente na pilha
	; mover o valor de 0x00002 para rax
	; mov rax, [rsp+0x18] ; 4
	; add rax, [rsp+0x10] ; 3
	; add rax, [rsp+0x08] ; 2
	; add rax, [rsp+0x00] ; 1
.loop:
	xor rdx, rdx ; limpa o rdx
	pop rdx
	add rax, rdx	
	dec rcx ; decrementa o contador
	jnz .loop ; se rcx ainda não for 0, fique executando o loop
	

