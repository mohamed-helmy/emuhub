FROM mohamedhelmy/android-docker:34

MAINTAINER Mohamed Helmy <helmy419@gmail.com>

###
# Deskstop/BASE noVNC
###
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=EET \
    HOME=/root \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    WEB_LISTENING_PORT=5800 \
    VNC_LISTENING_PORT=5900

RUN apt-get update && \
    apt-get -yq dist-upgrade && \
    apt-get install -yq --no-install-recommends \
    wget \
    curl \
    bzip2 \
    ca-certificates \
    apt-utils \
    software-properties-common \
    openssl \
    tini \
    pwgen \
    sudo \
    netcat \
    vim-tiny \
    net-tools \
    sed \
    jq \
    npm \
    unzip \
    python3-pip \
    xterm \
    supervisor \
    socat \
    x11vnc \
    openbox \
    feh \
    menu \
    python-numpy \
    net-tools \
    ffmpeg \
    jq \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients\
    virtinst \
    virt-manager \
    bridge-utils \
    build-essential \
    iputils-ping \
    lxde \
    lxde-common \
    xterm \
    xfce4-terminal \
    firefox \
    htop \
    screen


# create an emuhub user
RUN useradd --create-home --shell /bin/bash --user-group emuhub
RUN echo "emuhub:emuhub" | chpasswd
RUN usermod -aG libvirt emuhub
RUN usermod -aG kvm emuhub
RUN usermod -aG sudo emuhub
COPY ./user-configuration/images /home/emuhub/images
COPY ./user-configuration/.config /home/emuhub/.config 
COPY ./user-configuration/.Xauthority /home/emuhub/.Xauthority
COPY ./user-configuration/.bashrc /home/emuhub/.bashrc
RUN touch  /home/emuhub/.sudo_as_admin_successful

# create avd 
COPY emulator-configuration/skins /opt/android-sdk-linux/skins
COPY emulator-configuration/emulator  /home/emuhub/emulator
RUN chmod -R +x /home/emuhub/emulator
RUN chmod -R +777 /home/emuhub/.config
COPY ./user-configuration/Desktop /home/emuhub/Desktop

# Update Android SDK
RUN /opt/android-sdk-linux/cmdline-tools/tools/bin/sdkmanager --update && \
    /opt/android-sdk-linux/cmdline-tools/tools/bin/sdkmanager --install "system-images;android-34;google_apis_playstore;x86_64" && \
    /opt/android-sdk-linux/cmdline-tools/tools/bin/sdkmanager --install "system-images;android-34;google-tv;x86" && \
    /opt/android-sdk-linux/cmdline-tools/tools/bin/sdkmanager --install "system-images;android-33;android-wear;x86_64"


RUN apt-get install -y \
    tigervnc-standalone-server \
    tigervnc-xorg-extension 

ADD config /config

# Build noVNC
ARG NOVNC_VERSION=1.4.0
ARG NOVNC_URL=https://github.com/novnc/noVNC/archive/refs/tags/v${NOVNC_VERSION}.tar.gz
RUN npm install clean-css-cli -g

# packages websockify will need
RUN pip3 install \
    numpy \
    jwcrypto

# Install noVNC
RUN mkdir /noVNC && \
    curl -# -L ${NOVNC_URL} | tar -xz --strip 1 -C /noVNC
COPY config/index.html /noVNC/index.html
COPY config/app/imgs /noVNC/app/imgs

WORKDIR /tmp
# Install websockify
RUN wget https://github.com/novnc/websockify/archive/refs/tags/v0.11.0.tar.gz -O /tmp/websockify.tgz && \
    tar -zxf /tmp/websockify.tgz && \
    rm /tmp/websockify.tgz && \
    cd /tmp/websockify*  && \
    python3 setup.py install

# Set version of CSS and JavaScript file URLs
RUN sed "s/UNIQUE_VERSION/$(date | md5sum | cut -c1-10)/g" -i /noVNC/index.html

EXPOSE 6080

### RDP ###
RUN apt install -y xrdp 
RUN touch /var/log/xrdp-sesman.log && touch /var/log/xrdp.log
RUN chmod +66 /var/log/xrdp-sesman.log 
RUN chmod +66 /var/log/xrdp.log
RUN mkdir /var/run/xrdp
RUN chown xrdp:xrdp /var/run/xrdp
RUN chmod +777 /var/run/xrdp
RUN chown emuhub:emuhub -R /etc/xrdp


EXPOSE 3350
EXPOSE 3389

# remove clipit and deluge packages to get rid of more annoying UI stuff 
RUN apt-get remove -y \
    clipit \
    deluge

RUN /config/cleanup-cruft.sh
### Finish Build
ADD start-vnc.sh /usr/local/bin/start-vnc.sh
ENTRYPOINT ["tini", "--"]
CMD ["/usr/local/bin/start-vnc.sh"]

WORKDIR /home/emuhub
