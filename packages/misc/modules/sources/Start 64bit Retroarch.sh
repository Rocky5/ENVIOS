#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

source /etc/profile

jslisten set "killall retroarch"

/usr/bin/retroarch --appendconfig /usr/config/retroarch/retroarch64bit-append.cfg
