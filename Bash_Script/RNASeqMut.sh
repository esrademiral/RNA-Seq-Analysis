cd $RNA_HOME
git clone https://github.com/davidliwei/rnaseqmut/
cp $RNA_HOME/rnaseqmut/bin/rnaseqmut.linux.x64 $RNA_HOME/student_tools/rnaseqmut/bin/rnaseqmut
cd rnaseqmut/demo/data
rm *.ba?
#check out the sam files
for i in $(ls $RNA_HOME/alignments/hisat2/*.sam ) 
do
echo item:$i
done

#check out the sam file headers
for i in $(ls $RNA_HOME/alignments/hisat2/*_*.sam  | tr -s '/.' ' ' | awk '{print $(NF-1)}') 
do
echo item:$i
done

#create bam files from the sam files and index to create the bai files
for i in $(ls $RNA_HOME/alignments/hisat2/*_*.sam  | tr -s '/.' ' ' | awk '{print $(NF-1)}') 
do
samtools sort $RNA_HOME/alignments/hisat2/$i.sam > $i.bam
samtools index $i.bam
echo indexing of $i finished
done

#modify rnaseqmut shell script with our own normal and cancer brain file names
#modify depth from 10 to 5
nano rnaseqmut/demo/rundemo.sh

#run rnaseqmut on the bam files and produce the filtered snps (vcf files)
cd rnaseqmut/demo
./rundemo.sh

#take a look at the found variations
nano results/ALLMUT_FILTERED.vcf

#annotate your vcf using Annovar
grep -n chrom ALLMUT_FILTERED.vcf
wc -l ALLMUT_FILTERED.vcf
# tail -n the number of lines after #chrom  or grep -v '#' ALLMUT_FILTERED.vcf
awk '{FS="\t";print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t.\t"$7}' ../rnaseqmut/demo/results/ALLMUT_FILTERED.vcf | tail -5500 > ../rnaseqmut/demo/results/ALLMUT_FILTERED.filtercoladded.vcf


#for annovar, first download a few annotation databases
cd $RNA_HOME/annovar
perl annotate_variation.pl -buildver hg38 -downdb -webfrom annovar refGene humandb/

perl annotate_variation.pl -buildver hg38 -downdb cytoBand humandb/

perl annotate_variation.pl -buildver hg38 -downdb genomicSuperDups humandb/ 

perl annotate_variation.pl -buildver hg38 -downdb -webfrom annovar esp6500siv2_all humandb/

perl annotate_variation.pl -buildver hg38 -downdb -webfrom annovar 1000g2015aug humandb/

perl annotate_variation.pl -buildver hg38 -downdb -webfrom annovar exac03 humandb/ 

perl annotate_variation.pl -buildver hg38 -downdb -webfrom annovar avsnp150 humandb/ 

perl annotate_variation.pl -buildver hg38 -downdb -webfrom annovar dbnsfp30a humandb/

perl annotate_variation.pl -buildver hg38 -downdb -webfrom annovar clinvar_20200316 humandb/

perl annotate_variation.pl -buildver hg38 -downdb -webfrom annovar cosmic70 humandb/

cd $RNA_HOME/annovar
#run annovar on the 6 variants we found to check if they exist in any of the databases
perl table_annovar.pl  ../rnaseqmut/demo/results/ALLMUT_FILTERED.filtercoladded.vcf humandb/ -buildver hg38 -out myanno -remove -protocol refGene,cytoBand,genomicSuperDups,esp6500siv2_all,1000g2015aug_all,1000g2015aug_eur,exac03,avsnp150,dbnsfp30a,cosmic70,clinvar_20200316 -operation g,r,r,f,f,f,f,f,f,f,f -nastring . -vcfinput
cp myanno.hg38_multianno.txt myanno.hg38_multianno.tsv
libreoffice myanno.hg38_multianno.tsv
