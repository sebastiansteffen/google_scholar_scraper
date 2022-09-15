# Install the tidyverse and polite libraries in case they aren't already installed.
packages <- c("tidyverse", "polite", "magrittr")
install.packages(setdiff(packages, rownames(installed.packages())))  

# Load libraries.
library(tidyverse)
library(polite)
library(magrittr)

# TODO: Replace 'G_SCHOLAR_URL' with the Google Scholar Url you want to scrape.
#       Make sure to include the subdomain (after the /) and queries(after?).
#       To scrape your own Google Scholar, navigate to to scholar.google.com,
#       click on My Profile' and copy the URL.
# TODO: Replace 'IDENTIFICATION' with your name. 
#       It's to be polite to the website and mitigate making too many requests.
#       This only really matters if you scrape multiple Google Scholar Urls.
BASE_URL <- 'G_SCHOLAR_URL'
USER_NAME <- 'IDENTIFICATION'


# Example: Sebastian Steffen's Google Scholar.
# TODO: Comment out the following two lines.
BASE_URL <- 'https://scholar.google.com/citations?user=L_O2kH0AAAAJ&hl=en'
USER_NAME <-  'Sebastian Steffen (BC)'

scrape_google_scholar <- function(base_url){
  # Scrape the entire citation table from the base_url.
  # If you have more than 10000 papers (!!), increase the pagesize value.
  message("Scraping ", base_url)
  # nod to check that the additional queries are allowed and then scrape
  html_doc <- nod(session, base_url) %>% 
    scrape(verbose = TRUE,
           query = list(cstart = 0,
                        pagesize = 10000)) 
  
  # Grab citation table from the html using a CSS selector and clean the columns.
  df_cites <- html_doc %>% html_element('tbody#gsc_a_b') %>% html_table() %>% 
    rename(title = X1, Cites = X2, Year = X3) %>% 
    mutate(Cites = as.numeric(str_remove(string = Cites, pattern = '[^[:digit:]]'))) %T>%
    # Optional sample output.
    print(n = 5)
  
  return(df_cites)
}

# Bow to the website, ask for permission to scrape, and get rate limitations.
session <- bow(
  url = URL,
  user_agent = USER_NAME,  
  force = TRUE
)
print(session)  
  
DF_CITES <- scrape_google_scholar(base_url = BASE_URL)
