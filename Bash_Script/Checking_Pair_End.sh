#CHECKING PAIR END;

# See documentation for the SRA Toolkit:
# http://www.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=toolkit_doc&f=fastq-dump

sra_paired() {
  local SRA="$1"
  local x=$(
    /home/esra/workspace/rnaseq/student_tools/sratoolkit.current-ubuntu64/sratoolkit.2.11.2-ubuntu64/bin/fastq-dump -I -X 1 -Z --split-spot "$SRA" 2>/dev/null \
      | awk '{if(NR % 2 == 1) print substr($1,length($1),1)}' \
      | uniq \
      | wc -l
  )
  [[ $x == 2 ]]
}

if [[ "$1" == "" ]]; then
  echo "usage: sra-paired.sh file.sra"
  exit 1
fi

if sra_paired "$1"; then
  echo "$1 contains paired-end sequencing data"
else
  echo "$1 does not contain paired-end sequencing data"
fi
