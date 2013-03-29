# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DEPEND="app-misc/path-respect-wrapper"

usr_wrap_bin() {
	mkdir "${T}"/wrap-build || die
	pushd "${T}"/wrap-build >/dev/null || die

	einfo 'Building path-respect-wrappers ...'
	sh /usr/src/path-respect-wrapper/configure -C || die

	local DESTTREE=/

	local app
	for app; do
		cat > app.c <<-EOF
			const char* const real_path = "/usr/bin/${app}";
			const char* const real_name = "/bin/${app}";
		EOF

		emake app
		newbin app ${app}
	done

	popd >/dev/null || die
}
