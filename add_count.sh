#!/usr/bin/env bash

### per-comparatpr/input $i
# col1 : input voltage (or delay)
# col2 : 010011001...

### output
# <input> <count> <total> 010101001(length=total)

function countchar()
{
    while IFS= read -r i; do printf "%s" "$i" | tr -dc "$1" | wc -m; done    
}

i=${1:-/dev/stdin}
paste <( cut -f1 $i ) \
      <( cut -f2 $i | countchar "1" ) \
      <( awk 'BEGIN{OFS="\t"} {print length($2), $2 }' $i )
