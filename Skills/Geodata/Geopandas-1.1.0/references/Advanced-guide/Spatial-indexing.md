# Spatial Indexing

When you want to know a spatial relationship (known as a spatial predicate) between a set of geometries A and a geometry B (or a set of them), you can compare geometry B against any geometry in a set A. However, that is not the most performant approach in most cases. A spatial index is a more efficient method for pre-filtering comparisons of geometries before using more computationally expensive spatial predicates. GeoPandas exposes the Sort-Tile-Recursive R-tree from shapely on any GeoDataFrame and GeoSeries using the `GeoSeries.sindex` property.

For many operations where a spatial index provides significant performance benefits, GeoPandas already uses it automatically (like `sjoin()`, `overlay()`, or `clip()`). However, more advanced use cases may require direct interaction with the index.

```python
import geopandas
import matplotlib.pyplot as plt
import shapely
from geodatasets import get_path

nyc = geopandas.read_file(get_path("geoda nyc"))
```

---

## R-tree Principle

In principle, any R-tree index builds a hierarchical collection of bounding boxes (envelopes) representing first individual geometries and then their most efficient combinations (from a spatial query perspective). When creating one, you can imagine that your geometries are represented by their envelopes:

```python
fig, axs = plt.subplots(1, 2, sharey=True, figsize=(8, 4))
nyc.plot(ax=axs[0], edgecolor="black", linewidth=1)
nyc.envelope.boundary.plot(ax=axs[1], color='black')
```

<!-- Image: spatial_indexing_5_0.png -->

The left side shows the original geometries, while the right side shows their bounding boxes, extracted using the `envelope` property. Typically, the index works on top of those.

Let's generate two points — both intersecting at least one bounding box but only one intersecting the actual geometry:

```python
point_inside = shapely.Point(950000, 155000)
point_outside = shapely.Point(1050000, 150000)
points = geopandas.GeoSeries([point_inside, point_outside], crs=nyc.crs)
```

```python
fig, axs = plt.subplots(1, 2, sharey=True, figsize=(8, 4))
nyc.plot(ax=axs[0], edgecolor="black", linewidth=1)
nyc.envelope.boundary.plot(ax=axs[1], color='black')
points.plot(ax=axs[0], color="limegreen")
points.plot(ax=axs[1], color="limegreen")
```

<!-- Image: spatial_indexing_9_0.png -->

---

## Querying the Index

### Scalar Query

You can use the `sindex` property to query the index. The `query()` method, by default, returns positions of all geometries whose bounding boxes intersect the bounding box of the input geometry:

```python
bbox_query_inside = nyc.sindex.query(point_inside)
bbox_query_outside = nyc.sindex.query(point_outside)
bbox_query_inside, bbox_query_outside
```

```
(array([1]), array([16]))
```

Both point queries return one hit as each intersects one bounding box in the tree.

```python
fig, axs = plt.subplots(1, 2, sharey=True, figsize=(8, 4))
nyc.plot(ax=axs[0], edgecolor="black", linewidth=1)
nyc.envelope.boundary.plot(ax=axs[1], color='black')
points.plot(ax=axs[0], color="limegreen", zorder=3, edgecolor="black", linewidth=.5)
points.plot(ax=axs[1], color="limegreen", zorder=3, edgecolor="black", linewidth=.5)
nyc.iloc[bbox_query_inside].plot(ax=axs[0], color='orange')
nyc.iloc[bbox_query_outside].plot(ax=axs[0], color='orange')
nyc.envelope.iloc[bbox_query_inside].plot(ax=axs[1], color='orange')
nyc.envelope.iloc[bbox_query_outside].plot(ax=axs[1], color='orange')
```

<!-- Image: spatial_indexing_13_0.png -->

While only one point intersects an actual geometry, the hits are clear when looking at the bounding boxes. The spatial index allows further filtering based on the actual geometry. The tree is first queried as above, but afterwards each possible hit is checked using a spatial predicate:

```python
pred_inside = nyc.sindex.query(point_inside, predicate="intersects")
pred_outside = nyc.sindex.query(point_outside, predicate="intersects")
pred_inside, pred_outside
```

```
(array([1]), array([], dtype=int64))
```

When you specify `predicate="intersects"`, the result is indeed different — the output of the query using the point that lies outside of any geometry is empty.

<!-- Image: spatial_indexing_17_0.png -->

You can use any of the predicates available in `valid_query_predicates`:

```python
nyc.sindex.valid_query_predicates
```

```
{None, 'contains', 'contains_properly', 'covered_by', 'covers',
 'crosses', 'dwithin', 'intersects', 'overlaps', 'touches', 'within'}
```

### Array Query

Checking a single geometry against the tree is nice but not that efficient if you are interested in many-to-many relationships. The `query()` method allows passing any 1-D array of geometries to be checked against the tree. If you do so, the output structure is slightly different:

```python
bbox_array_query = nyc.sindex.query(points)
bbox_array_query
```

```
array([[ 0,  1],
       [ 1, 16]])
```

By default, the method returns a 2-D array of indices where the query found a hit. The subarrays correspond to the indices of the input geometries and indices of the tree geometries associated with each. In the example above, the 0-th geometry in `points` intersects the bounding box of the geometry at position 1 from `nyc`, while geometry 1 in `points` matches geometry 16 in `nyc`.

The other option is to return a boolean array with shape `(len(tree), n)` with boolean values marking whether the bounding box of a geometry in the tree intersects a bounding box of a given geometry. This can be either a dense numpy array, or a sparse scipy array. Keep in mind that the output will, in most cases, be mostly filled with `False` and the array can become really large, so it is recommended to use the sparse format if possible.

You can specify each using the `output_format` keyword:

```python
# Dense format
bbox_array_query_dense = nyc.sindex.query(points, output_format="dense")

# Sparse format (recommended for large datasets)
bbox_array_query_sparse = nyc.sindex.query(points, output_format="sparse")
```

For example, to find the number of neighboring geometries for each subborough, you can use the spatial index to compare all geometries against each other:

```python
neighbors = nyc.sindex.query(nyc.geometry, predicate="intersects", output_format="dense")
```

Getting the sum along one axis gives you the answer. Since a geometry always intersects itself, you need to subtract one:

```python
n_neighbors = neighbors.sum(axis=1) - 1
nyc.plot(n_neighbors, legend=True)
```

<!-- Image: spatial_indexing_31_0.png -->

### Nearest Geometry Query

GeoPandas also allows you to use the spatial index to find the nearest geometry. The API is similar:

```python
nearest_indices = nyc.sindex.nearest(points)
nearest_indices
```

```
array([[ 0,  1],
       [ 1, 16]])
```

If you are interested in how "near" the geometries actually are, the method can also return distances. In this case, the return format is a tuple of arrays:

```python
nearest_indices, distance = nyc.sindex.nearest(points, return_distance=True)
distance
```

```
array([   0.        , 4413.99923494])
```
