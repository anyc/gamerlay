# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit emul-linux-x86

DESCRIPTION="Backwards compat for emul-linux-x86-wxGTK using multilib"
HOMEPAGE="http://dev.gentoo.org/~vincent"
SRC_URI="http://dev.gentoo.org/~vincent/distfiles/${P}.tar.xz"

LICENSE="wxWinLL-3 GPL-2"
SLOT="2.8"
KEYWORDS="-* ~amd64"
IUSE="development"

RDEPEND="app-emulation/emul-linux-x86-baselibs
	app-emulation/emul-linux-x86-gtklibs
	app-emulation/emul-linux-x86-medialibs
	app-emulation/emul-linux-x86-opengl
	app-emulation/emul-linux-x86-sdl
	app-emulation/emul-linux-x86-xlibs
	!x11-libs/wxGTK[abi_x86_32]"

src_prepare() {
	ALLOWED="${S}/usr/lib32/|${S}/usr/bin"
	emul-linux-x86_src_prepare
}
