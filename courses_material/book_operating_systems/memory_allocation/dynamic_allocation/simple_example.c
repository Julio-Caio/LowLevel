#include <stdio.h>
#include <stdlib.h>

int main()
{
	char *ptr ; // ponteiro para caracteres
	ptr = malloc(4096); // requisita uma alocação de um bloco de 4096 bytes
	
	if (ptr == NULL) { abort(); } // alocação deu erro

	for (int i = 0; i < 4096; i++) {
		ptr[i] = (char)(i & 0xFF);
	} // preenchimento da página alocada a Heap (4096 bytes == 4kb -> tamanho de uma página)

	free(ptr);

	return 0;
}
