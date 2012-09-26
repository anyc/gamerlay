# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit games multilib unpacker-nixstaller

TIMESTAMP="2012-06-20"

DESCRIPTION="An original action role-playing game set in a lush imaginative world, in which players must create and fight for civilization’s last refuge as a mysterious narrator marks their every move."
HOMEPAGE="http://supergiantgames.com/?page_id=242"

SLOT="0"
LICENSE="as-is"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="fetch"
IUSE=""

SRC_URI="Bastion-HIB-${TIMESTAMP}.sh"

RDEPEND="=media-libs/libsdl-1.2*
	=dev-lang/mono-2.10*
	media-libs/fmod"
DEPEND="${RDEPEND}"

S="${WORKDIR}"
MY_PN="Bastion"

pkg_nofetch() {
        ewarn
        ewarn "Place ${A} to ${DISTDIR}"
        ewarn
}

src_unpack() {
	nixstaller_unpack "subarch" "instarchive_all"
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${dir}"
	doins -r \
		Content \
		Bastion.exe \
		FMOD.dll \
		GamepadBridge.dll \
		Lidgren.Network.dll \
		MonoGame.Framework.Linux.dll \
		OpenTK.dll OpenTK.dll.config \
		Tao.Sdl.dll Tao.Sdl.dll.config

	games_make_wrapper "${PN}" "mono Bastion.exe" "${dir}" "${dir}/$(get_libdir)"
	doicon "${MY_PN}.png" || die
	make_desktop_entry "${PN}" "${MY_PN}" "${MY_PN}"

	dodoc README.linux
	prepgamesdirs
}
