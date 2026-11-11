<p align="center">
  <img src="assets/banner.svg" alt="handy-bash-scripts" width="100%"/>
</p>

# handy-bash-scripts

Small, dependency-free shell scripts for everyday tasks. Each one does a single job, has built-in `--help`/usage text and works on Linux and macOS.

| Command | What it does |
|---|---|
| `extract` | Unpack almost any archive (zip, tar.gz, tar.xz, 7z, rar, ...) with one command |
| `backup` | Create a timestamped `.tar.gz` of a folder and keep only the newest N |
| `killport` | Stop whatever process is listening on a TCP port |
| `sysinfo` | Show OS, CPU, memory, disk, network and top processes at a glance |
| `cleanup` | Report (and optionally empty) common user-level caches |

## Install

```bash
git clone https://github.com/MofidChallenge10/handy-bash-scripts.git
cd handy-bash-scripts
bash install.sh
```

This symlinks every script into `~/.local/bin` (without the `.sh` extension). Pass a different directory to change that: `bash install.sh /usr/local/bin`. If the directory isn't in your `PATH`, the installer tells you what line to add.

## Usage

```bash
# unpack anything
extract archive.tar.gz            # into the current directory
extract photos.zip ~/Pictures     # into a specific directory

# back up a folder, keep the 5 newest copies (default)
backup ~/projects                 # -> ~/backups/projects-20261111-093000.tar.gz
backup ~/projects /mnt/usb 10     # custom destination, keep 10

# free up a busy port
killport 3000                     # polite (SIGTERM)
killport 3000 -f                  # force (SIGKILL)

# overview of the machine
sysinfo

# see what could be freed, then do it
cleanup
cleanup --yes
```

## Notes

- `extract` needs the matching tool for the format (`unzip`, `7z`, `unrar`, ...) and tells you if one is missing.
- `killport` uses `lsof` if available, otherwise `ss`.
- `cleanup` is a **dry run by default**. With `--yes` it empties the thumbnail cache, npm cache, pip cache and the user's Trash. Review the printed list first.

## Layout

```text
.
├── install.sh
├── scripts/
│   ├── extract.sh
│   ├── backup.sh
│   ├── killport.sh
│   ├── sysinfo.sh
│   └── cleanup.sh
└── assets/banner.svg
```

## Contributing

Got a script you reach for every week? Open a PR. Keep it to one job, POSIX-friendly where practical, and with a usage message.

## License

MIT
