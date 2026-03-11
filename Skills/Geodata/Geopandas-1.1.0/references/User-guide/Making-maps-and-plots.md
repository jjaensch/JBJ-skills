# Mapping and plotting tools

GeoPandas provides a high-level interface to the matplotlib library for making maps. Mapping shapes is as easy as using the `plot()` method on a GeoSeries or GeoDataFrame.

Loading some example data:

```python
import geodatasets

chicago = geopandas.read_file(geodatasets.get_path("geoda.chicago_commpop"))
groceries = geopandas.read_file(geodatasets.get_path("geoda.groceries"))
```

You can now plot those GeoDataFrames:

```python
# Examine the chicago GeoDataFrame
chicago.head()
```
```
         community  ...                                           geometry
0          DOUGLAS  ...  MULTIPOLYGON (((-87.609140876 41.844692503, -8...
1          OAKLAND  ...  MULTIPOLYGON (((-87.592152839 41.816929346, -8...
2      FULLER PARK  ...  MULTIPOLYGON (((-87.628798237 41.801893034, -8...
3  GRAND BOULEVARD  ...  MULTIPOLYGON (((-87.606708126 41.816813771, -8...
4          KENWOOD  ...  MULTIPOLYGON (((-87.592152839 41.816929346, -8...

[5 rows x 9 columns]
```

```python
# Basic plot, single color
chicago.plot();
```
<!-- Image: chicago_singlecolor.png -->

> **Note:** In general, any options one can pass to pyplot in matplotlib (or style options that work for lines) can be passed to the `plot()` method.

## Choropleth maps

GeoPandas makes it easy to create Choropleth maps (maps where the color of each shape is based on the value of an associated variable). Simply use the plot command with the `column` argument set to the column whose values you want used to assign colors.

```python
# Plot by population
chicago.plot(column="POP2010");
```
<!-- Image: chicago_population.png -->

### Creating a legend

When plotting a map, one can enable a legend using the `legend` argument:

```python
# Plot population estimates with an accurate legend
chicago.plot(column='POP2010', legend=True);
```
<!-- Image: chicago_choro.png -->

The following example plots the color bar below the map and adds its label using `legend_kwds`:

```python
chicago.plot(
    column="POP2010",
    legend=True,
    legend_kwds={"label": "Population in 2010", "orientation": "horizontal"},
);
```
<!-- Image: chicago_horizontal.png -->

However, the default appearance of the legend and plot axes may not be desirable. One can define the plot axes (with `ax`) and the legend axes (with `cax`) and then pass those in to the `plot()` call. The following example uses `mpl_toolkits` to horizontally align the plot axes and the legend axes and change the width:

```python
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import make_axes_locatable

fig, ax = plt.subplots(1, 1)
divider = make_axes_locatable(ax)
cax = divider.append_axes("bottom", size="5%", pad=0.1)

chicago.plot(
    column="POP2010",
    ax=ax,
    legend=True,
    cax=cax,
    legend_kwds={"label": "Population in 2010", "orientation": "horizontal"},
);
```
<!-- Image: chicago_cax.png -->

### Choosing colors

You can also modify the colors used by `plot()` with the `cmap` option. For a full list of colormaps, see Choosing Colormaps in Matplotlib.

```python
chicago.plot(column='POP2010', cmap='OrRd');
```
<!-- Image: chicago_red.png -->

To make the color transparent for when you just want to show the boundary, you have two options. One option is to do `chicago.plot(facecolor="none", edgecolor="black")`. However, this can cause confusion because `"none"` and `None` are different in the context of using `facecolor` and they do opposite things. `None` does the "default behavior" based on matplotlib, and if you use it for `facecolor`, it actually adds a color. The second option is to use `chicago.boundary.plot()`. This option is more explicit and clear:

```python
chicago.boundary.plot();
```
<!-- Image: chicago_transparent.png -->

The way color maps are scaled can also be manipulated with the `scheme` option (if you have `mapclassify` installed, which can be accomplished via `conda install -c conda-forge mapclassify`). The `scheme` option can be set to any scheme provided by mapclassify (e.g. 'box_plot', 'equal_interval', 'fisher_jenks', 'fisher_jenks_sampled', 'headtail_breaks', 'jenks_caspall', 'jenks_caspall_forced', 'jenks_caspall_sampled', 'max_p_classifier', 'maximum_breaks', 'natural_breaks', 'quantiles', 'percentiles', 'std_mean' or 'user_defined'). Arguments can be passed in `classification_kwds` dict. See the mapclassify documentation for further details about these map classification schemes.

