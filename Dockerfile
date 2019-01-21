# Pull base image.
FROM node:10

LABEL Description="Node LTS with react-native for Android"

# ——————————
# Installs i386 architecture required for running 32 bit Android tools
# and base software packages
# ——————————
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 \
    openjdk-8-jdk unzip && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ——————————
# Installs Android SDK
# ——————————

ENV ANDROID_HOME /opt/android-sdk
ENV PATH ${PATH}:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

RUN cd /opt && \
    wget --output-document=android-sdk.zip --quiet https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
    unzip android-sdk.zip -d android-sdk && \
    rm android-sdk.zip && \
    mkdir -p "$ANDROID_HOME/licenses" && \
    echo -e "\nd56f5187479451eabf01fb78af6dfcb131a6481e\n24333f8a63b6825ea9c5514f83c2829b004d1fee" > "$ANDROID_HOME/licenses/android-sdk-license" && \
    echo -e "\n601085b94cd77f0b54ff86406957099ebe79c4d6" > "$ANDROID_HOME/licenses/android-googletv-license" && \
    echo -e "\n33b6a2b64607f11b759f320ef9dff4ae5c47d97a" > "$ANDROID_HOME/licenses/google-gdk-license" && \
    echo -e "\ne9acab5b5fbb560a72cfaecce8946896ff6aab9d" > "$ANDROID_HOME/licenses/mips-android-sysimage-license" && \
    sdkmanager --verbose tools platform-tools \
        "platforms;android-27" \
        "build-tools;27.0.3" \
        "extras;android;m2repository" "extras;google;m2repository" \        
        "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2"
        #"platforms;android-23" "platforms;android-26" \
        #"build-tools;23.0.1" "build-tools;26.0.1" \
        #"extras;google;google_play_services" \

# ——————————
# Installs Gradle
# ——————————

# Gradle
#ENV GRADLE_VERSION 4.4
#
#RUN cd /usr/lib \
# && curl -fl https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle-bin.zip \
# && unzip "gradle-bin.zip" \
# && ln -s "/usr/lib/gradle-${GRADLE_VERSION}/bin/gradle" /usr/bin/gradle \
# && rm "gradle-bin.zip"
#
## Set Appropriate Environmental Variables
ENV GRADLE_HOME /usr/lib/gradle
ENV PATH $PATH:$GRADLE_HOME/bin

# ——————————
# Install React-Native package
# ——————————
RUN npm install --global react-native-cli && npm cache clean --force

ENV LANG en_US.UTF-8

# ——————————
# Install udev rules for most android devices
# ——————————
#RUN mkdir -p /etc/udev/rules.d/ && \
#    cd /etc/udev/rules.d/ && \
#    wget https://raw.githubusercontent.com/M0Rf30/android-udev-rules/master/51-android.rules
