#!/bin/sh

set -e

hostname="controller"
router_ip="192.168.1.1"
static_ip="192.168.1.2"
timezone="America/Chicago"
video_mem="16"

main() {
  set_base_config
  update_everything
  install_apps
  set_restartable_config
  start_containers
  success "Complete!"
  info "Reboot by running: sudo reboot -h now"
}

set_base_config() {
  info "Expanding file system"
  out=$(sudo raspi-config nonint do_expand_rootfs)

  info "Setting video memory"
  out=$(sudo raspi-config nonint do_memory_split $video_mem)

  info "Setting timezone"
  out=$(sudo timedatectl set-timezone $timezone)

  info "Setting static IP"
  out=$(echo "interface eth0"                  | sudo cat >> /etc/dhcpcd.conf)
  out=$(echo "static ip_address=$static_ip/24" | sudo cat >> /etc/dhcpcd.conf)
  out=$(echo "static routers=$router_ip"       | sudo cat >> /etc/dhcpcd.conf)
}

update_everything() {
  info "Updating packages"
  out=$(sudo apt-get update && sudo apt-get upgrade -y)
  out=$(sudo apt-get autoremove -y && sudo apt-get autoclean -y)
}

install_apps() {
  info "Installing vim"
  out=$(sudo apt-get install vim -y)

  info "Installing git"
  out=$(sudo apt-get install git -y)

  info "Installing docker"
  out=$(curl -fsSL https://get.docker.com -o get-docker.sh)
  out=$(sudo sh get-docker.sh)
  out=$(sudo usermod -aG docker $USER)
  out=$(newgrp docker)
}

set_restartable_config() {
  info "Setting hostname"
  out=$(sudo raspi-config nonint do_hostname $hostname)

  info "Setting SSH Password"
  sudo passwd pi
}

start_containers() {
  info "Starting pi-hole"
  out=$(mkdir -p ~/pihole)
  docker run -d --init \
    -e WEBPASSWORD="pihole" \
    -e ServerIP=192.168.1.2 \
    -v ~/pihole/etc-pihole:/etc/pihole \
    -v ~/pihole/etc-dnsmasq.d:/etc/dnsmasq.d \
    --cap-add=NET_ADMIN \
    --net=host \
    --dns=127.0.0.1 \
    --dns=1.1.1.1 \
    --restart unless-stopped \
    --name pihole \
    pihole/pihole

  info "Starting unifi"
  out=$(mkdir -p ~/unifi/data && mkdir -p ~/unifi/log)
  docker run -d \
    -e PUID=1000 \
    -e PGID=1000 \
    -e MEM_LIMIT=512M \
    -p 3478:3478/udp \
    -p 10001:10001/udp \
    -p 8080:8080 \
    -p 8081:8081 \
    -p 8443:8443 \
    -p 8843:8843 \
    -p 8880:8880 \
    -p 6789:6789 \
    -v ~/unifi:/config \
    --restart unless-stopped \
    --name unifi \
    linuxserver/unifi-controller
}

ask() {
  printf "\033[0;35m[PROFILE]\033[0m $1 "
}

info() {
  printf "\033[0;36m[PROFILE]\033[0m $1\n"
}

success() {
  printf "\033[0;32m[PROFILE]\033[0m $1\n"
}

main
