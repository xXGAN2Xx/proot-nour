#!/bin/bash
HOME="/home/container"
HOMEA="$HOME/linux/.apt"
STAR1="$HOMEA/lib:$HOMEA/usr/lib:$HOMEA/var/lib:$HOMEA/usr/lib/x86_64-linux-gnu:$HOMEA/lib/x86_64-linux-gnu:$HOMEA/lib:$HOMEA/usr/lib/sudo"
STAR2="$HOMEA/usr/include/x86_64-linux-gnu:$HOMEA/usr/include/x86_64-linux-gnu/bits:$HOMEA/usr/include/x86_64-linux-gnu/gnu"
STAR3="$HOMEA/usr/share/lintian/overrides/:$HOMEA/usr/src/glibc/debian/:$HOMEA/usr/src/glibc/debian/debhelper.in:$HOMEA/usr/lib/mono"
STAR4="$HOMEA/usr/src/glibc/debian/control.in:$HOMEA/usr/lib/x86_64-linux-gnu/libcanberra-0.30:$HOMEA/usr/lib/x86_64-linux-gnu/libgtk2.0-0"
STAR5="$HOMEA/usr/lib/x86_64-linux-gnu/gtk-2.0/modules:$HOMEA/usr/lib/x86_64-linux-gnu/gtk-2.0/2.10.0/immodules:$HOMEA/usr/lib/x86_64-linux-gnu/gtk-2.0/2.10.0/printbackends"
STAR6="$HOMEA/usr/lib/x86_64-linux-gnu/samba/:$HOMEA/usr/lib/x86_64-linux-gnu/pulseaudio:$HOMEA/usr/lib/x86_64-linux-gnu/blas:$HOMEA/usr/lib/x86_64-linux-gnu/blis-serial"
STAR7="$HOMEA/usr/lib/x86_64-linux-gnu/blis-openmp:$HOMEA/usr/lib/x86_64-linux-gnu/atlas:$HOMEA/usr/lib/x86_64-linux-gnu/tracker-miners-2.0:$HOMEA/usr/lib/x86_64-linux-gnu/tracker-2.0:$HOMEA/usr/lib/x86_64-linux-gnu/lapack:$HOMEA/usr/lib/x86_64-linux-gnu/gedit"
STARALL="$STAR1:$STAR2:$STAR3:$STAR4:$STAR5:$STAR6:$STAR7"
export LD_LIBRARY_PATH=$STARALL
export PATH="/bin:/usr/bin:/usr/local/bin:/sbin:$HOMEA/bin:$HOMEA/usr/bin:$HOMEA/sbin:$HOMEA/usr/sbin:$HOMEA/etc/init.d:$PATH"
export BUILD_DIR=$HOMEA

bold=$(echo -en "\e[1m")
nc=$(echo -en "\e[0m")
lightblue=$(echo -en "\e[94m")
lightgreen=$(echo -en "\e[92m")

echo "
${bold}${lightgreen}========================================================================
                                                                                                  
${bold}${lightblue}@@@@@@@   @@@@@@@  @@@@@@@@  @@@@@@@    @@@@@@      @@@  @@@  @@@@@@@@@@
${bold}${lightblue}@@@@@@@@  @@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@     @@@  @@@  @@@@@@@@@@@    
${bold}${lightblue}@@!  @@@    @@!    @@!       @@!  @@@  @@!  @@@     @@!  @@@  @@! @@! @@!    
${bold}${lightblue}!@!  @!@    !@!    !@!       !@!  @!@  !@!  @!@     !@!  @!@  !@! !@! !@!     
${bold}${lightblue}@!@@!@!     @!!    @!!!:!    @!@!!@!   @!@  !@!     @!@  !@!  @!! !!@ @!@      
${bold}${lightblue}!!@!!!      !!!    !!!!!:    !!@!@!    !@!  !!!     !@!  !!!  !@!   ! !@!        
${bold}${lightblue}!!:         !!:    !!:       !!: :!!   !!:  !!!     :!:  !!:  !!:     !!:        
${bold}${lightblue}:!:         :!:    :!:       :!:  !:!  :!:  !:!      ::!!:!   :!:     :!:            
${bold}${lightblue} ::          ::     :: ::::  ::   :::  ::::: ::       ::::    :::     ::        
${bold}${lightblue} :           :     : :: ::    :   : :   : :  :         :       :      :          
                                                                                                  
                                                                                                                
${bold}${lightgreen}========================================================================
 "
 
