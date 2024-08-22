#!/bin/bash

echo "Script By zendy"
echo "This script will install LXDE or Fluxbox and set up ngrok for tunnel and access it using VNC viewer."

# Function to install LXDE
install_lxde() {
    apt update
    apt install lxde x11vnc xvfb wget -y
}

# Function to install Fluxbox
install_fluxbox() {
    apt update
    apt install fluxbox x11vnc xvfb wget -y
}

# Main script
echo "Choose desktop environment to install:"
echo "1. LXDE"
echo "2. Fluxbox"
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        install_lxde
        start_command="startlxde"
        ;;
    2)
        install_fluxbox
        start_command="startfluxbox"
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Download and setup ngrok
echo "Downloading ngrok..."
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar xf ngrok*
rm ngrok-*

# Set ngrok auth token
read -p "Enter your ngrok auth token: " authtoken
./ngrok authtoken $authtoken

# Set custom ngrok port
read -p "Enter custom ngrok port (default 23): " ngrok_port
nohup ./ngrok tcp ${ngrok_port:-23} &

# Export display and start Xvfb and VNC
export DISPLAY=:1
Xvfb $DISPLAY -screen 0 1024x768x16 &
$start_command &

x11vnc -display $DISPLAY -bg -forever -nopw -quiet -listen localhost -xkb -rfbport ${ngrok_port:-23}