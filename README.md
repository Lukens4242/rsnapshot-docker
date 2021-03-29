# rsnapshot-docker
This is an image that allows you to run rsnapshot along with sshfs, rsync, encfs, cron, rclone.  I based the concept upon the linuxserver.io/rsnapshot image.  I needed something that ran on my NAS and acted as a scriptable *pull* type backup solution with work being kicked off by `cron`, encrypted destination (via `encfs`), and managed by `rsnapshot`.

I know that my scripted solution for handling `encfs` passwords is not the best, but it is better than no encryption at all.

This Docker image allows you to run a (continuous) rsnapshot backup. The logic is to perform a local backup from either a local folder or a remote server.

## Volumes
Using the volume `/.snapshots/` you provide the target folder for the backups. This is mandatory, otherwise backups are done into the ephemeral container disk space.
The rsnapshot configuration is kept in the volume `/config/`.  You will stuff your configuration files and scripts in this area.  `/config/log` exists if you wish to deposit the rsnapshot logs there.
For the ssh credentials and configuration, you'll have the volume of `/root/.ssh/` which will contain your `known_hosts` and `id_rsa*` files.
If you wish to create more volumes for your source data to be backed up, feel free to add those.  I primarilly use sshfs and rsnapshot/rsync over ssh for source material.

## Operation
The cron package is included, and whatever crontab entries you put into `/config/crontab/root` will be loaded at startup.
The tools `sshfs`, `rsync`, `rsnapshot`, `encfs`, and `rclone` are all included so that you can use these to get your source data and potentially encrypt it.
You will want to use the usual `rsnapshot` mechanisms for generating and manging configuration files.  That can be found here: https://github.com/rsnapshot/rsnapshot

## Example
The heart of it all:
```docker run -d \
  --device /dev/fuse
  --cap-add=SYS_ADMIN
  -v /path/on/host/to/config:/config
  -v /path/on/host/to/ssh:/root/.ssh
  -v /path/on/host/to/backuprepos:/.snapshots/
  lukens4242/rsnapshot```
  
Then go in with bash to setup your `id_rsa`, `id_rsa.pub`, `known_hosts`, and build your rsnapshot configurations.
`docker exec -it $CONTAINERID bash`
