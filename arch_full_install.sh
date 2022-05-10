# instalación de archlinux en sistema UEFI
bootear desde la ISO -- tener en cuenta desactivar secure_boot

# teclado en español
loadkeys es

# crear particiones en disco
cfdisk /dev/disco

1 - particion 512M - Linux
2 - particion 250G - Linux
3 - particion 4G   - swap

## formato a las particiones
1 - mkfs.vfat -F 32 /dev/sda1
2 - mkfs.ext4 /dev/sda2
3 - mkswap /dev/sda3 
	swapon

## montamos las particiones
mount /dev/sda2 /mnt
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

# instalando paquetes base
pacstrap /mnt linux linux-firmware networkmanager grub wpa_supplicant base base-devel

# creando el fstab
genfstab -U /mnt > /mnt/etc/fstab

# creacion de usuarios
arch-chroot /mnt
passwd --> password para root

useradd -m pgraffigna
passwd pgraffigna
usermod -aG wheel pgraffigna

## dependencias
pacman -S nano vim sudo

## editar /etc/sudoers
editar linea %wheel

# editar /etc/locale.gen
descomentar en_US, es_ES
locale-gen

# teclado en español
editar /etc/vconsole.conf
KEYMAP=es

# grub install
pacman -S efibootmgr
grub-install /dev/sda
grub-mkdconfig -o /boot/efi/grub/grub.cfg

# hostname + hosts
echo 'nombre_equipo' > /etc/hostname

nano /etc/hosts
127.0.0.1 localhost
::1 	  localhost
127.0.0.1 nombre_equipo.localhost nombre_equipo


# reiniciando
reboot

--------------

# habilitar conexion a internet
systemctl enable NetworkManager.service --now
systemctl enable wpa_supplicant.service --now

# repos 
pacman -S git
mkdir /home/pgraffigna/repos && cd repos

# agregando repo aur
git clone https://aur.archlinux.org/paru-bin.git && cd paru-bin
makepkg -si

# agregando repo blackarch
cd ../repos && mkdir blackarch && cd blackarch
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
sudo ./strap.sh

# habilitando la interfaz grafica
pacman -S xorg xorg-server gnome
systemctl enable gdm.service --now

# kitty
pacman -S kitty

# awesome
## github.com/rxyhn/dotfiles
paru -S awesome-git

paru -Sy picom-git alacritty todo-bin papirus-icon-theme acpi acpid \
acpi_call wireless_tools jq inotify-tools polkit-gnome xdotool xclip \
brightnessctl alsa-utils alsa-tools pulseaudio pulseaudio-alsa scrot \
redshift mpd mpc mpdris2 ncmpcpp playerctl rofi ffmpeg bluez-utils gpick --needed 

## awesome fonts
cd /usr/share/fonts

# iosevka
wget http://fontlot.com/downfile/5baeb08d06494fc84dbe36210f6f0ad5.105610
mv 5baeb08d06494fc84dbe36210f6f0ad5.105610 comprimido.zip
unzip comprimido.zip
rm comprimido.zip

find . | grep '.ttf$' | while read line; do cp $line .; done
rm -r iosevka-2.2.1/
rm -r iosevka-slab-2.2.1/

# icommon
descargar --> https://www.dropbox.com/s/hrkub2yo9iapljz/icomoon.zip?dl=0
mv /home/pgraffigna/Descargas/icomoon.zip .
unzip icomoon.zip
mv icomoon/*.ttf .
rm -rf icomoon/

# fuentes varias
paru -S nerd-fonts-jetbrains-mono ttf-font-awesome ttf-font-awesome-4 ttf-material-design-icons

# config
git clone https://github.com/rxyhn/dotfiles.git && cd dotfiles

mkdir /home/pgraffigna/.local/bin
cp -r config/* ~/.config/
cp -r bin/* ~/.local/bin/
cp -r misc/. ~/

reboot 

-----------

# volver a version anterior de awesome
cd /home/pgraffigna/repos/dotfiles
git checkout $(git log | grep 'commit c1e' | awk NF '{print $NF}')

cp -r config/* /home/pgraffigna/.config/
cp -r bin/* /home/pgraffigna/.local/bin
cp -r misc/ /home/pgraffigna

reboot 

-------------

## zsh
pacman -S zsh lsd bat
usermod --shell /usr/bin/zsh pgraffigna
localectl set-x11-keymap es

# zsh config
https://github.com/pgraffigna/notas_arch_install/blob/master/zshrc en ~/.zshrc

# instalando plugins
paru -S zsh-syntax-highlighting zsh-autosuggestions

cd /usr/share
mkdir zsh-sudo
chown -R pgraffigna:pgraffigna zsh-sudo
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh

# mas fuentes
cd /usr/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip 
unzip Hack.zip
rm Hack.zip

# config kitty
https://github.com/pgraffigna/notas_arch_install/blob/master/kitty.conf en /home/pgraffigna/.config/kitty/kitty.conf
https://github.com/pgraffigna/notas_arch_install/blob/master/color.ini en /home/pgraffigna/.config/kitty/color.ini

# picom
https://github.com/pgraffigna/notas_arch_install/blob/master/picom.conf en /home/pgraffigna/.config/awesome/theme/picom.conf

# fondo de pantalla
pacman -S feh
https://github.com/pgraffigna/notas_arch_install/blob/master/rc.lua en /home/pgraffigna/.config/awesome/rc.lua

# powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

zsh --> para configurar el p10k

# powerlevel10k root
sudo -i
ln -s -f /home/pgraffigna/.zshrc /root/.zshrc
usermod --shell /usr/bin/zsh root
## configurar p10k para root

# configurar icono awesome
cd ~/.config/awesome/theme/assets/icons
mv ~/Descargas/nuevo_icono.png awesome.png
 
