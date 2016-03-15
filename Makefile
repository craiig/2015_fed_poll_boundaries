
all:

#sourced from: http://geogratis.gc.ca/api/en/nrcan-rncan/ess-sst/157fcaf7-e1f7-4f6d-8fc9-564ec925c1ee.html?pk_campaign=recentItem
pd338.2015.zip:
	wget http://ftp2.cits.rncan.gc.ca/pub/geott/electoral/2015/pd338.2015.zip

pd338.2015/%:
	unzip pd338.2015.zip -d pd338.2015/

ridings.csv: ./pd338.2015/PD_A.shp
	-rm $@
	ogr2ogr -f "CSV" $@ pd338.2015/PD_A.shp -sql "SELECT distinct fed_num from PD_A"

.PHONY: allkml
kml: ridings.csv
	mkdir -p kml
	make $(patsubst %,kml/%.kml,$(shell tail -n+2 ridings.csv))

kml/%.kml: ./pd338.2015/PD_A.shp
	ogr2ogr -f "KML" -where "fed_num = '$*'" $@ $^ 
