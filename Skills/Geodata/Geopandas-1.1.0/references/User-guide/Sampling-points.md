# Sampling Points

Learn how to sample random points using GeoPandas.

The example below shows you how to sample random locations from shapes in GeoPandas GeoDataFrames.

---

## Import Packages

```python
import geopandas
import geodatasets
```

For this example, we will use the New York Borough example data (`nybb`) provided by geodatasets:

```python
nybb = geopandas.read_file(geodatasets.get_path("nybb"))

# Simplify geometry to save space when rendering many interactive maps
nybb.geometry = nybb.simplify(200)
nybb.explore()
```

---

## Sampling Random Points

To sample points from within a GeoDataFrame, use the `sample_points()` method. To specify the sample sizes, provide an explicit number of points to sample. For example, we can sample 200 points randomly from each feature:

```python
n200_sampled_points = nybb.sample_points(200)
m = nybb.explore()
n200_sampled_points.explore(m=m, color='red')
```

This functionality also works for line geometries. For example, let's look only at the boundary of Manhattan Island:

```python
manhattan_parts = nybb.iloc[[3]].explode(ignore_index=True)
manhattan_island = manhattan_parts.iloc[[30]]
manhattan_island.boundary.explore()
```

Sampling randomly from along this boundary can use the same `sample_points()` method:

```python
manhattan_border_points = manhattan_island.boundary.sample_points(200)
m = manhattan_island.explore()
manhattan_border_points.explore(m=m, color='red')
```

Keep in mind that sampled points are returned as a single multi-part geometry, and that the distances over the line segments are calculated along the line:

```python
manhattan_border_points
```

```
30    MULTIPOINT ((979415.017 199634.021), (979423.5...
Name: sampled_points, dtype: geometry
```

If you want to separate out the individual sampled points, use the `.explode()` method on the dataframe:

```python
manhattan_border_points.explode(ignore_index=True).head()
```

```
0    POINT (979415.017 199634.021)
1    POINT (979423.521 199695.101)
2    POINT (979428.646 195564.241)
3     POINT (979468.635 195493.21)
4    POINT (979508.074 195423.155)
Name: sampled_points, dtype: geometry
```

---

## Variable Number of Points

You can also sample different numbers of points from different geometries if you pass an array specifying the size of the sample per geometry:

```python
variable_size = nybb.sample_points([10, 50, 100, 200, 500])
m = nybb.explore()
variable_size.explore(m=m, color='red')
```

---

## Sampling from More Complicated Point Pattern Processes

The `sample_points()` method can use different sampling processes than those described above, so long as they are implemented in the `pointpats` package for spatial point pattern analysis. For example, a "cluster-poisson" process is a spatially-random cluster process where the "seeds" of clusters are chosen randomly, and then points around these clusters are distributed again randomly.

To see what this looks like, consider the following, where ten points will be distributed around five seeds within each of the boroughs in New York City:

```python
sample_t = nybb.sample_points(method='cluster_poisson', size=50, n_seeds=5, cluster_radius=7500)

m = nybb.explore()
sample_t.explore(m=m, color='red')
```
