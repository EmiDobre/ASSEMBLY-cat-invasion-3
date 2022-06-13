section .text
	global sort

sort:
	enter 0, 0

	push 	ebx
	push 	ecx
	push 	edx

	mov 	ecx, [ebp + 8]
	mov 	ebx, [ebp + 12]					; vect liste
	
	dec 	ecx
	mov 	edi, ecx						;retin nr de elem = contor pt cand caut elem mai mare
	push 	ecx								;pt cand voi calcula nodul cu val minima care va fi eax


FOR:										;parcurg vect si pt fiecare elem o sa caut elem+1
	push 	edi								;pun pe stiva nr de elem

	xor 	edi, edi
	xor		esi, esi
	
	lea		edi, [ebx + 8*ecx]				;in edi am adresa elementului curent
	xor 	eax, eax
	mov 	eax, dword[edi] 

	lea 	esi, [ebx + 8*ecx + 4]			;in  esi retin adresa de next
	mov		edx, dword[esi]					;in [esi] o sa pun adresa (elem+1) cand o gasesc

	inc 	eax								;gasesc adresa elem urmator
	pop 	edi								;nr de elemente 
	push 	esi								;pun adresa campului de urm pe stiva 
	jmp 	FIND_URM						;caut elementul in vector


CONTINUE_FOR:
	dec 	ecx
	cmp 	ecx, 0
	jge		FOR								;mai am elem de linkat
	jl 		LIST							;am terminat de stabilit legaturile

	
FIND_URM:									;retin nr el din vector inainte de for					
	push 	edi								;deoarece la fecare cautare pierd nr de elem
																						
FIND_URM_FOR:
	xor 	esi, esi						;adresa elem de gasit(a lui eax din forul ant)
	xor		edx, edx

	lea 	esi, [ebx + edi*8]
	mov 	edx, dword[ebx + edi*8]			;val din vector
	cmp 	edx, eax
	je      FOUND

	dec		edi
	cmp 	edi, 0
	jge		FIND_URM_FOR					;am gasit elementul cautat si pun adresa lui unde trebuie
	jl 		NOT_FOUND	


NOT_FOUND:
	xor 	edi, edi
	pop		edi								;nr de elemente din vector, retinut ant pe stiva
	xor 	esi, esi
	pop		edx								;adresa campului urm din stiva, pun 0 la val
	mov		[edx], esi
	jmp 	CONTINUE_FOR					;nu am gasit elem mai mare, e ultimul din lista


FOUND:
	xor 	edi, edi
	pop		edi								;nr elem din vector
	xor 	edx, edx
	pop		edx								;adresa campului urm la care pun adresa elem gasit
	mov 	[edx], esi						;la val de la adresa urmatorului se pune adresa acestuia

	jmp 	CONTINUE_FOR					;continui si fac aceeasi cautare pt toate elem din vect


LIST:										;am terminat de pus legaturile intre noduri
	xor 	ecx, ecx
	pop 	ecx								;aflu minimul, pun inapoi in ecx nr de elm din vect
	inc 	ecx
	
	xor 	edx, edx						;contor pt a parcurge vectorul
	xor		eax, eax 						;valoare din nod
	xor		edi, edi						;MINIM
	mov		edi, dword[ebx + edx*8]    		;init minim cu primul elem
	inc 	edx


FOR_MIN:
	xor 	eax, eax
	mov 	eax, dword[ebx + edx*8]			;compar cu celelalte elem
	cmp 	eax, edi
	jl 		NEW_MIN


CONT_MIN:
	inc		edx
	cmp 	edx, ecx
	jl 		FOR_MIN
	jge		FINISH


NEW_MIN:
	xor		esi, esi
	lea 	esi, [ebx + edx*8]				;adresa noului min, edi e val sa
	mov 	edi, [esi]
	jmp 	CONT_MIN
	

FINISH:
	mov 	eax, esi						;pun in eax adr nod cu val cea mai mica
	
	pop 	edx							
	pop 	ecx
	pop 	ebx

	leave
	ret
