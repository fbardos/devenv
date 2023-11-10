# DEVENV with Neovim, Python
# Maintainer: Fabian Bardos <fabian@bardos.dev>


# ############################################################################
# ARGs / ENVs
# ############################################################################
ARG UBUNTU_VERSION="22.04"
FROM ubuntu:$UBUNTU_VERSION

ARG USER_USERNAME="dev"
ARG USER_PASSWORD="changeme"
ARG ZSH_PREFIX=""

ENV USER_USERNAME $USER_USERNAME


# ############################################################################
# SETUP user
# ############################################################################
RUN apt-get update && apt-get install -y sudo \
    && useradd -m $USER_USERNAME && echo $USER_USERNAME:$USER_PASSWORD | chpasswd && adduser $USER_USERNAME sudo \
    # Temporary: Ensure sudo group users are not asked for password
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to newly created user, and set working dir
USER $USER_USERNAME

# Set ENV variables after creating user
ENV WORKDIR /home/$USER_USERNAME
WORKDIR $WORKDIR

ENV CONDA_DIR $WORKDIR/miniconda3


# ############################################################################
# INIT Filesystem / Config
# ############################################################################

# Create main directories (build_tmp gets deleted after building)
RUN mkdir code code/playground doc build_tmp scripts_runtime .zsh .ssh .zsh_extra \
    && chmod 700 $WORKDIR/.ssh \
    && echo "AddKeysToAgent yes" >> $WORKDIR/.ssh/config

# Copy config
COPY --chown=$USER_USERNAME build/.gitconfig .
COPY --chown=$USER_USERNAME build/environment-minimal-base.yml build_tmp/
COPY --chown=$USER_USERNAME build/environment-playground.yml build_tmp/
COPY --chown=$USER_USERNAME build/scripts ./scripts
COPY --chown=$USER_USERNAME build/.config/ .config/
COPY --chown=$USER_USERNAME --chmod=0755 entrypoint.sh ./scripts/entrypoint.sh
COPY --chown=$USER_USERNAME build/.p10k.zsh .
COPY --chown=$USER_USERNAME build/.zshrc .
COPY --chown=$USER_USERNAME build/.tmux.conf .

# ############################################################################
# Install Software
# ############################################################################

RUN sudo apt-get update \
    # #################################
    # General packages
    # #################################
    && sudo apt-get install -y \
    build-essential \
    sudo \
    locales locales-all \
    git \
    curl \
    man \
    tree \
    fzf \
    vim \
    manpages-posix \
    # #################################
    # Package manager
    # #################################
    && sudo apt-get install -y \
    Node.js \
    npm \
    wget \
    # #################################
    # NEOVIM
    # #################################
    && sudo apt-get install -y \
    ninja-build gettext cmake unzip curl ripgrep xclip x11-apps exuberant-ctags \
    && npm install tree-sitter-cli \
    && mkdir ext_repos \
    ### Install NEOVIM
    # -- Install via appimage (faster)
    && wget -q https://github.com/neovim/neovim/releases/latest/download/nvim.appimage \
    && chmod u+x ./nvim.appimage \
    && ./nvim.appimage --appimage-extract \
    && sudo mv ./squashfs-root /opt/nvim \
    && sudo chmod -R +rx /opt/nvim \
    && sudo ln -s /opt/nvim/usr/bin/nvim /usr/local/bin/nvim \
    && rm nvim.appimage \
    ### NVIM configuration
    && sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' \
    # Insall all NVIM plugins
    && nvim --headless --noplugin "+Lazy! restore" +qall \
    # Update Treesitter parser
    && nvim --headless +TSInstall +qall \
    # #################################
    # CLI (zsh)
    # #################################
    && sudo apt-get install -y \
    bat \
    zsh \
    tmux \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended" \
    # OH-MY-ZSH installation does overwrite .zshrc (wtf). https://github.com/ohmyzsh/ohmyzsh/issues/4390
    && cat ~/.zshrc.pre-oh-my-zsh >> ~/.zshrc \
    && git clone --depth 1 https://github.com/romkatv/powerlevel10k.git $WORKDIR/.oh-my-zsh/custom/themes/powerlevel10k \
    # Install gitstatusd manually to prevent download each time zsh gets started in fresh container
    && sh -c $WORKDIR/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/install -f \
    # Change default shell to zsh for user
    && sudo chsh -s $(which zsh) $USER_USERNAME \
    # Install zsh plugins
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $WORKDIR/ext_repos/zsh-syntax-highlighting \
    # Set autocomplete for conda envs (& add lines before and after oh-my-zsh init)
    # Source https://stackoverflow.com/a/57793510
    && git clone https://github.com/esc/conda-zsh-completion $WORKDIR/ext_repos/conda-zsh-completion \
    && sed -i "/source \$ZSH\/oh-my-zsh.sh/ifpath\+=~/ext_repos/conda-zsh-completion" $WORKDIR/.zshrc \
    && sed -i "/source \$ZSH\/oh-my-zsh.sh/acompinit conda" $WORKDIR/.zshrc \
    ### Set zsh theme
    && echo "source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc \
    # Add prefix for shell if ZSH_PREFIX is provided
    && sed -i -E "s/#\W(.*POWERLEVEL9K_DIR_PREFIX=').*(')/\1$ZSH_PREFIX\2/" $WORKDIR/.p10k.zsh \
    # #################################
    # Miniconda3
    # #################################
    # Temporary fix because of libmamba-solver error (gh/anaconda-issues/#13123): pinned to miniconda 23.5.2 (py3.11)
    # TODO: Revert as soon as fixed
    && wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py311_23.5.2-0-Linux-x86_64.sh -O miniconda3-installer.sh \
    # && wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda3-installer.sh \
    && /bin/bash ./miniconda3-installer.sh -b -p $CONDA_DIR \
    # Add libmamba-solver for conda
    && $CONDA_DIR/bin/conda install -n base conda-libmamba-solver \
    && $CONDA_DIR/bin/conda config --set solver libmamba \
    && $CONDA_DIR/bin/conda install -c conda-forge -n base isort neovim -y \
    # Needs to run after libmamba solbver has been set
    # && $CONDA_DIR/bin/conda env update --file build_tmp/environment-minimal-base.yml -n base --prune \
    && $CONDA_DIR/bin/conda env update --file build_tmp/environment-minimal-base.yml -n base \
    && $CONDA_DIR/bin/conda env create --file build_tmp/environment-playground.yml \
    && $CONDA_DIR/bin/conda init zsh \
    # Remove conda installer
    && rm -f miniconda3-installer.sh


# ############################################################################
# SYSTEM, after installation
# ############################################################################

# Extend PATH to include conda
ENV PATH=$CONDA_DIR/bin:$PATH

# Set image locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


# ############################################################################
# FINALIZING / CLEANUP
# ############################################################################

# Delete temporary build files
RUN rm -rf build_tmp

# Reenable sudo password requirement after building
RUN sudo sed -i '/NOPASSWD:ALL/d' /etc/sudoers

# Expose some ports for later use (e.g. when spinning up jupyter lab)
EXPOSE 8080 8081 8082 8083 8084 8085

ENTRYPOINT ["scripts/entrypoint.sh"]
