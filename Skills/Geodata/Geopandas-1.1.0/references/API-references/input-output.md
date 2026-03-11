# Input/output

## GIS vector files
|Code|Functionality|
|---|---|
|list_layers(filename)| List layers available in a file.|
|read_file(filename[, bbox, mask, columns, ...])| Returns a GeoDataFrame from a file or URL.|
|GeoDataFrame.to_file(filename[, driver, ...])| Write the GeoDataFrame to a file.|

## PostGIS
|Code|Functionality|
|---|---|
|read_postgis(sql, con[, geom_col, crs, ...])| Returns a GeoDataFrame corresponding to the result of the query string, which must contain a geometry column in WKB representation.|
|GeoDataFrame.to_postgis(name, con[, schema, ...])| Upload GeoDataFrame into PostGIS database.|

## Feather
|Code|Functionality|
|---|---|
|read_feather(path[, columns, to_pandas_kwargs])| Load a Feather object from the file path, returning a GeoDataFrame.|
|GeoDataFrame.to_feather(path[, index, ...])| Write a GeoDataFrame to the Feather format.|

## Parquet
|Code|Functionality|
|---|---|
|read_parquet(path[, columns, ...])| Load a Parquet object from the file path, returning a GeoDataFrame.|
|GeoDataFrame.to_parquet(path[, index, ...])| Write a GeoDataFrame to the Parquet format.|
