FROM golang:alpine as builder
COPY . /usr/src/egw/web
WORKDIR /usr/src/egw/web
RUN go build -o web ./main

FROM alpine
EXPOSE 8080
COPY --from=builder /usr/src/egw/web/web /usr/local/bin
RUN adduser --system --disabled-password --no-create-home egw
USER egw
CMD ["/usr/local/bin/web"]
