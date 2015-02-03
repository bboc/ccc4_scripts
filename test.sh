#!/bin/sh

source="$1"
dest="$2"
exitStatus=$3

# python function to extract the path to the volume from a full path
function get_volume {
PYTHON_ARG="$1" python - <<END

import os
python_arg = os.environ['PYTHON_ARG']

def get_volume(full_path):
    import sys
    """Extract the path to the volume from the full_path."""
    el = full_path.split('/', 3)
    try:
        el[3] = ''  # make sure closing slash is kept!
    except IndexError:
        sys.exit(2)
    if el[1] != 'Volumes':
        sys.exit(1)
    return '/'.join(el)

print get_volume(python_arg)

END
}
# TODO: test if return is empty (skip rest then)
volume=$(get_volume "$dest")

if [ -z "$volume" ]
then
  echo "destination $dest is not a valid volume"
 else

	echo "disable spotlight search for the volume"
	mdutil -d "$volume"
	echo "disable indexing for the volume"
	mdutil -i "$volume"
	echo "erase local store for volume"
	mdutil -E "$volume"
	echo "write a metadata never index to destination so it will not be re-indexed even if you cloned .Spotlight-V100"
	touch "$volume.metadata_never_index"
fi

