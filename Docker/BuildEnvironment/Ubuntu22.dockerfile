# This Dockerfile provides an environment for building GameNetworkingSockets for Linux and Android.

# This is an intermediate image to download required files without polluting base image.
FROM public.ecr.aws/docker/library/ubuntu:22.04 AS download

# Use bash shell and `/app` working directory as a best practice.
WORKDIR /app
SHELL [ "/bin/bash", "-c" ]

# Install required packages.
RUN apt update \
  && apt upgrade --assume-yes \
  && apt install --assume-yes wget curl zip tar unzip ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Download and unzip Android NDK.
RUN wget --no-verbose https://dl.google.com/android/repository/android-ndk-r28b-linux.zip \
  && echo "Android NDK archive hash:" > android-ndk-version-info.txt \
  && sha256sum android-ndk-r28b-linux.zip >> android-ndk-version-info.txt \
  && cat android-ndk-version-info.txt \
  && unzip android-ndk-r28b-linux.zip \
  && rm ./android-ndk-r28b-linux.zip

# This is a base image for both intermediate and build environment images.
FROM public.ecr.aws/docker/library/ubuntu:22.04 AS base

# Use bash shell and `/app` working directory as a best practice.
WORKDIR /app
SHELL [ "/bin/bash", "-c" ]

# Install required packages.
RUN apt update \
  && apt upgrade --assume-yes \
  && apt install --assume-yes build-essential cmake git wget curl zip vim pkg-config tar autoconf ninja-build cmake unzip ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Copy Android NDK and setup required environment variables.
COPY --from=download /app/android-ndk-r28b ./android-ndk
COPY --from=download /app/android-ndk-version-info.txt .

ENV ANDROID_NDK_HOME=/app/android-ndk

# Install vcpkg by cloning it's git repository.
# Note: this is intentionally not a shallow clone.
# Shallow clone may cause errors while executing vcpkg commands.
RUN git clone https://github.com/microsoft/vcpkg \
  && ./vcpkg/bootstrap-vcpkg.sh

ENV VCPKG_ROOT=/app/vcpkg
ENV PATH=$VCPKG_ROOT:$PATH

# Setup vcpkg cache.
RUN mkdir vcpkg-binary-cache
ENV VCPKG_BINARY_SOURCES="clear;files,/app/vcpkg-binary-cache,readwrite"

# This is an intermediate image for building and caching without polluting build environment image.
FROM base AS intermediate

# Build packages to cache binary objects and reduce build time.
# TODO Add libsodium (it is not compiling for some reason).
RUN mkdir vcpkg-cache-packages \
  && cd vcpkg-cache-packages \
  && vcpkg new --application \
  && vcpkg add port protobuf openssl abseil \
  && vcpkg install --triplet x64-linux \
  && vcpkg install --triplet arm64-android

# This is a build environment image for building GameNetworkingSockets.
FROM base AS gns-ubuntu-22-build-environment

# Copy vcpkg cache from intermediate image.
COPY --from=intermediate /app/vcpkg-binary-cache /app/vcpkg-binary-cache
