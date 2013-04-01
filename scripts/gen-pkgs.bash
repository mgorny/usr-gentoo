#!/usr/bin/env bash

warn() {
	echo "${@}" >&2
}

die() {
	echo "${@}" >&2
	exit 1
}

main() {
	printf "\033[1mLooking for repositories ...\033[0m\n" >&2

	if ! gentoopmq --version &>/dev/null; then
		die 'gentoopmq required (app-portage/gentoopm)!'
	fi

	local gx86_root repo_root

	if ! gx86_root=$(gentoopmq repo-path gentoo); then
		die 'Unable to find gentoo repository (portage tree).'
	fi
	if ! repo_root=$(gentoopmq repo-path usr-gentoo); then
		die 'Unable to find usr-gentoo repository (self).'
	fi

	local log_file=${repo_root}/scripts/update-patch.log
	exec 3>${log_file}

	local out_file=${repo_root}/scripts/update.log
	local out_file_old=${out_file}~
	if [[ -f ${out_file} ]]; then
		mv "${out_file}" "${out_file_old}" || die 'log rotation failed.'
	fi
	exec 2> >(tee "${out_file}" >&2)

	umask 022
	cd "${repo_root}" || die 'cd repo-root failed.'
	local x
	for x in */*.patch; do
		local p=${x%.patch}

		local gx86_path=${gx86_root}/${p}
		local repo_path=${repo_root}/${p}
		local patch_path=${repo_root}/${p}.patch

		if [[ ! -d ${gx86_path} ]]; then
			warn "Package ${p} not found in gx86."
			continue
		fi

		printf "\033[1m${p}\033[0m\n" >&2
		echo "*** ${p} ***" >&3

		rm -rf "${repo_path}"
		cp -r "${gx86_path}" "${repo_path}" || die "cp ${p} failed."

		cd "${repo_path}" || die "cd ${p} failed."
		local e
		for e in *.ebuild; do
			printf '%s' "- ${e}" >&2
			if ! patch --no-backup-if-mismatch -r - \
					"${e}" "${patch_path}" >&3; then
				printf ': \033[31mFAIL\033[0m\n' >&2
				rm -f "${e}"
			else
				printf ': \033[32mOK\033[0m\n' >&2
			fi
		done
	done

	printf '\n\033[1mUpdating Manifests ...\033[0m\n' >&2

	cd "${repo_root}" || die 'cd repo-root failed.'
	repoman manifest

	if [[ -f ${out_file_old} ]]; then
		printf '\n\033[1mDiffing ...\033[0m\n' >&2
		diff -dup "${out_file_old}" "${out_file}"
	fi
}

main "${@}"
