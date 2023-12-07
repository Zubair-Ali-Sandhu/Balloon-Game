[org 0x0100]

	jmp start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;variables;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	 board: dw 20
	message: db 'Score : ' ; string to be printed
	message1: db '  Game Ended ' ; string to be printeds
	message2: db 'Your Score : ' ; string to be printed
	message3: db 'Timer : ' ; string to be printed
	gname db  'Balloon Game', 0
	key: db   'press "x" key to continue', 0
	name1: db 'Zubair ALi 22P-9232', 0
	name2: db 'Zeshan Khalid 22P-9230', 0
	i1: db   'To burst the balloon';20 
	i2: db   'press the key inside the balloon';32 
	i3: db   'And increase your score';23
	dev: db  'Developers: ';11
        inst: db 'Instructions: ';13
	tickcount: dw 0 ; for timer 
	
	array: db 'akiwasndksnwondwidnwieodnxwioxdjwjewdijwdjhdgfhgdhadhghjgfdhsfafdtftysdjjhdjsdsiiueiyrwommasnjaoqiwew'; string to be printed
	arrcount: db 0 ; number 
	livescr: db 1;
	help: dw 0
	found: dw 0
	oldisr: dd 0
	count_total: dw 0   ; stores the score
	score: dw 0         ; stores total poped balloons
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;clear screen code;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clrscr: 
	push es
	push ax
	push di
	mov ax, 0xb800
	mov es, ax 							; point es to video base
	mov di, 0 							; point di to top left column
	
nextloc: 
	mov word [es:di], 0x0720 			; clear next char on screen
	add di, 2 							; move to next screen location
	cmp di, 4000 						; has the whole screen cleared
	jne nextloc 						; if no clear next position
	pop di
	pop ax
	pop es
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;boundary code;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
boundary:

 mov ax, 0xb800 ; load video base in ax
 mov es, ax ; point es to video base
 mov di, 0 ; point di to top left column
 
nextchar: 
	mov word [es:di], 0x4e00 ; clear next char on screen
	add di, 2 ; move to next screen location
	cmp di, 160 ; has the whole screen cleared
	jne nextchar ; if no clear next position		
	
	mov di, 3840 ; point di to top left column	
	
nextcharr: 
	mov word [es:di], 0x4e00 ; clear next char on screen
	add di, 2 ; move to next screen location
	cmp di, 4000 ; has the whole screen cleared
	jne nextcharr ; if no clear next position	
	
	mov cx , 10	
	mov ax, 0xb800	
	mov es, ax ; point es to video base	
	
	mov di , 130
	mov si, message3 ; point si to string
	mov ah, 1 ; load attribute in ah
	
	cld ; auto increment modee
	
w1:
	lodsb ; load next char in al
	stosw ; print char/attribute pair
	loop w1 ; repeat for the whole string


	mov di, 144;
	mov ax, 0xb800	
	mov es, ax ; point es to video base	
	mov bx , livescr+20	;
	mov word [es:di], bx ; 

	mov cx , 8
	mov ax, 0xb800	
	mov es, ax ; point es to video base	
	
	mov di , 24
	mov si, message ; point si to string
	mov ah, 1 ; load attribute in ah
	
	cld ; auto increment modee
	
w4:
	lodsb ; load next char in al
	stosw ; print char/attribute pair
	loop w4 ; repeat for the whole string
	
ret 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;delay code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
delay:
	push cx
	mov cx, 0x0019
delayLoop1:
	push cx
	mov cx, 0xffff
delayLoop2:
	loop delayLoop2
	pop cx
	loop delayLoop1
	pop cx
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;print balloon code;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printballoon:
	push bp
	mov bp,sp
	push ax
	push cx
	push si
	push di
	
	mov ax,0xb800
	mov es,ax
	mov al,80
	mul byte[bp+6]
	add ax,[bp+4]
	shl ax,1
	mov si,ax
	mov di,ax
	mov cx,6
	mov bx,[bp+8]

	
loop1:
;prints the upper boundary of balloon
	mov word [es:di],0x3800
	add di,2
	loop loop1
	
	mov dh,7
	mov dl , [array+bx]
	mov word[es:di + 150],dx 
	
	mov cx,3
	
loop2:
;prints the left and right side of balloon
	mov word[es:si],0x3800
	mov word[es:di],0x3800
	
	add si,160
	add di,160 
	loop loop2
	
