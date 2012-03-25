# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: games-puzzle/kinetris/kinetris-1.0.0b_pre5.ebuild frostwork Exp $

EAPI="3"
MY_PN=Kinetris

inherit games qt4

DESCRIPTION="a tetrominoes game (i.e.: a Tetris clone) that uses the Xbox 360 Kinect"
HOMEPAGE="http://code.google.com/p/${PN}"
SRC_URI="http://kinetris.googlecode.com/files/Kinetris%201.0.0%20Beta%205%20%28source%29.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-gui
	x11-libs/qt-opengl
	media-libs/nite
	virtual/glu"

S="${WORKDIR}"/"${MY_PN}"" 1.0.0 Beta 5 (source)"/"${MY_PN}"

src_prepare() {
	sed -i -e "s:OpenNI.xml:"${GAMES_DATADIR}"/"${PN}"/OpenNI.xml:g" -i src/SensorThread.cpp
}

src_compile() {
	eqmake4 "${MY_PN}".pro
	emake || die "emake failed"
}

src_install() {
	newgamesbin bin/release/"${MY_PN}" "${PN}"
	insinto "${GAMES_DATADIR}"/"${PN}"
	doins OpenNI.xml || die "doins failed"
}

pkg_postinst() {
	games_pkg_postinst
	ewarn "gspca_kinect drivers doesn't have to be enabled if you want to use openni."
	ewarn "so best use gspca_kinect as kernel module and rmmod when required."

}
