# Little Free Pantries Dashboard. 
A tracker for Little Free Pantries (currently, just in the Seattle area). Check it out [here](https://roba.shinyapps.io/lfp-dashboard/). Learn more about the Little Free Pantries project at [littlefreepantries.org](https://www.thelittlefreepantries.org/).

## Data 
The reporting data live in a google sheet (currently, simulated data for development) [here](https://docs.google.com/spreadsheets/d/1EjC43kxctXh82w3DD0XPIbBvmYglxTdpXNppHMm90yk/edit#gid=0). 

The address data live in a google sheet [here](https://docs.google.com/spreadsheets/u/1/d/1iXcz098Cc_RGejIq97JUK0Rj1oDw2QolF5_bNRlG4e4/edit#gid=0). 

Both of these sheets are anonymously viewable. 


## How tos
* How to modify a pantry address: 

First, change the address in the [Addresses google sheet](https://docs.google.com/spreadsheets/u/1/d/1iXcz098Cc_RGejIq97JUK0Rj1oDw2QolF5_bNRlG4e4/edit#gid=0). Then, go to the survey/reporting data, and recode all of the records with the previous address (what you changed from) to the new address (what you changed it to). If this second step is not done, the old records will no longer show up in the app. Finally, change the address value in the data collection survey to match the new value. 

* How to add a new pantry: 

First, check the current list to be 100% sure you are not adding a duplicate address with a slightly different format. Add the address in the [Addresses google sheet](https://docs.google.com/spreadsheets/u/1/d/1iXcz098Cc_RGejIq97JUK0Rj1oDw2QolF5_bNRlG4e4/edit#gid=0). Make sure to assign a Neighborhood and a Region using the dropdowns. Additionally, add the new address value in the data collection survey.

* How to add a new region or neighborhood: 

Navigate to the address google sheet, and click on the Neighborhood or Region tab. Add the new value to column A. Note that these regions will not show up in the app until survey data has been collected for an address in these regions. 

* How to request a new feature: 

File a github issue (Issues tab above :arrow_up:) 