loop3:
;prints the bottom of balloon
	mov word[es:si],0x3800
	add si,2
	cmp si,di
	jne loop3
	
	mov word[es:si],0x3800
	add si,2
	
	sub di,4
	sub si,10
	
	mov word[es:si],0x3800
	mov word[es:di],0x3800
	add di,160
	add si,160

	add si,2

	mov cx,1
	
loop5:
	add si,16
	
	add si,2
	loop loop5
	
	pop di
	pop si
	pop cx
	pop ax
	pop bp
	ret 4
	
	
balloon_pop:

loop_pop:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;scroll up code;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scroll_up:

	push bp
	mov bp,sp
	push ax
	push cx
	push si
	push di
	push es
	push ds
	
	mov ax, 80
	mul byte[bp+4]
	mov si,ax
	push si
	shl si,1
	mov cx, 1840
	sub cx,ax
	mov ax,0xb800
	mov es,ax
	mov ds,ax
	;xor di,di
	mov di , 160
	cld
	rep movsw
	mov ax,0x0720
	pop cx
	rep stosw
	
	pop ds
	pop es
	pop di
	pop si
	pop cx
	pop ax
	pop bp
	ret 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;remove balloon helper subroutine;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

remove_balloon:
	push bp
	mov bp,sp
	push ax
	push si
	push di
	push cx
	
	mov di,0
	mov ax,0xb800
	mov es,ax
	mov dx,[bp+4];; attribute passed as parameter
	
next:
	mov ax,[es:di]
	cmp ax,dx
	jne incrementa
	
	mov word[found],1; if a is matched and found in screen
	sub di,160
	sub di,2
	mov si,di
	mov cx,7
	
a1:
	mov word [es:di],0x0720
	add di,2
	loop a1
	
	;add si,160
	;mov word[es:si],0x0720
	
	mov di,si
	add di,160
	mov cx,6
a2:
	mov word [es:di],0x0720
	add di,2
	loop a2
	
	mov word [es:di],0x0720
	;mov di,si
	add di,160
	mov cx,7
a3:
	mov word [es:di],0x0720
	sub di,2
	loop a3
	
	add di,160
	mov cx,8
a4:
	mov word[es:di],0x0720
	add di,2
	loop a4
	
	jmp exita
	
incrementa:
	add di,2
	cmp di,4000
	jne next
	
exita:
	pop cx
	pop si
	pop di
	pop ax
	pop bp
	
	ret 2
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;kbisr subroutine;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
kbisr:
	push ax
	push es
	mov ax, 0xb800
	mov es, ax 
	
	in al, 0x60 ; read a char from keyboard port
	cmp al, 0x1e ; has the 'a' been pressed
	jne nextcmpb ; no, try next comparison

	mov dx,0x0761; if 'a' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatcha; if balloon has been remove
	
	jmp nextcmpb; else check for next comparison
	
nomatcha:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit 
	
nextcmpb: 
	cmp al, 0x30 ; has the right shift pressed
	jne nextcmpc ; no, try next comparison
	
	mov dx,0x0762; if 'b' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchb
	
	jmp nextcmpc; else check for next comparison
	
nomatchb:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit 
	
nextcmpc: 
	cmp al, 0x2e ; has the right shift pressed
	jne nextcmpd ; no, try next comparison
	
	mov dx,0x0763; if 'c' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchc

	jmp nextcmpd; else check for next comparison
	
nomatchc:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit 
	
nextcmpd: 
	cmp al, 0x20 ; has the right shift pressed
	jne nextcmpe ; no, try next comparison
	
	mov dx,0x0764; if 'd' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchd
	
	jmp nextcmpe; else check for next comparison
	
nomatchd:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit 
	
nextcmpe:
	cmp al, 0x12 ; has the right shift pressed
	jne nextcmpf ; no, try next comparison
	
	mov dx,0x0765; if 'e' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatche
	
	jmp nextcmpf; else check for next comparison
	
nomatche:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit 
	
nextcmpf:
	cmp al, 0x21 ; has the right shift pressed
	jne nextcmpg ; no, try next comparison
	
	mov dx,0x0766; if 'f' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchf
	
	jmp nextcmpg; else check for next comparison
	
nomatchf:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit 
	
nextcmpg:
	cmp al, 0x22 ; has the right shift pressed
	jne nextcmph ; no, try next comparison
	
	mov dx,0x0767; if 'g' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchg
	
	jmp nextcmph; else check for next comparison
	
