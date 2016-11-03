#! /usr/bin/make -f

PG=psql service=lakes

# We need the California Counties, since this is in github, we can use bower to install it.
caco.shp:=bower_components/california-counties/shp/california_counties.shp
${caco.shp}:version:=v1.0.0
${caco.shp}:tgz:=v1.0.0.tar.gz
${caco.shp}:git:=https://github.com/CSTARS/california-counties/archive
${caco.shp}:
	bower install CSTARS/california-counties#1.0.0


# Lakes from California DFW
lakes.shp:=CA_Lakes.shp
${lakes.shp}:zip:=CA_Lakes.zip
${lakes.shp}:base:=ftp://ftp.wildlife.ca.gov/BDB/GIS/California_Lakes
${lakes.shp}:
	[[ -f ${zip} ]] || wget ${base}/${zip}
	unzip ${zip}


fed_lakes.shp:=hydrogp020.shp
${fed_lakes.shp}:tgz:=hydrogm020_nt00015.tar.gz
${fed_lakes.shp}:base:=https://prd-tnm.s3.amazonaws.com/StagedProducts/Small-scale/data/Hydrography
${fed_lakes.shp}:
	[[ -f ${tgz} ]] || wget ${base}/${tgz}
	tar -xzf ${tgz}

# We will do our processing in postgis, so upload to there
postgis:: ${caco.shp} ${fed_lakes.shp}
	shp2pgsql -d -s4269:3310 -g boundary ${fed_lakes.shp} fed_lakes | ${PG}
	shp2pgsql -d -s3310 -g boundary ${caco.shp} counties | ${PG}
	shp2pgsql -d -s3310 -g boundary ${lakes.shp} lakes | ${PG}
	${PG} -f lake-density.sql


clean:
	rm -rf bower_components hydrogp020*
	rm -f `unzip -qq -l CA_Lakes.zip | tr -s ' ' | cut -d' ' -f 5`
