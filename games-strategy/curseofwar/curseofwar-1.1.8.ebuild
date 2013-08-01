# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games

DESCRIPTION="A fast-paced action strategy game implemented using ncurses user interface."
HOMEPAGE="https://github.com/a-nikolaev/curseofwar/wiki"
SRC_URI="https://github.com/a-nikolaev/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s:%VERSION%:${PV}:g" ${PN}.6
}

src_install() {
	dogamesbin ${PN}
	doman ${PN}.6
	dodoc CHANGELOG README
}
