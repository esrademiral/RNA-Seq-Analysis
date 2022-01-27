#BALLGOWN (PARTII)

# Load libraries needed for this analysis
library(ballgown)
library(genefilter)
library(dplyr)
library(devtools)

# Define a path for the output PDF to be written
outfile="/home/esra/workspace/rnaseq/de/ballgown/ref_only_my_data/Tutorial_Part2_ballgown_output.pdf"

# Load phenotype data
pheno_data = read.csv("Gefinitib_vs_DMSO.csv")

# Display the phenotype data
pheno_data

# Load the ballgown object from file
load('bg.rda')

# The load command, loads an R object from a file into memory in our R session. 
# You can use ls() to view the names of variables that have been loaded
ls()

# Print a summary of the ballgown object
bg

# Open a PDF file where we will save some plots. We will save all figures and then view the PDF at the end
pdf(file=outfile)

# Extract FPKM values from the 'bg' object
fpkm = texpr(bg,meas="FPKM")

# View the last several rows of the FPKM table
tail(fpkm)

# Transform the FPKM values by adding 1 and convert to a log2 scale
fpkm = log2(fpkm+1)

# View the last several rows of the transformed FPKM table
tail(fpkm)

# Create boxplots to display summary statistics for the FPKM values for each sample
boxplot(fpkm,col=as.numeric(pheno_data$type)+1,las=2,ylab='log2(FPKM+1)')

# Display the transcript ID for a single row of data
ballgown::transcriptNames(bg)[177933]

# Display the gene name for a single row of data 
ballgown::geneNames(bg)[177933]

# Create a BoxPlot comparing the expression of a single gene for all replicates of both conditions

boxplot(fpkm[177933,] ~ pheno_data$type, border=c(2,3), main=paste(ballgown::geneNames(bg)[177933],' : ', ballgown::transcriptNames(bg)[177933]),pch=19, xlab="Type", ylab='log2(FPKM+1)')



# Add the FPKM values for each sample onto the plot 

points(fpkm[177933,] ~ jitter(c(2,2,2,1,1,1)), col=c(2,2,2,1,1,1)+1, pch=16)


# Create a plot of transcript structures observed in each replicate and color transcripts by expression level
plotTranscripts(ballgown::geneIDs(bg)[177933], bg, main=c('EGR1 in all Gefitinib samples'), sample=c('SRR7618907_expression', 'SRR7618908_expression', 'SRR7618909_expression'), labelTranscripts=TRUE)
plotTranscripts(ballgown::geneIDs(bg)[177933], bg, main=c('EGR1 in all DMSO samples'), sample=c('SRR7618904_expression', 'SRR7618905_expression', 'SRR7618906_expression'), labelTranscripts=TRUE)



# Close the PDF device where we have been saving our plots
dev.off()

# Exit the R session
quit(save="no")