nomatchg:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit 
	
nextcmph:
	cmp al, 0x23 ; has the right shift pressed
	jne nextcmpi ; no, try next comparison
	
	mov dx,0x0768; if 'h' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchh
	
	jmp nextcmpi; else check for next comparison
	
nomatchh:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit 
	
nextcmpi:
	cmp al, 0x17 ; has the right shift pressed
	jne nextcmpj ; no, try next comparison
	
	mov dx,0x0769; if 'i' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchi

	jmp nextcmpj; else check for next comparison
	
nomatchi:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit
	
nextcmpj:
	cmp al, 0x24 ; has the right shift pressed
	jne nextcmpk ; no, try next comparison
	
	mov dx,0x076a; if 'j' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchj

	jmp nextcmpk; else check for next comparison
	
nomatchj:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit
	
nextcmpk:
	cmp al, 0x25 ; has the right shift pressed
	jne nextcmpl ; no, try next comparison
	
	mov dx,0x076b; if 'k' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchk
	
	jmp nextcmpl; else check for next comparison
	
nomatchk:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit
	
nextcmpl:
	cmp al, 0x26 ; has the right shift pressed
	jne nextcmpm ; no, try next comparison
	
	mov dx,0x076c; if 'l' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchl
	
	jmp nextcmpm; else check for next comparison
	
nomatchl:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit

nextcmpm:
	cmp al, 0x32 ; has the right shift pressed
	jne nextcmpn ; no, try next comparison
	
	mov dx,0x076d; if 'm' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchm
	
	jmp nextcmpn; else check for next comparison
	
nomatchm:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit
	
nextcmpn:
	cmp al, 0x31 ; has the right shift pressed
	jne nextcmpo ; no, try next comparison
	
	mov dx,0x076e; if 'n' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchn
	
	jmp nextcmpo; else check for next comparison
	
nomatchn:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit
	
nextcmpo:
	cmp al, 0x18 ; has the right shift pressed
	jne nextcmpp ; no, try next comparison
	
	mov dx,0x076f; if 'o' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatcho
	
	jmp nextcmpp; else check for next comparison
	
nomatcho:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit

nextcmpp:
	cmp al, 0x19 ; has the right shift pressed
	jne nextcmpq ; no, try next comparison
	
	mov dx,0x0770; if 'p' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchp
	
	jmp nextcmpq; else check for next comparison
	
nomatchp:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit

nextcmpq:
	cmp al, 0x10 ; has the right shift pressed
	jne nextcmpr ; no, try next comparison
	
	mov dx,0x0771; if 'q' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchq
	
	jmp nextcmpr; else check for next comparison
	
nomatchq:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit
	
nextcmpr:
	cmp al, 0x13 ; has the right shift pressed
	jne nextcmps ; no, try next comparison
	
	mov dx,0x0772; if 'r' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchr
	
	jmp nextcmps; else check for next comparison
	
nomatchr:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit
	
nextcmps:
	cmp al, 0x1f ; has the right shift pressed
	jne nextcmpt ; no, try next comparison
	
	mov dx,0x0773; if 's' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchs
	
	jmp nextcmpt; else check for next comparison
	
nomatchs:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit

nextcmpt:
	cmp al, 0x14 ; has the right shift pressed
	jne nextcmpu ; no, try next comparison
	
	mov dx,0x0774; if 't' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatcht
	
	jmp nextcmpu; else check for next comparison
	
nomatcht:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit
	
nextcmpu:
	cmp al, 0x16 ; has the right shift pressed
	jne nextcmpv ; no, try next comparison
	
	mov dx,0x0775; if 'u' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchu
	
	jmp nextcmpv; else check for next comparison
	
nomatchu:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit
	
nextcmpv:
	cmp al, 0x2f ; has the right shift pressed
	jne nextcmpw ; no, try next comparison
	
	mov dx,0x0776; if 'v' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchv
	
	jmp nextcmpw; else check for next comparison
	
nomatchv:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit
	
nextcmpw:
	cmp al, 0x11 ; has the right shift pressed
	jne nextcmpx ; no, try next comparison
	
	mov dx,0x0777; if 'w' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchw
	
	jmp nextcmpx; else check for next comparison
	
nomatchw:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit
	
