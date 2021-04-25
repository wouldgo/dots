#!/usr/bin/env zsh

_GVM_RC_FILE="go.mod"
_GO_SYSTEM_VERSION="$(go version  | grep --colour=never -oE '[[:digit:]]+.[[:digit:]]+' | head -n 1)"

if [[ ! -n "${_GO_SYSTEM_VERSION}" ]]; then
  echo "Please install a default version for go with:
    gvm install go<version> -pb -b -B; gvm use go<version> --default"
fi

load-gvmrc() {
  local current_dir="${1:-$(pwd)}"

  if [[ -f "${current_dir}/${_GVM_RC_FILE}" ]]; then
    local go_version="$(grep -oP '^go\W+(.*)$' ${current_dir}/${_GVM_RC_FILE} | sed -e 's/go //')"

    gvm install "go${go_version}" -pb -b -B
    gvm use "go${go_version}"
  elif [[ "${current_dir}" != '/' ]]; then

    load-gvmrc $(dirname ${current_dir})
  else

    gvm use "go${_GO_SYSTEM_VERSION}"
  fi
}
