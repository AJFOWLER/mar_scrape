# functions to download MAR data
# get the main MAR data by month #
' This needs to be altered to take latest iteration of the timeseries'
# find all excel documents on the MAR site
find_excels_MAR = function(type_request = 'commissioner'){
  if(!(type_request %in% c('commissioner', 'provider'))){stop('Type should be a character string of either commissioner or provider, depending on what data is needed')}

  
  
  base_url = 'https://www.england.nhs.uk/statistics/statistical-work-areas/hospital-activity/monthly-hospital-activity/mar-data/'
  # find first .xls with 'Comm-Timeseries'
  library(rvest)

  page = read_html(base_url)
  
  # read the page and extract links.
  a = page %>%
    html_nodes('a') %>% #get links
    html_attr("href") #identify those links
  # find.xls files
  excels = a[which(grepl('\\.xls',a))] # find excel sheets
  return(excels)
}

get_main_MAR = function(excels){
  library(readxl)
  
  mar_dat = excels[grepl('timeseries', tolower(excels))][[1]]
  # will work for current data, historic will be more challenging
  
  temp_f = tempfile()
  #download to temp file
  
  dl_file = download.file(mar_dat, mode='wb', destfile=temp_f)
  #read this sheet
  
  dt = readxl::read_xls(temp_f, sheet=1)
  
  #remove only this temporary file from tempdir()
  file.remove(temp_f)
  
  return(dt)
}

'testing :: get MAR for years and commissioner based'
' Not yet working'

find_MAR_ = function(years, type_request = 'commissioner'){
  
  if(!(type_request %in% c('commissioner', 'provider'))){stop('Type should be a character string of either commissioner or provider, depending on what data is needed')}
  
  # required to process the html_nodes 
  library(rvest)
  
  base_html = 'https://www.england.nhs.uk/statistics/statistical-work-areas/hospital-activity/monthly-hospital-activity/mar-data/'
  
  page = read_html(base_html)
  
  a = page %>%
    html_nodes('a') %>% #get links
    html_attr("href") #identify those links
  
  excels = a[which(grepl('\\.xls',a))] # find excel sheets
  
  # two formats dependeing on if commissioner or provider based
  if(tolower(type) == 'commissioner'){
    relevant_ = excels[grepl('MAR_Comm', excels)]  
  }else(tolower(type) == 'provider'){
    relevant_ = excels[grepl('MAR_Prov', excels)]
  }
  
  # year iterations are either whole year or final dyad with '_' or '-' after #
  # this processing could sit in its own sub function
  years_ = do.call(paste0, list(years, '_'))
  years_h = do.call(paste0, list(years, '-'))
  dyad_ = do.call(paste0, list(substr(years, 3, 4), '_'))
  dyad_h = do.call(paste0, list(substr(years, 3, 4), '-'))
  any = do.call(paste, list(c(years_, years_h, dyad_, dyad_h), collapse= '|'))
  
  # now select relevants
  relevant_years = excels[grepl(any, excels)]
  
  return(relevant_years)
}