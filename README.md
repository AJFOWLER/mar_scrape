## mar_scrape
Scraping monthly activity returns data from NHS England


#### first functions added:
*find_excels_MAR* - which finds all .xls sheets on the NHS England Monthly Activity Return site.

*get_main_MAR* - which takes the output of find_excels_MAR and returns the main 'timeseries'. This is updated monthly.


#### Things to do:
_dl files:
* test commissioner/provider versions, should we allow **both**?
* add years to download
* need some verification mechanism to ensure what is downloaded is what is expected

_cl files:
* everything