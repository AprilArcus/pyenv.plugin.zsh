found_pyenv=''
pyenvdirs=("$HOME/.pyenv" "$HOME/.local/pyenv" "/usr/local/opt/pyenv" "/usr/local/pyenv" "/opt/pyenv")

for pyenvdir in "${pyenvdirs[@]}" ; do
  if [ -z "$found_pyenv" ] && [ -d "$pyenvdir/versions" ]; then
    found_pyenv=true
    if [ -z "$PYENV_ROOT" ]; then
      PYENV_ROOT=$pyenvdir
      export PYENV_ROOT
    fi
    export PATH=${pyenvdir}/bin:$PATH
    eval "$(pyenv init --no-rehash - zsh)"
    if [ -x "$(command -v pyenv-virtualenv-init)" ]; then
      eval "$(pyenv virtualenv-init - zsh)"
    fi

    function current_python() {
      echo "$(pyenv version-name)"
    }

    function pyenv_prompt_info() {
      echo "$(current_python)"
    }
    break
  fi
done
unset pyenvdir

if [ -z "$found_pyenv" ] ; then
  function pyenv_prompt_info() {
    echo "system: $(python -V 2>&1 | cut -f 2 -d ' ')"
  }
fi