echo "${nc}"

if [[ -f "./installed" ]]; then
    echo "${bold}${lightgreen}==> Started ${lightblue}Container${lightgreen} <=="
    function runcmd1 {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        ./proot -S . /bin/bash -c "$cmdtorun"
        runcmd
    }
    function runcmd {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        ./proot -S . /bin/bash -c "$cmdtorun"
        runcmd1
    }
    runcmd
else
    echo "Downloading files for application"
    curl -sSLo proot https://github.com/xXGAN2Xx/proot-nour/raw/main/proot >/dev/null 2>err.log
    curl -sSLo root.tar.gz https://gitlab.com/openbsd98324/debian-rootfs/-/raw/main/content/1640716280-1-linux-rootfs-sid-bookworm-debootstrap-5.14.0-4-arm64-cln-nokern-2021.tar.gz?ref_type=heads&inline=false >/dev/null 2>err.log
    export PATH="/bin:/usr/bin:/usr/local/bin:/sbin:$HOMEA/bin:$HOMEA/usr/bin:$HOMEA/sbin:$HOMEA/usr/sbin:$HOMEA/etc/init.d:$PATH"
    tar -xf root.tar.gz >/dev/null 2>err.log
    chmod +x ./proot >/dev/null 2>err.log
    rm -rf root.tar.gz >/dev/null 2>err.log

    cmds=("apt-get update" "apt-get -y upgrade" "apt-get -y install sudo curl wget hwloc htop nano neofetch python3" "curl -o /bin/systemctl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py")

    for cmd in "${cmds[@]}"; do
        ./proot -S . /bin/bash -c "$cmd >/dev/null 2>err.log"
    done
    echo -ne '####################(100%)\r'
    echo -ne '\n'
    touch installed
    
    echo "
${bold}${lightgreen}========================================================================
                                                                                                  
${bold}${lightblue}@@@@@@@   @@@@@@@  @@@@@@@@  @@@@@@@    @@@@@@      @@@  @@@  @@@@@@@@@@
${bold}${lightblue}@@@@@@@@  @@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@     @@@  @@@  @@@@@@@@@@@    
${bold}${lightblue}@@!  @@@    @@!    @@!       @@!  @@@  @@!  @@@     @@!  @@@  @@! @@! @@!    
${bold}${lightblue}!@!  @!@    !@!    !@!       !@!  @!@  !@!  @!@     !@!  @!@  !@! !@! !@!     
${bold}${lightblue}@!@@!@!     @!!    @!!!:!    @!@!!@!   @!@  !@!     @!@  !@!  @!! !!@ @!@      
${bold}${lightblue}!!@!!!      !!!    !!!!!:    !!@!@!    !@!  !!!     !@!  !!!  !@!   ! !@!        
${bold}${lightblue}!!:         !!:    !!:       !!: :!!   !!:  !!!     :!:  !!:  !!:     !!:        
${bold}${lightblue}:!:         :!:    :!:       :!:  !:!  :!:  !:!      ::!!:!   :!:     :!:            
${bold}${lightblue} ::          ::     :: ::::  ::   :::  ::::: ::       ::::    :::     ::        
${bold}${lightblue} :           :     : :: ::    :   : :   : :  :         :       :      :          
                                                                                                  
                                                                                                                
${bold}${lightgreen}========================================================================
 "
 
echo "${nc}"
    
    echo "${bold}${lightgreen}==> Started ${lightblue}Container${lightgreen} <=="
    function runcmd1 {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        ./proot -S . /bin/bash -c "$cmdtorun"
        runcmd
    }
    function runcmd {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        ./proot -S . /bin/bash -c "$cmdtorun"
        runcmd1
    }
    runcmd
fi
