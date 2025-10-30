# Debian-based image with fish, nushell, oh-my-posh (ys theme), git, curl, and jq
FROM debian:bookworm-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV OH_MY_POSH_VERSION=21.15.1
ENV NUSHELL_VERSION=0.98.0

# Update and install basic dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    jq \
    ca-certificates \
    gnupg \
    unzip \
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install fish shell (available in Debian bookworm)
RUN apt-get update && apt-get install -y fish \
    && rm -rf /var/lib/apt/lists/*

# Install nushell
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        NU_ARCH="x86_64"; \
    elif [ "$ARCH" = "arm64" ]; then \
        NU_ARCH="aarch64"; \
    else \
        NU_ARCH="$ARCH"; \
    fi && \
    curl -k -L -o nu.tar.gz "https://github.com/nushell/nushell/releases/download/${NUSHELL_VERSION}/nu-${NU_ARCH}-unknown-linux-musl.tar.gz" && \
    tar -xzf nu.tar.gz && \
    find . -name "nu" -type f -executable -exec mv {} /usr/local/bin/ \; && \
    rm -rf nu.tar.gz nu-*

# Install oh-my-posh
RUN curl -k -L -o /usr/local/bin/oh-my-posh "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v${OH_MY_POSH_VERSION}/posh-linux-amd64" && \
    chmod +x /usr/local/bin/oh-my-posh

# Create themes directory and download ys theme
RUN mkdir -p /root/.config/oh-my-posh/themes && \
    curl -k -L -o /root/.config/oh-my-posh/themes/ys.omp.json "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/ys.omp.json"

# Configure fish with oh-my-posh
RUN mkdir -p /root/.config/fish && \
    echo 'oh-my-posh init fish --config /root/.config/oh-my-posh/themes/ys.omp.json | source' > /root/.config/fish/config.fish

# Configure nushell with oh-my-posh
RUN mkdir -p /root/.config/nushell && \
    echo '$env.PROMPT_COMMAND = { || oh-my-posh print primary --config /root/.config/oh-my-posh/themes/ys.omp.json }' > /root/.config/nushell/env.nu && \
    echo '$env.PROMPT_COMMAND_RIGHT = ""' >> /root/.config/nushell/env.nu && \
    echo '$env.PROMPT_INDICATOR = ""' >> /root/.config/nushell/env.nu && \
    touch /root/.config/nushell/config.nu

# Set fish as the default shell
ENV SHELL=/usr/bin/fish

# Set working directory
WORKDIR /workspace

# Default command
CMD ["/usr/bin/fish"]
