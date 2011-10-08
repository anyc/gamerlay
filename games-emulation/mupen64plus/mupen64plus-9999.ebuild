# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="A fork of Mupen64 Nintendo 64 emulator"
HOMEPAGE="http://code.google.com/p/mupen64plus/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="plugins"

RDEPEND="games-emulation/mupen64plus-ui-console
	plugins? (
		games-emulation/mupen64plus-rsp-z64
		games-emulation/mupen64plus-video-arachnoid
		games-emulation/mupen64plus-video-glide64
		games-emulation/mupen64plus-video-z64
	)"

pkg_postinst() {
	games_pkg_postinst

	elog "As of 2.0, Mupen64Plus includes only a command line launcher."
	elog "Run 'mupen64plus --help' for options."
	echo
	elog "If you would prefer to use a GUI frontend, see the following for options:"
	elog "http://code.google.com/p/mupen64plus/wiki/ThirdPartyPlugins#Third-Party_Front-end_Applications"
}
