###############################################################################
## Script for making ADMIXTURE plots in R from ADMIXTURE output               #
## Written by:  M Nieves Colon (mnievesc@asu.edu) 4/15/2019                   # 
## Necessary files: .fam, .txt file with sample info and .q files             #
###############################################################################


###### 1. Plot CV error
cv=read.table("admixture/output/Ancient+HGDP.LDpruned.Kcomparison.txt", header=F) 
cv.table=cbind.data.frame(c(2:10), cv$V4)
colnames(cv.table) <- c("K","CVerror")
pdf("Ancient+HGDP.ADMIXTURE.CVerror.pdf")
plot(as.numeric(cv.table$K), as.numeric(cv.table$CVerror), pch=19, col="blue", xlab = "K", 
     ylab = "Cross-validation error",
     main = "Cross-validation error for ADMIXTURE run K2-10\n Ancient+HGDP dataset")
dev.off()


###### 2. Read in fam file
fam=read.table("admixture/input/Ancient+HGDP.LDpruned.fam", header=F)
colnames(fam)=c("PopID", "IndID", "pat", "mat", "sex", "pheno")

###### 3. Read in popinfo file
txt=read.table("Ancient+HGDP.popinfo.txt", header = T, sep="\t")
head(txt)


###### 4. Define function for naming barplot. Function from:  https://gaworkshop.readthedocs.io/en/latest/
barnaming <- function(vec) {
  retVec <- vec
  for(k in 2:length(vec)) {
    if(vec[k-1] == vec[k])
      retVec[k] <- ""
  }
  return(retVec)
}



###### 5. Plot ADMIXTURE barplots, 3 plots per PDF document. f
pdf("Ancient+HGDP.ADMIXTURE.K2-4.pdf")

### Modify plotting parameters:
par(mar=c(4,4,4,2))  # Modify plot margins 
par(mfrow=c(3,1))    # Allow three plots per page


### K2
q=read.table("admixture/output/Ancient+HGDP.LDpruned.2.Q")   # Read in Q file for K2

data=cbind.data.frame(fam[,1:2], q)     # Make new dataframe with FAM individual IDs

alldata=merge.data.frame(data, txt, by=c("PopID", "IndID"))    # Merge with metadata in popinfo file
head(alldata)

ordered=alldata[order(alldata$Order),]     # Order the alldata table 
 
grp = table(unlist(ordered$Order))
plotspacing = c(rep(0,as.numeric(grp[1]-1)),5,    # Create numeric vector to place spaces between groups
                rep(0,as.numeric(grp[2]-1)),5,
                rep(0,as.numeric(grp[3]-1)),5,
                rep(0,as.numeric(grp[4]-1)),5,
                rep(0,as.numeric(grp[5]-1)),5,
                rep(0,as.numeric(grp[6]-1)),5,
                rep(0,as.numeric(grp[7]-1)),5,
                rep(0,as.numeric(grp[8]-1)),5,
                rep(0,as.numeric(grp[9]-1)),5,
                rep(0,as.numeric(grp[10]-1)) )

barplot(t(as.matrix(subset(ordered, select=c(V1:V2)))), col=rainbow(2), border=NA,
        space=plotspacing, names.arg = barnaming(ordered$AdmixtureLabelID), las=2, cex.axis=0.90, cex.names=0.65)   # plot
mtext("K=2", side=3, at=10, las=1, cex=0.70)  # Add label with K value



### K3
q=read.table("admixture/output/Ancient+HGDP.LDpruned.3.Q")

data=cbind.data.frame(fam[,1:2], q)

alldata=merge.data.frame(data, txt, by=c("PopID", "IndID"))
head(alldata)

ordered=alldata[order(alldata$Order),]

barplot(t(as.matrix(subset(ordered, select=c(V1:V3)))), col=rainbow(3), border=NA,
       space=plotspacing, names.arg = barnaming(ordered$AdmixtureLabelID), las=2, cex.axis=0.90, cex.names=0.65)
mtext("K=3", side=3, at=10, las=1, cex=0.70)



### K4
q=read.table("admixture/output/Ancient+HGDP.LDpruned.4.Q")

data=cbind.data.frame(fam[,1:2], q)

alldata=merge.data.frame(data, txt, by=c("PopID", "IndID"))
head(alldata)

ordered=alldata[order(alldata$Order),]

