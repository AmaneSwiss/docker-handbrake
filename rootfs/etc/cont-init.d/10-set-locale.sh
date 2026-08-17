#!/bin/sh
#
# Set the locale to the value of the LANG environment variable.
#

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

if grep -q "^# *${LANG}" /etc/locale.gen; then
    sed -i "s/^# *\(${LANG}\)/\1/" /etc/locale.gen
    locale-gen "${LANG}"
    update-locale LANG="${LANG}"
    echo "Locale set to $(locale | grep LANG)"
fi

# vim:ts=4:sw=4:et:sts=4
