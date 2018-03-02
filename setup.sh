set -e
echo $$ > /tmp/setup.pid

sed -i .bak 's/quarterly/latest/' /etc/pkg/FreeBSD.conf
sed -i .bak -e '/^#.*ASSUME_ALWAYS_YES /s/^#//' -e '/ASSUME_ALWAYS_YES /s/false/true/' /usr/local/etc/pkg.conf
sed -i '.bak' -e 's/^mlxen/mlx4en/' /boot/loader.conf
pkg install tmux vim-console git fzf zsh x86info yasm bash
chsh -s /usr/local/bin/zsh
sh -c $(curl -fsSL "https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh")

echo 'done' > setup.done
