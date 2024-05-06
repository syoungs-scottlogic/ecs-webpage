#! /usr/bin/bash

function highlight {
    case $1 in
        red)
        COLOUR=31
        ;;
        blue)
        COLOUR=34
        ;;
        green)
        COLOUR=32
        ;;
        yellow)
        COLOUR=33
        ;;
        purple)
        COLOUR=35
        ;;
        cyan)
        COLOUR=36
        ;;
        *)
        echo "No colour found with $1."
    esac

    echo -e "\e[${COLOUR}m${2}\e[0m"
}

function yes_no_prompt {
    while true; do
    read -p "Do you want to proceed? [y/n]: " yn
    case "$yn" in
        y|Y|yes)
        break
        ;;
        n|N|no)
        exit 0
        ;;
        *)
        echo "Incorrect option. Please use y or no"
        ;;
    esac
    done
}
