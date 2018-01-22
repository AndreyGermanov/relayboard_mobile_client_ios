#!/bin/bash
source_file=$1
mkdir -p appicon
rsvg-convert -w 40 -h 40 -f png -o appicon/iphone_notification_ios_7_11@2x.png $1
rsvg-convert -w 60 -h 60 -f png -o appicon/iphone_notification_ios_7_11@3x.png $1
rsvg-convert -w 58 -h 58 -f png -o appicon/iphone_spotlight_ios_5_6@2x.png $1
rsvg-convert -w 87 -h 87 -f png -o appicon/iphone_spotlight_ios_5_6@3x.png $1
rsvg-convert -w 80 -h 80 -f png -o appicon/iphone_spotlight_ios_7_11@2x.png $1
rsvg-convert -w 120 -h 120 -f png -o appicon/iphone_spotlight_ios_7_11@3x.png $1
rsvg-convert -w 120 -h 120 -f png -o appicon/iphone_app_ios_7_11@2x.png $1
rsvg-convert -w 180 -h 180 -f png -o appicon/iphone_app_ios_7_11@3x.png $1
rsvg-convert -w 20 -h 20 -f png -o appicon/ipad_notification_ios_7_11@1x.png $1
rsvg-convert -w 40 -h 40 -f png -o appicon/ipad_notification_ios_7_11@2x.png $1
rsvg-convert -w 29 -h 29 -f png -o appicon/ipad_settings_ios_5_11@1x.png $1
rsvg-convert -w 58 -h 58 -f png -o appicon/ipad_settings_ios_5_11@2x.png $1
rsvg-convert -w 40 -h 40 -f png -o appicon/ipad_spotlight_ios_7_11@1x.png $1
rsvg-convert -w 80 -h 80 -f png -o appicon/ipad_spotlight_ios_7_11@2x.png $1
rsvg-convert -w 76 -h 76 -f png -o appicon/ipad_app_ios_7_11@1x.png $1
rsvg-convert -w 152 -h 152 -f png -o appicon/ipad_app_ios_7_11@2x.png $1
rsvg-convert -w 167 -h 167 -f png -o appicon/ipad_pro_app_ios_9_11@2x.png $1
rsvg-convert -w 1024 -h 1024 -f png -o appicon/appstore_ios@1x.png $1




