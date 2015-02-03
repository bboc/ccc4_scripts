#!/bin/bash

function call_python {
PYTHON_ARG="$1" python - <<END

import os
python_arg = os.environ['PYTHON_ARG']

print 'this is python output', python_arg

END
}

# simple call
call_python "$1"

# grab result
result=$(call_python "$1")
echo $result

