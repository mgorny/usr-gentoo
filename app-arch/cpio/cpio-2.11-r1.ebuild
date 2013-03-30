# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/cpio/cpio-2.11-r1.ebuild,v 1.2 2013/02/17 20:32:53 zmedico Exp $

EAPI="4"

inherit eutils usr-gentoo

DESCRIPTION="A file archival tool which can also read and write tar files"
HOMEPAGE="http://www.gnu.org/software/cpio/cpio.html"
SRC_URI="mirror://gnu/cpio/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~arm-linux ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls"

src_prepare() {
	epatch "${FILESDIR}"/${P}-stat.patch #328531
	epatch "${FILESDIR}"/${P}-no-gets.patch #424974
	epatch "${FILESDIR}"/${P}-non-gnu-compilers.patch #275295
}

src_configure() {
	econf \
		$(use_enable nls) \
		--with-rmt="${EPREFIX}"/usr/sbin/rmt
}

src_install() {
	default
	rm "${ED}"/usr/share/man/man1/mt.1 || die
	rmdir "${ED}"/usr/libexec || die

	usr_wrap_bin cpio
}