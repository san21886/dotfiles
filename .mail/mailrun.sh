#!/bin/bash

PID=$(pgrep offlineimap)

# if it is still running then stop it
if [[ -z "$PID" ]]; then
    offlineimap -o -a gmail,sdf -u quiet
    sed -i 's@"+gmail/[Gmail]\.Spam"\|"+gmail/[Gmail]\.Trash"\|"+gmail/[Gmail]\.Sent Mail"|"+gmx/Spam"@@' /home/ivan/.mutt/muttrc.mailboxes
    goobook reload
    notmuch new
fi

exit 0
