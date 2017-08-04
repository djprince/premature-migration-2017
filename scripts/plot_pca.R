# Usage: Rscript -i infile.covar -s spp -c component1-component2 -a annotation.file -o outfile.eps
.libPaths("/home/djprince/programs/R/x86_64-pc-linux-gnu-library/3.0/")
library(optparse)
library(ggplot2)

option_list <- list(make_option(c('-i','--in_file'), action='store', type='character', default=NULL, help='Input file (output from ngsCovar)'),
                    make_option(c('-c','--comp'), action='store', type='character', default=1-2, help='Components to plot'),
                    make_option(c('-s','--spp'), action='store', type='character', default=NULL, help='Species (either St or Ch)'),
                    make_option(c('-a','--annot_file'), action='store', type='character', default=NULL, help='Annotation file with individual classification (2 column TSV with ID and ANNOTATION)'),
                    make_option(c('-o','--out_file'), action='store', type='character', default=NULL, help='Output file')
)
opt <- parse_args(OptionParser(option_list = option_list))
spp <- opt$spp
covar <- read.table(opt$in_file, stringsAsFact=F)
annot <- read.table(opt$annot_file, sep="\t", header=T)
comp <- as.numeric(strsplit(opt$comp, "-", fixed=TRUE)[[1]])
                   
                   
eig <- eigen(covar, symm=TRUE)
eig$val <- eig$val/sum(eig$val)
cat(signif(eig$val, digits=3)*100,"\n")
PC <- as.data.frame(eig$vectors)
colnames(PC) <- gsub("V", "PC", colnames(PC))
PC$LOC <- factor(annot$CLUSTER)
PC$RT <- factor(annot$IDVAR)
PC$IND <- factor(annot$FID)
if(spp == "St"){
ggplot() + theme_bw(base_size=6) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), legend.justification=c(1,1), legend.box.just= "left", legend.text.align =0, legend.position=c(1,1), legend.key = element_blank(), legend.background = element_rect(fill="transparent"), legend.text=element_text(size=5), legend.title=element_text(size=6.75)) +
  geom_point(data=PC, size =2,
             aes_string(x=paste("PC",comp[1],sep=""), y=paste("PC",comp[2],sep=""), 
                        color="LOC", 
                        shape="RT")) +
  xlab(label = paste("PC",comp[1])) +
  ylab(label = paste("PC",comp[2])) +
  scale_color_manual("Steelhead ESU (Location)",breaks = c("Sil", "Ump","New","Eel","Sco"), values = c('Sco' = '#4daf4a','Eel' = '#ff7f00','New' = '#e41a1c', 'Sil' = '#984ea3', 'Ump' = '#377eb8'), 
                     labels = c("ORC (Siletz River)", "ORC (North Umpqua River)", "KMP (New River)","NCC (Eel River)", "CCC (Scott Creek)")) +
  scale_shape_manual("Migration Timing", breaks = c("P", "M"), values = c('P'= 17, 'M' = 16), labels = c("Premature", "Mature"))
} else if (spp == "Ch") {
  ggplot() + theme_bw(base_size=6) + 
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), legend.justification=c(1,1), legend.box.just= "left", legend.text.align =0, legend.position=c(1,1), legend.key = element_blank(), legend.background = element_rect(fill="transparent"), legend.text=element_text(size=5), legend.title=element_text(size=6.75)) +
    geom_point(data=PC, size =2,
               aes_string(x=paste("PC",comp[1],sep=""), y=paste("PC",comp[2],sep=""), 
                          color="LOC", 
                          shape="RT")) +
    xlab(label = paste("PC",comp[1])) +
    ylab(label = paste("PC",comp[2])) +
    scale_color_manual("Chinook ESU (Location)",breaks = c("Noo", "Puy", "Sil","Nor", "Sou", "Rog","Sal","Tri","Eel"), 
                       values = c('Noo' = '#a65628','Puy' = '#f781bf', 'Sil' = '#984ea3', 'Nor' = '#377eb8', 'Sou' = '#9BBEDC', 'Rog' = '#4daf4a', 'Sal' = '#ffd700', 'Tri' = '#e41a1c','Eel' = '#ff7f00'), 
                       labels = c("PS (Nooksack River)", "PS (Puyallup River)", "OC (Siletz River)","OC (North Umpqua River)", "OC (South Umpqua River)", "SONCC (Rogue River)", "UKTR (Salmon River)", "UKTR (Trinity River)", "CC (Eel River)")) +
    scale_shape_manual("Migration Timing", breaks = c("P", "M"), values = c('P'= 17, 'M' = 16), labels = c("Premature", "Mature"))
  
}
ggsave(opt$out_file)
unlink("Rplots.pdf", force=TRUE)

