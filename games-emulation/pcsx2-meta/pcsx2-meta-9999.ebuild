# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="meta package for pcsx2 and plugins"
HOMEPAGE="http://www.pcsx2.net"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"

RDEPEND=" games-emulation/pcsx2
	games-emulation/ps2emu-cdvdiso
	games-emulation/ps2emu-cdvdlinuz
	games-emulation/ps2emu-cdvdnull
	games-emulation/ps2emu-dev9null
	games-emulation/ps2emu-fwnull
	games-emulation/ps2emu-gsdx
	games-emulation/ps2emu-gsnull
	games-emulation/ps2emu-onepad
	games-emulation/ps2emu-padnull
	games-emulation/ps2emu-spu2null
	games-emulation/ps2emu-spu2-x
	games-emulation/ps2emu-usbnull
	games-emulation/ps2emu-zerogs
	games-emulation/ps2emu-zerospu
	games-emulation/ps2emu-zzogl
	"