```python
chicago.plot(column='POP2010', cmap='OrRd', scheme='quantiles');
```
<!-- Image: chicago_quantiles.png -->

### Missing data

In some cases one may want to plot data which contains missing values - for some features one simply does not know the value. GeoPandas (from version 0.7) by default ignores such features.

```python
import numpy as np

chicago.loc[np.random.choice(chicago.index, 30), 'POP2010'] = np.nan

chicago.plot(column='POP2010');
```
<!-- Image: missing_vals.png -->

However, passing `missing_kwds` one can specify the style and label of features containing None or NaN.

```python
chicago.plot(column='POP2010', missing_kwds={'color': 'lightgrey'});

chicago.plot(
    column="POP2010",
    legend=True,
    scheme="quantiles",
    figsize=(15, 10),
    missing_kwds={
        "color": "lightgrey",
        "edgecolor": "red",
        "hatch": "///",
        "label": "Missing values",
    },
);
```
<!-- Image: missing_vals_grey.png -->
<!-- Image: missing_vals_hatch.png -->

### Other map customizations

Maps usually do not have to have axis labels. You can turn them off using `set_axis_off()` or `axis("off")` axis methods.

```python
ax = chicago.plot()
ax.set_axis_off();
```
<!-- Image: set_axis_off.png -->

## Maps with layers

There are two strategies for making a map with multiple layers – one more succinct, and one that is a little more flexible.

Before combining maps, however, remember to always ensure they share a common CRS (so they will align).

```python
# Look at capitals
# Note use of standard `pyplot` line style options
groceries.plot(marker='*', color='green', markersize=5);

# Check crs
groceries = groceries.to_crs(chicago.crs)
```
<!-- Image: capitals.png -->

**Method 1:**

```python
base = chicago.plot(color='white', edgecolor='black')
groceries.plot(ax=base, marker='o', color='red', markersize=5);
```
<!-- Image: groceries_over_chicago_1.png -->

**Method 2:** Using matplotlib objects

```python
fig, ax = plt.subplots()

chicago.plot(ax=ax, color='white', edgecolor='black')
groceries.plot(ax=ax, marker='o', color='red', markersize=5)

plt.show();
```
<!-- Image: groceries_over_chicago_2.png -->

### Control the order of multiple layers in a plot

When plotting multiple layers, use `zorder` to take control of the order of layers being plotted. The lower the `zorder` is, the lower the layer is on the map and vice versa.

Without specified `zorder`, cities (Points) gets plotted below world (Polygons), following the default order based on geometry types.

```python
ax = groceries.plot(color='k')
chicago.plot(ax=ax);
```
<!-- Image: zorder_default.png -->

You can set the `zorder` for cities higher than for world to move it on top.

```python
ax = groceries.plot(color='k', zorder=2)
chicago.plot(ax=ax, zorder=1);
```
<!-- Image: zorder_set.png -->

## Pandas plots

Plotting methods also allow for different plot styles from pandas along with the default `geo` plot. These methods can be accessed using the `kind` keyword argument in `plot()`, and include:

- `geo` for mapping
- `line` for line plots
- `bar` or `barh` for bar plots
- `hist` for histogram
- `box` for boxplot
- `kde` or `density` for density plots
- `area` for area plots
- `scatter` for scatter plots
- `hexbin` for hexagonal bin plots
- `pie` for pie plots

```python
chicago.plot(kind="scatter", x="POP2010", y="POP2000")
```
<!-- Image: pandas_line_plot.png -->

You can also create these other plots using the `GeoDataFrame.plot.<kind>` accessor methods instead of providing the `kind` keyword argument. For example, `hist` can be used to plot histograms of population for two different years from the Chicago dataset.

```python
chicago[["POP2000", "POP2010", "geometry"]].plot.hist(alpha=.4)
```
<!-- Image: pandas_hist_plot.png -->

For more information, see Chart visualization in the pandas documentation.

## Other resources

Links to Jupyter Notebooks for different mapping tasks:

- Making Heat Maps
