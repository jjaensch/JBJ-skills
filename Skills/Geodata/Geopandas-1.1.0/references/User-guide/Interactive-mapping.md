# Interactive mapping

Alongside static plots, geopandas can create interactive maps based on the folium library.

Creating maps for interactive exploration mirrors the API of static plots in an `explore()` method of a GeoSeries or GeoDataFrame.

Loading some example data:

```python
import geopandas
import geodatasets

nybb = geopandas.read_file(geodatasets.get_path("nybb"))
chicago = geopandas.read_file(geodatasets.get_path("geoda.chicago_commpop"))
groceries = geopandas.read_file(geodatasets.get_path("geoda.groceries")).explode(ignore_index=True)
```

The simplest option is to use `GeoDataFrame.explore()`:

```python
nybb.explore()
```

Interactive plotting offers largely the same customisation as static one plus some features on top of that. You can use a column with names as an input of the choropleth, show (only) its name in the tooltip on hover but show all values on click. You can also pass custom background tiles (either a name supported by folium, a name recognized by `xyzservices.providers.query_name()`, XYZ URL or `xyzservices.TileProvider` object), specify colormap (all supported by matplotlib) and specify black outline.

> **Note:** The GeoDataFrame needs to have a CRS set if you want to use background tiles.

```python
nybb.explore(
    column="BoroName",  # make choropleth based on "BoroName" column
    tooltip="BoroName",  # show "BoroName" value in tooltip (on hover)
    popup=True,  # show all values in popup (on click)
    tiles="CartoDB positron",  # use "CartoDB positron" tiles
    cmap="Set1",  # use "Set1" matplotlib colormap
    style_kwds=dict(color="black"),  # use black outline
)
```

The `explore()` method returns a `folium.Map` object, which can also be passed directly (as you do with `ax` in `plot()`). You can then use folium functionality directly on the resulting map. In the example below, you can plot two GeoDataFrames on the same map and add layer control using folium. You can also add additional tiles allowing you to change the background directly in the map.

```python
import folium

m = chicago.explore(
    column="POP2010",  # make choropleth based on "POP2010" column
    scheme="naturalbreaks",  # use mapclassify's natural breaks scheme
    legend=True,  # show legend
    k=10,  # use 10 bins
    tooltip=False,  # hide tooltip
    popup=["POP2010", "POP2000"],  # show popup (on-click)
    legend_kwds=dict(colorbar=False),  # do not use colorbar
    name="chicago",  # name of the layer in the map
)

groceries.explore(
    m=m,  # pass the map object
    color="red",  # use red color on all points
    marker_kwds=dict(radius=5, fill=True),  # make marker radius 5px with fill
    tooltip="Address",  # show "Address" column in the tooltip
    tooltip_kwds=dict(labels=False),  # do not show column label in the tooltip
    name="groceries",  # name of the layer in the map
)

folium.TileLayer("CartoDB positron", show=False).add_to(m)  # add alternative tiles
folium.LayerControl().add_to(m)  # add layer control

m  # show map
```
