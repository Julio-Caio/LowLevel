#include <stdio.h>
#include <Windows.h>

/*
 Exemplo de pipe anônima do Windows
 Pipe são objetos (buffers temporários) criados pelo kernel para permitir a comunicação entre processos (IPC)
 Existe um processo produtor e um processo consumidor
*/

int main() {
	// create handlers (descriptors para o pipe), em termos simples, imagine o pipe como um cano que tem uma ponta que entra (escrita) e sai (read) água
	// quando o Windows cria esse cano, ele preciso desses identificadores para conectar aquele buffer entre dois processos que querem se 'comunicar entre si'
	// Num telefone de latinhas, a latinha que uma pessoa fala seria o hWrite, e a latinha que o outra pessoa escuta na outra ponta, hRead;
	HANDLE hRead, hWrite;

	if (!CreatePipe(&hRead, &hWrite, NULL, 0)) {
		printf("Erro ao criar pipe!\n");
		return 1;
	}
	// crio a mensagem a ser escrita no buffer
	char msg[] = "Hello World!\n";
	char buffer[sizeof(msg)];

	DWORD read, written;

	/*
	* Imagine um cano de água (pipe). Ligamos esse cano em uma torneira de bytes (msg)
	// Ao ligarmos essa torneira (WriteFile) estaremos despejando os bytes de msg ('H', 'E'...) neste cano. 
	Após a execução de WriteFile ...
	// retornará True se a operação de escrita for bem-sucedida e 
	// o número de bytes que foram escritos serão armazenados na variável apontada por &written (neste caso, 14 bytes)
	*/

	if (!WriteFile(hWrite, msg, sizeof(msg), &written, NULL)) {
		fprintf(stderr, "Erro ao escrever no pipe!\n");
		return 1;
	}

	if (!ReadFile(hRead, buffer, sizeof(msg), &read, NULL)) {
		fprintf(stderr, "Erro ao ler o pipe!\n");
		return 1;
	}

	printf("%s", buffer);

	CloseHandle(hWrite);
	CloseHandle(hRead);

	return 0;

}
