# Set Operations with Overlay

When working with multiple spatial datasets — especially multiple polygon or line datasets — users often wish to create new shapes based on places where those datasets overlap (or don't overlap). These manipulations are often referred to using the language of sets — intersections, unions, and differences. These types of operations are made available in the GeoPandas library through the `overlay()` method.

The basic idea is demonstrated by the graphic below but keep in mind that overlays operate at the DataFrame level, not on individual geometries, and the properties from both are retained. In effect, for every shape in the left `GeoDataFrame`, this operation is executed against every other shape in the right `GeoDataFrame`:

<!-- Image: overlay_operations.png -->

> **Note:** Note to users familiar with the shapely library: `overlay()` can be thought of as offering versions of the standard shapely set operations that deal with the complexities of applying set operations to two GeoSeries. The standard shapely set operations are also available as `GeoSeries` methods.

---

## The Different Overlay Operations

First, create some example data:

```python
from shapely.geometry import Polygon

polys1 = geopandas.GeoSeries([Polygon([(0,0), (2,0), (2,2), (0,2)]),
                              Polygon([(2,2), (4,2), (4,4), (2,4)])])

polys2 = geopandas.GeoSeries([Polygon([(1,1), (3,1), (3,3), (1,3)]),
                              Polygon([(3,3), (5,3), (5,5), (3,5)])])

df1 = geopandas.GeoDataFrame({'geometry': polys1, 'df1': [1, 2]})
df2 = geopandas.GeoDataFrame({'geometry': polys2, 'df2': [1, 2]})
```

These two GeoDataFrames have some overlapping areas:

```python
ax = df1.plot(color='red')
df2.plot(ax=ax, color='green', alpha=0.5)
```

<!-- Image: overlay_example.png -->

The `overlay()` method will determine the set of all individual geometries from overlaying the two input GeoDataFrames. This result covers the area covered by the two input GeoDataFrames, and also preserves all unique regions defined by the combined boundaries of the two GeoDataFrames.

> **Note:** For historical reasons, the overlay method is also available as a top-level function `overlay()`. It is recommended to use the method as the function may be deprecated in the future.

### Union

When using `how='union'`, all those possible geometries are returned:

```python
res_union = df1.overlay(df2, how='union')
res_union
```

```
   df1  df2                                           geometry
0  1.0  1.0                POLYGON ((2 2, 2 1, 1 1, 1 2, 2 2))
1  2.0  1.0                POLYGON ((2 2, 2 3, 3 3, 3 2, 2 2))
2  2.0  2.0                POLYGON ((4 4, 4 3, 3 3, 3 4, 4 4))
3  1.0  NaN      POLYGON ((2 0, 0 0, 0 2, 1 2, 1 1, 2 1, 2 0))
4  2.0  NaN  MULTIPOLYGON (((3 4, 3 3, 2 3, 2 4, 3 4)), ((4...
5  NaN  1.0  MULTIPOLYGON (((2 3, 2 2, 1 2, 1 3, 2 3)), ((3...
6  NaN  2.0      POLYGON ((3 5, 5 5, 5 3, 4 3, 4 4, 3 4, 3 5))
```

```python
ax = res_union.plot(alpha=0.5, cmap='tab10')
df1.plot(ax=ax, facecolor='none', edgecolor='k')
df2.plot(ax=ax, facecolor='none', edgecolor='k')
```

<!-- Image: overlay_example_union.png -->

### Intersection

With `how='intersection'`, it returns only those geometries that are contained by both GeoDataFrames:

```python
res_intersection = df1.overlay(df2, how='intersection')
res_intersection
```

```
   df1  df2                             geometry
0    1    1  POLYGON ((2 2, 2 1, 1 1, 1 2, 2 2))
1    2    1  POLYGON ((2 2, 2 3, 3 3, 3 2, 2 2))
2    2    2  POLYGON ((4 4, 4 3, 3 3, 3 4, 4 4))
```

```python
ax = res_intersection.plot(cmap='tab10')
df1.plot(ax=ax, facecolor='none', edgecolor='k')
df2.plot(ax=ax, facecolor='none', edgecolor='k')
```

<!-- Image: overlay_example_intersection.png -->

### Symmetric Difference

`how='symmetric_difference'` is the opposite of `'intersection'` and returns the geometries that are only part of one of the GeoDataFrames but not of both:

```python
res_symdiff = df1.overlay(df2, how='symmetric_difference')
res_symdiff
```

```
   df1  df2                                           geometry
0  1.0  NaN      POLYGON ((2 0, 0 0, 0 2, 1 2, 1 1, 2 1, 2 0))
1  2.0  NaN  MULTIPOLYGON (((3 4, 3 3, 2 3, 2 4, 3 4)), ((4...
2  NaN  1.0  MULTIPOLYGON (((2 3, 2 2, 1 2, 1 3, 2 3)), ((3...
3  NaN  2.0      POLYGON ((3 5, 5 5, 5 3, 4 3, 4 4, 3 4, 3 5))
```

```python
ax = res_symdiff.plot(cmap='tab10')
df1.plot(ax=ax, facecolor='none', edgecolor='k')
df2.plot(ax=ax, facecolor='none', edgecolor='k')
```

<!-- Image: overlay_example_symdiff.png -->

### Difference

To obtain the geometries that are part of `df1` but are not contained in `df2`, you can use `how='difference'`:

```python
res_difference = df1.overlay(df2, how='difference')
res_difference
```

```
                                            geometry  df1
0      POLYGON ((2 0, 0 0, 0 2, 1 2, 1 1, 2 1, 2 0))    1
1  MULTIPOLYGON (((3 4, 3 3, 2 3, 2 4, 3 4)), ((4...    2
```

```python
ax = res_difference.plot(cmap='tab10')
df1.plot(ax=ax, facecolor='none', edgecolor='k')
df2.plot(ax=ax, facecolor='none', edgecolor='k')
```

<!-- Image: overlay_example_difference.png -->

### Identity

With `how='identity'`, the result consists of the surface of `df1`, but with the geometries obtained from overlaying `df1` with `df2`:

```python
res_identity = df1.overlay(df2, how='identity')
res_identity
```

```
   df1  df2                                           geometry
0    1  1.0                POLYGON ((2 2, 2 1, 1 1, 1 2, 2 2))
1    2  1.0                POLYGON ((2 2, 2 3, 3 3, 3 2, 2 2))
2    2  2.0                POLYGON ((4 4, 4 3, 3 3, 3 4, 4 4))
3    1  NaN      POLYGON ((2 0, 0 0, 0 2, 1 2, 1 1, 2 1, 2 0))
4    2  NaN  MULTIPOLYGON (((3 4, 3 3, 2 3, 2 4, 3 4)), ((4...
```

```python
ax = res_identity.plot(cmap='tab10')
df1.plot(ax=ax, facecolor='none', edgecolor='k')
df2.plot(ax=ax, facecolor='none', edgecolor='k')
```

<!-- Image: overlay_example_identity.png -->

---

## Overlay Groceries Example

First, load the Chicago community areas and groceries example datasets:

```python
import geodatasets

chicago = geopandas.read_file(geodatasets.get_path("geoda.chicago_commpop"))
groceries = geopandas.read_file(geodatasets.get_path("geoda.groceries"))

# Project to CRS that uses meters as distance measure
chicago = chicago.to_crs("ESRI:102003")
groceries = groceries.to_crs("ESRI:102003")
```

To illustrate the `overlay()` method, consider the following case in which one wishes to identify the "served" portion of each area — defined as areas within 1km of a grocery store — using a `GeoDataFrame` of community areas and a `GeoDataFrame` of groceries.

```python
chicago.plot()
```

<!-- Image: chicago_basic.png -->

```python
# Now buffer groceries to find area within 1km
groceries['geometry'] = groceries.buffer(1000)
groceries.plot()
```

<!-- Image: groceries_buffers.png -->

To select only the portion of community areas within 1km of a grocery, specify the `how` option to be `"intersection"`, which creates a new set of polygons where these two layers overlap:

```python
chicago_cores = chicago.overlay(groceries, how='intersection')
chicago_cores.plot(alpha=0.5, edgecolor='k', cmap='tab10')
```

<!-- Image: chicago_cores.png -->

Changing the `how` option allows for different types of overlay operations. For example, if you were interested in the portions of Chicago far from groceries (the peripheries), you would compute the difference of the two:

```python
chicago_peripheries = chicago.overlay(groceries, how='difference')
chicago_peripheries.plot(alpha=0.5, edgecolor='k', cmap='tab10')
```

<!-- Image: chicago_peripheries.png -->

---

## keep_geom_type Keyword

In default settings, `overlay()` returns only geometries of the same geometry type as the left `GeoDataFrame` has, where `Polygon` and `MultiPolygon` are considered as the same type (other types likewise). You can control this behavior using the `keep_geom_type` option, which is set to `True` by default. Once set to `False`, `overlay` will return all geometry types resulting from the selected set-operation. Different types can result for example from intersection of touching geometries, where two polygons intersect in a line or a point.

---

## More Examples

A larger set of examples of the use of `overlay()` can be found in the [GeoPandas overlays notebook](https://nbviewer.jupyter.org/github/geopandas/geopandas/blob/main/doc/source/gallery/overlays.ipynb).
