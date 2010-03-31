# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games

DESCRIPTION="OpenSFX data files for OpenTTD"
HOMEPAGE="http://bundles.openttdcoop.org/opensfx/"
SRC_URI="http://bundles.openttdcoop.org/${PN}/releases/${P}-source.tar.gz"

LICENSE="CCPL-Sampling-Plus-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=games-simulation/openttd-1.0.0_beta1
	games-util/catcodec"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}-source

src_install() {
	insinto "${GAMES_DATADIR}/openttd/data/"
	doins opensfx.cat opensfx.obs || die "doins failed in $(pwd)"
	dodoc docs/*.txt || die "dodoc failed"
	prepgamesdirs
}
