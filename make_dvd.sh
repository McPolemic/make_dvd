#!/bin/bash

# Check if the input argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_video>"
    exit 1
fi

INPUT_VIDEO="$1"
TEMP_FOLDER="temp_dvd_folder"
OUTPUT_MPG="${TEMP_FOLDER}/output.mpg"
DVD_FOLDER="${TEMP_FOLDER}/DVD"
DVD_XML="${TEMP_FOLDER}/dvd.xml"
ISO_IMAGE="dvdimage.iso"

# Ensure ffmpeg and dvdauthor are installed using Homebrew
if ! brew list ffmpeg &>/dev/null; then
    echo "### ffmpeg is not installed. Installing..."
    brew install ffmpeg
fi

if ! brew list dvdauthor &>/dev/null; then
    echo "### dvdauthor is not installed. Installing..."
    brew install dvdauthor
fi

# Create a temporary folder for intermediate files
mkdir -p "${TEMP_FOLDER}"

# Convert the video using ffmpeg
echo "### Converting video to DVD-compatible format..."
ffmpeg -i "${INPUT_VIDEO}" -target ntsc-dvd -aspect 16:9 "${OUTPUT_MPG}"

# Create the DVD XML configuration
cat > "${DVD_XML}" <<EOL
<dvdauthor dest="${DVD_FOLDER}">
  <vmgm />
  <titleset>
    <titles>
      <pgc>
        <vob file="${OUTPUT_MPG}" />
      </pgc>
    </titles>
  </titleset>
</dvdauthor>
EOL

# Create the DVD file structure using dvdauthor
echo "### Creating DVD file structure..."
dvdauthor -x "${DVD_XML}"

# Create the ISO image
echo "### Creating ISO image..."
hdiutil makehybrid -iso -joliet -o "${ISO_IMAGE}" "${DVD_FOLDER}"

# Cleanup temporary files
rm -rf "${TEMP_FOLDER}"

echo "Done! ISO image created as ${ISO_IMAGE}"
