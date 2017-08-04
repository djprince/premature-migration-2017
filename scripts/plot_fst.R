#!/usr/bin/Rscript
# Usage: Rscript speciesID 
args <- commandArgs()
spp <- args[8]
input.file <- paste("RAD_fst/",spp,".fstmatrix", sep = "")

values.in <- read.table(input.file, stringsAsFact=F, header = T)
if(spp == "Ch") {
  order = c("Eel_M", "Tri_M", "Tri_P", "Sal_M", "Sal_P", "Rog_M", "Rog_P", "Sou_M", "Nor_P", "Sil_M", "Sil_P", "Puy_M", "Puy_P", "Noo_M", "Noo_P","Sou_P")
  values.o = values.in[match(order,values.in$Pop),]
  values = data.frame(Eel_M = values.o$Eel_M, Tri_M = values.o$Tri_M, Tri_P = values.o$Tri_P, Sal_M = values.o$Sal_M, Sal_P = values.o$Sal_P, Rog_M = values.o$Rog_M, Rog_P = values.o$Rog_P, Sou_M = values.o$Sou_M, Nor_P = values.o$Nor_P, Sil_M = values.o$Sil_M, Sil_P = values.o$Sil_P, Puy_M = values.o$Puy_M, Puy_P = values.o$Puy_P, Noo_M = values.o$Noo_M, Noo_P = values.o$Noo_P, Sou_P = values.o$Sou_P)
  rownames(values) <- order
  values$Sou_P <- NULL
  values <- head(values,-1)
  order <- head(order, -1)
} else if (spp == "St"){
  order = c("Sco_M", "Eel_M", "Eel_P", "New_P", "Ump_M", "Ump_P", "Sil_M", "Sil_P")
  values.o = values.in[match(order,values.in$Pop),]
  values = data.frame(Sco_M= values.o$Sco_M, Eel_M= values.o$Eel_M, Eel_P= values.o$Eel_P, New_P= values.o$New_P, Ump_M= values.o$Ump_M, Ump_P= values.o$Ump_P, Sil_M= values.o$Sil_M, Sil_P= values.o$Sil_P)
  rownames(values) <- order
}

n1<-nrow(values)-1
n2<-ncol(values)-1
key <- c(seq(from = 0.015, to = 0.22, by = (0.205/n1)))
values$key <- key
values <- rbind(values, key)
values <- as.matrix(values)
key <- round(key,2)
colv <- colorRampPalette(c("black", "white"))


# Plot
output.file = paste("plots/",spp, "_fst.pdf", sep = "")
pdf(file = output.file, height = 6.5/2.54, width = 6.5/2.54)
par(mar=c(5,5,5,5), cex= 0.3)
image(x=seq(0,n1+1), y=seq(0,n2+1), col=colv(1000), z=(-values), axes = F, xlab = "", ylab = "")
axis(1, at = c(0:(n1)), labels = order, las =2)
axis(2, at = c(0:(n1)), labels = order, las =2)
axis(1, at = c(n1+1), labels = c("key"), las =2)
axis(2, at = c(n1+1), labels = c("key"), las =2)
axis(3, at = c(0:(n1)), labels = key, las =2, cex.lab= 0.0001)
axis(4, at = c(0:(n1)), labels = key, las =2, cex.lab= 0.0001)
dev.off();

