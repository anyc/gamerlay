# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils games toolchain-funcs flag-o-matic check-reqs

MY_PN="${PN^}"
DESCRIPTION="Fork of Nexuiz, Deathmatch FPS based on DarkPlaces, an advanced Quake 1 engine"
HOMEPAGE="http://www.xonotic.org/"
SRC_URI="http://dl.xonotic.org/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa ode opengl +s3tc +sdl +server"
REQUIRED_USE="
	|| ( opengl sdl server )
"

UIRDEPEND="
	media-libs/libogg
	media-libs/libtheora[encode]
	media-libs/libvorbis
	media-libs/libmodplug
	x11-libs/libX11
	virtual/opengl
	media-libs/freetype:2
	s3tc? ( media-libs/libtxc_dxtn )
"
RDEPEND="
	sys-libs/zlib
	virtual/jpeg
	media-libs/libpng:0=
	net-misc/curl
	>=dev-libs/d0_blind_id-0.5
	ode? ( dev-games/ode[double-precision] )
	opengl? (
		${UIRDEPEND}
		x11-libs/libXext
		x11-libs/libXpm
		x11-libs/libXxf86vm
		alsa? ( media-libs/alsa-lib )
	)
	sdl? (
		${UIRDEPEND}
		media-libs/libsdl[X,audio,joystick,opengl,video,alsa?]
	)
"
DEPEND="${RDEPEND}
	opengl? (
		x11-proto/xextproto
		x11-proto/xf86vidmodeproto
		x11-proto/xproto
	)
"

S="${WORKDIR}/${MY_PN}"

CHECKREQS_DISK_BUILD="2100M"
CHECKREQS_DISK_USR="950M"

pkg_pretend() {
	check-reqs_pkg_pretend
}

pkg_setup() {
	check-reqs_pkg_setup
	games_pkg_setup
}

src_prepare() {
	tc-export CC
	# Required for DP_PRELOAD_DEPENDENCIES=1
	append-ldflags $(no-as-needed)

	epatch_user

	sed -i \
		-e "/^EXE_/s:darkplaces:${PN}:" \
		-e "/^OPTIM_RELEASE=/s:$: ${CFLAGS}:" \
		-e "/^LDFLAGS_RELEASE=/s:$: ${LDFLAGS}:" \
		source/darkplaces/makefile.inc || die

	if use !alsa; then
		sed -e "/DEFAULT_SNDAPI/s:ALSA:OSS:" \
			-i source/darkplaces/makefile || die
	fi
}

src_compile() {
	local targets=""
	local i

	use opengl && targets+=" cl-release"
	use sdl && targets+=" sdl-release"
	use server && targets+=" sv-release"

	cd source/darkplaces || die
	for i in ${targets}; do
		emake STRIP=true \
			DP_FS_BASEDIR="${GAMES_DATADIR}/${PN}" \
			DP_PRELOAD_DEPENDENCIES=1 \
			${i}
	done
}

src_install() {
	if use opengl; then
		dogamesbin source/darkplaces/${PN}-glx
		make_desktop_entry ${PN}-glx "${MY_PN} (GLX)"
	fi
	if use sdl; then
		dogamesbin source/darkplaces/${PN}-sdl
		make_desktop_entry ${PN}-sdl "${MY_PN} (SDL)"
	fi
	if use opengl || use sdl; then
		newicon misc/logos/icons_png/${PN}_512.png ${PN}.png
	fi
	use server && dogamesbin source/darkplaces/${PN}-dedicated

	dodoc Docs/*.txt
	dohtml -r Docs

	insinto "${GAMES_DATADIR}/${PN}"

	# public key for d0_blind_id
	doins key_0.d0pk

	use server && doins -r server

	doins -r data

	prepgamesdirs
}
