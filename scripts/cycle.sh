#!/bin/sh
# Copyright (C) 2014  Codethink Limited
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

usage() {
    echo "Usage: cycle.sh some-system"
    echo
    echo "This builds and deploys the current checked out version of"
    echo "some-system, and applies it as a self-upgrade to the system you"
    echo "are working in. The upgrade is labelled TEST, and is set to be"
    echo "the default for next boot."
}

if [ -z "$1" ]; then
    usage
    exit 1
fi

set -e
set -v

morph gc
morph build $1
system-version-manager set-default factory
if [ `system-version-manager list | grep ^TEST$` ]; then
  system-version-manager remove TEST
fi

sed -i "s|^- morph: .*$|- morph: $1|" clusters/upgrade-devel.morph
morph deploy --upgrade clusters/upgrade-devel.morph self.HOSTNAME=$(hostname) self.VERSION_LABEL=TEST
