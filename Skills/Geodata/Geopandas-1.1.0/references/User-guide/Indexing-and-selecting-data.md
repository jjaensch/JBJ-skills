# Indexing and selecting data

GeoPandas inherits the standard pandas methods for indexing/selecting data. This includes label based indexing with `loc` and integer position based indexing with `iloc`, which apply to both GeoSeries and GeoDataFrame objects. For more information on indexing/selecting, see the pandas documentation.

In addition to the standard pandas methods, GeoPandas also provides coordinate based indexing with the `cx` indexer, which slices using a bounding box. Geometries in the GeoSeries or GeoDataFrame that intersect the bounding box will be returned.

Using the `geoda.chile_labor` dataset, you can use this functionality to quickly select parts of Chile whose boundaries extend south of the -50 degrees latitude. You can first check the original GeoDataFrame:

```python
import geodatasets

chile = geopandas.read_file(geodatasets.get_path('geoda.chile_labor'))

chile.plot(figsize=(8, 8));
```
<!-- Image: chile.png -->

And then select only the southern part of the country:

```python
southern_chile = chile.cx[:, :-50]

southern_chile.plot(figsize=(8, 8));
```
<!-- Image: chile_southern.png -->
