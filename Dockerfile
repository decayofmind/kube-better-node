FROM golang:1.16-alpine as builder

WORKDIR /build

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY main.go ./

RUN go build

FROM scratch

COPY --from=builder ./kube-betternode /

ENTRYPOINT ["/kube-betternode"]
