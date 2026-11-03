FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates git openssh-client python3 python3-venv curl jq gh unzip xz-utils \
  build-essential pkg-config libstdc++6 libglu1-mesa libicu74 libsqlite3-0 \
  && rm -rf /var/lib/apt/lists/*
RUN groupadd -g 1002 whaleorcale && useradd -u 1001 -g 1002 -d /home/whaleorcale -m -s /bin/bash whaleorcale
ENV HOME=/home/whaleorcale
ENV PATH=/home/whaleorcale/.local/opt/creativanta/pnpm/bin:/home/whaleorcale/.local/opt/creativanta/go1.27.3/bin:/home/whaleorcale/.local/opt/creativanta/flutter-3.47.9/bin:/usr/local/bin:/usr/bin:/bin
USER 1001:1002
WORKDIR /opt/harness
ENTRYPOINT ["python3","-u","/opt/harness/supervisor.py"]
CMD ["run"]
