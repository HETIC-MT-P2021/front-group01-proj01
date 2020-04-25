FROM alpine:3.10.3 as builder

RUN wget -O - 'https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz' \
  | gunzip -c >/usr/local/bin/elm
RUN chmod +x /usr/local/bin/elm

WORKDIR /root/

COPY app/elm.json elm.json
COPY app/src ./src

RUN elm make src/Main.elm --optimize --output build/main.js

FROM nginx:alpine

COPY --from=builder /root/build/ /usr/share/nginx/html
COPY app/index.html /usr/share/nginx/html
COPY app/style.css /usr/share/nginx/html