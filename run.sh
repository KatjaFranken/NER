#!/bin/bash 

#Start by cleaning up the file from any weird characters
for x in *ner.xml ; do perl removeNonUTFChars.pl $x > ${x%.xml}.noNonUTF.xml ; done 

# To gather the stats for the geographical features, first concatenate all files
# then select only those tokens that are capitalised (to not use up your GeoNames 
# query limit with terms that are not locations) 
for x in *noNonUTF.xml ; do cat $x >> noNonUTFconcatenated ; done 
perl selectTokensForGeoLookup.pl noNonUTFconcatenated > TokensForGeoNamesQuery

# query GeoNames
perl queryGeoNames.pl TokensForGeoNamesQuery GeoFeatures 

# Clean up
rm noNonUTFconcatenated 

# Make sure you are not concatenating your output to a previously generated output file
if [ -f EuropeanaMetadata.csv ];
then
    rm EuropeanaMetadata.csv
fi

# Create the tab separated input file 
for x in *noNonUTF.xml ; do perl createFeatureInstances.pl $x >> EuropeanaMetadata.csv ; done  