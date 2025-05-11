# Zadanie 1 – część obowiązkowa

## 1. Linki
- **GitHub**: https://github.com/GodEFreyy/weather-app  
- **Docker Hub**: https://hub.docker.com/r/godefrey/weather

## 2. Kod aplikacji
Poniżej najważniejsze fragmenty (pełny kod dostępny w repozytorium):

```asm
# fragment serwera (server.S) z komentarzami wyjaśniającymi
.intel_syntax noprefix
.text
.global _start
_start:
    mov   rax,41            # socket(AF_INET, SOCK_STREAM, 0)
    …
.msg:                      # wiadomość logu
    .ascii "Container started. Author: Nazar Malizderskyi Port:8080\n"
…
