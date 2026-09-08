#!/bin/zsh
# Publie la version du Drive sur GitHub : copie des fichiers, version, envoi.
set -e
SRC="/Users/schmidt/Library/CloudStorage/GoogleDrive-schmidt.basile@studiosilo.fr/Mon Drive/Claude Code/Website v1"
cd "$(dirname "$0")"
rsync -a --delete --exclude-from="$SRC/.gitignore" --exclude '.git/' --exclude 'publier.sh' "$SRC/" ./
git add -A
git commit -m "${1:-Mise à jour du site}" || { echo "Rien de nouveau à publier."; exit 0; }
git push
echo "Publié. Le site se met à jour d'ici une à deux minutes."
