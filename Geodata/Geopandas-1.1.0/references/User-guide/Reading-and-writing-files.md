# Reading and writing files

## Reading spatial data

GeoPandas can read almost any vector-based spatial data format including ESRI shapefile, GeoJSON files and more using the `geopandas.read_file()` command:

```python
geopandas.read_file(...)
```

which returns a GeoDataFrame object. This is possible because GeoPandas makes use of the massive open-source program called GDAL/OGR designed to facilitate spatial data transformations, through the Python packages Pyogrio or Fiona, which both provide bindings to GDAL.

Any arguments passed to `geopandas.read_file()` after the file name will be passed directly to `pyogrio.read_dataframe()` or `fiona.open()`, which does the actual data importation. In general, `geopandas.read_file()` is pretty smart and should do what you want without extra arguments, but for more help, type:

```python
import pyogrio; help(pyogrio.read_dataframe)
import fiona; help(fiona.open)
```

Among other things, one can explicitly set the driver (shapefile, GeoJSON) with the `driver` keyword, or pick a single layer from a multi-layered file with the `layer` keyword:

```python
countries_gdf = geopandas.read_file("package.gpkg", layer='countries')
```

If you have a file with multiple layers, you can list them using `geopandas.list_layers()`. Note that this function requires Pyogrio.

GeoPandas can also load resources directly from a web URL, for example for GeoJSON files from geojson.xyz:

```python
url = "http://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_110m_land.geojson"
df = geopandas.read_file(url)
```

You can also load ZIP files that contain your data:

```python
zipfile = "zip:///Users/name/Downloads/cb_2017_us_state_500k.zip"
states = geopandas.read_file(zipfile)
```

If the dataset is in a folder in the ZIP file, you have to append its name:

```python
zipfile = "zip:///Users/name/Downloads/gadm36_AFG_shp.zip!data"
```

If there are multiple datasets in a folder in the ZIP file, you also have to specify the filename:

```python
zipfile = "zip:///Users/name/Downloads/gadm36_AFG_shp.zip!data/gadm36_AFG_1.shp"
```

It is also possible to read any file-like objects with a `read()` method, such as a file handler (e.g. via built-in `open()` function) or `StringIO`:

```python
filename = "test.geojson"
file = open(filename)
df = geopandas.read_file(file)
```

File-like objects from `fsspec` can also be used to read data, allowing for any combination of storage backends and caching supported by that project:

```python
path = "simplecache::http://download.geofabrik.de/antarctica-latest-free.shp.zip"
with fsspec.open(path) as file:
    df = geopandas.read_file(file)
```

You can also read path objects:

```python
import pathlib
path_object = pathlib.Path(filename)
df = geopandas.read_file(path_object)
```

### Using Arrow for faster reading

For faster data reading, pass `use_arrow=True` when using the default pyogrio engine. This can be 2-4 times faster than the default reading behavior and works with all drivers. See `pyogrio.read_dataframe` for full details.

It is also possible to enable this by default by setting the environment variable `PYOGRIO_USE_ARROW=1` (which will also enable writing data using arrow).

> **Note:** This requires the `pyarrow` dependency to exist in your environment.

### Reading subsets of the data

Since geopandas is powered by GDAL, you can take advantage of pre-filtering when loading in larger datasets. This can be done geospatially with a geometry or bounding box. You can also filter rows loaded with a slice. Read more at `geopandas.read_file()`.

#### Geometry filter

The geometry filter only loads data that intersects with the geometry.

```python
import geodatasets

gdf_mask = geopandas.read_file(
    geodatasets.get_path("geoda.nyc")
)
gdf = geopandas.read_file(
    geodatasets.get_path("geoda.nyc education"),
    mask=gdf_mask[gdf_mask.name=="Coney Island"],
)
```

#### Bounding box filter

The bounding box filter only loads data that intersects with the bounding box.

```python
bbox = (
    1031051.7879884212, 224272.49231459625, 1047224.3104931959, 244317.30894023244
)
gdf = geopandas.read_file(
    geodatasets.get_path("nybb"),
    bbox=bbox,
)
```

#### Row filter

Filter the rows loaded in from the file using an integer (for the first n rows) or a slice object.

```python
gdf = geopandas.read_file(
    geodatasets.get_path("geoda.nyc"),
    rows=10,
)
gdf = geopandas.read_file(
    geodatasets.get_path("geoda.nyc"),
    rows=slice(10, 20),
)
```

#### Field/column filters

Load in a subset of fields from the file using the `columns` keyword (this requires pyogrio or Fiona 1.9+):

```python
gdf = geopandas.read_file(
    geodatasets.get_path("geoda.nyc"),
    columns=["name", "rent2008", "kids2000"],
)
```

Skip loading geometry from the file:

> **Note:** Returns `pandas.DataFrame`

