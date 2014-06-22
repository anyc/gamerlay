# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: games-emulation/pcsx2-meta-9999.ebuild,v 1.1 2014/06/20 08:30:00 frostwork Exp $

EAPI="2"

inherit eutils

DESCRIPTION="meta package for pcsx2 and plugins"
HOMEPAGE="http://www.pcsx2.net"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="cdvdiso cdvdlinuz cdvdnull dev9null fwnull gsdx gsnull onepad padnull spu2null spu2-x usbnull zerogs zzogl"

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
	zzogl?		( games-emulation/ps2emu-zzogl )
	"
