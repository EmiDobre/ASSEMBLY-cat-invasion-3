section .text
	global cmmmc

cmmmc:
	push	ebp
    lea 	ebp, [esp]

	push 	ebx							;echivalentul pusha doar fara eax pt a retine val de ret
	push 	ecx
	push 	edx

	xor		eax, eax					;pun adresa lui a in eax si adreesa lui b in ebx
	xor     edi, edi					;in final in edi il retin pe a efectiv
	add		ebp, 8
	add		eax, ebp
	add     edi, [eax]
	sub		ebp, 8
	
	xor     esi, esi					;in esi il retin pe b efectiv
	xor 	ebx, ebx
	add		ebp, 12
	add		ebx, ebp
	add     esi, [ebx]

	sub 	ebp, 12						;readuc baza stivei unde era
	xor 	eax, eax
	xor 	ebx, ebx
	
	xor		edx, edx					;aici retin cmmdc inainte de a afla puterea maxima divizor
	add		edx, 1						;inainte de FOR care testeaza pana ce caturile devin 0 pt ambele
	push 	edx 						;sau pana cand ecx ajunge egal cu unul din ele=>prime intre ele
	xor 	ecx, ecx					;ecx divizor de analizat
	add		ecx, 2
	jmp 	NUMBER1						;prima data pornesc cu ecx = 2
	

FOR:	
	push 	edx							;cmmdc anterior
	add		ecx, 1
	cmp 	ecx, edi
	je		FINISH
	cmp		ecx, esi
	je		FINISH
	cmp		esi, 0
	je		CHECK_2
	jne 	NUMBER1


CHECK_2:
	cmp 	edi, 0						;vf daca am de verificat si al doilea nr
	je		FINISH
	jne		NUMBER1


NUMBER1:								;aflu puterea div in cele 2 nr				 
	xor		ebx, ebx					;aici retin puterea divizorului
	add		ebx, 1

	xor 	edx, edx
	xor		eax, eax
	push	edi							;pun pe stiva nr pt a le schimba cu eax
	pop		eax							;nr1 retinut acum in eax
	div		cx							;impart la primul div, cat in eax, rest in edx
	cmp 	edx, 0
	je		IS_DIV						;doar daca e divizor aflu puterea in nr
	jne		STOP_DIV


IS_DIV:
	push 	eax							;catul de la primul nr care va deveni primul nr
	pop		edi
	push 	ecx
	pop		ebx							;ebx devine egal cu div si apoi ii aflu puterea max				
	jmp 	POWER						;acum aflu de cate ori apare divizorul in numarul ramas


POWER:
	xor 	edx, edx		
	xor		eax, eax
	push	edi							;pun pe stiva nr pt a le schimba cu eax
	pop		eax							;nr1 retinut acum in eax
	div		cx							;impart la primul div, cat in eax, rest in edx
	cmp 	edx, 0
	je		DIV_FOR_NR1
	jne		STOP_DIV


DIV_FOR_NR1:
	push 	eax							;catul de la primul nr care va deveni primul nr
	pop		edi				

	push	ebx							;retin puterea actuala a divizorului
	xor 	eax, eax					;modific puterea
	xor 	edx, edx
	pop 	eax							;putere anterioara a divizorului

	mul 	ecx
	push	eax							;pun noua putere a div pe stiva
	pop 	ebx							;puterea lui ecx cu care am pornit
	jmp 	POWER


STOP_DIV:
	cmp 	esi, -1
	je		MAX_POWER
	jne		NUMBER2


NUMBER2:
	push 	edi							;pun catul la care am ramas pt numar pe stiva
	push 	ebx							;repet pt al doilea, retin val lui ebx pe stiva
	push 	esi							;schimb intre registrii val nr pt a afla puterea max pt nr2
	pop		edi
	xor 	esi, esi
	sub 	esi, 1						;esi devine -1 cand am verificat si pentru al doilea numar
	jmp		NUMBER1


MAX_POWER:
	xor 	eax, eax
	pop		eax							;puterea maxima pt primul numar
	pop		esi							;catul primului numar

	cmp 	ebx, eax					;ebx este pt al doilea numar
	jg		TWO							;inmultesc max la cmmdc obtinut pana acum
	jle		ONE


TWO:
	xor 	edx, edx
	pop		edx							;inmultesc la cmmdc anterior
	xor		eax, eax
	push 	ebx
	pop		eax
	mul		edx
	xor 	edx, edx
	push 	eax
	pop		edx
	jmp 	FOR


ONE:
	xor 	edx, edx
	pop		edx
	mul		edx							;div este la putere mai mare in primul numar, eax
	xor		edx, edx
	push 	eax
	pop		edx
	jmp 	FOR


FINISH:
	xor		edx, edx
	pop		edx
	push 	edx
	pop		eax
	xor		edx, edx
	mul		edi							;daca am ajuns aici numerele edi si esi sunt prime intre ele 
	mul		esi							;deci le inmultesc la cmmdc
	
	pop 	edx							;echivalentul popa doar ca fara eax pt a nu elimina val de ret
	pop 	ecx
	pop 	ebx

	xor		esp, esp
	add		esp, ebp
    pop 	ebp
    ret
