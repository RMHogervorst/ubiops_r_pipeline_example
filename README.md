# A ubiops R pipeline
This is a quick project that only contains the three deployment zips of a pipeline. 

I worked through the webinterface for this project 
but you could do it with the CLI or client packages too. 


This is a pipeline that combines three packages 

* test-set-creator
* winepredictr
* scorer

In short:
the testset creates a subset of the red-wine dataset without the quality score 
The winepredictr uses a previously trained model to predict quality of wines given their features, and returns a dataset with predicted quality 
The scorer takes the results, matches them to a testset and calculates the performance. 