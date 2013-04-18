# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=5

DESCRIPTION="An Improved Quake C Compiler"
HOMEPAGE="http://graphitemaster.github.com/gmqcc/"
SRC_URI="https://github.com/graphitemaster/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"

SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

src_prepare() {
	sed -i -e "s:-Werror ::" Makefile || die
}

src_install() {
	emake install PREFIX="${D}/usr"
	dodoc README
}
