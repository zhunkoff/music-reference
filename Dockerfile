# Copyright (c) 2026 Sergey Zhunkov.
# SPDX-License-Identifier: CC-BY-4.0

FROM debian:trixie-slim@sha256:8aa5a7bf5a1955bddbe7d74fcdd0b91ab30e74362a8b73af672b0481b35b44a0

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        fonts-dejavu-extra \
        just \
        latexmk \
        libyaml-pp-perl \
        texlive-lang-cyrillic \
        texlive-lang-english \
        texlive-latex-extra \
        texlive-luatex \
        texlive-music \
        texlive-pictures \
    && rm -rf /var/lib/apt/lists/*

# Allow font caching when running with a numeric UID from the host.
ENV TEXMFVAR=/tmp \
    OSFONTDIR=/usr/share/fonts/truetype/dejavu

WORKDIR /workspace
ENTRYPOINT ["just"]
CMD ["--list"]
