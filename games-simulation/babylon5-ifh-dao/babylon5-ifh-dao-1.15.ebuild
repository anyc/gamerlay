# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games

MY_PV=${PV/./}
DESCRIPTION="Danger and Opportunity - a prequel for Babylon 5: I've Found Her"
HOMEPAGE="http://ifhgame.ru/main/dao-home"
SRC_URI="http://www.b5.ru/ifh/ifh${MY_PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/fmod-4.30.06
	virtual/opengl
	x11-libs/libX11"
DEPEND="${DEPEND}"

S="${WORKDIR}"/ifh

src_install() {
	local dir=${GAMES_PREFIX_OPT}/ifh
	if use amd64; then
		local exefile=coreifh64
	fi
	if use x86; then
		local exefile=coreifh32
	fi
	# useless stuff
	rm -r "${S}"/data/music/gg/.svn/
	insinto "${dir}"
	doins -r data || die "doins failed"
	insinto "${dir}"/bin
	doins bin/{*.cfg,resource.war} || die "doins failed"
	# Saves goes here. INSECURE!!1
	fperms 770 "${dir}"/data/pilots
	exeinto "${dir}"/bin
	doexe bin/${exefile} || die "doexe failes"
	games_make_wrapper ${PN} ./${exefile} "${dir}/bin" "${dir}/bin"

	prepgamesdirs
}
