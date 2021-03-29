FROM ubuntu:latest

LABEL maintainer="David Lukens<david@insanityunlimited.com>"
LABEL version="0.1"
LABEL description="This is an image that allows you to run rsnapshot along with sshfs, rsync, encfs, cron, rclone."

ARG DEBIAN_FRONTEND=noninteractive

RUN apt -y update && apt-get install -y libfuse2 fuse rsnapshot rclone encfs vim ssh apt-utils less

RUN cp /usr/share/zoneinfo/America/New_York /etc/localtime
RUN mkdir /config /config/crontab /config/log
#RUN modprobe fuse
COPY root /config/crontab/root

RUN apt install -y sshfs

VOLUME ["/config", "/.snapshots", "/root/.ssh"]

COPY init.sh /init.sh
CMD ["./init.sh"]
