# Computing Final

## About
This project scrapes a data off of the NCBI GEO and runs statistical analysis. The analysis seeks to parse out differentially expressed genes between castrated mice and uncastracted mice to determine the effect of androgens on the immune microenvironment. 

### Python Script
This script serves as a web scraper. It isolates the datasets provided on the NCBI GEO website and saves them into a csv file. 

### R Script 
The R script takes the csv file from the Python script and runs a t-test on the two groups (either castrated or uncastrated). It uses the p-values calculated from the t-test along with fold change between the two groups to highlight the up- and down-regulated genes between the datasets through generation of a volcano plot and heatmap. 

## How to use

### Dependencies
Before running, make sure to install `clang` in your environment. 
In macOS, for example, run the following in the terminal:
```
xcode-select --install
```
#### Python packages
* requests
* bs4
* csv
* pandas
* functools
* sys

#### R packages
Uncomment the first few lines as needed to install packages before running the shell script. 
```R
# install.packages("tidyverse")
# install.packages("tidyr")
# install.packages("gplots")    
# install.packages("RColorBrewer")
```

### macOS
In the terminal, navigate to the directory and run the following command:
```bash
sh run.sh
```

### Linux
Run the bash script "run.sh". Something like:
```bash
./run.sh
```


 Computing-Final-Project
# Computing-Final
#Intro-to-Computing-Final
