;Orlando Companioni
;This program will check if there is a palindrome in a sentence
;It will also print the number of palindromes it found on the screen                        
include 'emu8086.inc'  

org 100h     

mov dx, 100
LEA di, sourceString  ;moving the string address into di,
   

;GET_STRING reads from DI
call GET_STRING
putc 0dh
putc 0ah   
      
step1:
mov cx,0; Initialize counter
counting: 
mov al,[di]
cmp al,' '   
je end
cmp al,0 
je ending:
inc cx;increase the counter by 1
inc di
jmp counting     ;cant use loop because the counter is 0 so I used jmp so it would go regardless


ending:
mov [done],1  

end:          
cmp counter,0 
jne step2:     
mov si,di 
mov dx,di   ;ax hold the space
dec si
lea di,sourceString 
jmp rep


step2:
mov dx,di
mov si,di
dec si
mov di,start

rep: mov al,[di]
mov bl,[si]
cmp al,bl
jne notfound   ;jump to notFound if the letters are not the same.
inc di
dec si          ;decrease the memory add of si 
loop rep    
       
inc newCounter ;increase the actual counter
inc counter
mov start,dx
inc start 
cmp done,1
jne step1  
 
foundONE:  
lea si,found
call PRINT_STRING   ;PRINT_STRING uses SI register
putc 0dh
putc 0ah     


mov ax, newCounter               ; load result into ax
    mov bx, 10                  ; divisor for conversion to ascii
    lea si, [words+1]        ; point si to end of words, so it starts insert from end, little ENDIAN               
convert:
        xor dx,dx          ; clear dx for division
        div bx              ; divide ax by 10, quotient in ax, remainder in dx
        ; dividing by 10 to separate the digits of the result: 
        ; 32357/10 = 3235, remainder = 7
        ; 3235/10 = 323, remainder = 5
        ; 323/10 = 32, remainder = 3
        ; 32/10 = 3, remainder = 2
        ; 3/10 = 0, remainder = 3
        ; so the result is 3 2 3 5 7 spilt with the loop
        ; and since we are inserting from the end, the order is perfect
        add dl,'0' ; convert remainder to ascii
        ; 7 + '0' = 0x7 + 0x30 = 0x37 = '7'
        ; 5 + '0' = 0x5 + 0x30 = 0x35 = '5'
        ; 3 + '0' = 0x3 + 0x30 = 0x33 = '3'
        ; 2 + '0' = 0x2 + 0x30 = 0x32 = '2'
        ; 3 + '0' = 0x3 + 0x30 = 0x33 = '3'
        ; so the result is "3", "2", "3", "5", "7" stored in WORDS with the loop
        dec     si              ; move si to one position closer to beginning in WORDS
        mov     [si],dl         ;store character in WORDS
        test    ax,ax           ;check if quotient is zero
        jnz     convert         ; if not 0, repeat conversion 


lea si,sentence        
call PRINT_STRING
  
        
lea si,words        
call PRINT_STRING
 

lea si, wordEnd      
call PRINT_STRING
 


mov cx,newCounter
beep:
mov ah, 0eh  
mov al, 07h
int 10h  
loop beep:
jmp finish  ;jump into the finish part




notFound:  
inc counter
cmp done,1
je badFIN  
mov start,dx
inc start 
jmp step1

badFIN: 
cmp foundPaly,0  ;CHECK IF there was a palindrome ever found
jne foundONE     ;if it didnt then print not found else go to the next one    

lea si,Nfound
call PRINT_STRING
putc 0dh
putc 0ah  

 
 
finish:ret
sourceString db 100 dup(0);any spaces after the string will be 0    
wordTprint db 50 dup(0)
found db "Found palindrome",(0)   ;null terminator 
Nfound db "No palindromic on this word",(0)
sentence db "There are: ",(0)
wordEnd db " Palindromic Words     :)",(0)
start dw ?
counter db 0 
done db ? 
words dw 0 ;ascii 
foundPaly db 0
newCounter dw 0   ;actual counter          
DEFINE_GET_STRING        
DEFINE_PRINT_STRING 


    
        
       



