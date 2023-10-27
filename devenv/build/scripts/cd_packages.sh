#!/bin/zsh
# CD into site-packages/ directory from current conda env
CD_PATH=$(python3 -c 'import sysconfig; print(sysconfig.get_paths()["purelib"])')
cd $CD_PATH
ls -d */
