#!/bin/sh
# disable-spotlight-on-volume.sh
#
# This script disables spotlight indexing for the destination volume, to avoid
# the operation being slowed down by the spotlight indexer.
#
# This script should work with OSX 10.6 through at least 10.9
# (use 'man mdutil' in the terminal to see if the parameters match on your version of OS-X)
#
# WARNING: This script does not work when the destination path is not pointing to the 
#          root of the volume!
#
# If you run into issues with spotlight (e.g. an error message that says Spotlight Server disabled)
# you can stop and restart the service
# stop spotlight completely:
# sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
# start it again (this will update all indexes and may slow your system down)
# sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
#
# don't forget to chmod 755 this script

source="$1"
dest="$2"
exitStatus=$3

# disable spotlight search for the volume
mdutil -d $dest
# disable indexing for the volume
mdutil -i $dest
# erase local store for volume, might not be necessary but thrown in for good measure
mdutil -E $dest
# write a metadata never index to destination so it will not be re-indexed even if you cloned .Spotlight-V100
touch {$dest}.metadata_never_index
