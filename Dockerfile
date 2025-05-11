# syntax=docker/dockerfile:1
FROM alpine:3.20 AS build
LABEL org.opencontainers.image.authors="Nazar Malizderskyi"
RUN apk add --no-cache gcc upx binutils
WORKDIR /src
COPY server.S page.html .
RUN gcc -nostdlib -nostartfiles -static -Os -s \
      -Wl,--build-id=none -Wl,--gc-sections -Wl,--strip-all \
      server.S -o server \
 && upx --ultra-brute server

FROM scratch
LABEL org.opencontainers.image.authors="Nazar Malizderskyi"
COPY --from=build /src/server /server
CMD ["/server"]
