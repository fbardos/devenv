# Development environment with Neovim, Python

# ############################################################################
# ROOT: ARGs / ENVs
# ############################################################################
ARG UBUNTU_VERSION="24.04"
FROM ubuntu:$UBUNTU_VERSION
LABEL maintainer="Fabian Bardos <fabian@bardos.dev>"
USER root

# Ubuntu images >= 24.04 have already a user with GID/UID == 1000, named ubuntu
# Be careful when chaning these. When you run devenv before with docker volumes
# then, this directories will be mounted as the original UID/GID, befor the migration.
# When changing these, also change the owner of the filestructure, with:
#
#   $ docker run --rm -v my_volume:/data --user root alpine chown -R 1001:1001 /data
#
ARG USER_UID=1001
ARG USER_GID=1001

# Default software versions (can be overwritten by --build-args)
# Must stand after FROM clause, will otherwise not be available.
ARG NODE_MAJOR=22
ARG NVIM_VERSION=stable
ARG QUARTO_VERSION=1.7.32

# By default, disable Docker-out-of-Docker DooD, OWASP rule 1
# ARG HOST_DOCKER_GROUP_ID=999
ARG USER_USERNAME="dev"
ARG ZSH_PREFIX=""
ARG UNIX_TZ="Europe/Zurich"
ARG DEBIAN_FRONTEND=noninteractive
ENV USER_USERNAME=$USER_USERNAME
ENV TZ=$UNIX_TZ

# Unminiminze Ubuntu to get manpages and other stuff
# Starting with Ubuntu 24.04, unminimized is no longer included in the base image
# and must therefore be installed manually
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    unminimize \
    adduser \
    build-essential \
    libtiff6 \
    locales locales-all \
    iproute2 \
    openssh-client \
    curl \
    rsync \
    tmux \
    git \
    less \
    ca-certificates \
    gnupg \
    htop \
    wget \
    fzf \
    ninja-build \
    gettext \
    cmake \
    clang \
    luarocks \
    unzip \
    curl \
    ripgrep \
    xclip \
    x11-apps \
    exuberant-ctags \
    sudo \
    # tzdata is used to set timezone later
    tzdata \
    tree \
    jq \
    vim \
    manpages-posix \
    # python3 is used as base setup for non-uv setups
    python3 \
    python3-venv \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN yes | unminimize


# ############################################################################
# ROOT: SETUP user
# ############################################################################
RUN --mount=type=secret,id=user_password,target=/run/secrets/user_password \
    groupadd -g $USER_GID -o $USER_USERNAME \
    && useradd -u $USER_UID -g $USER_GID -m $USER_USERNAME \
    && echo $USER_USERNAME:$(cat /run/secrets/user_password) | chpasswd

# Switch to newly created user, and set working dir
USER $USER_UID:$USER_GID
ENV WORKDIR=/home/$USER_USERNAME
WORKDIR $WORKDIR

# ############################################################################
# USER: INIT Filesystem / Config
# ############################################################################
USER $USER_UID:$USER_GID

# Create main directories (build_tmp gets deleted after building)
RUN mkdir code code/playground doc build_tmp scripts_runtime .bash .ssh .bash_extra \
    && chmod 700 $WORKDIR/.ssh \
    && echo "AddKeysToAgent yes" >> $WORKDIR/.ssh/config


# ############################################################################
# ROOT: Base settings
# ############################################################################
USER root

COPY --chown=$USER_UID:$USER_GID build/.gitconfig .

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# ############################################################################
# ROOT: uv / Python
# ############################################################################
# uv [1] combines multiple separate tool together and makes the handling
# of projects with different dependencies and python versions easier.
#
# [1] https://github.com/astral-sh/uv
USER root
WORKDIR $WORKDIR

# Create a shared virtual environment for global pip packages
COPY --chown=$USER_UID:$USER_GID build/requirements-minimal.txt build_tmp/

ENV VENV_PATH=/opt/venv
RUN python3 -m venv $VENV_PATH && \
    # Upgrade pip inside the venv
    $VENV_PATH/bin/pip install --upgrade pip && \
    # Install desired packages into the venv
    $VENV_PATH/bin/pip install --no-cache-dir -r build_tmp/requirements-minimal.txt

## uv
USER $USER_UID:$USER_GID
WORKDIR $WORKDIR
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="$VENV_PATH/bin/:$PATH"

# ############################################################################
# Install additional software
# ############################################################################
WORKDIR $WORKDIR

# ROOT: Install Quarto
USER root
RUN wget -q -O quarto.deb \
      https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && apt install -y ./quarto.deb \
    && rm quarto.deb

# ROOT: rustc / cargo
# cargo is used by mason to install LSPs, and also to install the tree-sitter
# install under /usr/local to make available to unpriviledged user
USER root
ENV RUSTUP_HOME=/usr/local/rustup
ENV CARGO_HOME=/usr/local/cargo
ENV PATH=/usr/local/cargo/bin:$PATH
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --profile minimal --default-toolchain stable

# ROOT: Nodejs
# npm is used by mason to install LSPs
USER root
RUN curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | bash -
RUN apt-get install -y nodejs
RUN node --version
RUN npm --version

# ############################################################################
# ROOT: Install NeoVim
# ############################################################################
USER root
RUN cargo install --locked tree-sitter-cli
RUN mkdir ext_repos \
    ### Install NEOVIM (via appimage, because faster)
    && wget -q -O nvim.appimage "https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux-x86_64.appimage" \
    && chmod u+x ./nvim.appimage \
    && ./nvim.appimage --appimage-extract \
    && mv ./squashfs-root /opt/nvim \
    && chmod -R +rx /opt/nvim \
    && ln -s /opt/nvim/usr/bin/nvim /usr/local/bin/nvim \
    && rm nvim.appimage

COPY --chown=$USER_UID:$USER_GID build/.config/ .config/

# USER: NVIM configuration
USER $USER_UID:$USER_GID
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' \
    # Insall all NVIM plugins
    && nvim --headless "+Lazy! restore" +qa \
    # Update Treesitter parser
    && nvim --headless +TSInstall +qa

# USER: Install Mason LSPs
# Unfortunately, it is currently not possible to run a MasonInstallAll
# For the lsp names, use the names from Mason, not lspconfig
# Must be placed after python installation, because it needs link to python3
USER $USER_UID:$USER_GID
RUN nvim --headless "+MasonInstall html-lsp css-lsp lua-language-server pyright" +qa
RUN nvim --headless -c 'TSUpdateSync' -c 'MasonUpdate' -c 'q'
RUN nvim --headless +MasonToolsInstallSync +qa

# ############################################################################
# SYSTEM, after installation
# ############################################################################

# USER Set image locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# ############################################################################
# FINALIZING / CLEANUP
# ############################################################################
COPY --chown=$USER_UID:$USER_GID build/scripts ./scripts
COPY --chown=$USER_UID:$USER_GID build/.bashrc .

# add uv autocompletion
RUN echo 'eval "$(uv generate-shell-completion bash)"' >> ~/.bashrc

COPY --chown=$USER_UID:$USER_GID build/.tmux.conf .

# USER: Delete temporary build files
RUN rm -rf build_tmp

# Expose some ports for later use (e.g. when spinning up jupyter lab)
EXPOSE 8080 8081 8082 8083 8084 8085

USER $USER_UID:$USER_GID
ENTRYPOINT ["scripts/entrypoint.sh"]
