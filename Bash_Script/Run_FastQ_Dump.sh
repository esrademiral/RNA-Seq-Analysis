#RUN_FASTQ_DUMP;

#!/usr/bin/env bash
for filename in /home/esra/workspace/rnaseq/data/*.sra; do
    fastq-dump $filename
done
