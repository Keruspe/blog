#!/bin/sh

date_pattern=$(date "+%Y-%m-%d")-

read -r -p "Post name > "
title=${REPLY}
# to ascii, to lowercase, keep only alphanum and ._- space and turn spaces into dashes
clean_title=$(echo $title \
    | iconv -f utf8 -t ascii//translit \
    | tr '[:upper:]' '[:lower:]' \
    | tr -dc 'a-z0-9. _-' \
    | tr ' ' '-')

filename=$date_pattern$clean_title.md
author=$(git config --get user.name)

cat > "posts/"$filename <<EOF
---
title: $title
author: $author
tags:
---

EOF

$EDITOR "posts/"$filename
