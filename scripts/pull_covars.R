args <- commandArgs(trailingOnly = TRUE);
input <- args[1]
axes <- args[2]

out1 <- paste(input,".eigs", sep = "")
out2 <- paste(input,".cov10", sep = "")
covar <- read.table(input, stringsAsFact=F)
eig <- eigen(covar, symm=TRUE)
eig$val <- eig$val/sum(eig$val)
#cat(signif(eig$val, digits=3)*100,"\n")
PC <- as.data.frame(eig$vectors)
colnames(PC) <- gsub("V", "PC", colnames(PC))

write.table(PC[,1:axes], col.names=F, row.names=F)


#write.table(out1,eig$val)

#write.table(out2,PC[,1:10])

