#!/bin/bash

ansi_art='                      ▄▄▄                                                   
     ■                    ■        ■■                   
     ■                    ■     ■■■■            ■      ■     
     ■      ■■           ■■ ■■■■■               ■      ■     
     ■■■■■   ■■          ■      ■               ■      ■     
 ■■■■■        ■         ■■      ■               ■      ■     
     ■                  ■       ■           ■■■■■■■■■■■■■■■■ 
     ■                 ■■       ■               ■      ■     
     ■ ■■■■■■         ■ ■  ■■■■■■■■■■■          ■      ■     
     ■■■    ■■          ■       ■               ■      ■     
   ■■■       ■■         ■       ■               ■      ■     
  ■■ ■        ■         ■       ■               ■    ■■      
 ■■  ■        ■         ■       ■               ■            
 ■   ■       ■■         ■       ■               ■            
 ■  ■■      ■■          ■       ■                ■           
  ■■■     ■■■           ■   ■■■■■■■■■             ■■■■■■■■   
                        ■                               
 ██████  ███    ███  █████  ██   ██  █████  ███████ ███████ 
██    ██ ████  ████ ██   ██ ██  ██  ██   ██ ██      ██      
██    ██ ██ ████ ██ ███████ █████   ███████ ███████ █████   
██    ██ ██  ██  ██ ██   ██ ██  ██  ██   ██      ██ ██      
 ██████  ██      ██ ██   ██ ██   ██ ██   ██ ███████ ███████ '

clear
echo -e "\n$ansi_art\n"

sudo pacman -Syu --noconfirm --needed git

# Use custom repo if specified, otherwise default to nightconcept/nightconcept
OMAKASE_REPO="${OMAKASE_REPO:-nightconcept/omakase}"

echo -e "\nCloning Omarchy from: https://github.com/${OMAKASE_REPO}.git"
rm -rf ~/.local/share/omakase/
git clone "https://github.com/${OMAKASE_REPO}.git" ~/.local/share/omakase >/dev/null

# Use custom branch if instructed, otherwise default to main
OMAKASE_REF="${OMAKASE_REF:- main}"
if [[ $OMAKASE_REF != " main" ]]; then
  echo -e "\eUsing branch: $OMAKASE_REF"
  cd ~/.local/share/omakase
  git fetch origin "${OMAKASE_REF}" && git checkout "${OMAKASE_REF}"
  cd -
fi

echo -e "\nInstallation starting..."
source ~/.local/share/omakase/install.sh
