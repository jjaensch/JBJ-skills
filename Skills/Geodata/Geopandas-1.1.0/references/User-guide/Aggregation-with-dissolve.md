# Aggregation with Dissolve

Spatial data are often more granular than needed. For example, you might have data on sub-national units, but you're actually interested in studying patterns at the level of countries.

In a non-spatial setting, when you need summary statistics of the data, you can aggregate data using the `groupby()` function. But for spatial data, you sometimes also need to aggregate geometric features. In the GeoPandas library, you can aggregate geometric features using the `dissolve()` function.

`dissolve()` can be thought of as doing three things:

1. It dissolves all the geometries within a given group together into a single geometric feature (using the `union_all()` method), and
2. It aggregates all the rows of data in a group using `groupby.aggregate`, and
3. It combines those two results.

---

## dissolve() Example

Take the example of administrative areas in Nepal. You have districts, which are smaller, and zones, which are larger. A group of districts always compose a single zone. Suppose you are interested in Nepalese zones, but you only have Nepalese district-level data like the `geoda.nepal` dataset included in geodatasets. You can easily convert this to a zone-level dataset.

First, let's look at the most simple case where you just want zone shapes and names:

```python
import geodatasets

nepal = geopandas.read_file(geodatasets.get_path('geoda.nepal'))
nepal = nepal.rename(columns={"name_2": "zone"})  # rename to remember the column
nepal[["zone", "geometry"]].head()
```

```
          zone                                           geometry
0  Dhaualagiri  POLYGON ((83.10834 28.6202, 83.1056 28.60976, ...
1  Dhaualagiri  POLYGON ((83.99726 29.31675, 84 29.31576, 84 2...
2  Dhaualagiri  POLYGON ((83.50688 28.79306, 83.51024 28.78809...
3  Dhaualagiri  POLYGON ((83.70261 28.39837, 83.70435 28.39452...
4      Bagmati  POLYGON ((85.52173 27.71822, 85.52359 27.71375...
```

By default, `dissolve()` will pass `'first'` to `groupby.aggregate`:

```python
nepal_zone = nepal[['zone', 'geometry']]
zones = nepal_zone.dissolve(by='zone')
zones.plot()
zones.head()
```

```
                                                      geometry
zone
Bagmati      POLYGON ((85.87653 27.61234, 85.87355 27.60861...
Bheri        POLYGON ((81.75089 28.31038, 81.75562 28.3074,...
Dhaualagiri  POLYGON ((83.70647 28.39278, 83.70721 28.38781...
Gandaki      POLYGON ((84.49995 28.74099, 84.50443 28.7441,...
Janakpur     POLYGON ((86.26166 26.91417, 86.2588 26.91144,...
```

<!-- Image: zones1.png -->

If you are interested in aggregate populations, however, you can pass different functions to the `dissolve()` method to aggregate populations using the `aggfunc` argument:

```python
nepal_pop = nepal[['zone', 'geometry', 'population']]
zones = nepal_pop.dissolve(by='zone', aggfunc='sum')
zones.plot(column='population', scheme='quantiles', cmap='YlOrRd')
zones.head()
```

```
                                                      geometry  population
zone
Bagmati      POLYGON ((85.87653 27.61234, 85.87355 27.60861...     3750441
Bheri        POLYGON ((81.75089 28.31038, 81.75562 28.3074,...     1463510
Dhaualagiri  POLYGON ((83.70647 28.39278, 83.70721 28.38781...      516905
Gandaki      POLYGON ((84.49995 28.74099, 84.50443 28.7441,...     1530310
Janakpur     POLYGON ((86.26166 26.91417, 86.2588 26.91144,...     2818356
```

<!-- Image: zones2.png -->

---

## Dissolve Arguments

The `aggfunc` argument defaults to `'first'` which means that the first row of attribute values found in the dissolve routine will be assigned to the resultant dissolved GeoDataFrame. However it also accepts other summary statistic options as allowed by `pandas.groupby` including:

- `'first'`
- `'last'`
- `'min'`
- `'max'`
- `'sum'`
- `'mean'`
- `'median'`
- function
- string function name
- list of functions and/or function names, e.g. `[np.sum, 'mean']`
- dict of axis labels -> functions, function names or list of such

For example, to get the number of districts in each zone, as well as the populations of the largest and smallest district of each, you can aggregate the `'district'` column using `'count'`, and the `'population'` column using `'min'` and `'max'`:

```python
zones = nepal.dissolve(
    by="zone",
    aggfunc={
        "district": "count",
        "population": ["min", "max"],
    },
)
zones.head()
```

```
                                                      geometry  ...  (population, max)
zone                                                            ...
Bagmati      POLYGON ((85.87653 27.61234, 85.87355 27.60861...  ...            1688131
Bheri        POLYGON ((81.75089 28.31038, 81.75562 28.3074,...  ...             422812
Dhaualagiri  POLYGON ((83.70647 28.39278, 83.70721 28.38781...  ...             250065
Gandaki      POLYGON ((84.49995 28.74099, 84.50443 28.7441,...  ...             480851
Janakpur     POLYGON ((86.26166 26.91417, 86.2588 26.91144,...  ...             765959

[5 rows x 4 columns]
```
