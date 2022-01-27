#DOWNLOADING SRR FILES;

function LoadDump {
 /home/esra/workspace/rnaseq/student_tools/sratoolkit.current-ubuntu64/sratoolkit.2.11.2-ubuntu64/bin/prefetch -O ./ -X 999999999 $1 

  if [[ -e ${1}.sra ]]; then
    /home/esra/workspace/rnaseq/student_tools/sratoolkit.current-ubuntu64/sratoolkit.2.11.2-ubuntu64/bin/parallel-fastq-dump -s ${1}.sra -t 8 -O ./ --tmpdir ./ --split-3 --gzip && rm ${1}.sra
  else
    echo '[ERROR]' $1 'apparently not successfully loaded' && exit 1
  fi
}; export -f LoadDump

cat IDs.txt | parallel -j 2 "LoadDump {}"
