#!/bin/bash

if [[ ${#} -lt 1 ]]; then
        echo "expecting 1 argument at least."
        exit 1
fi

dir="$1"
f="$2"

if [ ! -d "$dir" ]; then
    echo "Error: directory does not exist" >&2
    exit 1
fi



broken_symlink=$(find -L "${dir}" -type l| wc -l)

solution() {
        while read link; do
                linked_to=$(readlink ${link})
                if [[ -e "${link}" ]]; then
                        echo "$(basename ${link}) -> ${linked_to}"
                fi

        done < <(find ${dir} -type l)

        echo "Broken symlinks: ${broken_symlink}"
}
if [[ ${#} -eq 2 ]]; then
        if [[ -f  ${f} ]]; then
                solution >> "${f}"
    else
        echo "File doesn't exist"
    fi
else
        solution
fi
