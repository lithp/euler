; /usr/local/bin/nasm -f macho64 1.asm
; ls -macosx_version_min 10.7.0 -lSystem -o 1 1.o
; ./1

global start

section .data

buffer: times 11 db 0 ; string buffer, fill with 0s

section .text

start:
  mov r8D, 0 ; our counter
  mov r10D, 0 ; fives
  mov r12D, 0 ; threes

  mov byte [rel buffer+1], 48
  mov byte [rel buffer+2], 48
  mov byte [rel buffer+3], 48
  mov byte [rel buffer+4], 48
  mov byte [rel buffer+5], 48
  mov byte [rel buffer+6], 48
  mov byte [rel buffer+7], 10

loop:
  mov edx, 0 ; should we add?
  inc r8D ; our counter goes up by one
  
  cmp r8D, 1000
  je finish

int_five:
  inc r10D
  cmp r10D, 5
  jne inc_three
  mov r10D, 0
  mov edx, 1 ; we should add!

inc_three:
  inc r12D
  cmp r12D, 3
  jne next
  mov r12D, 0
  mov edx, 1 ; we should add!

next:
  cmp edx, 1
  jne loop
  ; should now run incr once per r8D
  mov r9D, r8D
  jmp incr

add: ; incr calls this once it has finished
  dec r9D
  cmp r9D, 0
  jne incr
  jmp loop

incr:
  mov eax, 6 ; the current index, increment if we end up carrying
  lea ebx, [rel buffer]
  add ebx, eax

incr_inner:
  inc byte [ebx]
  cmp byte [ebx], 58
  je carry ; we have overflowed and need to carry
  jmp add

carry:
  sub byte [ebx], 10 ; set it back to '0'
  ; move over by a byte and repeat until we stop overflowing
  dec eax
  dec ebx
  jmp incr_inner

finish:
    mov     rax, 0x2000004 ; write
    mov     rdi, 1 ; stdout
    lea rsi, [rel buffer]
    mov rdx, 8 ; it's an 8 byte buffer
    syscall
    jmp end

end:
    mov     rax, 0x2000001 ; exit
    mov     rdi, 0
    syscall
