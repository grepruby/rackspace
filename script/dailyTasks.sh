#!/bin/sh

##development
cd /var/www/mobiledev.myhostessapp.com/current/
/usr/bin/env rake schedule:send_about_expire_notifications

##preview
cd /var/www/mobilepreview.myhostessapp.com/current/
/usr/bin/env rake schedule:send_about_expire_notifications