nextcmpx:
	cmp al, 0x2d ; has the right shift pressed
	jne nextcmpy ; no, try next comparison
	
	mov dx,0x0778; if 'x' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchx
	
	jmp nextcmpy; else check for next comparison
	
nomatchx:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit
	
nextcmpy:
	cmp al, 0x15 ; has the right shift pressed
	jne nextcmpz ; no, try next comparison
	
	mov dx,0x0779; if 'y' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je nomatchy
	
	jmp nextcmpz; else check for next comparison
	
nomatchy:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx
	jmp nomatch ; exit
	
nextcmpz:
	cmp al, 0x2c ; has the right shift pressed
	jne nomatch ; no, try next comparison
	
	mov dx,0x077a; if 'z' is pressed 
	push dx
	call remove_balloon ; remove the balloon
	
	cmp word[found],1
	je increment_score
	
increment_score:
	mov cx,[count_total]
	add cx,10
	mov [count_total],cx
	push cx
	call printnum
	mov cx,[score]
	add cx,1
	mov [score],cx

nomatch: 
	mov word [found],0
	pop es
	pop ax
	jmp far [cs:oldisr] ; call the original ISR
	mov al, 0x20
	out 0x20, al ; send EOI to PIC
	pop es
	pop ax
	iret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;printing balloon again and again;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
main_loop:

print1:
	mov ax,[help]
	push ax
	mov ax,19
	push ax
	mov ax,2
	push ax
	
	call printballoon
	mov ax,[help]
	add ax,1
	cmp ax,40
	je makezero1
	jmp simple1
makezero1:
	mov ax,0
simple1:
	mov [help],ax
	
	mov ax,7
	push ax
	call delay
	call scroll_up
	call delay
	call delay
	
print2:
	mov ax,[help]
	push ax
	mov ax,19
	push ax
	mov ax,32
	push ax
	call printballoon
	mov ax,[help]
	add ax,1
	cmp ax,40
	je makezero2
	jmp simple2
makezero2:
	mov ax,0
simple2:
	mov [help],ax
	
	mov ax,7
	push ax
	call delay
	call scroll_up
	call delay
	call delay
	
print3:
	mov ax,[help]
	push ax
	mov ax,19
	push ax
	mov ax,62
	push ax
	call printballoon
	mov ax,[help]
	add ax,1
	cmp ax,40
	je makezero3
	jmp simple3
makezero3:
	mov ax,0
simple3:
	mov [help],ax
	
	mov ax,7
	push ax
	call delay
	call scroll_up
	call delay
	call delay
	
	cmp cx,0
	je end_
	jmp main_loop
end_:
	pop ax
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Print Score code;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
printnum:
	push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push di
	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov ax, [bp+4] ; load number in ax
	;cmp ax , 120;;;;;;
	;je gameend;;;;;
	mov bx, 10 ; use base 10 for division
	mov cx, 0 ; initialize count of digits
	
nextdigit: 
	mov dx, 0 ; zero upper half of dividend
	div bx ; divide by 10
	add dl, 0x30 ; convert digit into ascii value
	push dx ; save ascii value on stack
	inc cx ; increment count of values
	cmp ax, 0 ; is the quotient zero
	jnz nextdigit ; if no divide it again
	mov di, 40 ; point di to 70th column
	
nextpos: 
	pop dx ; remove a digit from the stack
	mov dh, 0x07 ; use normal attribute
	mov [es:di], dx ; print char on screen
	add di, 2 ; move to next screen location
	loop nextpos ; repeat for all digits on stack
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
 
	ret 2
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;TIMER;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








	
printnum2:
	push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push di
	
	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov ax, [bp+4] ; load number in ax
	cmp ax , 320;;;;;;
	je gameend;;;;;
	mov bx, 10 ; use base 10 for division
	mov cx, 0 ; initialize count of digits
	
nextdigitt: 
	mov dx, 0 ; zero upper half of dividend
	div bx ; divide by 10
	add dl, 0x30 ; convert digit into ascii value
	push dx ; save ascii value on stack
	inc cx ; increment count of values
	;call delay 
	cmp ax, 0 ; is the quotient zero
	jnz nextdigitt ; if no divide it again
	mov di, 150 ; point di to 70th column
	
nextposs: 
	pop dx ; remove a digit from the stack
	mov dh, 0x07 ; use normal attribute
	mov [es:di], dx ; print char on screen
	add di, 2 ; move to next screen location
	loop nextposs ; repeat for all digits on stack
	
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
 
 ret 2
 