barplot(t(as.matrix(subset(ordered, select=c(V1:V4)))), col=rainbow(4), border=NA,
        space=plotspacing, names.arg = barnaming(ordered$AdmixtureLabelID), las=2, cex.axis=0.90, cex.names=0.65)
mtext("K=4", side=3, at=10, las=1, cex=0.70)

dev.off()






### 5. Plot next three Ks
pdf("Ancient+HGDP.ADMIXTURE.K5-7.pdf")

### Plotting parameters
par(mar=c(4,4,4,2))
par(mfrow=c(3,1))


### K5
q=read.table("admixture/output/Ancient+HGDP.LDpruned.5.Q")

data=cbind.data.frame(fam[,1:2], q)

alldata=merge.data.frame(data, txt, by=c("PopID", "IndID"))
head(alldata)

ordered=alldata[order(alldata$Order),]

barplot(t(as.matrix(subset(ordered, select=c(V1:V5)))), col=rainbow(5), border=NA,
        space=plotspacing, names.arg = barnaming(ordered$AdmixtureLabelID), las=2, cex.axis=0.90, cex.names=0.65)
mtext("K=5", side=3, at=10, las=1, cex=0.70)



### K6
q=read.table("admixture/output/Ancient+HGDP.LDpruned.6.Q")

data=cbind.data.frame(fam[,1:2], q)

alldata=merge.data.frame(data, txt, by=c("PopID", "IndID"))
head(alldata)

ordered=alldata[order(alldata$Order),]

barplot(t(as.matrix(subset(ordered, select=c(V1:V6)))), col=rainbow(6), border=NA,
        space=plotspacing, names.arg = barnaming(ordered$AdmixtureLabelID), las=2, cex.axis=0.90, cex.names=0.65)
mtext("K=6", side=3, at=10, las=1, cex=0.70)



### K7
q=read.table("admixture/output/Ancient+HGDP.LDpruned.7.Q")

data=cbind.data.frame(fam[,1:2], q)

alldata=merge.data.frame(data, txt, by=c("PopID", "IndID"))
head(alldata)

ordered=alldata[order(alldata$Order),]

barplot(t(as.matrix(subset(ordered, select=c(V1:V7)))), col=rainbow(7), border=NA,
        space=plotspacing, names.arg = barnaming(ordered$AdmixtureLabelID), las=2, cex.axis=0.90, cex.names=0.65)
mtext("K=7", side=3, at=10, las=1, cex=0.70)


dev.off()





### 6. Plot next three Ks
pdf("Ancient+HGDP.ADMIXTURE.K8-10.pdf")

### Plotting parameters
par(mar=c(4,4,4,2))
par(mfrow=c(3,1))



### K8
q=read.table("admixture/output/Ancient+HGDP.LDpruned.8.Q")

data=cbind.data.frame(fam[,1:2], q)

alldata=merge.data.frame(data, txt, by=c("PopID", "IndID"))
head(alldata)

ordered=alldata[order(alldata$Order),]

barplot(t(as.matrix(subset(ordered, select=c(V1:V8)))), col=rainbow(8), border=NA,
        space=plotspacing, names.arg = barnaming(ordered$AdmixtureLabelID), las=2, cex.axis=0.90, cex.names=0.65)
mtext("K=8", side=3, at=10, las=1, cex=0.70)



### K9
q=read.table("admixture/output/Ancient+HGDP.LDpruned.9.Q")

data=cbind.data.frame(fam[,1:2], q)

alldata=merge.data.frame(data, txt, by=c("PopID", "IndID"))
head(alldata)

ordered=alldata[order(alldata$Order),]

barplot(t(as.matrix(subset(ordered, select=c(V1:V9)))), col=rainbow(9), border=NA,
        space=plotspacing, names.arg = barnaming(ordered$AdmixtureLabelID), las=2, cex.axis=0.90, cex.names=0.65)

mtext("K=9", side=3, at=10, las=1, cex=0.70)




### K10
q=read.table("admixture/output/Ancient+HGDP.LDpruned.10.Q")

data=cbind.data.frame(fam[,1:2], q)

alldata=merge.data.frame(data, txt, by=c("PopID", "IndID"))
head(alldata)

ordered=alldata[order(alldata$Order),]

barplot(t(as.matrix(subset(ordered, select=c(V1:V10)))), col=rainbow(10), border=NA,
        space=plotspacing, names.arg = barnaming(ordered$AdmixtureLabelID), las=2, cex.axis=0.90, cex.names=0.65)

mtext("K=10", side=3, at=10, las=1, cex=0.70)


dev.off()

