import requests as rq
from bs4 import BeautifulSoup
import csv
import pandas as pd
import functools
import sys

def extract_data(html, name):
    # take the html, parse it into a BeautifulSoup
    # object that we can navigate
    soup = BeautifulSoup(html, "html.parser")
    # data is contained inside the html tag <pre>
    data_container = soup.find_all("pre")
    # print(data_container)
    if len(data_container) == 1:
        # access the first (and only) element
        element = data_container[0]
        big_string = str(element)
        # print(element)
        #get the headings, which should be in the <strong> tags
        f = csv.writer(open(str(name) + ".csv", "w"))
        f.writerow(["ID", name])
        # read html
        lines = big_string.split('\n')
        for line in lines:
            # print(line)
            split_by_tab = line.split("\t")
            # print(split_by_space)
            if len(split_by_tab) == 2:
                if line[0] != "<": #ensure we are not in an HTML tag
                    f.writerow(split_by_tab)
        #print(element)
    else:
        print("Error: bad search criteria for HTML.")


def get_data():
    # first, initialize list of names we want
    names = ["GSM1327039",
             "GSM1327040",
             "GSM1327041",
             "GSM1327042"] 
    base_url = "https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?view=data&acc="
    for name in names:
        print("Retrieving {0}".format(name))
        response = rq.get(base_url + name)
        html = response.text
        extract_data(html, name)
        print("Created {0}.csv".format(name))
        print("----------------")




def main():
    # the main function tells the interpreter where to start execution
    if len(sys.argv) != 2:
        print("Need to specify output file as argument.")
    else:
        file_name = sys.argv[1]
        get_data()
        files = ["GSM1327039.csv", "GSM1327040.csv", "GSM1327041.csv", "GSM1327042.csv"] 
        dataframes = [ pd.read_csv( f ) for f in files ] # add arguments as necessary to the read_csv method
        merged = functools.reduce(lambda left,right: pd.merge(left,right,on="ID", how="outer"), dataframes) 
        merged.to_csv(file_name, index=False)


if __name__ == "__main__":
    main()

















