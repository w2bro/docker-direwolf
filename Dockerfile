FROM debian:buster-slim as base
RUN mkdir -p /etc/direwolf
RUN apt-get update && apt-get upgrade \
 && apt-get install -y \
    rtl-sdr \
    libasound2-dev \
    libusb-1.0-0-dev \
 && rm -rf /var/lib/apt/lists/*

FROM base as builder
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    cmake \
 && rm -rf /var/lib/apt/lists/*

RUN git clone "https://github.com/wb2osz/direwolf.git" /tmp/direwolf \
  && cd /tmp/direwolf \
  && make \
  && make DESTDIR=/target install \
  && find /target/bin -type f -exec strip -p --strip-debug {} \;

FROM base
COPY --from=builder /target/ /usr/local/
COPY --from=builder /etc/udev/rules.d/99-direwolf-cmedia.rules /etc/udev/rules.d/99-direwolf-cmedia.rules

ENV ADEVICE stdin null \
    CALLSIGN N0CALL \
    PASSCODE -1 \
    IGSERVER noam.aprs2.net \
    FREQUENCY 144.39M \
    COMMENT Direwolf in Docker w2bro/direwolf \
    SYMBOL igate

COPY start.sh direwolf.conf /etc/direwolf/
WORKDIR /etc/direwolf

CMD ["/bin/sh", "/etc/direwolf/start.sh"]
