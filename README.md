La Quinta is Spanish for next to Denny's
---

<br/>

![dennys next to la quinta](hedberg.jpg?raw=1)

<br/>

## Background

This observation is a joke made famous by the late comedian Mitch Hedberg. Several years ago, John Reiser on his [blog](http://njgeo.org/2014/01/30/mitch-hedberg-and-gis/) detailed an approach to assess how true this joke actually is by scraping location data for all US locations of La Quinta and Denny's. Your goal will be to recreate this analysis within R and expand on both the data collection and analysis.

<br/>

## Task 1 - Scraping Denny's

Scraping the Denny's site involves the traversal of a hierarchical series of location and restaurant pages starting with the state level page at [locations.dennys.com](http://locations.dennys.com). Your initial task will be to scrape this page identifying the links for each state page, following those links will provide additional pages containing links to sub-regional / city pages as well as  individual restaurant pages. By continuing to traverse these pages your eventual goal is to locate and download all of the restaurant pages into the `data/dennys/` folder. All of the code to accomplish this should be included in your `get_dennys.R` script.

Once the restaurant pages are downloaded you will write a second script, `parse_dennys.R`, which should read in each of these files and parse / scrape the relevant details for each of these restaurants and construct a tidy data frame containing the results for all of the restaurants. The data frame should be saved as `dennys.rds` in `data/`. For each restaurant you must extract the latitude and longitude as well as the address and phone number. Additional credit will be given for scraping open hours, additional amenities, and other useful data you can find on the pages.

This data collection must be constructed in a reproducible fashion - all web pages being scraped should be cached locally and each analysis step should be self contained in a separate R script. You will also create a `Makefile` that will run your R scripts and render your report (specifics will be given in Lecture 15). 

Finally, note that you should not abuse this or any other web page or API. Make sure to space out your requests to avoid getting your or the department server's IP banned. We have created a local cache of the Denny's location page [here](http://www2.stat.duke.edu/~cr173/data/dennys/locations.dennys.com/index.html) which you should use for scraping. Note that these mirrors are imperfect, particularly when it comes to styling and javascript components so you may benefit from checking both the original and mirrored page when identifying what to scrape.

Your write up in `hw4.Rmd` should include a discussion of your scraping approach.

<br/>

##  Task 2 - Scraping La Quinta

The original blog post states that the location of all the La Quinta's was obtained via [`hotelMarkers.js`](http://www.lq.com/lq/data/hotelMarkers.js) from La Quinta's website which contained JSON data with the latitude and longitude of each location. Since the time of the blog post La Quinta's website has had a complete overhaul and redesign and as such this file is no longer available.

To make our lives even more complicated, La Quinta's website now makes use of Javascript which makes using tools like rvest more difficult. Similar to the Denny's webite, La Quinta has a location subpage which lists all locations at [wyndhamhotels.com/laquinta/locations](https://www.wyndhamhotels.com/laquinta/locations). These pages can be downloaded and then scraped to obtain the necessary location information and additional details, as with the Denny's data latitude, longitude, address and phone number are all required and additional credit will be given for including other useful data collected from the hotel pages.

Similar to your solution to Scraping Denny's website your code should be separated into two distinct files, `get_lq.R` which downloads the raw data from the website and `parse_lq.R` which tidies and flattens the downloaded data.

Again we have provided a local cache of the La Quinta hotel listing page [here](http://www2.stat.duke.edu/~cr173/data/lq/www.wyndhamhotels.com/laquinta/locations.html) which you should use for scraping.

<br/>

## Task 3 - Distance analysis

Using the results of your scraping you should analyze the veracity of Hedberg's claim. This is left as an open ended exercise - there is not one correct approach. This can include anything from visualizations to tabulations, but will need to be more than just a list of the La Quinta and Denny's pairs that happen to be within an arbitrary radius. Answers should at a minimum describe / visualize the distribution of the minimum distance for each Denny's / La Quinta pair.

Note that this analysis depends on calculating the distance between two spatial locations on a sphere, as such using euclidean distances is *not correct*. Make sure you use an appropriate approach for calculating any distances you use and make sure the units of distance are clearly indicated in your analysis. Also note that the set of distances from all La Quintas to the nearest Denny's is not the same as the set of distances from all Denny's to the nearest La Quinta.

<br/>

## Expected files

For this assignment you will need to create the following files:

* `get_lq.R` - this script should go to the La Quinta website download either a summary resource or each individual hotel page. All of file(s) should be saved into the `data/lq/` directory. If these folders do not exist they should be created.

* `parse_lq.R` - this script should read the saved file(s) in `data/lq/` and construct an appropriate data frame / tibble where each row is a hotel and the columns reflect hotel characteristics (e.g. lat, long, state, amenities). The resulting data frame should be saved as `lq.rds` (using the `saveRDS` function) in the `data/` directory.

* `get_dennys.R` - this script should download the individual restaurant pages from locations page and save the results to `data/dennys/`. If these folders do not exist they should be created.

* `parse_dennys.R` - this script should read all of the saved files in `data/dennys/` and construct an appropriate data frame / tibble where each row is a restaurant with columns for the relevant restaurant characteristics. This data frame should be saved as `dennys.rds` in the `data/` directory.

* `hw4.Rmd` - this document should detail how your group has chosen to implement your various download and parsing scripts. Additionally, it should wholly contain your distance analysis which loads the necessary data directly (and exclusively) from `data/lq.rds` and `data/dennys.rds`.

* `Makefile` - this file will specify the interdependence between your script files and their various products.

<br/>