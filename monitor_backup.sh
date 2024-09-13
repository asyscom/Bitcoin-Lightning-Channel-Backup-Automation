#!/bin/bash

# File da monitorare
FILE_TO_MONITOR="$HOME/umbrel/app-data/lightning/data/lnd/data/chain/bitcoin/mainnet/channel.backup"

# Directory di backup su Nextcloud
RCLONE_REMOTE="bksd:/backup" # Remote configurato su rclone per Nextcloud
BACKUP_DIR="$HOME/mnt/script/nextcloud"

# Crea la cartella di backup locale se non esiste
mkdir -p "$BACKUP_DIR"

# Funzione per copiare il file su Nextcloud
backup_file() {
    echo "File aggiornato: $FILE_TO_MONITOR"
    echo "Copia del file in corso..."

    # Copia il file nella directory di Nextcloud
    rclone copy "$FILE_TO_MONITOR" "$RCLONE_REMOTE"

    if [ $? -eq 0 ]; then
        echo "Copia completata con successo."
    else
        echo "Errore nella copia del file."
    fi
}

# Monitorare il file con inotifywait (monitoriamo modify, close_write e attrib)
echo "Monitoraggio del file $FILE_TO_MONITOR per aggiornamenti..."
while inotifywait -e modify -e close_write -e attrib "$FILE_TO_MONITOR"; do
    backup_file
done
