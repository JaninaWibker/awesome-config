#!/usr/env/bin bash

# Run xidlehook
xidlehook \
  --socket /home/jannik/xidlehook.sock \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# Don't lock when there's audio playing` \
  --not-when-audio \
  `# Dim the screen after 60 seconds, undim if user becomes active` \
  --timer 180 \
    'notify-send -u ctritical -t 10000 -- "locking screen in 30s"' \
    '' \
  `# Undim & lock after 10 more seconds` \
  --timer 10 \
    'i3lock; sleep 1; xset dpms force off' \
    '' \
  `# Finally, suspend an hour after it locks` \
  --timer 3600 \
    'systemctl suspend' \
    ''