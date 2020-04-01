FROM alpine:3.10.3 as builder

RUN wget -O - 'https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz' \
  | gunzip -c >/usr/local/bin/elm
RUN chmod +x /usr/local/bin/elm

WORKDIR /root/

COPY elm.json .

# RUN elm install

COPY . .

EXPOSE 8000

CMD ["elm", "make", "src/Main.elm", "--output", "build/index.html"]

FROM nginx:alpine

COPY --from=builder /root/build/ /usr/share/nginx/html