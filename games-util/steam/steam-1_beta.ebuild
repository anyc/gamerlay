EAPI="5"
inherit eutils unpacker

DESCRIPTION="Valve's Steam"
HOMEPAGE="http://store.steampowered.com/"
SRC_URI="http://media.steampowered.com/client/installer/steam.deb"
IUSE="multilib"

DEPEND=""
RDEPEND="
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdmcp
	amd64? (
		app-emulation/emul-linux-x86-xlibs
	)
"

SLOT="0"
# As far, as I tested it on ~amd64 — it don't work after update...
KEYWORDS="-* ~x86"

S="${WORKDIR}"

# Currently — 32bit only, so use it on x86_64 requires multilib...
REQUIRED_USE="amd64? ( multilib )"

src_prepare() {
	# Valve guys forget about trailing semicolons in .desktop
	# and also about [ ] syntax in shell
	sed -r \
		-e "s/(MimeType=.*)/\1;/" \
		-e "s/(Actions=.*)/\1;/" \
		-i "usr/share/applications/steam.desktop"
	sed -r \
		-e 's/(if.*)(\$NEEDSINSTALL)(.*then)/\1-n "\2"\3/' \
		-i "usr/bin/steam"
}

src_install() {
        dobin "usr/bin/steam"
	gzip -d "usr/share/man/man6/steam.6.gz"
	gzip -d "usr/share/doc/steam/changelog.gz"
	doman "usr/share/man/man6/steam.6"
	dodoc "usr/share/doc/steam"/*

	rm -rf	"usr/share/man" \
		"usr/share/doc" \
		"usr/bin" \

        insinto "/usr"
        doins -r "usr"/* || die "Install failed!"
}