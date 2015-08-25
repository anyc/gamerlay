# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

SCM=""
[[ "${PV}" = 9999 ]] && SCM="git-r3"
inherit eutils games ${SCM}
unset SCM

DESCRIPTION="Return to Castle Wolfenstein - IORTCW Project"
HOMEPAGE="http://games.activision.com/games/wolfenstein/"
if [[ "${PV}" = 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/iortcw/iortcw.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/iortcw/iortcw/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/iortcw-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+client curl mumble openal opus server truetype voip vorbis"

REQUIRED_USE="|| ( client server )
		voip? ( opus )"

DEPEND="client?	(
		media-libs/libsdl2
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libXext
		virtual/opengl
	)"

RDEPEND="client? ( media-libs/libsdl2
		virtual/opengl
		virtual/jpeg:0
		curl? ( net-misc/curl )
		mumble? ( media-sound/mumble )
		openal? ( media-libs/openal )
		opus? ( media-libs/libogg
			media-libs/opus
			media-libs/opusfile )
		truetype? ( media-libs/freetype )
		vorbis? ( media-libs/libogg
			media-libs/libvorbis ) )"
	#voip? ( media-libs/speex )"

dir=${GAMES_PREFIX_OPT}/${PN}
ARCHITECTURE=$(uname -m)

use_switch() {
	local flag="${1}" cfg_option="${2}" cfg_val=0
	local makefile="${S}/SP/Makefile.local"
	[[ -z "${flag}" ]] && die
	[[ -z "${cfg_option}" ]] && die

	use ${flag} && cfg_val=1

	if grep -q "^${cfg_option}=" ${makefile} ; then
		sed "/${cfg_option}=/s@[[:digit:]]@${cfg_val}@" -i ${makefile} \
			|| die
	else
		echo "${cfg_option}=${cfg_val}" >> ${makefile}
	fi
}

src_prepare(){
	epatch "${FILESDIR}/${PN}-zlib.patch"
	cp "${FILESDIR}/Makefile.local" "${S}/SP/"

	# remove bundled libs
	local bundled_libs bundle bdir tdir

	bundled_libs=(
		AL # openal
		SDL2
		freetype-2.5.5
		jpeg-8c
		libcurl-7.35.0
		libogg-1.3.2
		libvorbis-1.3.4
		opus-1.1
		opusfile-0.6
		zlib
	)
	for bundle in ${bundled_libs[@]} ; do
		for tdir in MP SP ; do
			bdir="${tdir}/code/${bundle}"
			if [[ -d "${bdir}" ]] ; then
				rm -r ${bdir} || die
			fi
		done
	done

	sed "/^CFLAGS=/s@=.*\$@=${CFLAGS}@" -i SP/Makefile.local || die

	use_switch client BUILD_CLIENT
	use_switch curl USE_CURL
	use_switch mumble USE_MUMBLE
	use_switch openal USE_OPENAL
	use_switch opus USE_CODEC_OPUS
	use_switch server BUILD_SERVER
	use_switch truetype USE_FREETYPE
	use_switch vorbis USE_CODEC_VORBIS
	use_switch voip USE_VOIP

	use curl && echo "USE_CURL_DLOPEN=0" >> SP/Makefile.local
	use openal && echo "USE_OPENAL_DLOPEN=0" >> SP/Makefile.local
}

src_compile() {
	cd "${S}/SP/"
	ARCH="${ARCHITECTURE}" emake
}

src_install() {
	cd "${S}/SP/"
	ARCH="${ARCHITECTURE}" \
	COPYDIR=${D}/${GAMES_PREFIX_OPT}/${PN} \
	emake copyfiles

	#games_make_wrapper rtcwmp ./wolf.x86 "${dir}" "${dir}"
	games_make_wrapper rtcwsp ./iowolfsp."${ARCHITECTURE}" "${dir}" "${dir}"

	#if use server; then
	#	games_make_wrapper wolf-ded ./wolfded.x86 "${dir}" "${dir}"
	#	newinitd "${FILESDIR}"/wolf-ded.rc wolf-ded
	#	sed -i \
	#		-e "s:GENTOO_DIR:${dir}:" \
	#		"${D}"/etc/init.d/wolf-ded \
	#		|| die
	#fi

	doicon -s scalable misc/iortcw.svg
	make_desktop_entry rtcwsp "Return to Castle Wolfenstein (SP)" iortcw
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "You need to copy pak0.pk3, mp_pak0.pk3, mp_pak1.pk3, mp_pak2.pk3,"
	elog "sp_pak1.pk3 and sp_pak2.pk3 sp_pak3.pk3 sp_pak4.pk3 from a Window installation into ${dir}/main/"
	elog
	elog "To play the game run:"
	elog " rtcwsp (single-player)"
	#elog " rtcwmp (multi-player)"
	elog
#	if use server
#	then
#		elog "To start a dedicated server run:"
#		elog " /etc/init.d/wolf-ded start"
#		elog
#		elog "To run the dedicated server at boot, type:"
#		elog " rc-update add wolf-ded default"
#		elog
#		elog "The dedicated server is started under the ${GAMES_USER_DED} user account"
#		echo
#	fi
}
