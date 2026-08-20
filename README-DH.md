## HandBrake | [Github](https://github.com/AmaneSwiss/docker-handbrake)

- With healthcheck -> [autoheal](https://hub.docker.com/r/willfarrell/autoheal)
- Add locales for $LANG env. like de_DE.UTF-8
- Set logging conversations off with:
  - `LOGGING_AUTOMATIC_CONVERSIONS: false`
    - `/config/log/hb/conversion.log`
  - `LOGGING_IGNORED_CONVERSIONS: false`
    - `config/ignored_conversions`
  - `LOGGING_FAILED_CONVERSIONS: false`
    - `/config/failed_conversions`
  - `LOGGING_SUCCESSFUL_CONVERSIONS: false`
    - `/config/successful_conversions`

##

### Built with support for:
- Intel QuickSync
- **Nvidia NVEnc**
- AMD VCN
- fdk-aac
- **x265**

##

### Docker Run:

```bash
docker run -d \
    --name=handbrake \
    -p 5800:5800 \
    -v /:/storage:ro \
    -v /opt/handbrake/config:/config:rw \
    -v /opt/handbrake/watch:/watch:rw \
    -v /opt/handbrake/output:/output:rw \
    amaneswiss/handbrake
```

##

### Docker Compose:
```yaml
---

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
