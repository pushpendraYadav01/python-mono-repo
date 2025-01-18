## Install wsl
```
$ wsl --install
```
## Uninstall legacy version of WSL
```
$ wsl --unregister Legacy
$ rm -Recurse $env:localappdata/lxss/.
```

## Comands to execute makefile
1. Create Virtual Environment
```
$ make create-venv
$ .\venv\Scripts\activate
```
2. Update Virtual Environment
```
$ make update-venv
```
3. Delete Virtual Environment
```
$ make delete-venv
```
4. Install System-Level Packages
```
$ make install-apt
```
5. Clean Temporary Files
```
$ make clean
```

## Project Specific 
<TODO>