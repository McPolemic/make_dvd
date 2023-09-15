# make_dvd

A simple script to convert a video file into a DVD-compatible ISO image on macOS using `ffmpeg` and `dvdauthor`.

## Prerequisites

- macOS with [Homebrew](https://brew.sh/) installed.

## Usage

1. Ensure the script is executable:

```bash
chmod +x make_dvd
```

2. Run the script with your video file as the argument:

```bash
./make_dvd path_to_your_video.mp4
```

The script will then convert the video, create the DVD structure, generate the ISO image, and clean up any temporary files. The resulting ISO image will be named `dvdimage.iso`.

## Notes

- The script assumes the input video has a 16:9 aspect ratio. Adjust the `-aspect` option in the script if your video uses a different aspect ratio.
