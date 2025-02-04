FROM python:3.11-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    python3-pip \
    python3-dev \
    gcc \
    libffi-dev \
    libssl-dev \
    wget \
    openssh-server \
    sudo \
    ufw \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# Install zinit
RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
    chmod +x /sbin/zinit

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh -o /usr/local/bin/install-ollama.sh && \
    chmod +x /usr/local/bin/install-ollama.sh && \
    sh /usr/local/bin/install-ollama.sh

# Install OpenWebUI
RUN pip install --no-cache-dir open-webui

# Copy scripts and zinit configurations
COPY ./scripts/ /scripts/
COPY ./zinit/ /etc/zinit/
RUN chmod +x /scripts/*.sh

EXPOSE 8080
EXPOSE 11434

# Set zinit as the entrypoint
ENTRYPOINT ["/sbin/zinit", "init"]