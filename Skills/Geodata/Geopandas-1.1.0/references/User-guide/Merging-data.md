# Merging Data

There are two ways to combine datasets in GeoPandas — attribute joins and spatial joins.

In an **attribute join**, a `GeoSeries` or `GeoDataFrame` is combined with a regular `pandas.Series` or `pandas.DataFrame` based on a common variable. This is analogous to normal merging or joining in pandas.

In a **spatial join**, observations from two `GeoSeries` or `GeoDataFrame` are combined based on their spatial relationship to one another.

In the following examples, these datasets are used:

```python
import geodatasets

chicago = geopandas.read_file(geodatasets.get_path("geoda.chicago_commpop"))
groceries = geopandas.read_file(geodatasets.get_path("geoda.groceries"))

# For attribute join
chicago_shapes = chicago[['geometry', 'NID']]
chicago_names = chicago[['community', 'NID']]

# For spatial join
chicago = chicago[['geometry', 'community']].to_crs(groceries.crs)
```

---

## Appending

Appending `GeoDataFrame` and `GeoSeries` uses pandas `concat()` function. Keep in mind that appended geometry columns need to have the same CRS.

```python
# Appending GeoSeries
joined = pd.concat([chicago.geometry, groceries.geometry])

# Appending GeoDataFrames
douglas = chicago[chicago.community == 'DOUGLAS']
oakland = chicago[chicago.community == 'OAKLAND']
douglas_oakland = pd.concat([douglas, oakland])
```

---

## Attribute Joins

Attribute joins are accomplished using the `merge()` method. In general, it is recommended to use the `merge()` method called from the spatial dataset. With that said, the stand-alone `pandas.merge()` function will work if the `GeoDataFrame` is in the `left` argument; if a `DataFrame` is in the `left` argument and a `GeoDataFrame` is in the `right` argument, the result will be a `DataFrame` rather than a `GeoDataFrame`.

For example, consider the following merge that adds full names to a `GeoDataFrame` that initially has only area IDs for each geometry by merging it with a `DataFrame`:

```python
# `chicago_shapes` is GeoDataFrame with community shapes and area IDs
chicago_shapes.head()
```

```
                                            geometry  NID
0  MULTIPOLYGON (((-87.609140876 41.844692503, -8...   35
1  MULTIPOLYGON (((-87.592152839 41.816929346, -8...   36
2  MULTIPOLYGON (((-87.628798237 41.801893034, -8...   37
3  MULTIPOLYGON (((-87.606708126 41.816813771, -8...   38
4  MULTIPOLYGON (((-87.592152839 41.816929346, -8...   39
```

```python
# `chicago_names` is DataFrame with community names and area IDs
chicago_names.head()
```

```
         community  NID
0          DOUGLAS   35
1          OAKLAND   36
2      FULLER PARK   37
3  GRAND BOULEVARD   38
4          KENWOOD   39
```

```python
# Merge with `merge` method on shared variable (area ID):
chicago_shapes = chicago_shapes.merge(chicago_names, on='NID')
chicago_shapes.head()
```

```
                                            geometry  NID        community
0  MULTIPOLYGON (((-87.609140876 41.844692503, -8...   35          DOUGLAS
1  MULTIPOLYGON (((-87.592152839 41.816929346, -8...   36          OAKLAND
2  MULTIPOLYGON (((-87.628798237 41.801893034, -8...   37      FULLER PARK
3  MULTIPOLYGON (((-87.606708126 41.816813771, -8...   38  GRAND BOULEVARD
4  MULTIPOLYGON (((-87.592152839 41.816929346, -8...   39          KENWOOD
```

---

## Spatial Joins

In a spatial join, two geometry objects are merged based on their spatial relationship to one another.

```python
# One GeoDataFrame of communities, one of grocery stores.
# Want to merge to get each grocery's community.
chicago.head()
```

```
                                            geometry        community
0  MULTIPOLYGON (((1181573.249800048 1886828.0393...          DOUGLAS
1  MULTIPOLYGON (((1186289.355600054 1876750.7332...          OAKLAND
2  MULTIPOLYGON (((1176344.998000037 1871187.5456...      FULLER PARK
3  MULTIPOLYGON (((1182322.042900046 1876674.7304...  GRAND BOULEVARD
4  MULTIPOLYGON (((1186289.355600054 1876750.7332...          KENWOOD
```

```python
# Execute spatial join
groceries_with_community = groceries.sjoin(chicago, how="inner", predicate='intersects')
groceries_with_community.head()
```

```
   OBJECTID     Ycoord  ...  index_right       community
0        16  41.973266  ...           30          UPTOWN
1        18  41.696367  ...           73     MORGAN PARK
2        22  41.868634  ...           28  NEAR WEST SIDE
3        23  41.877590  ...           28  NEAR WEST SIDE
4        27  41.737696  ...           39         CHATHAM
```

GeoPandas provides two spatial-join functions:

- `GeoDataFrame.sjoin()`: joins based on binary predicates (intersects, contains, etc.)
- `GeoDataFrame.sjoin_nearest()`: joins based on proximity, with the ability to set a maximum search radius.

> **Note:** For historical reasons, both methods are also available as top-level functions `sjoin()` and `sjoin_nearest()`. It is recommended to use methods as the functions may be deprecated in the future.

### Binary Predicate Joins

`GeoDataFrame.sjoin()` has two core arguments: `how` and `predicate`.

**predicate**

The `predicate` argument specifies how GeoPandas decides whether or not to join the attributes of one object to another, based on their geometric relationship. The values for `predicate` correspond to the names of geometric binary predicates and depend on the spatial index implementation.

The default spatial index in GeoPandas currently supports the following values for `predicate`:

- `intersects`
- `contains`
- `within`
- `touches`
- `crosses`
- `overlaps`

**how**

The `how` argument specifies the type of join that will occur and which geometry is retained in the resultant `GeoDataFrame`. It accepts the following options:

- `left`: use the index from the first (or `left_df`) `GeoDataFrame`; retain only the `left_df` geometry column
- `right`: use index from second (or `right_df`); retain only the `right_df` geometry column
- `inner`: use intersection of index values from both `GeoDataFrame`; retain only the `left_df` geometry column

> **Note:** More complicated spatial relationships can be studied by combining geometric operations with spatial join. To find all polygons within a given distance of a point, for example, one can first use the `buffer()` method to expand each point into a circle of appropriate radius, then intersect those buffered circles with the polygons in question.

### Nearest Joins

Proximity-based joins can be done via `GeoDataFrame.sjoin_nearest()`.

`GeoDataFrame.sjoin_nearest()` shares the `how` argument with `GeoDataFrame.sjoin()`, and includes two additional arguments: `max_distance` and `distance_col`.

**max_distance**

The `max_distance` argument specifies a maximum search radius for matching geometries. This can have a considerable performance impact in some cases. If you can, it is highly recommended that you use this parameter.

**distance_col**

If set, the resultant GeoDataFrame will include a column with this name containing the computed distances between an input geometry and the nearest geometry.
