# Migration from the Fiona to the Pyogrio Read/Write Engine

Since version 0.11, GeoPandas started supporting two engines to read and write files: [Fiona](https://fiona.readthedocs.io/) and [Pyogrio](https://pyogrio.readthedocs.io/).

It became possible to choose the engine using the `engine=` parameter in `geopandas.read_file()` and `geopandas.GeoDataFrame.to_file()`. It also became possible to change the default engine globally with:

```python
geopandas.options.io_engine = "pyogrio"
```

For GeoPandas versions < 1.0, the default was Fiona. Starting from GeoPandas version 1.0, the global default changed from Fiona to Pyogrio.

The main reason for this change is performance. Pyogrio is optimized for the use case relevant for GeoPandas: reading and writing in bulk. Because of this, in many cases speedups of >5–20x can be observed.

This guide outlines the (known) functional differences between both, so you can account for them when switching to Pyogrio.

---

## Write an Attribute Table to a File

Using the Fiona engine, it was possible to write an attribute table (a table without geometry column) to a file using the `schema` parameter to specify that the "geometry" column of a GeoDataFrame should be ignored.

With Pyogrio you can write an attribute table by using `pyogrio.write_dataframe()` and passing a pandas DataFrame to it:

```python
import pyogrio

df = pd.DataFrame({"data_column": [1, 2, 3]})
pyogrio.write_dataframe(df, "test_attribute_table.gpkg")
```

---

## No Support for `schema` Parameter to Write Files

Pyogrio does not support specifying the `schema` parameter to write files. This means it is not possible to specify the types of attributes being written explicitly.

---

## Writing EMPTY Geometries

Pyogrio writes EMPTY and `None` geometries as such to e.g. GPKG files; Fiona writes both as `None`.

```python
import shapely

gdf = geopandas.GeoDataFrame(geometry=[shapely.Polygon(), None], crs=31370)

gdf.to_file("test_fiona.gpkg", engine="fiona")
gdf.to_file("test_pyogrio.gpkg", engine="pyogrio")
```

```python
geopandas.read_file("test_fiona.gpkg").head()
```

```
  geometry
0     None
1     None
```

```python
geopandas.read_file("test_pyogrio.gpkg").head()
```

```
        geometry
0  POLYGON EMPTY
1           None
```
