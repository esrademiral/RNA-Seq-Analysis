
library(clusterProfiler)
library(GSEABase)
library(org.Hs.eg.db)
filename<- "c7.all.v7.1.entrez.gmt"
gmtfile <- system.file(filename)
c6 <- read.gmt(gmtfile)
yourEntrezIdList<- c(1958,54855,440,29950,22911,219654,28971,56204,284,80726,57466,10426,9786,116113,114789,5837,4147,314,728411,9709,25778,93594,51175,388730,10482,2049,23509,26504,54800,63035,1513,55869,55521,80311,64789,5326,55781,147040,2353,25901,51542,84915,149041,29116)
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
