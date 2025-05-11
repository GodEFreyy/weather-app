.intel_syntax noprefix
.text
.global _start

_start:
    # socket(AF_INET=2, SOCK_STREAM=1, 0)
    mov   rax, 41
    mov   rdi, 2
    mov   rsi, 1
    xor   rdx, rdx
    syscall
    mov   r12, rax            # save listen_fd

    # write startup log to stdout (fd=1)
    mov   rax, 1              # SYS_write
    mov   rdi, 1              # fd = 1
    lea   rsi, [rip + msg]
    mov   rdx, msg_end - msg
    syscall

    # bind(listen_fd, &sockaddr, 16)
    mov   rax, 49             # SYS_bind
    mov   rdi, r12
    lea   rsi, [rip + sockaddr]
    mov   rdx, 16
    syscall

    # listen(listen_fd, 5)
    mov   rax, 50             # SYS_listen
    mov   rdi, r12
    mov   rsi, 5
    syscall

accept_loop:
    # accept(listen_fd, NULL, NULL)
    mov   rax, 43             # SYS_accept
    mov   rdi, r12
    xor   rsi, rsi
    xor   rdx, rdx
    syscall
    mov   r13, rax            # client_fd

    # read(client_fd, tmp, 512)
    mov   rax, 0              # SYS_read
    mov   rdi, r13
    lea   rsi, [rsp - 512]
    mov   rdx, 512
    syscall

    # write HTTP header
    mov   rax, 1              # SYS_write
    mov   rdi, r13
    lea   rsi, [rip + hdr]
    lea   rdx, [rip + hdr_end]
    sub   rdx, rsi
    syscall

    # write HTML page
    mov   rax, 1              # SYS_write
    mov   rdi, r13
    lea   rsi, [rip + page]
    lea   rdx, [rip + page_end]
    sub   rdx, rsi
    syscall

    # close(client_fd)
    mov   rax, 3              # SYS_close
    mov   rdi, r13
    syscall

    jmp   accept_loop

.section .rodata
msg:
    .ascii "Container started. Author: Nazar Malizderskyi Port:8080\n"
msg_end:

hdr:
    .ascii "HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n"
hdr_end:

page:
    .incbin "page.html"
page_end:

.section .data
sockaddr:
    .short 2                  # AF_INET
    .short 0x901f             # htons(8080)
    .long 0                   # INADDR_ANY
    .long 0                   # padding
