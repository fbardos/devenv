# DEVENV
```text
==============================================================
                                                              
 /$$$$$$$                       /$$$$$$$$                     
| $$__  $$                     | $$_____/                     
| $$  \ $$  /$$$$$$  /$$    /$$| $$       /$$$$$$$  /$$    /$$
| $$  | $$ /$$__  $$|  $$  /$$/| $$$$$   | $$__  $$|  $$  /$$/
| $$  | $$| $$$$$$$$ \  $$/$$/ | $$__/   | $$  \ $$ \  $$/$$/ 
| $$  | $$| $$_____/  \  $$$/  | $$      | $$  | $$  \  $$$/  
| $$$$$$$/|  $$$$$$$   \  $/   | $$$$$$$$| $$  | $$   \  $/   
|_______/  \_______/    \_/    |________/|__/  |__/    \_/    
                                                              
==============================================================
```

Developemnt environment inside docker, using the following core components:
* neovim (latest)
* Lazy.nvim setup
* Python (2 prepared conda envs)
* Miniconda3
* oh-my-zsh

## Setup

### .env-file
Make sure to overwrite defaults for ARG and ENV. For this, change the templated .env file inside `devenv/`.

### Fonts
In order to display the icons inside neovim correctly, a [nerd-font](https://github.com/ryanoasis/nerd-fonts) patched font must be installed on the host system.

### Config escape keybindings
`<C-p>` is used by docker as default escape keybinding. Unfortunately, this keybinding is also used for go to previous element in e.g. drop-downs inside nvim.
To change this default behaviour, edit docker config on `~/.docker/config.json` and add:
```json
{
    "detachKeys": "ctrl-@"
}
```

### Make clipboard available
[Source](https://stackoverflow.com/a/51415992)

To share a yank from containers nvim, execute the following on you linux host:
```bash
xhost +"local:docker@"
```
Additionally, make sure, the ENV `DISPLAY` is set in docker run/compose:
```yaml
services:
    devenv:
        environment:
            - DISPLAY=unix$DISPLAY  # export DISPLAY env variable for X server
```
Check correct setup with `xclock`.

