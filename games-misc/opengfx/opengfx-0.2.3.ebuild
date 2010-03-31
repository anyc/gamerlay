# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games

DESCRIPTION="OpenGFX data files for OpenTTD"
HOMEPAGE="http://bundles.openttdcoop.org/opengfx/"
SRC_URI="http://bundles.openttdcoop.org/${PN}/releases/${P}-source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${P}-source"

DEPEND=">=games-simulation/openttd-0.7.0
	games-util/nforenum
	games-util/grfcodec"
RDEPEND="${DEPEND}"

src_compile() {
	emake bundle
}

src_install() {
	insinto "${GAMES_DATADIR}/openttd/data/"
	doins *.grf opengfx.obg
	dodoc docs/*.txt || die "dodoc failed"
	prepgamesdirs
}
