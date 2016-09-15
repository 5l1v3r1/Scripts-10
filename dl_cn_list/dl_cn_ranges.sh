#!/bin/bash
#
# Author: Spacecow
# Date: 01/08/2016
# Description:
# Download a list of ip ranges for list of countries.


function main() {
    local STORAGE='IP_RANGES'
    while getopts 'h' OPT; do
        case ${OPT} in
            h)
                printf "${0} [-h] \n"
                exit 0
                ;;
        esac
    done

    local ip2location="https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ip2location_country/ip2location_country_%s.netset"
    local geolite2="https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/geolite2_country/country_%s.netset"
    local ipdeny="https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ipdeny_country/id_country_%s.netset"

    #   South America
    #local CN_LIST=(co pe bo uy py gy cl br gf sr ve ec ar)
    #   North America
    #local CN_LIST=(bm bb tc mq mx bl cu pm vg ms hn ca bz gl gd jm ag pa bq cr kn dm lc mf ky aw cw vc tt us sx gt gp vi ai sv pr do ni ht bs)
    #   Africa
    #local CN_LIST=(ma za gh dj mz na mg sd cv cd ng cm zw ug sz tg bw ga ss sc gn bi gm gq km sn td ci ao lr dz sl mr cf ne ml er bj eg ly tn tz ls so re et cg mw rw gw yt mu zm ke st bf)
    #   Asia
    #local CN_LIST=(cn mv lb my in ir uz sa kw mo th kg kh tw vn sy il mn om tm sg jo bh am bt np ge mm id ps af tr iq az pk ae kp io bd tj kz kr jp la hk bn ye ph lk qa)
    #   Europe
    #local CN_LIST=(fo se bg mt me ua bg is im lu mk cz be mc at nl pt rs hr ru si cy by ro fi ad gg al no md gr pl lv je de ie ee sm va hu it es ch gi ba li lt fr dk sk)
    #   Australia
    #local CN_LIST=(ki au nu mp as tk vu to sb ck pw pg wf nf fm fj mh pf nr nz nc tv tl ws gu)

    # List of countries who's ip range you wish to download
    local CN_LIST=(cn ca us)
    for CN in ${CN_LIST[@]}; do
        mkdir -p "${STORAGE}/${CN}"; cd "${STORAGE}/${CN}"; rm *;
        wget "$(printf ${ip2location} ${CN})"
        wget "$(printf ${geolite2} ${CN})"
        wget "$(printf ${ipdeny} ${CN})"
        cat *.netset | grep -v '^#' | sort | uniq > "combined_${CN}.ipset"
        cd ../..
    done
}


main ${@}
