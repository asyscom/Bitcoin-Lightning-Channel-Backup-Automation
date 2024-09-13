# Bitcoin-Lightning-Channel-Backup-Automation
This repository contains a script that automates the backup of the Bitcoin Lightning channel.backup file to a remote Nextcloud server using rclone. The script monitors changes to the backup file and uploads it to Nextcloud whenever it's updated.
Certo! Ecco una **README** che puoi usare per il tuo repository GitHub. Anonimizza i dettagli relativi al tuo setup, ma include tutte le informazioni necessarie per chi vuole configurare un backup automatico del file `channel.backup` su un server Nextcloud tramite `rclone`.

---

# Bitcoin Lightning Channel Backup Automation

This repository contains a script that automates the backup of the Bitcoin Lightning `channel.backup` file to a remote Nextcloud server using `rclone`. The script monitors changes to the backup file and uploads it to Nextcloud whenever it's updated. 

## Features
- Monitors the `channel.backup` file for any changes, including timestamp updates.
- Automatically copies the file to a remote Nextcloud directory using `rclone`.
- Runs in the background and ensures the backup process continues after system restarts.

## Prerequisites
- **rclone** configured with your Nextcloud remote.
- **inotify-tools** for monitoring file changes.
- A working installation of Bitcoin Lightning on your device (e.g., Umbrel).

### Dependencies
Install the required tools:
```bash
sudo apt update
sudo apt install inotify-tools rclone
```

### rclone Configuration
Ensure you have `rclone` configured with your Nextcloud account. You can set up the remote using the command:
```bash
rclone config
```
Follow the prompts to add a new remote for your Nextcloud instance. Here is an example of a remote configuration:

```bash
[bksd]
type = webdav
url = https://nextcloud.example.com/remote.php/webdav
vendor = nextcloud
user = your-username
pass = your-password
```

## Setup Instructions

### Step 1: Download the Script
Clone this repository and copy the `monitor_backup.sh` script to your local system:

```bash
git clone https://github.com/yourusername/lightning-channel-backup.git
cd lightning-channel-backup
```

### Step 2: Configure the Script
Edit the `monitor_backup.sh` file to match your setup. You’ll need to adjust the following variables:

- `FILE_TO_MONITOR`: The path to the `channel.backup` file on your system. For example:
  ```bash
  FILE_TO_MONITOR="$HOME/umbrel/app-data/lightning/data/lnd/data/chain/bitcoin/mainnet/channel.backup"
  ```

- `RCLONE_REMOTE`: Your Nextcloud remote configuration. For example:
  ```bash
  RCLONE_REMOTE="bksd:/backup"
  ```

### Step 3: Install the Script as a Service (Optional)
To ensure the script runs automatically on system startup, you can configure it as a `systemd` service.

1. Copy the script to a global location:
   ```bash
   sudo cp monitor_backup.sh /usr/local/bin/
   sudo chmod +x /usr/local/bin/monitor_backup.sh
   ```

2. Create a `systemd` service file:
   ```bash
   sudo nano /etc/systemd/system/monitor_backup.service
   ```

3. Add the following content to the service file:
   ```ini
   [Unit]
   Description=Monitor Lightning Channel Backup File and Copy to Nextcloud
   After=network.target

   [Service]
   ExecStart=/usr/local/bin/monitor_backup.sh
   Restart=always
   User=your-username

   [Install]
   WantedBy=multi-user.target
   ```

4. Reload `systemd` to apply the changes:
   ```bash
   sudo systemctl daemon-reload
   ```

5. Enable and start the service:
   ```bash
   sudo systemctl enable monitor_backup.service
   sudo systemctl start monitor_backup.service
   ```

### Step 4: Running the Script Manually
You can also run the script manually by executing:
```bash
./monitor_backup.sh
```

### Step 5: Verify the Backup
You can check if the backup file has been copied successfully by logging into your Nextcloud instance or by listing the contents of the remote directory using `rclone`:

```bash
rclone ls bksd:/backup
```

## Logs and Troubleshooting
If you've set the script to run as a service, you can view the logs using:
```bash
journalctl -u monitor_backup.service -f
```

This will give you real-time updates on the backup process.

## Contributing
Feel free to submit issues or pull requests to improve this script.

---

**Note:** Always ensure you securely store your credentials and sensitive data when configuring backup scripts for critical files like `channel.backup`.

## License
This project is licensed under the MIT License.

---

Con questa README, chiunque può configurare il monitoraggio e il backup automatico del file `channel.backup` su Nextcloud. Puoi adattarla alle tue preferenze e necessità.
