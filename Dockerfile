# 使用最新的 jenkins/jenkins 镜像作为基础镜像
FROM jenkins/jenkins:2.440.1-jdk11

# 切换为 root 用户，以便安装软件
USER root

# 安装Android SDK依赖的系统库
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# 设置Android SDK环境变量
ENV ANDROID_HOME /opt/android-sdk
ENV PATH $PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# 下载和解压Android命令行工具
ENV ANDROID_SDK_ZIP commandlinetools-linux-11076708_latest.zip
ENV ANDROID_SDK_ZIP_URL https://dl.google.com/android/repository/$ANDROID_SDK_ZIP

RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    curl -o cmdline-tools.zip $ANDROID_SDK_ZIP_URL && \
    unzip cmdline-tools.zip -d ${ANDROID_HOME}/cmdline-tools/tmp && \
    mv ${ANDROID_HOME}/cmdline-tools/tmp/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm -rf cmdline-tools.zip ${ANDROID_HOME}/cmdline-tools/tmp


# 安装所需的Android SDK平台工具和构建工具
RUN yes | sdkmanager --licenses && \
    sdkmanager \
    "platform-tools" \
    "build-tools;33.0.1" \
    "build-tools;32.0.0" \
    "platforms;android-33" \
    "platforms;android-32" 

# 返回到jenkins用户
USER jenkins
