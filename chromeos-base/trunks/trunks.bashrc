cros_post_src_install_specified_rpi4_openfyde_patches() {
  if [ $PV == "9999" ]; then
    return
  fi
  if use tpm2_simulator and not use tpm2_simulator_deprecated; then
    # append tpm2-simulator to the list of dependencies
    sed -i '/started dbus/ s/$/ and started tpm2-simulator/' \
      "${D}/etc/init/trunksd.conf"
  fi
}
