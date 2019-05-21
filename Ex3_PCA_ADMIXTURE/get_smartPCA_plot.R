###############################################################################
## Script for making PCA plot in R from smartpca output                       #
## Written by:  M Nieves Colon (mnievesc@asu.edu) 12/11/2016                  #                                                
## Necessary files: .fam, .evec, .eval files and .txt file with sample info   #
###############################################################################

###### Necessary R libraries
library(ggplot2)
library(RColorBrewer)


###### 1. Input the data table with eigenvectors, skip the first line to avoid having an unncessary header.
######    Rename columns.
importevec = function (filename) {
  x =read.table(filename, header=F, skip=1)
  #print(head(x))
  print(nrow(x))
  return(x)
}

evec=importevec ("smartpca/output/Ancient+HGDP.evec")
colnames(evec)=c("IndID","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10")
head(evec)


######## 2. Add population labels to data by importing auxiliary files with information.
########    This will make subsetting for later plots very easy.
fam=read.table("plink/Ancient+HGDP.fam", header=F)
colnames(fam)=c("PopID", "IndID", "pat", "mat", "sex", "pheno")

txt=read.table("Ancient+HGDP.popinfo.txt", header = T, sep="\t")
head(txt)

metadata=merge.data.frame(fam, txt, by=c("PopID", "IndID"))
head(metadata)

tempdata=cbind.data.frame(evec[2:11],fam[,1:2])
head(tempdata)

alldata=merge.data.frame(tempdata, txt, by=c("PopID", "IndID"))
head(alldata)


######## 3.  Import variance per PC component (eigenvalues).
pcvariance=function (filename) {
  eval=read.table(filename)
  eval1pc=round(eval[1,1]/sum(eval)*100,digits=2)
  eval2pc=round(eval[2,1]/sum(eval)*100,digits=2)
  eval3pc=round(eval[3,1]/sum(eval)*100,digits=2)
  list(PC1var=eval1pc, PC2var=eval2pc, PC3var=eval3pc)
}
pcvar=pcvariance("smartpca/output/Ancient+HGDP.eval")


######## 4. Plot by groups using ggplot.
ancients <- subset(alldata, PCALabelID == "Ancient Tarahumara" | PCALabelID == "Ancient Pericues" | PCALabelID == "Ancient FuegoPatagonian")
refpops <- subset(alldata, PCALabelID != "Ancient Tarahumara" & PCALabelID != "Ancient Pericues" & PCALabelID != "Ancient FuegoPatagonian")

# Sanity check
nrow(refpops)  # 873
nrow(ancients) # 19


## Plot PC1 v 2 
x1 <- ggplot(refpops, aes(x = PC1, y = PC2)) +
  geom_point(size=3, alpha = 0.45, aes(color=PCALabelID)) +
  theme_bw() + scale_colour_brewer("Region", palette = "Set1") + 
  labs(x=paste("Principal Component 1 (",pcvar[1],"%)",sep=""),
       y=paste("Principal Component 2 (",pcvar[2],"%)",sep="") ) 
pc1v2 = x1 + geom_point(data=ancients, size=3, alpha = 0.80, 
                           aes(shape=factor(PCALabelID))) + labs(shape='Ancient Pops')
  
  
## Plot PC1 v 3
x2 <- ggplot(refpops, aes(x = PC1, y = PC3)) +
  geom_point(size=3, alpha = 0.45, aes(color=PCALabelID)) +
  theme_bw() + scale_colour_brewer("Region", palette = "Set1") + 
  labs(x=paste("Principal Component 1 (",pcvar[1],"%)",sep=""),
       y=paste("Principal Component 2 (",pcvar[2],"%)",sep="") ) 
pc1v3 = x2 + geom_point(data=ancients, size=3, alpha = 0.80, 
                           aes(shape=factor(PCALabelID))) + labs(shape='Ancient Mexico')


## Plot PC2 v 3
x3 <- ggplot(refpops, aes(x = PC2, y = PC3)) +
  geom_point(size=3, alpha = 0.75, aes(color=PCALabelID)) +
  theme_bw() + scale_colour_brewer("Region", palette = "Set1") + 
  labs(x=paste("Principal Component 2 (",pcvar[1],"%)",sep=""),
       y=paste("Principal Component 3 (",pcvar[2],"%)",sep="") ) 
pc2v3 = x3 + geom_point(data=ancients, size=3, alpha = 0.65, 
                           aes(shape=factor(PCALabelID))) +  labs(shape='Ancient Mexico')


######## 5. Save to pdf
pdf("Ancient+HGDP.smartpca.pdf")
plot(pc1v2)
plot(pc1v3)
plot(pc2v3)
dev.off()
