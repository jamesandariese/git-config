FROM alpine:3

RUN apk add git gomplate make bash

COPY . /src

ENTRYPOINT [ "/src/test/test.sh" ]

WORKDIR /src
