
#INDEXING BAM FILES;

for INFILE in "$@"
do
   samtools index $INFILE
done
