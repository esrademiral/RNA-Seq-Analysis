#GENE ENRICHMENT

#Gene Enrichment Analysis

library(clusterProfiler)
library(enrichplot)
library(ggplot2)

#SETTING THE DESIRED ORGANISM HERE
organism = "org.Hs.eg.db"
library(organism, character.only = TRUE)

# reading data 
df = read.csv("Gefinitib_vs_DMSO_gene_results_sig.csv", header=TRUE)

# we want the log2 fold change 
original_gene_list <- df$fc

# name the vector
names(original_gene_list) <- df$id

# omit any NA values 
gene_list<-na.omit(original_gene_list)

# sort the list in decreasing order (required for clusterProfiler)
gene_list = sort(gene_list, decreasing = TRUE)



#Gene Set Enrichment

gse <- gseGO(geneList=gene_list, 
             ont ="ALL", 
             keyType = "ENSEMBL", 
             nPerm = 10000, 
             minGSSize = 3, 
             maxGSSize = 800, 
             pvalueCutoff = 0.05, 
             verbose = TRUE, 
             OrgDb = organism, 
             pAdjustMethod = "none")


require(DOSE)


outfile = "/home/esra/Desktop/dotplot.pdf"
pdf(file=outfile)
dotplot <- dotplot(gse, showCategory=10, split=".sign") + facet_grid(.~.sign)
plot(dotplot)
dev.off()


#to draw emapplot we should do pairwise termsim
x2 <- pairwise_termsim(gse)

outfile = "/home/esra/Desktop/emapplot.pdf"
pdf(file=outfile)
emapplot <- emapplot(x2, showCategory = 10)
plot(emapplot)
dev.off()


#cnetplot
outfile = "/home/esra/Desktop/cnetplot.pdf"
pdf(file=outfile)
cnetplot <- cnetplot(gse, categorySize="pvalue", foldChange=gene_list, showCategory = 3)
plot(cnetplot)
dev.off()


#ridgeplot
outfile = "/home/esra/Desktop/ridgeplot.pdf"
pdf(file=outfile)
ridgeplot <- ridgeplot(gse) + labs(x = "enrichment distribution")
plot(ridgeplot)
dev.off()


#gseaplot
outfile = "/home/esra/Desktop/gseaplot.pdf"
pdf(file=outfile)
gseaplot <- gseaplot(gse, by = "all", title = gse$Description[1], geneSetID = 1)
plot(gseaplot)
dev.off()


#pmcplot
terms <- gse$Description[1:3]
outfile = "/home/esra/Desktop/pmcplot.pdf"
pdf(file=outfile)
pmcplot <- pmcplot(terms, 2010:2018, proportion=FALSE)
plot(pmcplot)
dev.off()



#KEGG Gene Set Enrichment Analysis

ids<-bitr(names(original_gene_list), fromType = "ENSEMBL", toType = "ENTREZID", OrgDb=organism)

# Convert gene IDs for gseKEGG function
# We will lose some genes here because not all IDs will be converted
ids<-bitr(names(original_gene_list), fromType = "ENSEMBL", toType = "ENTREZID", OrgDb=organism)
 # remove duplicate IDS (here I use "ENSEMBL", but it should be whatever was selected as keyType)
dedup_ids = ids[!duplicated(ids[c("ENSEMBL")]),]

# Create a new dataframe df2 which has only the genes which were successfully mapped using the bitr function above
df2 = df[df$id %in% dedup_ids$ENSEMBL,]

# Create a new column in df2 with the corresponding ENTREZ IDs
df2$Y = dedup_ids$ENTREZID

# Create a vector of the gene unuiverse
kegg_gene_list <- df2$fc

# Name vector with ENTREZ ids
names(kegg_gene_list) <- df2$Y

# omit any NA values 
kegg_gene_list<-na.omit(kegg_gene_list)

# sort the list in decreasing order (required for clusterProfiler)
kegg_gene_list = sort(kegg_gene_list, decreasing = TRUE)

#Create gseKEGG object

kegg_organism = "hsa"
kk2 <- gseKEGG(geneList     = kegg_gene_list,
               organism     = kegg_organism,
               nPerm        = 10000,
               minGSSize    = 3,
               maxGSSize    = 800,
               pvalueCutoff = 0.05,
               pAdjustMethod = "none",
               keyType       = "ncbi-geneid")

#Dotplot
outfile = "/home/esra/Desktop/dotplot_enc.pdf"
pdf(file=outfile)
dotplot_enc <- dotplot(kk2, showCategory = 10, title = "Enriched Pathways" , split=".sign") + facet_grid(.~.sign)
plot(dotplot_enc)
dev.off()

#Emapplot
kk2_new <- pairwise_termsim(kk2) 

outfile = "/home/esra/Desktop/emapplot_enc.pdf"
pdf(file=outfile)
emapplot_enc <- emapplot(kk2_new)
plot(emapplot_enc)
dev.off()

#cnetplot

outfile = "/home/esra/Desktop/cnetplot_enc.pdf"
pdf(file=outfile)
cnetplot_enc <- cnetplot(kk2, categorySize="pvalue", foldChange=gene_list)
plot(cnetplot_enc)
dev.off()

#ridgeplot
outfile = "/home/esra/Desktop/ridgeplot_enc.pdf"
pdf(file=outfile)
ridgeplot_enc <- ridgeplot(kk2) + labs(x = "enrichment distribution")
plot(ridgeplot_enc)
dev.off()

#gseaplot
outfile = "/home/esra/Desktop/gseaplot_enc.pdf"
pdf(file=outfile)
gseaplot_enc <- gseaplot(kk2, by = "all", title = kk2$Description[1], geneSetID = 1)
plot(gseaplot_enc)
dev.off()

#to see pathway for each pathway id in kk2 object
hsa <- pathview(gene.data=kegg_gene_list, pathway.id="hsa04371", species = kegg_organism)
hsa2 <- pathview(gene.data=kegg_gene_list, pathway.id="hsa04912", species = kegg_organism)
hsa3 <- pathview(gene.data=kegg_gene_list, pathway.id="hsa04928", species = kegg_organism)
hsa4 <- pathview(gene.data=kegg_gene_list, pathway.id="hsa04933", species = kegg_organism)
