#!/bin/bash

service cron start
crontab /config/crontab/root

sleep infinity