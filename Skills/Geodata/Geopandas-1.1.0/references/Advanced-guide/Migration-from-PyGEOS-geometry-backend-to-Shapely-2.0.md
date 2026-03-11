# Migration from PyGEOS Geometry Backend to Shapely 2.0

Since version 0.8, GeoPandas included experimental support of PyGEOS as an alternative geometry backend to Shapely. Recently, PyGEOS codebase was merged into the Shapely project and released as part of Shapely 2.0. GeoPandas therefore deprecated support of the PyGEOS backend and goes forward with Shapely 2.0 as the only geometry engine exposing GEOS functionality.

Given that historically the PyGEOS engine was automatically used if the package was installed, some downstream code may depend on PyGEOS geometries being available as underlying data of a `GeometryArray`.

This guide outlines the migration from the PyGEOS-based code to the Shapely-based code.

---

## Migration Period

The migration was planned for three releases spanning approximately one year, starting with 0.13 released in the second quarter of 2023.

### GeoPandas 0.13

- PyGEOS is still used as a default backend over Shapely (1.8 or 2.0) if installed, with a `FutureWarning` warning about upcoming changes.

### GeoPandas 0.14

- The default backend is Shapely 2.0 and PyGEOS is used only if Shapely 1.8 is installed instead of 2.0 or newer. The PyGEOS backend is still supported, but a user needs to opt in using the environment variable `USE_PYGEOS`.

### GeoPandas 1.0

- GeoPandas removed support of both PyGEOS and Shapely < 2.

---

## How to Prepare Your Code for Transition

If you don't use PyGEOS explicitly, there is nothing to be done as GeoPandas internals will take care of the transition. If you use PyGEOS directly and access an array of PyGEOS geometries using `GeoSeries.values.data`, you will need to make some changes to avoid code breakage.

The recommended way is using Shapely vectorized operations on the `GeometryArray` instead of accessing the NumPy array of geometries and using PyGEOS/Shapely operations on the array.

**Old pattern** (GeoPandas 0.12 or earlier — should now be avoided):

```python
import pygeos
geometries = gdf.geometry.values.data
mrr = pygeos.minimum_rotated_rectangle(geometries)
```

**Recommended refactoring** (GeoPandas 0.12 or later):

```python
import shapely  # shapely 2.0
mrr = shapely.minimum_rotated_rectangle(gdf.geometry.array)
```

This code will work no matter which geometry backend GeoPandas actually uses, because at the `GeometryArray` level, it always returns Shapely geometry. Although keep in mind that it may involve additional overhead cost of converting PyGEOS geometry to Shapely geometry.

> **Note:** While in most cases, a simple replacement of `pygeos` with `shapely` together with a change of `gdf.geometry.values.data` to `gdf.geometry.values` (or analogous `gdf.geometry.array`) should work, there are some differences between the API of PyGEOS and that of Shapely. Please consult the [Migrating from PyGEOS](https://shapely.readthedocs.io/en/stable/migration_pygeos.html) document for details.
