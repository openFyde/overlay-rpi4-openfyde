# Copyright (c) 2022 Fyde Innovations Limited and the openFyde Authors.
# Distributed under the license specified in the root directory of this project.

# Copyright 2011 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="95cba42c3e39999a02c3534e6924cdd5b8cdc775"
CROS_WORKON_TREE=("79cdd007ff69259efcaad08803ef2d1498374ec4" "cf309d680997762b7fc5077d9fcce880ff40e7d1" "eb510d666a66e6125e281499b649651b849a25f7" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid #include-ing platform2 headers directly.
CROS_WORKON_SUBTREE="common-mk init metrics .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="init"

inherit tmpfiles cros-workon platform user

DESCRIPTION="Upstart init scripts for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/init/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="
	arcpp arcvm cros_embedded direncryption +encrypted_stateful
	+encrypted_reboot_vault frecon fsverity lvm_stateful_partition
	fydeos_factory_install fixcgroup fixcgroup-memory kvm_host
	+oobe_config prjquota -s3halt +syslog systemd tpm2 +udev vivid vtconsole"

# secure-erase-file, vboot_reference, and rootdev are needed for clobber-state.
# re2 is needed for process_killer.
COMMON_DEPEND="
	chromeos-base/bootstat:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/secure-erase-file:=
	chromeos-base/vboot_reference:=
	dev-libs/re2:=
	sys-apps/rootdev:=
"

DEPEND="${COMMON_DEPEND}
	test? (
		sys-process/psmisc
		dev-util/shflags
		dev-util/shunit2
		sys-apps/diffutils
	)
"

RDEPEND="${COMMON_DEPEND}
	app-arch/tar
	app-misc/jq
	!chromeos-base/chromeos-disableecho
	chromeos-base/chromeos-common-script
	chromeos-base/tty
	oobe_config? ( chromeos-base/oobe_config )
	sys-apps/upstart
	!systemd? ( sys-apps/systemd-tmpfiles )
	sys-process/lsof
	virtual/chromeos-bootcomplete
	!cros_embedded? (
		chromeos-base/common-assets
		chromeos-base/chromeos-storage-info
		chromeos-base/swap-init
		sys-fs/e2fsprogs
	)
	frecon? (
		sys-apps/frecon
	)
"

platform_pkg_test() {
	local shell_tests=(
		killers_unittest
		tests/chromeos-disk-metrics-test.sh
		tests/send-kernel-errors-test.sh
	)

	local test_bin
	for test_bin in "${shell_tests[@]}"; do
		platform_test "run" "./${test_bin}"
	done

	platform test_all
}

src_install_upstart() {
	insinto /etc/init

	if use cros_embedded; then
		doins upstart/startup.conf
		dotmpfiles tmpfiles.d/chromeos.conf
		doins upstart/embedded-init/boot-services.conf

		doins upstart/report-boot-complete.conf
		doins upstart/failsafe-delay.conf upstart/failsafe.conf
		doins upstart/pre-shutdown.conf upstart/pre-startup.conf
		doins upstart/pstore.conf upstart/reboot.conf
		doins upstart/system-services.conf
		doins upstart/uinput.conf
		doins upstart/sysrq-init.conf

		if use syslog; then
			doins upstart/collect-early-logs.conf
			doins upstart/log-rotate.conf upstart/syslog.conf
			dotmpfiles tmpfiles.d/syslog.conf
		fi
		if use !systemd; then
			doins upstart/cgroups.conf
			doins upstart/dbus.conf
			dotmpfiles tmpfiles.d/dbus.conf
			if use udev; then
				doins upstart/udev*.conf
			fi
		fi
		if use frecon; then
			doins upstart/boot-splash.conf
		fi
	else
		doins upstart/*.conf
		dotmpfiles tmpfiles.d/*.conf

		if ! use arcpp && use arcvm; then
			sed -i '/^env IS_ARCVM=/s:=0:=1:' \
				"${D}/etc/init/rt-limits.conf" || \
				die "Failed to replace is_arcvm in rt-limits.conf"
		fi

		dosbin chromeos-disk-metrics
		dosbin chromeos-send-kernel-errors
		dosbin display_low_battery_alert
	fi

	if use s3halt; then
		newins upstart/halt/s3halt.conf halt.conf
	else
		doins upstart/halt/halt.conf
	fi

	if use vivid; then
		doins upstart/vivid/vivid.conf
	fi

	use vtconsole && doins upstart/vtconsole/*.conf
}

src_install() {
	# Install helper to run periodic tasks.
	dobin "${OUT}"/periodic_scheduler
	dobin "${OUT}"/process_killer

	if use syslog; then
		# Install log cleaning script and run it daily.
		dosbin chromeos-cleanup-logs

		insinto /etc
		doins rsyslog.chromeos
	fi

	insinto /usr/share/cros
	doins ./*_utils.sh

	exeinto /usr/share/cros/init
	doexe is_feature_enabled.sh

	into /	# We want /sbin, not /usr/sbin, etc.

	# Install various utility files.
	dosbin killers

	# Install various helper programs.
	dosbin "${OUT}"/cros_sysrq_init
	dosbin "${OUT}"/static_node_tool
	dosbin "${OUT}"/net_poll_tool
	dosbin "${OUT}"/file_attrs_cleaner_tool
	dosbin "${OUT}"/usermode-helper

	# Install startup/shutdown scripts.
	dosbin "${OUT}"/chromeos_startup
	dosbin chromeos_startup.sh
	dosbin chromeos_shutdown

	# Disable encrypted reboot vault if it is not used.
	if ! use encrypted_reboot_vault; then
		sed -i '/USE_ENCRYPTED_REBOOT_VAULT=/s:=1:=0:' \
			"${D}/sbin/chromeos_startup.sh" ||
			die "Failed to replace USE_ENCRYPTED_REBOOT_VAULT in chromeos_startup"
	fi

	# Enable lvm stateful partition.
	if use lvm_stateful_partition; then
		sed -i '/USE_LVM_STATEFUL_PARTITION=/s:=0:=1:' \
			"${D}/sbin/chromeos_startup.sh" ||
			die "Failed to replace USE_LVM_STATEFUL_PARTITION in chromeos_startup"
	fi

	dosbin "${OUT}"/clobber-state

	dosbin clobber-log
	dosbin chromeos-boot-alert

	# Install Upstart scripts.
	src_install_upstart

	insinto /usr/share/cros
	doins $(usex encrypted_stateful encrypted_stateful \
		unencrypted_stateful)/startup_utils.sh

	# Install LVM conf files.
	insinto /etc/lvm
	doins lvm.conf
}

pkg_preinst() {
	# Add the syslog user
	enewuser syslog
	enewgroup syslog

	# Create debugfs-access user and group, which is needed by the
	# chromeos_startup script to mount /sys/kernel/debug.  This is needed
	# by bootstat and ureadahead.
	enewuser "debugfs-access"
	enewgroup "debugfs-access"

	# Create pstore-access group.
	enewgroup pstore-access
}

src_prepare() {
	default
	if use fydeos_factory_install; then
		eapply -p2 ${FILESDIR}/insert_factory_install_script.patch
		eapply -p2 ${FILESDIR}/set_default_language_to_zh.patch
		if [ -n "${FYDEOS_FACTORY_INSTALL}" ]; then
			echo $FYDEOS_FACTORY_INSTALL > $FYDEOS_INSTALL_FILE
		fi
	fi
	if use fixcgroup; then
		eapply -p2 ${FILESDIR}/cgroups_cpuset.patch
	fi
	if use fixcgroup-memory; then
		eapply -p2 ${FILESDIR}/fix_cgroup_memory.patch
	fi
	eapply -p2 ${FILESDIR}/change_splash_background_color_black.patch
	if ! use kvm_host; then
		eapply -p2 ${FILESDIR}/remove_cgroup_crosvm.patch
	fi
}
