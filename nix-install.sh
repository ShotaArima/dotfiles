if [ "$(uname)" == 'Darwin' ]; then
    echo 'Mac'
    if command -v nix >/dev/null 2>&1; then
        echo "nix is already installed."
    else
        sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
    fi
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    echo 'Linux'
    if command -v nix >/dev/null 2>&1; then
        echo "nix is already installed."
    else
        sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
    fi
else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
fi