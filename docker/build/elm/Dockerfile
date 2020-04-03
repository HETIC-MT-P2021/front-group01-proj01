FROM alpine:3.10.3 as builder

RUN wget -O - 'https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz' \
  | gunzip -c >/usr/local/bin/elm
RUN chmod +x /usr/local/bin/elm

WORKDIR /var/www/gallery

# RUN elm install

COPY app/ /var/www/gallery/

RUN elm make /var/www/gallery/src/Main.elm --optimize --output=elm.js