# Debian-based image with fish, nushell, oh-my-posh (ys theme), git, curl, and jq
FROM debian:bookworm-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV OH_MY_POSH_VERSION=21.15.1

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

# Install nushell - using GitHub API to get latest release (inspired by hustcer/nushell)
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        NU_ARCH="x86_64"; \
    elif [ "$ARCH" = "arm64" ]; then \
        NU_ARCH="aarch64"; \
    else \
        NU_ARCH="$ARCH"; \
    fi && \
    cd /tmp && \
    RELEASE_URL="https://api.github.com/repos/nushell/nushell/releases/latest" && \
    wget -qO - ${RELEASE_URL} \
    | grep browser_download_url \
    | cut -d '"' -f 4 \
    | grep ${NU_ARCH}-unknown-linux-gnu.tar.gz \
    | xargs -I{} wget -q {} && \
    mkdir nu-latest && tar xf nu-*.tar.gz --directory=nu-latest && \
    cp -aR nu-latest/**/* /usr/bin/ && \
    chmod +x /usr/bin/nu && \
    echo '/usr/bin/nu' >> /etc/shells && \
    rm -rf /tmp/*

# Install oh-my-posh
RUN wget -qO /usr/local/bin/oh-my-posh "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v${OH_MY_POSH_VERSION}/posh-linux-amd64" && \
    chmod +x /usr/local/bin/oh-my-posh

# Create themes directory and download ys theme
RUN mkdir -p /root/.config/oh-my-posh/themes && \
    wget -qO /root/.config/oh-my-posh/themes/ys.omp.json "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/ys.omp.json"

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
