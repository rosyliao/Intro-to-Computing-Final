# Shell Script to run the scripts

# clean up CSVs before running
find . -name \*.csv -delete

# set file name
name="combined.csv"

# first run python script
python web_scraper.py $name

# then run R script
Rscript gene_exp_profiling.R $name

# clean up CSVs after
find . -name \*.csv -delete