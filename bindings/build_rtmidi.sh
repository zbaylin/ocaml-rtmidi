#/usr/bin/env bash
set -e

# The name of the library in vendored/
library_dirname="rtmidi-5.0.0"

cp -r "$DUNE_SOURCEROOT/vendored/$library_dirname" .
cd "$library_dirname"

./configure
make

ar -rcs librtmidi.a *.o

cp librtmidi.a "../"
cp *.h "../"
