mkdir -p pervol

for f in $( ls *.trim | sort -n ) ; do
    cat $f | awk ' 
{
out = sprintf( "pervol/%d" ,NR )
print $0 >> out 
} '
done

cd pervol
mkdir -p percomp
for v in $( ls [0-9]* | sort -n) ; do
    cut -f2 $v | awk '
{
for(i=1;i<257;i++) {
out=sprintf( "percomp/%d" ,i )
printf(  "%s", substr( $1,i,1  )  ) >> out
}
}

END{ 
for(i=1;i<257;i++) {
out=sprintf( "percomp/%d" ,i )
printf( "\n" ) >> out
}
}
'
done
