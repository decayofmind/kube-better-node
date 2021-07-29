FROM golang:1.16.6 as builder

WORKDIR /build

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY main.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build

FROM scratch

USER 1000

COPY --from=builder /build/kube-better-node /bin/kube-better-node

ENTRYPOINT ["/bin/kube-better-node"]
