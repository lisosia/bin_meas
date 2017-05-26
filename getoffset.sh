#!/usr/bin/env bash

for i in $(seq 0 255) ; do
    awk 'BEGIN{OFS="\t"} {print $1, $2/$3}' $i | convert_errfunc > $i.mean

    printf "$i\t" >> OFFSET
    cat $i.mean >> OFFSET
done
