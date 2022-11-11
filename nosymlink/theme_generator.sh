#!/bin/sh

SCHEME_REPO_NAME="base16-schemes"
SCHEME_REPO_HTTPS="https://github.com/tinted-theming/base16-schemes.git"
WORKING_DIR="$(dirname $(realpath $0))"
LOCAL_REPO="${WORKING_DIR}/${SCHEME_REPO_NAME}"
TMP_DIR="${WORKING_DIR}/schemes"
X_DIR="${WORKING_DIR}/xresources"
SHELL_DIR="${WORKING_DIR}/shell_escape_codes"

get_schemes() {
    echo $LOCAL_REPO
    if [ ! -d "$LOCAL_REPO" ]; then
        git clone $SCHEME_REPO_HTTPS & 
    else
        git --git-dir=${LOCAL_REPO}/.git pull &
    fi
    echo "Fetching latest colour schemes ..."
    wait
    echo "Done."
}


format_colour () {
    original=$1
    echo "${original:0:2}/${original:2:2}/${original:4:2}"
}

write_xresources() {
    
    echo "! b16-$1"

    echo "#define base00 #${colours[0]}"
    echo "#define base01 #${colours[1]}"
    echo "#define base02 #${colours[2]}"
    echo "#define base03 #${colours[3]}"
    echo "#define base04 #${colours[4]}"
    echo "#define base05 #${colours[5]}"
    echo "#define base06 #${colours[6]}"
    echo "#define base07 #${colours[7]}"
    echo "#define base08 #${colours[8]}"
    echo "#define base09 #${colours[9]}"
    echo "#define base0A #${colours[10]}"
    echo "#define base0B #${colours[11]}"
    echo "#define base0C #${colours[12]}"
    echo "#define base0D #${colours[13]}"
    echo "#define base0E #${colours[14]}"
    echo "#define base0F #${colours[15]}"

    echo "*foreground:   base05"
    echo "*background:   base00"
    echo "*cursorColor:  base05"
    echo "*color0:       base00"
    echo "*color1:       base08"
    echo "*color2:       base0B"
    echo "*color3:       base0A"
    echo "*color4:       base0D"
    echo "*color5:       base0E"
    echo "*color6:       base0C"
    echo "*color7:       base05"
    echo "*color8:       base03"
    echo "*color9:       base09"
    echo "*color10:      base01"
    echo "*color11:      base02"
    echo "*color12:      base04"
    echo "*color13:      base06"
    echo "*color14:      base0F"
    echo "*color15:      base07"
}

write_shell_escape_codes() {
    echo "#!/bin/sh"
    echo "source ansi_colour_functions.sh"
    echo "put_template 0  `format_colour ${colours[0]}`"
    echo "put_template 1  `format_colour ${colours[8]}`"
    echo "put_template 2  `format_colour ${colours[11]}`"
    echo "put_template 3  `format_colour ${colours[10]}`"
    echo "put_template 4  `format_colour ${colours[13]}`"
    echo "put_template 5  `format_colour ${colours[14]}`"
    echo "put_template 6  `format_colour ${colours[12]}`"
    echo "put_template 7  `format_colour ${colours[5]}`"
    echo "put_template 8  `format_colour ${colours[3]}`"

    echo "put_template 9  `format_colour ${colours[9]}`"
    echo "put_template 10 `format_colour ${colours[1]}`"
    echo "put_template 11 `format_colour ${colours[2]}`"
    echo "put_template 12 `format_colour ${colours[4]}`"
    echo "put_template 13 `format_colour ${colours[6]}`"
    echo "put_template 14 `format_colour ${colours[15]}`"
    echo "put_template 15 `format_colour ${colours[7]}`"
    echo "put_template_var 10 `format_colour ${colours[5]}`"
    echo "put_template_var 11 `format_colour ${colours[0]}`"
    echo "put_template_custom 12 \";7\""
}

process_themes() {
    echo "Writing themes ..."
    for f in $TMP_DIR/*.yaml
    do
        fname=$(echo $(basename $f) | cut -f 1 -d ".")
        colours=()
        for c in base0{0..9} base0{A..F}
        do
            colours+=(`sed -ne 's/'"${c}"': "\(.*\)".*/\1/p' $f`)
        done
        write_xresources ${fname} > ${X_DIR}/b16-${fname} &
        write_shell_escape_codes > ${SHELL_DIR}/b16-${fname}.sh &
    done
    wait
    echo "Done."
}

main() {
    mkdir -p $TMP_DIR
    mkdir -p $X_DIR
    mkdir -p $SHELL_DIR
    get_schemes
    cp $SCHEME_REPO_NAME/*.yaml $TMP_DIR
    process_themes
}

main