; timer interrupt service routine
timer: 
	push ax
	inc word [cs:tickcount]; increment tick count
	push word [cs:tickcount]
	call printnum2 ; print tick count
	
	;call delay
	mov al, 0x20
	out 0x20, al ; end of interrupt
	pop ax
 iret ; return from interrupt 
 
startt: 
	xor ax, ax
	mov es, ax ; point es to IVT base
	cli ; disable interrupts
	mov word [es:8*4], timer; store offset at n*4
	mov [es:8*4+2], cs ; store segment at n*4+2
	sti ; enable interrupts
	mov dx, startt ; end of resident portion
	add dx, 15 ; round up to next para
	mov cl, 4
	shr dx, cl ; number of paras
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;end screen;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	
gameend: 
	call clrscr
	
	mov ax, 0xb800 ; load video base in ax
	mov es, ax ; point es to video base
	mov di, 0 ; point di to top left column
 
	nextchart:
		 mov word [es:di], 0x0020 ; clear next char on screen
		add di, 2 ; move to next screen location
		cmp di, 4000 ; has the whole screen cleared
		jne nextchart ; if no clear next position		
	;
		
	mov ax, 0xb800	
	mov es, ax ; point es to video base	
	
	mov di , 996
	mov si, message1 ; point si to string
	mov ah, 1 ; load attribute in ah	
	mov cx , 13	
	
	
	
	cld ; auto increment modee
	
w2:
	lodsb ; load next char in al
	stosw ; print char/attribute pair
	loop w2 ; repeat for the whole string
		

	
	mov di , 1960
	mov si, message2 ; point si to string
	mov cx , 13		
	cld ; auto increment modee	
w3:
	lodsb ; load next char in al
	stosw ; print char/attribute pair
	loop w3 ; repeat for the whole string
		
	
	
	mov ax, 0xb800
        mov di, 1989;	
	mov es, ax ; point es to video base
	mov bx , 0
	mov bh , 0x06 
	mov bx , count_total

	mov word [es:1989], bx ; 
	
	mov ax,0x4c00
	int 21h
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Start Screen;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

wait_for_key:
    xor ah, ah
    int 0x16
	cmp al, 'x'
	jne wait_for_key
    ret


;-------------------------------------------------------------------
start_screen:
	call clrscr
	push 0x6
        mov ax,gname
	push ax
	push 12
	push 0x05

        call print_main
        push 0x1f
	mov ax,dev
	push ax
	push 11
	push 0x07
	call print_main
	push 0x6
        mov ax,name1
	push ax
	push 19
	push 0x08
	call print_main
	push 0x6
	mov ax,name2
	push ax
	push 22
	push 0x09
	call print_main
	push 0x1f
	mov ax,inst
	push ax
	push 13
	push 0x0c
	call print_main
	push 0x6
	mov ax,i1
	push ax 
	push 20
	push 0x0d
	call print_main
	push 0x6
	mov ax,i2
	push ax 
	push 32
	push 0x0e
	call print_main
	push 0x6
	mov ax,i3
	push ax 
	push 23
	push 0x0f
	call print_main
	push 0xf1
	mov ax,key
        push ax 
	push 25
	push 0x14
	call print_main
	ret

print_main:
	push bp
	mov bp, sp

	push ax
	push bx
	push cx
	push dx
	push es


	mov ah, 0x13	; Screen output Code
	mov al, 1		; Sub-code text output
	mov bh, 0		; page number
	mov bl, [bp+10]		; text attribute

	mov dh, [bp+4]	; row number
	mov dl, 0x01e	; column number

	mov cx, [bp+6]		; string length
	push cs
	pop es
	mov bp, [bp+8]

	int 0x10		; video service interrupt call

	pop es
	pop dx-
	pop cx
	pop bx
	pop ax
	pop bp
	ret 8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start:
	call start_screen

        call wait_for_key
	mov ax,[count_total]
	push ax
	call printnum
	
	xor ax, ax  ; hook key borad interupt
	mov es, ax 
	mov ax, [es:9*4]
	mov [oldisr], ax
	mov ax, [es:9*4+2]
	mov [oldisr+2], ax 
	cli
	mov word [es:9*4], kbisr 
	mov [es:9*4+2], cs 
	sti
	call startt
	call clrscr
	call boundary
	mov cx,3
	call main_loop
	
	mov ax,0x4c00
	int 21h