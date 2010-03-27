# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2:2.6"

inherit games

DESCRIPTION="An ambiguously named music replacement set for OpenTTD"
HOMEPAGE="http://bundles.openttdcoop.org/openmsx/"
SRC_URI="http://bundles.openttdcoop.org/${PN}/releases/${P}-source.tar.gz"

LICENSE="|| ( GPL-2 CCPL-Sampling-Plus-1.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${P}-source"

DEPEND=">=games-simulation/openttd-1.0.0_beta1[alsa]"
RDEPEND="${DEPEND}"

src_compile() {
	emake bundle
}

src_install() {
	cd "${P}" || die
	insinto "${GAMES_DATADIR}/openttd/gm/${P}"
	doins *.mid openmsx.obm || die "doins failed"
	dodoc changelog.txt license.txt readme.txt || die "dodoc failed"
	prepgamesdirs
}