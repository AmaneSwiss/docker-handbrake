# Docker container for HandBrake <br> → with full hardware support ←
[![Release](https://img.shields.io/github/release/amaneswiss/docker-handbrake.svg?logo=github&style=for-the-badge)](https://github.com/amaneswiss/docker-handbrake/releases/latest)
[![Docker Size](https://img.shields.io/docker/image-size/amaneswiss/handbrake/latest?logo=docker&style=for-the-badge)](https://hub.docker.com/r/amaneswiss/handbrake/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/amaneswiss/handbrake?label=Pulls&logo=docker&style=for-the-badge)](https://hub.docker.com/r/amaneswiss/handbrake)
[![Docker Stars](https://img.shields.io/docker/stars/amaneswiss/handbrake?label=Stars&logo=docker&style=for-the-badge)](https://hub.docker.com/r/amaneswiss/handbrake)
[![Build Status](https://img.shields.io/github/actions/workflow/status/amaneswiss/docker-handbrake/Build-and-Check.yml?logo=github&branch=main&style=for-the-badge)](https://github.com/amaneswiss/docker-handbrake/actions/workflows/Build-and-Check.yml)
---

[![HandBrake logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/handbrake-icon.png&w=110)](https://handbrake.fr)[![HandBrake](https://images.placeholders.dev/?width=288&height=110&fontFamily=monospace&fontWeight=400&fontSize=52&text=HandBrake&bgColor=rgba(0,0,0,0.0)&textColor=rgba(121,121,121,1))](https://handbrake.fr)

HandBrake is a tool for converting video from nearly any format to a selection
of modern, widely supported codecs.

---

This project provides Docker container for
[HandBrake](https://handbrake.fr).

Built with support for:
- AMD VCN
- Intel QuickSync
- **Nvidia NVEnc**
- fdk-aac
- **x265**

This repository is a fork of
[jlesage/docker-handbrake](https://github.com/jlesage/docker-handbrake).
Compared to the original image, this fork is built with full hardware support.
To achieve this, an Ubuntu-based image is used.

## Fork details and configuration reference

This image focuses on broad hardware support and keeps the same application-side
configuration model as the upstream project.

For all application-related configuration options, variables, and behavior,
refer to the upstream documentation:

- [Upstream README](https://github.com/jlesage/docker-handbrake#readme)

Use this repository for image-specific differences, build details, and support
of this fork.

## What this fork adds

- Built-in healthcheck support, so the container can be used together with
  [autoheal](https://hub.docker.com/r/willfarrell/autoheal).
- Locale packages are included, allowing custom language settings via `LANG`
  (for example: `de_DE.UTF-8`).
- Conversion logging can be kept quiet by setting:
  - `LOGGING_AUTOMATIC_CONVERSIONS: false`
    - `/config/log/hb/conversion.log`
  - `LOGGING_IGNORED_CONVERSIONS: false`
    - `config/ignored_conversions`
  - `LOGGING_FAILED_CONVERSIONS: false`
    - `/config/failed_conversions`
  - `LOGGING_SUCCESSFUL_CONVERSIONS: false`
    - `/config/successful_conversions`

---

## Quick Start

> [!IMPORTANT]
> The Docker command provided in this quick start is an example, and parameters
> should be adjusted to suit your needs.

Launch the HandBrake docker container with the following command:

```shell
# Example
docker run -d \
    --name=handbrake \
    -p 5800:5800 \
    -v /:/storage:ro \
    -v /opt/handbrake/config:/config:rw \
    -v /opt/handbrake/watch:/watch:rw \
    -v /opt/handbrake/output:/output:rw \
    amaneswiss/handbrake
```

Where:
  - `/config` : Stores the application's configuration, state, logs, and any files requiring persistency.
  - `/storage`: Path of dirs and files from the host that need to be accessible to the application.
  - `/watch`  : The location for videos to be automatically converted.
  - `/output` : The destination for converted video files.

Access the HandBrake GUI by browsing to `http://your-host-ip:5800`.
Files from the host appear under the `/storage` folder in the container.

## Docker Compose File

Below is an example `docker-compose.yml` file for use with
[Docker Compose](https://docs.docker.com/compose/overview/).

Adjust the configuration to suit your needs. Only mandatory settings are
included in this example.

For the complete list of application-side environment variables and detailed
behavior, use the upstream documentation:
[jlesage/docker-handbrake](https://github.com/jlesage/docker-handbrake#readme).

```yaml
services:
  handbrake:
    container_name: handbrake
    hostname: handbrake
    image: amaneswiss/handbrake:latest
    restart: unless-stopped
    network_mode: bridge
    mem_limit: 6g

    # # For Nvidia GPU
    # deploy:
    #   resources:
    #     reservations:
    #       devices:
    #         - driver: nvidia
    #           count: all
    #           capabilities:
    #             - gpu
    #             - compute
    #             - video
    #             - utility

    # For autoheal (healthcheck included)
    labels:
      autoheal: true

    environment:
      USER_ID: 1000
      GROUP_ID: 1000
      UMASK: 0002
      # LANG: de_DE.UTF-8
      # LANGUAGE: de_DE:de
      # TZ: Europe/Berlin
      APP_NICENESS: 0
      DISPLAY_WIDTH: 1280
      DISPLAY_HEIGHT: 768
      DARK_MODE: 1
      HANDBRAKE_GUI: 1
      HANDBRAKE_GUI_QUEUE_STARTUP_ACTION: NONE
      AUTOMATED_CONVERSION: 1
      AUTOMATED_CONVERSION_CHECK_INTERVAL: 5
      AUTOMATED_CONVERSION_FORMAT: mp4
      AUTOMATED_CONVERSION_KEEP_SOURCE: 0
      AUTOMATED_CONVERSION_WATCH_DIR: /watch
      AUTOMATED_CONVERSION_MAX_WATCH_FOLDERS: 1
      AUTOMATED_CONVERSION_OUTPUT_DIR: /output
      AUTOMATED_CONVERSION_OVERWRITE_OUTPUT: 1
      AUTOMATED_CONVERSION_TRASH_DIR: /trash
      AUTOMATED_CONVERSION_USE_TRASH: 1
      AUTOMATED_CONVERSION_NON_VIDEO_FILE_ACTION: ignore
      AUTOMATED_CONVERSION_NON_VIDEO_FILE_EXTENSIONS: "jpg jpeg bmp png gif txt nfo rar zip 7z mp4"
      AUTOMATED_CONVERSION_NO_GUI_PROGRESS: 0
      AUTOMATED_CONVERSION_PRESET: "Hardware/H.265 NVENC 1080p"
      AUTOMATED_CONVERSION_SOURCE_MAIN_TITLE_DETECTION: 0
      AUTOMATED_CONVERSION_SOURCE_MIN_DURATION: 300
      AUTOMATED_CONVERSION_SOURCE_STABLE_TIME: 5
      NVIDIA_DRIVER_CAPABILITIES: all
      NVIDIA_VISIBLE_DEVICES: all
      SECURE_CONNECTION: 0
      SECURE_CONNECTION_VNC_METHOD: SSL
      SECURE_CONNECTION_CERTS_CHECK_INTERVAL: 60
      WEB_AUTHENTICATION: 0
      WEB_LISTENING_PORT: 5800
      VNC_LISTENING_PORT: 5900
      LOGGING_AUTOMATIC_CONVERSIONS: true
      LOGGING_IGNORED_CONVERSIONS: true
      LOGGING_FAILED_CONVERSIONS: true
      LOGGING_SUCCESSFUL_CONVERSIONS: true
    volumes:
      - /:/storage:ro
      #- /mnt:/mnt:ro
      - /opt/handbrake/config:/config:rw
      - /opt/handbrake/watch:/watch:rw
      - /opt/handbrake/output:/output:rw
      - /opt/handbrake/trash:/trash:rw
    ports:
      - 5800:5800
      #- 5900:5900
```

## Support or Contact

Having troubles with the container or have questions? Please
[create a new issue](https://github.com/amaneswiss/docker-handbrake/issues).
