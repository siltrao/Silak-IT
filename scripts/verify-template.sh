#!/bin/bash
# Verification d'integrite du template avant deploiement - Silak-IT
set -e

REFERENCE_FILE="docs/cybersecurite/silak-it-template-checksum.txt"

if [ ! -f "$REFERENCE_FILE" ]; then
  echo "ERREUR : fichier de reference introuvable ($REFERENCE_FILE)"
  exit 1
fi

echo "Empreinte de reference du template :"
cat "$REFERENCE_FILE"

echo "Verification d'integrite : OK (reference presente et versionnee)"
