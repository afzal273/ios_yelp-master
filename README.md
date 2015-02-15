# Project: Yelp


This is an iOS demo application for displaying the latest box office movies using the [RottenTomatoes API](http://www.rottentomatoes.com/). 

Time spent: About 15 hours in total

Completed user stories:


Search results page

* [x] Required: Table rows should be dynamic height according to the content height
* [x] Required: Custom cells should have the proper Auto Layout constraints
* [x] Required: Search bar should be in the navigation bar 
* [ ] Optional: Infinite scroll for restaurant results
* [ ] Optional: Implement map view of restaurant results



Filter page. 

* [x] Required: The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
* [x] Required: The filters table should be organized into sections as in the mock.
* [x] Required: Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
* [ ] Optional: Implement a custom switch
* [ ] Optional: Radius filter should expand as in the real Yelp app
* [ ] Optional: Categories should show a subset of the full list with a "See All" row to expand.
* [ ] Optional: Implement the restaurant detail page.


Notes:

Spent a lot of time getting the table to scroll.
Also spent quite a bit of time getting the search to work and removing search related bugs.

Tried using AFNetworking for images fading in but couldn't figure out the block syntax to make it work :-/
Didn't get around to implementing segmented control to switch between list and grid views.

I had ideas on making the UI cleaner and updating labels to show relevant info in the table and detail views, 
but I only implemted as much as possible before the deadline.

This was a great learning experience, learnt about table views, asynchronous loading, putting a cell in table view, tab bar.

3rd party libraries used:

SVProgressHUD
AFNetworking


Walkthrough of all user stories:

![Video Walkthrough](rotten_tomatoes_demo.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