```python
pdf = geopandas.read_file(
    geodatasets.get_path("geoda.nyc"),
    ignore_geometry=True,
)
```

#### SQL WHERE filter

> Added in version 0.12. Requires Fiona 1.9+ or the pyogrio engine.

Load in a subset of data with a SQL WHERE clause.

```python
gdf = geopandas.read_file(
    geodatasets.get_path("geoda.nyc"),
    where="subborough='Coney Island'",
)
```

### Supported drivers / file formats

When using pyogrio, all drivers supported by the GDAL installation are enabled, and you can check those with:

```python
import pyogrio; pyogrio.list_drivers()
```

where the values indicate whether reading, writing or both are supported for a given driver. Fiona only exposes a default subset of drivers. To display those, type:

```python
import fiona; fiona.supported_drivers
```

There is a list of available drivers which are unexposed by default but may be supported (depending on the GDAL-build). You can activate these at runtime by updating the supported_drivers dictionary like:

```python
fiona.supported_drivers["NAS"] = "raw"
```

## Writing spatial data

GeoDataFrames can be exported to many different standard formats using the `geopandas.GeoDataFrame.to_file()` method. For a full list of supported formats, type `import pyogrio; pyogrio.list_drivers()`.

In addition, GeoDataFrames can be uploaded to PostGIS database (starting with GeoPandas 0.8) by using the `geopandas.GeoDataFrame.to_postgis()` method.

> **Note:** For faster data writing, pass `use_arrow=True` when using the default pyogrio engine. This can be 2-4 times faster than the default writing behavior and works with all drivers. See `pyogrio.write_dataframe` for full details. This requires the `pyarrow` dependency to exist in your environment.

> **Note:** GeoDataFrame can contain more field types than supported by most of the file formats. For example tuples or lists can be easily stored in the GeoDataFrame, but saving them to e.g. GeoPackage or Shapefile will raise a ValueError. Before saving to a file, they need to be converted to a format supported by a selected driver.

> **Note:** One GeoDataFrame can contain multiple geometry (GeoSeries) columns, but most standard GIS file formats, e.g. GeoPackage or ESRI Shapefile, support only a single geometry column. To store multiple geometry columns, non-active GeoSeries need to be converted to an alternative representation like well-known text (WKT) or well-known binary (WKB) before saving to file. Alternatively, they can be saved as an Apache (Geo)Parquet or Feather file, both of which support multiple geometry columns natively.

Writing to Shapefile:

```python
countries_gdf.to_file("countries.shp")
```

Writing to Shapefile via Arrow:

```python
countries_gdf.to_file("countries.shp", use_arrow=True)
```

Writing to GeoJSON:

```python
countries_gdf.to_file("countries.geojson", driver='GeoJSON')
```

Writing to GeoPackage:

```python
countries_gdf.to_file("package.gpkg", layer='countries', driver="GPKG")
cities_gdf.to_file("package.gpkg", layer='cities', driver="GPKG")
```

Writing with multiple geometry columns:

```python
countries_gdf["country_center"] = countries_gdf["geometry"].centroid

# Line below fails because GeoJSON can't contain multiple geometry columns
# countries_gdf.to_file("countries.geojson", driver='GeoJSON')

countries_gdf["country_center"] = countries_gdf["country_center"].to_wkt()
countries_gdf.to_file("countries.geojson", driver='GeoJSON')
```

For multi-layer formats such as GeoPackage, it is possible to write additional geometry columns to separate layers instead of saving them as WKT or WKB within a single layer.

## Spatial databases

GeoPandas can also get data from a PostGIS database using the `geopandas.read_postgis()` command.

Writing to PostGIS:

```python
from sqlalchemy import create_engine
db_connection_url = "postgresql://myusername:mypassword@myhost:5432/mydatabase"
engine = create_engine(db_connection_url)
countries_gdf.to_postgis("countries_table", con=engine)
```

## Apache Parquet and Feather file formats

> Added in version 0.8.0.

GeoPandas supports writing and reading the Apache Parquet (GeoParquet) and Feather file formats.

Apache Parquet is an efficient, columnar storage format (originating from the Hadoop ecosystem). It is a widely used binary file format for tabular data. The Feather file format is the on-disk representation of the Apache Arrow memory format, an open standard for in-memory columnar data.

The `geopandas.read_parquet()`, `geopandas.read_feather()`, `geopandas.GeoDataFrame.to_parquet()` and `geopandas.GeoDataFrame.to_feather()` methods enable fast roundtrip from GeoPandas to those binary file formats, preserving the spatial information.

> **Note:** The GeoParquet specification is developed at: opengeospatial/geoparquet. By default, the latest version is used when writing files, but older versions can be specified using the `schema_version` keyword. GeoPandas supports reading files encoded using any GeoParquet version.
