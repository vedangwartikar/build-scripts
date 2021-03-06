#!/bin/bash
# repo: https://github.com/Netflix/ribbon

export DEBIAN_FRONTEND=noninteractive
WDIR=`pwd`
sudo apt-get update -y
apt-get install -y git ant gradle libjna-java openjdk-8-jdk openjdk-8-jre \
        gcc g++ make automake libffi-dev build-essential locales
sudo cp /usr/share/java/jna.jar /usr/lib/jvm/java-8-openjdk-ppc64el/jre/lib/ext

export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-ppc64el
export PATH=$PATH:$JAVA_HOME/bin
export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"

sudo touch /etc/default/locale && \
    echo "LC_CTYPE=\"en_US.UTF-8\"" | sudo tee -a /etc/default/locale && \
    echo "LC_ALL=\"en_US.UTF-8\"" | sudo tee -a /etc/default/locale && \
    echo "LANG=\"en_US.UTF-8\"" | sudo tee -a /etc/default/locale && \
    sudo locale-gen en_US en_US.UTF-8 && sudo dpkg-reconfigure -f noninteractive locales

cd /tmp && git clone https://github.com/java-native-access/jna && \
    mkdir -p /tmp/jna/build/native-linux-ppc64le/libffi/.libs && \
    cd jna && git checkout 4.1.0 && \
    ln -s /usr/lib/powerpc64le-linux-gnu/libffi.a /tmp/jna/build/native-linux-ppc64le/libffi/.libs/libffi.a && \
    (ant test || true) && (ant test-platform || true) && (ant dist || true)
sudo ln -s /tmp/jna/build/classes/com/sun/jna/linux-ppc64le/libjnidispatch.so /usr/lib/jvm/java-1.8.0-openjdk-ppc64el/jre/lib/ppc64le/libjnidispatch.so

cd $WDIR
git clone https://github.com/Netflix/ribbon
cd ribbon
./gradlew build
