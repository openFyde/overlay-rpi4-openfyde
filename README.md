# overlay-rpi4-openfyde

Copyright (c) 2022 Fyde Innovations and the openFyde Authors.

Distributed under the license specified in the root directory of this project.

This repository is part of [openfyde](https://github.com/openFyde/) and can be used to set up a BOARD named `overlay-rpi4-openfyde`.

This repository contains the following packages:

| Packages                               | Description                                           | Reference                                                                                                                                      |
|----------------------------------------|-------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| chromeos-base/device-appid             | Setup device appid                                    |                                                                                                                                                |
| chromeos-base/chromeos-chrome          | Open-source version of Google Chrome web browser      | [chromiumos-overlay](https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/refs/heads/main/chromeos-base/chromeos-chrome) |
| chromeos-base/chromeos-init            | Upstart init scripts for Chromium OS                  | [chromiumos-overlay](https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/refs/heads/main/chromeos-base/chromeos-init)   |
| chromeos-base/chromeos-bsp-rpi4-openfyde | drivers, config files for Raspberry Pi 4              |                                                                                                                                                |
| virtual/chromeos-bsp                   | Generic ebuild which satisifies virtual/chromeos-bsp. | [chromiumos-overlay](https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/refs/heads/main/virtual/chromeos-bsp)          |
| virtual/chromeos-config-bsp            | Chrome OS BSP config virtual package                  |                                                                                                                                                |
