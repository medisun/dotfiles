#!/usr/bin/env bash
# Google Drive Sync
#
# Dependencies: pv, notify-send, tar, find, grive
#
# Config BEGIN
# =====================================================================

# Directory to backup
BACKUPDIR=/tmp/google_drive_backup_sync

# Google Drive directory
GDRIVEDIR=/mnt/GoogleDrive

# Directory target in remote
TARGETDIR=/backups

# User directory
USERDIR=/home/morock

# =====================================================================
# Config END

BACKUPDATE=`date +"%Y-%m-%d %H:%M"`

# Startup notify
notify-send -i emblem-downloads "Start Backup & Sync to Google drive..."

# Requirements checking
command -v pv >/dev/null 2>&1 || { echo "I require 'pv' but it's not installed.  Aborting." >&2; exit 1; }
command -v notify-send >/dev/null 2>&1 || { echo "I require 'notify-send' but it's not installed.  Aborting." >&2; exit 1; }
command -v tar >/dev/null 2>&1 || { echo "I require 'tar' but it's not installed.  Aborting." >&2; exit 1; }
command -v find >/dev/null 2>&1 || { echo "I require 'find' but it's not installed.  Aborting." >&2; exit 1; }
command -v grive >/dev/null 2>&1 || { echo "I require 'grive' but it's not installed.  Aborting." >&2; exit 1; }

# Locking file
LN="${BACKUPDIR}/autopull.running"

if [[ -f "$LN" ]]; then
    exit 0
fi

touch "$LN"

# Make sure only root can run our script
if [ ! -w "$GDRIVEDIR" ]; then
   echo ">>> $GDRIVEDIR is not writable!"
   notify-send -i emblem-unreadable "Failed backup &  sync to Google drive"
   exit 1
fi

# Create backup dir if not exists
if [ ! -d "${BACKUPDIR}" ]; then 
  echo ">>> Creating ${BACKUPDIR}"
  mkdir ${BACKUPDIR}
fi

##
## Backup instructions
##

# Backup Firefox  profile
echo ">>> Backup Firefox  profile at ~/.mozilla"
tar -czf - "$USERDIR/.mozilla/" | pv >  "${BACKUPDIR}/firefox.tgz"

# Backup Sublime Text 3 profile
echo ">>> Backup Sublime Text 3 profile at ~/.config/sublime-text-3"
tar -czf - "$USERDIR/.config/sublime-text-3/" | pv >  "${BACKUPDIR}/sublime-text-3.tgz"

# Create log file
echo ">>> Backup Info File "
echo "Last backup date : ${BACKUPDATE}
Directory listing : 
`ls -Alh ${BACKUPDIR}`
" > "${BACKUPDIR}/backup_details.txt"


##
## Begin syncronization
##

# Create backup dir if not exists
if [ ! -d "${GDRIVEDIR}" ]; then 
  echo ">>> Whoops! There is no ${GDRIVEDIR}. Try create it"
  mkdir ${GDRIVEDIR}
fi

# Moving to Gdrive Dir
echo ">>> Entering ${GDRIVEDIR}"
cd ${GDRIVEDIR}

# Initial sync
echo ">>> Initial Google Drive Sync"
grive

# Create backup dir if not exists
if [ ! -d "${GDRIVEDIR}/${TARGETDIR}" ]; then 
  echo ">>> Creating ${GDRIVEDIR}/${TARGETDIR}"
  mkdir ${GDRIVEDIR}/${TARGETDIR}
fi

# Coping new content
echo ">>> Copying from ${BACKUPDIR}/* to ${GDRIVEDIR}/${TARGETDIR}/"
cp -R ${BACKUPDIR}/* ${GDRIVEDIR}/${TARGETDIR}/

# Showing files copied
echo ">>> Files to sync"
find ${GDRIVEDIR}/${TARGETDIR}/


# Final sync
echo ">>> Final Google Drive Sync"
grive

# Remove lock file
rm -f "$LN"

echo ">>> Backup & Sync Finished."

notify-send -i emblem-default "Finished Backup & Sync to Google drive..."

exit 0
