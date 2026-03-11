# GeoDataFrame
A GeoDataFrame is a tabular data structure that contains at least one GeoSeries column storing geometry.

## Constructor
|Code|Functionality|
|---|---|
|GeoDataFrame([data, geometry, crs])| A GeoDataFrame object is a pandas.DataFrame that has one or more columns containing geometry.|

## Serialization / IO / conversion
|Code|Functionality|
|---|---|
|GeoDataFrame.from_file(filename, **kwargs)| Alternate constructor to create a GeoDataFrame from a file.|
|GeoDataFrame.from_features(features[, crs, ...])| Alternate constructor to create GeoDataFrame from an iterable of features or a feature collection.|
|GeoDataFrame.from_postgis(sql, con[, ...])| Alternate constructor to create a GeoDataFrame from a sql query containing a geometry column in WKB representation.|
|GeoDataFrame.from_arrow(table[, geometry, ...])| Construct a GeoDataFrame from a Arrow table object based on GeoArrow extension types.|
|GeoDataFrame.to_file(filename[, driver, ...])| Write the GeoDataFrame to a file.|
|GeoDataFrame.to_json([na, show_bbox, ...])| Returns a GeoJSON representation of the GeoDataFrame as a string.|
|GeoDataFrame.to_geo_dict([na, show_bbox, ...])| Returns a python feature collection representation of the GeoDataFrame as a dictionary with a list of features based on the __geo_interface__ GeoJSON-like specification.|
|GeoDataFrame.to_parquet(path[, index, ...])| Write a GeoDataFrame to the Parquet format.|
|GeoDataFrame.to_arrow(*[, index, ...])| Encode a GeoDataFrame to GeoArrow format.|
|GeoDataFrame.to_feather(path[, index, ...])| Write a GeoDataFrame to the Feather format.|
|GeoDataFrame.to_postgis(name, con[, schema, ...])| Upload GeoDataFrame into PostGIS database.|
|GeoDataFrame.to_wkb([hex])| Encode all geometry columns in the GeoDataFrame to WKB.|
|GeoDataFrame.to_wkt(**kwargs)| Encode all geometry columns in the GeoDataFrame to WKT.|

## Projection handling
|Code|Functionality|
|---|---|
|GeoDataFrame.crs| The Coordinate Reference System (CRS) represented as a pyproj.CRS object.|
|GeoDataFrame.set_crs([crs, epsg, inplace, ...])| Set the Coordinate Reference System (CRS) of the GeoDataFrame.|
|GeoDataFrame.to_crs([crs, epsg, inplace])| Transform geometries to a new coordinate reference system.|
|GeoDataFrame.estimate_utm_crs([datum_name])| Returns the estimated UTM CRS based on the bounds of the dataset.|

## Active geometry handling
|Code|Functionality|
|---|---|
|GeoDataFrame.rename_geometry(col[, inplace])| Renames the GeoDataFrame geometry column to the specified name.|
|GeoDataFrame.set_geometry(col[, drop, ...])| Set the GeoDataFrame geometry using either an existing column or the specified input.|
|GeoDataFrame.active_geometry_name| Return the name of the active geometry column|

## Aggregating and exploding
|Code|Functionality|
|---|---|
|GeoDataFrame.dissolve([by, aggfunc, ...])| Dissolve geometries within groupby into single observation.|
|GeoDataFrame.explode([column, ignore_index, ...])| Explode multi-part geometries into multiple single geometries.|

## Spatial joins
|Code|Functionality|
|---|---|
|GeoDataFrame.sjoin(df[, how, predicate, ...])| Spatial join of two GeoDataFrames.|
|GeoDataFrame.sjoin_nearest(right[, how, ...])| Spatial join of two GeoDataFrames based on the distance between their geometries.|

## Overlay operations
|Code|Functionality|
|---|---|
|GeoDataFrame.clip(mask[, keep_geom_type, sort])| Clip points, lines, or polygon geometries to the mask extent.|
|GeoDataFrame.overlay(right[, how, ...])| Perform spatial overlay between GeoDataFrames.|

## Plotting
|Code|Functionality|
|---|---|
|GeoDataFrame.explore(*args, **kwargs)| Interactive map based on GeoPandas and folium/leaflet.js|
|GeoDataFrame.plot| alias of GeoplotAccessor|

## Spatial index
|Code|Functionality|
|---|---|
|GeoDataFrame.sindex| Generate the spatial index|
|GeoDataFrame.has_sindex| Check the existence of the spatial index without generating it.|

## Indexing
|Code|Functionality|
|---|---|
|GeoDataFrame.cx| Coordinate based indexer to select by intersection with bounding box.|

## Interface
|Code|Functionality|
|---|---|
|GeoDataFrame.__geo_interface__| Returns a GeoDataFrame as a python feature collection.|
|GeoDataFrame.iterfeatures([na, show_bbox, ...])| Returns an iterator that yields feature dictionaries that comply with __geo_interface__|

All pandas DataFrame methods are also available, although they may not operate in a meaningful way on the geometry column. All methods listed in GeoSeries work directly on an active geometry column of GeoDataFrame.
