.libPaths("/home/djprince/programs/R/x86_64-pc-linux-gnu-library/3.0/")
library(ape)

arg = commandArgs()
input = arg[8]
in.file = paste("PCR_tree/", input, ".outtree", sep = "")
tree = read.tree(in.file)
tree = unroot(tree)
tree = compute.brlen(tree,1)

edge.rt=substr(tree$tip.label[tree$edge[,2]],4,4)
edge.clr = sub(edge.rt, pattern = "M", replacement = "blue")
edge.clr = sub(edge.clr, pattern = "P", replacement = "orange")
edge.clr = ifelse(is.na(edge.clr),'black',edge.clr)

output.file = paste("plots/tree_", input, ".pdf", sep = "")
pdf(file=output.file)
plot(tree,
     type="unrooted",
     cex = .5,
     lab4ut ="axial",
     no.margin = T,
     edge.color=edge.clr
     )
dev.off()
