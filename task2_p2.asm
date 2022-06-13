section .text
	global par

par:
	push	ebp
    lea 	ebp, [esp]

	push 	ebx							;echivalentul pusha doar fara eax = val de ret
	push 	ecx
	push 	edx

	xor		eax, eax					;pun adresa sizeului in eax
	xor     ecx, ecx		
	add		ebp, 8
	add		eax, ebp
	add     ecx, [eax]					;sizeul in ecx
	sub		ebp, 8

	xor 	esi, esi					;pun adresa stringului in ebx si stringul in esi		;
	xor		ebx, ebx
	add		ebp, 12
	add		ebx, ebp
	add		esi, [ebx]

	sub 	ebp, 12
	xor 	eax, eax
	xor 	ebx, ebx

	push	2							;verific daca size-ul este impar
	pop		ebx
	push 	ecx
	pop		eax
	xor		edx, edx
	div		bx
	cmp		edx, 1
	je		NOT_OK
	jne		CHECK


NOT_OK:									;paranteze nu sunt puse corect
	xor 	eax, eax
	jmp		FINISH


CHECK:									;daca size-ul e par verific 
	xor 	edi, edi					;contor pt push pop 
	dec 	ecx
	xor		ebx, ebx
	add		bl, byte[esi + ecx ];
	dec 	ecx
	push	ebx							;pun inainte de for un elem in stiva
	inc		edi


FOR:
	xor		ebx, ebx
	add		bl, byte[esi + ecx ];
	dec 	ecx

	xor		edx, edx					;scot elem ant din stiva si vf daca este egal cu cel curent
	pop		edx
	cmp		edx, ebx
	je		EQUAL
	jne 	NOT_EQUAL


EQUAL: 									;daca elem este la fel ca cel anterior se 
	push	ebx							; pune pe stiva cu tot cu anteriorul si 
	push	edx							;se mareste numarul de pushuri si se continua apoi
	inc  	edi	
	jmp 	CONTINUE


NOT_EQUAL:								;daca paranteza actuala e diferita de anterioara 
	dec		edi							;nu mai adaug nimic, elem anterior a fost deja extras si
	jmp 	CONTINUE					;doar scad numarul de pushuri ramase, apoi continui


CONTINUE:
	cmp		ecx, 0						;verific daca mai am elemente in string
	jl 		AFTER_FOR
	jge		CHECK_STACK

CHECK_STACK:
	cmp 	edi, 0						;daca mai am elemente in string verific daca stiva s-a golit
	je		CHECK						;in timpul forului pentru a nu da pop la ceva ce nu trebuie
	jne		FOR							;daca s-a golit se reface algoritmul de la CHECK pt stringul ramas


AFTER_FOR:								;aici se ajunge dupa ce am parcurs tot stringul
	cmp 	edi, 0						;verific nur de pushuri care indica daca sunt ok parantezele
	je		OK						
	jne 	FREE_STACK

FREE_STACK:
	xor		eax, eax					;au ramas caractere din string in stiva ce trebuiesc scoase
	pop		eax							;scot ce a ramas in stiva pana cand nu mai am aceste caractere
	dec 	edi						
	cmp 	edi, 0						;parantezele nu sunt corecte, am eliberat corect stiva pot sari la label
	je		NOT_OK
	jg		FREE_STACK

OK:										;am scos toate elem din string din stiva, parant sunt corecte
	xor 	eax, eax
	inc		eax	

FINISH:
    pop 	edx							;echivalentul popa doar ca fara eax pt a nu elimina val de ret
	pop 	ecx
	pop 	ebx

	xor		esp, esp
	add		esp, ebp
    pop 	ebp
    ret
