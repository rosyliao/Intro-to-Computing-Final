# install packages 
# install.packages("tidyverse")
# install.packages("gplots")    
# install.packages("RColorBrewer")

library(tidyverse)
library(gplots)
library(RColorBrewer)

# import data into R
# choose downloaded python dataset "combined.csv" as an argument
args = commandArgs(trailingOnly=TRUE)
if (length(args) == 0)
{
  stop("At least one argument must be supplied (input csv).")
}

# get current working directory
wd <- getwd()
# and concatenate it
filename <- paste(wd, args[1], sep = "/", collapse = NULL)

# read the CSV file
gene_exp <- read.csv(filename, sep = ",", header = TRUE, stringsAsFactors = FALSE, check.names = FALSE)

# omit NA if present
gene_exp <- na.omit(gene_exp)

# changing column 1 to row name
gene_exp_new <- gene_exp %>% 
  remove_rownames %>% 
  column_to_rownames(var="ID")

# remove zeros if present
gene_exp_new <- gene_exp_new[apply(gene_exp_new[,-1], 1, function(x) !all(x==0)),]

# separate WT and KO
Sham = gene_exp_new[,1:2]
Cast = gene_exp_new[,3:4]

# log2 transform
Sham_log2 = log2(Sham)
Cast_log2 = log2(Cast)
All_log2 = log2(gene_exp_new) #create full dataframe of log2 transformed values for later use 

#calculate means across replicates
Sham_mean = rowMeans(Sham_log2)
Cast_mean = rowMeans(Cast_log2)

# log2 fold change = log2(B)-log2(A)
fold_change = Cast_mean - Sham_mean

# t-test for statistical significance
pvalue = NULL # empty list for the p-values
t = NULL # empty list of the t test statistics

for(i in 1 : nrow(All_log2)) {
  t = t.test(Sham[i,], Cast[i,]) #computing t-test
  pvalue[i] = t$p.value # collect p-values
}

# filter based on fold change and pvalue
filter_by_fold = abs(fold_change) > 2
filter_by_pvalue = pvalue < 0.01

# use both criteria on data
final_filter = filter_by_fold & filter_by_pvalue
filtered_matrix <- as.matrix(All_log2[final_filter, ])	

# create volcano plot and save to PDF
pdf("Up_Down_Volcano.pdf")
volcano <- plot(fold_change, -log10(pvalue), 
          main = "Up and Down Regulation of Genes Following Castration",
          pch = 20,
          xlab = "Log2 Fold Change",
          ylab = "-Log10(P-value)")
          # add points to the plot
          points(fold_change[final_filter & fold_change > 0],
          -log10(pvalue[final_filter & fold_change > 0]),
          pch = 20, 
          col = "red")
          points(fold_change[final_filter & fold_change < 0],
          -log10(pvalue[final_filter & fold_change < 0]),
          pch = 20, 
          col = "green")
          # add a legend 
          legend(3.5, 3.8, c("Upregulated", "Downregulated"), pch = 20, col = c("red", "green"))
dev.off()

# clustering and correlation
dist.pear <- function(x) as.dist(1-cor(t(x)))             #pearson correlation
hclust.ave <- function(x) hclust(x, method = "ward.D2")    #linkage

# generate heatmap and save to a PDF file
pdf("CastrationAndrogen.pdf")
DFE <- heatmap.2(filtered_matrix, 
          distfun=dist.pear, 
          hclustfun=hclust.ave, 
          cexCol=0.75,
          cexRow = 0.5,
          col = redgreen(75), 
          scale = "row",
          key = TRUE,
          keysize = 1,
          margins = c(7,6))
dev.off()

# save filtered genes to txt file 
write.table(filtered_matrix, "Castration_Diff_Exp.txt", col.names = TRUE, row.names = TRUE)

