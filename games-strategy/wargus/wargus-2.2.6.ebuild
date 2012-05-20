# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/wargus/wargus-2.2.5.5.ebuild,v 1.7 2012/05/17 18:06:23 mr_bones_ Exp $

EAPI=2
inherit eutils cdrom cmake-utils games

DESCRIPTION="Warcraft II for the Stratagus game engine (Needs WC2 DOS CD)"
HOMEPAGE="http://wargus.sourceforge.net/"
SRC_URI="http://launchpad.net/wargus/trunk/${PV}/+download/wargus_${PV}.orig.tar.gz
	mirror://gentoo/wargus.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libpng
	media-sound/timidity++
	media-video/ffmpeg2theora"
RDEPEND="=games-engines/stratagus-${PV}*"

S="${WORKDIR}/${PN}_${PV}.orig"

src_prepare() {
	cdrom_get_cds data/rezdat.war
	epatch "${FILESDIR}/${PN}-2.2.5.5-libpng.patch"

	sed -i \
		-e '/TARGETS.*DESTINATION/s:games\|s\?bin:games/bin:' \
		CMakeLists.txt || die 'fixing install paths failed'
}

src_configure() {
	local mycmakeargs=(
		-DSTRATAGUS=/usr/games/bin/stratagus
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	# XXX: -r to rip CD tracks? not sure if it is good idea to pass it
	# by default

	local dir=${GAMES_DATADIR}/stratagus/${PN}

	"${D}"/usr/games/bin/wartool -m -v "${CDROM_ROOT}"/data "${D}/${dir}" \
		|| die "Failed to extract data"
}
