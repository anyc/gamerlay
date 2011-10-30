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
IUSE="cdvdiso cdvdlinuz cdvdnull dev9null fwnull gsdx gsnull onepad padnull spu2null spu2-x usbnull zerogs zerospu zzogl"

RDEPEND=" games-emulation/pcsx2
	cdvdiso?	( games-emulation/ps2emu-cdvdiso )
	cdvdlinuz?	( games-emulation/ps2emu-cdvdlinuz )
	cdvdnull?	( games-emulation/ps2emu-cdvdnull )
	dev9null?	( games-emulation/ps2emu-dev9null )
	fwnull?		( games-emulation/ps2emu-fwnull )
	gsdx?		( games-emulation/ps2emu-gsdx )
	gsnull?		( games-emulation/ps2emu-gsnull )
	onepad?		( games-emulation/ps2emu-onepad )
	padnull?	( games-emulation/ps2emu-padnull )
	spu2null?	( games-emulation/ps2emu-spu2null )
	spu2-x?		( games-emulation/ps2emu-spu2-x )
	usbnull?	( games-emulation/ps2emu-usbnull )
	zerogs?		( games-emulation/ps2emu-zerogs )
	zerospu?	( games-emulation/ps2emu-zerospu )
	zzogl?		( games-emulation/ps2emu-zzogl )
	"
