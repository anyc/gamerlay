# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/openni-sensors/openni-sensors-9999.ebuild,v 1.2 2011/10/31 11:45:12 frostwork Exp $

EAPI=4

inherit eutils git-2 multilib

MY_PN="Sensor"
DESCRIPTION="PrimeSensor Modules for OpenNI"
HOMEPAGE="https://github.com/PrimeSense/${MY_PN}"
EGIT_REPO_URI="git://github.com/PrimeSense/${MY_PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc graphviz"

DEPEND="media-libs/openni
	graphviz? ( media-gfx/graphviz )
	doc? ( app-doc/doxygen )"
RDEPEND="${DEPEND}"

src_prepare() {
	if use !doc; then
	sed -i -e "s:execute_check(\"doxygen:#execute_check(\"doxygen:g" -i Platform/Linux-x86/CreateRedist/Redist_OpenNi.py
	fi
}

src_compile() {
	cd ${WORKDIR}/${P}/Platform/Linux-x86/Build
#	parallel build fails as lOpenNI is references before it exists
	emake -j1 redist || die "emake failed"
}

src_install() {
	cd ${WORKDIR}/${P}/Platform/Linux-x86/Redist
	
	libdir=$(get_libdir)
	dodir /usr/${libdir}
	insinto /usr/${libdir}
	doins Lib/*.so || die
	
	etcdir=/etc/primesense
	dodir ${etcdir}
	insinto ${etcdir}
	doins Config/GlobalDefaults.ini || die

	insinto /usr/bin/
	exeinto /usr/bin/
	doexe Bin/* || die
	
	serverlogdir=/var/log/primesense/XnSensorServer
	dodir ${serverlogdir}
	chmod a+w ${serverlogdir}
	
	insinto /etc/udev/rules.d
	doins Install/55-primesense-usb.rules || die
}

pkg_postinst() {
	chown root /usr/bin/XnSensorServer
	chmod +s /usr/bin/XnSensorServer
	MODULES="libXnDeviceSensorV2.so libXnDeviceFile.so"
	for module in $MODULES; do
		printf "registering module '$module'..."
		/usr/bin/niReg -r /usr/lib/$module
		printf "OK\n"
	done
}
