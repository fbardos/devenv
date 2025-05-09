# DEVENV

Development environment inside docker, with [neovim](https://neovim.io) and [Python](https://python.org).

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

![DevEnv Screencast](screencast.gif)

DevEnv uses the following core components:
* neovim (latest), with a [Lazy.nvim](https://github.com/folke/lazy.nvim) setup
* Python 3, with 2 prepared Miniconda envs
* bash

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

### Github Copilot
In order to start using [Github Copilot](https://github.com/features/copilot), run `:Copilot setup` when startup nvim for the first time.
