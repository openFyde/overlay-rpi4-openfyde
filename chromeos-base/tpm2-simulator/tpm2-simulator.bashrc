# Copyright (c) 2022 Fyde Innovations Limited and the openFyde Authors.
# Distributed under the license specified in the root directory of this project.

# tpm2-simulator in overlay-rpi4 will be used, unset hooks in
# tpm2-simulator.bashrc of openfyde-patches, to prevent applying same patch
# multiple times.
unset -f cros_pre_src_prepare_openfyde_patches
