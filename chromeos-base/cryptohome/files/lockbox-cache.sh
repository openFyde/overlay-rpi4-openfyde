#!/bin/sh
# Copyright 2016 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

echo "Lockbox cache started"

umask 022
mkdir -p -m 0711 $LOCKBOX_CACHE_DIR

# Exit the script if any command fails.
set -e

# Look for the existing install attributes.
# If there's any, move them to new path.
# Note: this whole process is kept as much fault-tolerant as possible.
if [ -s $OLD_INSTALL_ATTRS_FILE ]; then
  if [ ! -s $NEW_INSTALL_ATTRS_FILE ]; then
    echo "Migrating install attributes"
    # First, create a copy to the new location, then rename it.
    # If the copy/rename operation somehow gets interrupted (sudden
    # reboot), the old install_attributes.pb file will still be there at
    # the next reboot.
    # So, it will reach this step again and eventually continue from here.
    mkdir -p $INSTALL_ATTRS_NEW_PATH
    sync
    cp $OLD_INSTALL_ATTRS_FILE $COPY_INSTALL_ATTRS_FILE
    sync
    mv $COPY_INSTALL_ATTRS_FILE $NEW_INSTALL_ATTRS_FILE
    sync
  fi
fi

if [ -f "${NEW_INSTALL_ATTRS_FILE}" ]; then
  cp "${NEW_INSTALL_ATTRS_FILE}" "${INSTALL_ATTRS_CACHE}"
fi
