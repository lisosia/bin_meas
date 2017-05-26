#!/usr/bin/env bash
#set -uvx

# inputfile name :== input voltage
# col2 : 01101011...11 (256count), n番目の文字はcomparaator<n> に対応

function countchar()
{
    while IFS= read -r i; do printf "%s" "$i" | tr -dc "$1" | wc -m; done    
}

mkdir -p per_comparator

add_count=$(dirname $( readlink -f $0 ) )/add_count.sh
for f in $( ls | grep ".trim" | sort -n ); do
    echo "PER_COMPARATOR.sh : processing $f"
    voltage=$( echo $f | ruby -e " print gets.split('.')[0] " )

    for c in $(seq 1 256) ; do
    	num=$(( $c - 1 ))
    	out=per_comparator/$num
    	printf -- "${voltage}\t" >> $out
    	cut -f2 <$f | cut -c $c | tr -d "\n" >> $out
    	printf "\n" >> $out
    done

done

for c in $(seq 1 256) ; do
    num=$(( $c - 1 ))
    out=per_comparator/$num
    paste <( cut -f1 $out ) \
	  <( cut -f2 $out | countchar "1" ) \
	  <( awk 'BEGIN{OFS="\t"} {print length($2), $2 }' $out )   > $out.count
done
