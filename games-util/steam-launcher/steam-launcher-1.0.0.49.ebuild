# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils gnome2-utils fdo-mime udev games

DESCRIPTION="Installer, launcher and supplementary files for Valve's Steam client"
HOMEPAGE="http://steampowered.com"
SRC_URI="http://repo.steampowered.com/steam/pool/steam/s/steam/steam_${PV}.tar.gz"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="ValveSteamLicense"

RESTRICT="bindist mirror"
SLOT="0"

RDEPEND="
		app-arch/tar
		app-shells/bash
		net-misc/curl
		|| (
			>=gnome-extra/zenity-3
			x11-terms/xterm
			)

		amd64? (
			|| (
				>=app-emulation/emul-linux-x86-xlibs-20121028[-abi_x86_32(-)]
				(
					x11-libs/libX11[abi_x86_32]
					x11-libs/libXau[abi_x86_32]
					x11-libs/libxcb[abi_x86_32]
					x11-libs/libXdmcp[abi_x86_32]
				)
			)
			>=sys-devel/gcc-4.6.0[multilib]
			>=sys-libs/glibc-2.15[multilib]
			)

		x86? (
			>=sys-devel/gcc-4.6.0
			>=sys-libs/glibc-2.15
			>=x11-libs/libX11-1.5
			x11-libs/libXau
			x11-libs/libxcb
			x11-libs/libXdmcp
			)
"

S=${WORKDIR}/steam/

src_prepare() {
	epatch "${FILESDIR}"/steam-fix-ld-library-path.patch

	# we use our ebuild functions to install the files
	rm Makefile

	sed -i \
		-e "s:/usr/bin/steam:${GAMES_BINDIR}/steam:" \
		"${S}"/steam.desktop || die "sed failed"

	epatch_user
}

src_install() {
	dogamesbin steam || die "dogamesbin failed"

	insinto /usr/lib/steam/
	doins bootstraplinux_ubuntu12_32.tar.xz

	udev_dorules lib/udev/rules.d/99-steam-controller-perms.rules

	dodoc debian/changelog steam_install_agreement.txt
	doman steam.6

	domenu steam.desktop

	cd icons/
	for s in * ; do
		doicon -s ${s} ${s}/steam.png
	done

	# tgz archive contains no separate pixmap, see #38
	insinto /usr/share/pixmaps/
	newins 48/steam_tray_mono.png steam_tray_mono.png

	prepgamesdirs
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
	udev_reload

	elog "Execute ${GAMES_BINDIR}/steam to download and install the actual"
	elog "client into your home folder. After installation, the script"
	elog "also starts the client from your home folder."
	elog ""

	if ! has_version "gnome-extra/zenity"; then
		ewarn "Valve does not provide a xterm fallback for all calls of zenity."
		ewarn "Please install gnome-extra/zenity for full support."
		ewarn ""
	fi

	ewarn "The steam client and the games are _not_ controlled by portage."
	ewarn "Updates are handled by the client itself."
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
