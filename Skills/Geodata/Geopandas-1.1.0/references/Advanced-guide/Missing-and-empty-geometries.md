# Missing and Empty Geometries

GeoPandas supports, just like in pandas, the concept of missing values (NA or null values). But for geometry values, there is an additional concept of empty geometries:

- **Empty geometries** are actual geometry objects but that have no coordinates (and thus also no area, for example). They can originate from taking the intersection of two polygons that have no overlap. The scalar object (when accessing a single element of a GeoSeries) is still a Shapely geometry object.
- **Missing geometries** are unknown values in a GeoSeries. They will typically be propagated in operations (for example in calculations of the area or of the intersection), or ignored in reductions such as `union_all()`. The scalar object (when accessing a single element of a GeoSeries) is the Python `None` object.

> **Warning:** Starting from GeoPandas v0.6.0, those two concepts are more consistently separated. See below for more details on what changed compared to earlier versions.

Consider the following example GeoSeries with one polygon, one missing value and one empty polygon:

```python
from shapely.geometry import Polygon

s = geopandas.GeoSeries([Polygon([(0, 0), (1, 1), (0, 1)]), None, Polygon([])])
s
```

```
0    POLYGON ((0 0, 1 1, 0 1, 0 0))
1                              None
2                     POLYGON EMPTY
dtype: geometry
```

In spatial operations, missing geometries will typically propagate (be missing in the result as well), while empty geometries are treated as a geometry and the result will depend on the operation:

```python
s.area
```

```
0    0.5
1    NaN
2    0.0
dtype: float64
```

```python
s.union(Polygon([(0, 0), (0, 1), (1, 1), (1, 0)]))
```

```
0    POLYGON ((1 1, 1 0, 0 0, 0 1, 1 1))
1                                   None
2    POLYGON ((0 1, 1 1, 1 0, 0 0, 0 1))
dtype: geometry
```

```python
s.intersection(Polygon([(0, 0), (0, 1), (1, 1), (1, 0)]))
```

```
0    POLYGON ((0 0, 0 1, 1 1, 0 0))
1                              None
2                     POLYGON EMPTY
dtype: geometry
```

The `GeoSeries.isna()` method will only check for missing values and not for empty geometries:

```python
s.isna()
```

```
0    False
1     True
2    False
dtype: bool
```

If you want to know which values are empty geometries, you can use the `GeoSeries.is_empty` attribute:

```python
s.is_empty
```

```
0    False
1    False
2     True
dtype: bool
```

To get only the actual geometry objects that are neither missing nor empty, you can use a combination of both:

```python
s.is_empty | s.isna()
```

```
0    False
1     True
2     True
dtype: bool
```

```python
s[~(s.is_empty | s.isna())]
```

```
0    POLYGON ((0 0, 1 1, 0 1, 0 0))
dtype: geometry
```

---

## Changes Since GeoPandas v0.6.0

In GeoPandas v0.6.0, the missing data handling was refactored and made more consistent across the library.

Historically, missing ("NA") values in a GeoSeries could be represented by empty geometric objects, in addition to standard representations such as `None` and `np.nan`. At least, this was the case in `GeoSeries.isna()` or when a GeoSeries got aligned in geospatial operations. But other methods like `dropna()` and `fillna()` did not follow this approach and did not consider empty geometries as missing.

The most important change is `GeoSeries.isna()` no longer treating empty as missing:

- **Old behaviour** treated both the empty and missing geometry as "missing":

```python
>>> s.isna()
0    False
1     True
2     True    # empty was treated as missing
dtype: bool
```

- **New behaviour** (v0.6.0+) only sees actual missing values as missing:

```python
s.isna()
```

```
0    False
1     True
2    False    # empty is no longer treated as missing
dtype: bool
```

Additionally, the behaviour of `GeoSeries.align()` changed to use missing values instead of empty geometries to fill non-matching indexes:

```python
from shapely.geometry import Point

s1 = geopandas.GeoSeries([Point(0, 0), Point(1, 1)], index=[0, 1])
s2 = geopandas.GeoSeries([Point(1, 1), Point(2, 2)], index=[1, 2])
```

- **Old behaviour** used empty geometries to fill values:

```python
>>> s1_aligned, s2_aligned = s1.align(s2)
>>> s1_aligned
0                 POINT (0 0)
1                 POINT (1 1)
2    GEOMETRYCOLLECTION EMPTY
dtype: object
```

- **New behaviour** (v0.6.0+) uses missing values (`None`) to fill non-aligned indices, consistent with pandas:

```python
s1_aligned, s2_aligned = s1.align(s2)

s1_aligned
```

```
0    POINT (0 0)
1    POINT (1 1)
2           None
dtype: geometry
```

```python
s2_aligned
```

```
0           None
1    POINT (1 1)
2    POINT (2 2)
dtype: geometry
```

This has the consequence that spatial operations will also use missing values instead of empty geometries:

```python
s1.intersection(s2)
```

```
0           None
1    POINT (1 1)
2           None
dtype: geometry
```
