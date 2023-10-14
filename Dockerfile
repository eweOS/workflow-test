FROM --platform=$BUILDPLATFORM alpine:latest AS builder
ARG TARGETPLATFORM

RUN mkdir -p /rootfs
WORKDIR /
RUN apk add wget
RUN case ${TARGETPLATFORM} in \
            "amd64")  DOWNARCH=x86_64  ;; \
            "arm64")  DOWNARCH=aarch64  ;; \
    esac && \
    wget -r -np -nd -R "index.html*" -A "eweos-$DOWNARCH-tarball-*.xz" https://os-repo.ewe.moe/eweos-images/$DOWNARCH/ && mv ./*.xz image.tar.xz && tar xf ./image.tar.xz -C /rootfs

FROM scratch AS root
COPY --from=builder /rootfs/ /

CMD ["/usr/bin/bash"]
