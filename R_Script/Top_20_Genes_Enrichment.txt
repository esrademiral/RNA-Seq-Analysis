library(clusterProfiler)
library(GSEABase)
library(org.Hs.eg.db)
filename<- "c7.all.v7.1.entrez.gmt"
gmtfile <- system.file(filename)
c6 <- read.gmt(gmtfile)
yourEntrezIdList<- c(6202,5052,10103,9406,1486,3491,6125,2773,51592,7812,476,26227,6944,9181,7203,8407,9462,6045,493,824)
ImmunSigEnrich <- enricher(yourEntrezIdList, TERM2GENE=c6, pvalueCutoff = 0.01)
ImmunSigEnrich <- setReadable(ImmunSigEnrich, OrgDb = org.Hs.eg.db, keyType =
"ENTREZID")
write.csv(ImmunSigEnrich,"MyImmunePathwayRelatedGenes.csv")
goEnrich<-enrichGO(gene= yourEntrezIdList,OrgDb= org.Hs.eg.db, ont=
"ALL",pAdjustMethod=
"BH",pvalueCutoff = 0.01,readable= TRUE)
write.csv(goEnrich,"MyGORelatedGenes.csv")
keggEnrich<-enrichKEGG(gene= yourEntrezIdList,organism= "hsa",pAdjustMethod="BH",
pvalueCutoff = 0.01)
write.csv(keggEnrich,"MyKEGGRelatedGenes.csv")

