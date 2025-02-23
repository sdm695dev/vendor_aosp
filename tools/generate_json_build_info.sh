#!/bin/bash
# shellcheck enable=avoid-nullary-conditions

GREEN="\033[1;32m"
YELLOW="\033[1;33m"
NC="\033[0m"

file_path=$1
if [[ -f $file_path ]]; then
    echo "Generating .json"
    file_name=$(basename "$file_path")
    device_name=$(echo "$file_name" | cut -d'-' -f5)
    buildprop=${OUT_DIR:-out}/target/product/veux/system/build.prop
        file_size=$(stat -c %s "$file_path")
        sha256=$(cut -d' ' -f1 "$file_path".md5sum)
        datetime=$(grep -w ro\\.build\\.date\\.utc "$buildprop" | cut -d= -f2)
        link=https://sourceforge.net/projects/sdm695devbuilds/files/veux/PixelOS/$file_name/download
        cat >"$file_path".json <<JSON
{
  "response": [
    {
      "datetime": $datetime,
      "filename": "$file_name",
      "id": "$sha256",
      "romtype": "Unofficial",
      "size": $file_size,
      "url": "$link",
      "version": "fifteen"
    }
  ]
}
JSON
        mv "$file_path".json "${OUT_DIR:-out}"/target/product/veux/veux.json
        echo -e "${GREEN}Done generating ${YELLOW}veux.json${NC}"
fi
