# DEVENV with Neovim, Python
# Maintainer: Fabian Bardos <fabian@bardos.dev>

# ############################################################################
# ROOT: ARGs / ENVs
# ############################################################################
ARG UBUNTU_VERSION="24.04"
FROM ubuntu:$UBUNTU_VERSION
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

# By default, disable Docker-out-of-Docker DooD, OWASP rule 1
# ARG HOST_DOCKER_GROUP_ID=999
ARG USER_USERNAME="dev"
ARG ZSH_PREFIX=""
ARG NODE_MAJOR=20
ARG UNIX_TZ="Europe/Zurich"

ARG NODE_VERSION=22

ENV USER_USERNAME $USER_USERNAME
ENV TZ=$UNIX_TZ

# Unminiminze Ubuntu to get manpages and other stuff
# Starting with Ubuntu 24.04, unminimized is no longer included in the base image
# and must therefore be installed manually
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    unminimize \
    adduser \
    && rm -rf /var/lib/apt/lists/*
RUN yes | unminimize


# ############################################################################
# ROOT: SETUP user
# ############################################################################
RUN --mount=type=secret,id=user_password,target=/run/secrets/user_password \
    apt-get update && apt-get install -y --no-install-recommends sudo \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -g $USER_GID -o $USER_USERNAME \
    && useradd -u $USER_UID -g $USER_GID -m $USER_USERNAME \
    && echo $USER_USERNAME:$(cat /run/secrets/user_password) | chpasswd && adduser $USER_USERNAME sudo \
    # Temporary: Ensure sudo group users are not asked for password
    && echo "${USER_USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to newly created user, and set working dir
USER $USER_UID:$USER_GID
ENV WORKDIR=/home/$USER_USERNAME
WORKDIR $WORKDIR
ENV CONDA_DIR=$WORKDIR/miniconda3

# ############################################################################
# USER: INIT Filesystem / Config
# ############################################################################

# Create main directories (build_tmp gets deleted after building)
RUN mkdir code code/playground doc build_tmp scripts_runtime .zsh .ssh .zsh_extra \
    && chmod 700 $WORKDIR/.ssh \
    && echo "AddKeysToAgent yes" >> $WORKDIR/.ssh/config

# Copy config
COPY --chown=$USER_UID:$USER_GID build/.gitconfig .
COPY --chown=$USER_UID:$USER_GID build/environment-minimal-base.yml build_tmp/
COPY --chown=$USER_UID:$USER_GID build/environment-playground.yml build_tmp/
COPY --chown=$USER_UID:$USER_GID build/scripts ./scripts
COPY --chown=$USER_UID:$USER_GID build/.config/ .config/
COPY --chown=$USER_UID:$USER_GID --chmod=0755 entrypoint.sh ./scripts/entrypoint.sh
COPY --chown=$USER_UID:$USER_GID build/.bashrc .
COPY --chown=$USER_UID:$USER_GID build/.tmux.conf .
COPY --chown=$USER_UID:$USER_GID build/.condarc .

# ############################################################################
# USER: Install Software
# ############################################################################

# Install base packages
# Also, unminimize ubuntu to get manpages and other stuff.
RUN sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends \
    build-essential \
    libtiff6 \
    locales locales-all \
    iproute2 \
    openssh-client \
    curl \
    tmux \
    git \
    less \
    ca-certificates \
    gnupg \
    htop \
    && sudo rm -rf /var/lib/apt/lists/*

# Set timezone
RUN sudo apt-get update \
    && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata \
    && sudo rm -rf /var/lib/apt/lists/* \
    && sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && sudo dpkg-reconfigure -f noninteractive tzdata

# Install homebrew, and install specific packages
USER root
RUN useradd -m -s /bin/zsh linuxbrew && \
    usermod -aG sudo linuxbrew &&  \
    mkdir -p /home/linuxbrew/.linuxbrew && \
    chown -R linuxbrew: /home/linuxbrew/.linuxbrew
USER linuxbrew
WORKDIR /home/linuxbrew
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND=noninteractive \
    USER="linuxbrew" \
    CI="1" \
    HOMEBREW_NO_ANALYTICS=1
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
RUN brew --version
RUN brew install fzf

# USER: Install more specific packages (apt)
USER $USER_UID:$USER_GID
WORKDIR $WORKDIR

RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    tree \
    jq \
    vim \
    wget \
    manpages-posix \
    && sudo rm -rf /var/lib/apt/lists/*

# USER: Nodejs
RUN curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | sudo bash -
RUN sudo apt-get install -y nodejs
RUN node --version
RUN npm --version

# USER: NeoVim
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    ninja-build gettext cmake unzip curl ripgrep xclip x11-apps exuberant-ctags \
    && sudo rm -rf /var/lib/apt/lists/*
RUN npm install tree-sitter-cli
RUN mkdir ext_repos \
    ### Install NEOVIM (via appimage, because faster)
    && wget -q https://github.com/neovim/neovim/releases/latest/download/nvim.appimage \
    && chmod u+x ./nvim.appimage \
    && ./nvim.appimage --appimage-extract \
    && sudo mv ./squashfs-root /opt/nvim \
    && sudo chmod -R +rx /opt/nvim \
    && sudo ln -s /opt/nvim/usr/bin/nvim /usr/local/bin/nvim \
    && rm nvim.appimage

# USER: NVIM configuration
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' \
    # Insall all NVIM plugins
    && nvim --headless "+Lazy! restore" +qa \
    # Update Treesitter parser
    && nvim --headless +TSInstall +qa

# CLI (zsh)
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    bat \
    zsh \
    && sudo rm -rf /var/lib/apt/lists/*
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends tmux \
    && sudo rm -rf /var/lib/apt/lists/*
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended" \
    # OH-MY-ZSH installation does overwrite .zshrc (wtf). https://github.com/ohmyzsh/ohmyzsh/issues/4390
    && cat ~/.zshrc.pre-oh-my-zsh >> ~/.zshrc
RUN git clone --depth 1 https://github.com/romkatv/powerlevel10k.git $WORKDIR/.oh-my-zsh/custom/themes/powerlevel10k \
    # Install gitstatusd manually to prevent download each time zsh gets started in fresh container
    && sh -c $WORKDIR/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/install -f \
    # Change default shell to zsh for user
    && sudo chsh -s $(which zsh) $USER_USERNAME

# Install zsh plugins
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $WORKDIR/ext_repos/zsh-syntax-highlighting

# By default, disable Docker-out-of-Docker DooD
# RUN curl -fsSL https://get.docker.com | sh \
#     && sudo groupmod -g $HOST_DOCKER_GROUP_ID docker \
#     && sudo usermod -aG docker $USER_USERNAME

# Set autocomplete for conda envs (& add lines before and after oh-my-zsh init)
# Source https://stackoverflow.com/a/57793510
RUN git clone https://github.com/esc/conda-zsh-completion $WORKDIR/ext_repos/conda-zsh-completion \
    && sed -i "/source \$ZSH\/oh-my-zsh.sh/ifpath\+=~/ext_repos/conda-zsh-completion" $WORKDIR/.zshrc \
    && sed -i "/source \$ZSH\/oh-my-zsh.sh/acompinit conda" $WORKDIR/.zshrc \
    ### Set zsh theme
    && echo "source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc \
    # Add prefix for shell if ZSH_PREFIX is provided
    && sed -i -E "s/#\W(.*POWERLEVEL9K_DIR_PREFIX=').*(')/\1$ZSH_PREFIX\2/" $WORKDIR/.p10k.zsh

# Miniconda3
# Temporary fix because of libmamba-solver error (gh/anaconda-issues/#13123): pinned to miniconda 23.5.2 (py3.11)
# TODO: Revert as soon as fixed
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py311_23.5.2-0-Linux-x86_64.sh -O miniconda3-installer.sh \
    # && wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda3-installer.sh \
    && /bin/bash ./miniconda3-installer.sh -b -p $CONDA_DIR

# Add libmamba-solver for conda
RUN $CONDA_DIR/bin/conda install -n base conda-libmamba-solver \
    && $CONDA_DIR/bin/conda config --set solver libmamba

# USER: Install conda packages
RUN $CONDA_DIR/bin/conda install -c conda-forge -n base isort neovim -y && $CONDA_DIR/bin/conda clean -ay
RUN $CONDA_DIR/bin/conda env update --file build_tmp/environment-minimal-base.yml -n base && $CONDA_DIR/bin/conda clean -ay
RUN $CONDA_DIR/bin/conda env create --file build_tmp/environment-playground.yml && $CONDA_DIR/bin/conda clean -ay

# Tell conda to initialize zsh
RUN $CONDA_DIR/bin/conda init zsh \
    # Remove conda installer
    && rm -f miniconda3-installer.sh

# USER: Extend PATH to include conda
ENV PATH=$CONDA_DIR/bin:$PATH

# Install Quarto
run wget -q -O quarto.deb 'https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.40/quarto-1.6.40-linux-amd64.deb' \
    && sudo apt install -y ./quarto.deb \
    && rm quarto.deb

# USER: Install Mason LSPs
# Unfortunately, it is currently not possible to run a MasonInstallAll
# For the lsp names, use the names from Mason, not lspconfig
# Must be placed after python installation, because it needs link to python3
RUN nvim --headless "+MasonInstall typescript-language-server html-lsp css-lsp lua-language-server pyright" +qa
RUN nvim --headless +MasonToolsInstallSync +qa

# USER: Global git config
# Set pager to previously installed less (for better scolling with vi keybinds)
RUN git config --global core.pager "less -FRX"


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

# USER: Delete temporary build files
RUN rm -rf build_tmp

# Reenable sudo password requirement after building
RUN sudo sed -i '/NOPASSWD:ALL/d' /etc/sudoers

# Expose some ports for later use (e.g. when spinning up jupyter lab)
EXPOSE 8080 8081 8082 8083 8084 8085

ENTRYPOINT ["scripts/entrypoint.sh"]
