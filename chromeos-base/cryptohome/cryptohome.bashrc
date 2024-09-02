# Copyright 2024 Fyde Innovations. All rights reserved.

cros_post_src_install_specified_rpi4_openfyde_patches() {
  if use tpm and not use tpm2; then
    exeinto /usr/share/cros/init
    doexe "${RPI4_OPENFYDE_BASHRC_FILEPATH}"/lockbox-cache.sh
  fi
}
