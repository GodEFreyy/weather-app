Zadanie 1 – część nieobowiązkowa (punkt 3)

Linki
GitHub: https://github.com/GodEFreyy/weather-app  
Docker Hub: https://hub.docker.com/r/godefrey/weather  


1. Wybór zadania
Zrealizowałem punkt 3

2. Przygotowanie buildx

export DOCKER_BUILDKIT=1
docker buildx create --name multi --driver docker-container --use
docker buildx inspect --bootstrap

3. Budowa obrazów z cache i SSH

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --push \
  -t godefrey/weather:tiny3 \
  --cache-to   type=registry,ref=godefrey/weather:buildcache,mode=max \
  --cache-from type=registry,ref=godefrey/weather:buildcache \
  --secret id=ssh_key,src=$HOME/.ssh/id_ed25519 \
  --ssh default=$HOME/.ssh/id_ed25519 \
  https://github.com/GodEFreyy/weather-app.git#main

4. Weryfikacja manifestu multi-arch
docker buildx imagetools inspect godefrey/weather:tiny3

5. Test uruchomienia
docker rm -f weather || true
docker run -d --name weather -p 8080:8080 godefrey/weather:tiny3
docker logs weather

Wynik:
Container started. Author: Nazar Malizderskyi Port:8080

6. Analiza podatności (Trivy)
trivy image --scanners vuln --severity CRITICAL,HIGH godefrey/weather:tiny3

Wynik: brak CRITICAL i HIGH (obraz bez krytycznych lub wysokich CVE).