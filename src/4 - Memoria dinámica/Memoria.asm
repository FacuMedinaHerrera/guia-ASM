extern malloc
extern free
extern fprintf

section .data
formato db "%s ", 0

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
strCmp:
	push rbp
	mov rbp,rsp
	xor rax,rax

	.stringCompare:
		mov dl,byte [rdi]	;muevo a rdx el caracter a comparar, ya que no puedo hacer operacion de memoria a memoria.
		cmp dl,byte[rsi]	;comparo los caracteres de cada cadena. si a<b retorno 1. si a>b retorno -1. si son = sigo comparando.
		jl .menor
		jg .mayor
		cmp dl, 0			;si a terminó, o fueron != en la comparación anterior, o terminaron ambos y son =.
		je .finStrCmp
		inc rdi					;si no terminó, avanzo los punteros.
		inc rsi
		jmp .stringCompare

	.menor:
		inc rax
		jmp .finStrCmp
	.mayor:
		dec rax
		jmp .finStrCmp
	.finStrCmp:
	pop rbp
	ret

; char* strClone(char* a)
strClone:
	push rbp
	mov rbp,rsp
	xor rax,rax
	sub rsp,16 ;reservo memoria dejandola alineada
	mov [rbp-8], rdi ;guardo el puntero al original.
	call strLen
	mov rdi, rax	;como el tamaño de cada caracter es de 1 byte, la longitud de la cadena es el tamaño de memoria a reservar
	inc rdi			;espacio para '\0'
	call malloc		;ahora en rax tengo el puntero a la memoria reservada.
	mov rdi, [rbp-8];restauro el puntero a la cadena original
	mov rdx,rax		;guardo una copia del puntero a la copia para restaurar luego.

	.clonado:;debo pedir memoria por cada caracter. Primero me fijo la longitud total del arreglo y pido toda la memoria de una.
		cmp [rdi],byte 0
		je .finClonado
		mov sil,byte [rdi]
		mov byte [rax],sil	;copio el valor
		inc rdi
		inc rax			;aumento ambos punteros y sigo copiando
		jmp .clonado
	.finClonado:
	mov sil,byte [rdi]
	mov byte [rax],sil		;copio el '\0'

	mov rax,rdx			;restauro el inicio del puntero.
	add rsp,16
	pop rbp
	ret

; void strDelete(char* a)
strDelete:
	push rbp
	mov rbp, rsp

	call free

	pop rbp
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	push rbp
	mov rbp, rsp

	mov rdx, rdi
	mov rdi, rsi
	xor rsi,rsi
	lea rsi, [rel formato]

	call fprintf
	

	pop rbp
	ret

; uint32_t strLen(char* a)
strLen:
	push rbp
	mov rbp,rsp
	xor rax,rax
	.lengf:
		cmp [rdi], byte 0
		je .finLengf
		inc rax
		inc rdi
		jmp .lengf
	.finLengf:
	pop rbp
	ret


