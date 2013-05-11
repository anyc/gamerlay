# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: games-util/gogonlinux-0.2.6.ebuild,v 1.0 2013/05/11 08:46:00 by frostwork Exp $

EAPI="4"

inherit distutils eutils

DESCRIPTION="Linux compatibility project for gog.com"
HOMEPAGE="http://www.${PN}.com"
SRC_URI="http://www.${PN}.com/releases/${P}.tar.gz"

LICENSE="BSD-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="gnome-base/libglade
		dev-python/certifi
		dev-python/oauth2
		dev-python/requests
		games-engines/scummvm
		games-emulation/dosbox
		app-emulation/wine
		app-emulation/winetricks
		app-arch/innoextract"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -e "s:/local::" -i setup.py || die
	sed -e "s:'/man:'/share/man:" -i setup.py || die
	sed -e "s:.svg::" -i data/gog-tux.desktop || die
	sed -e "s:Game:Game;:" -i data/gog-tux.desktop || die
}
