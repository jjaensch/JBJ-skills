# Reference Index — Geopandas 1.1.0

Use this index to identify which reference files to load for a given question.
Most questions benefit from at least one API-reference file AND one User-guide file.

---

## API-references/

| File | Covers |
|---|---|
| **GeoDataFrame.md** | GeoDataFrame constructor, serialization/IO (file, JSON, Parquet, Feather, Arrow, PostGIS, WKB, WKT), CRS/projection handling (set_crs, to_crs, estimate_utm_crs), active geometry management (set_geometry, rename_geometry), dissolve, explode, spatial joins (sjoin, sjoin_nearest), overlay/clip, plotting (plot, explore), spatial index (sindex), coordinate indexer (cx), __geo_interface__ |
| **GeoSeries.md** | GeoSeries constructor, geometry attributes (area, bounds, length, geom_type, coordinates, z/m), unary predicates (is_valid, is_empty, is_simple, has_z), binary predicates (contains, intersects, within, crosses, touches, overlaps, covers, dwithin, DE-9IM relate), set-theoretic methods (difference, intersection, symmetric_difference, union, clip_by_rect), constructive methods (buffer, simplify, envelope, convex/concave hull, centroid, segmentize, offset_curve, triangulation), affine transforms (rotate, scale, skew, translate) |
| **input-output.md** | Top-level I/O functions: read_file, to_file, list_layers, read_postgis/to_postgis, read_feather/to_feather, read_parquet/to_parquet |
| **Spatial-index.md** | STRtree spatial index via GeoSeries.sindex, query method, nearest method, valid predicates |
| **Testing.md** | assert_geoseries_equal, assert_geodataframe_equal — testing utilities |
| **Tools.md** | Top-level functions: sjoin, sjoin_nearest, overlay, clip, geocode, reverse_geocode, collect, points_from_xy |

---

## User-guide/

| File | Covers |
|---|---|
| **Data-structures.md** | GeoSeries and GeoDataFrame fundamentals, geometry types (Point, Line, Polygon + Multi variants), active geometry column concept, set_geometry, rename_geometry, display options (display_precision, io_engine) |
| **Reading-and-writing-files.md** | read_file usage patterns, supported formats (shapefile, GeoJSON, GeoPackage, ZIP, URL), Pyogrio/Fiona engines, multi-layer files, list_layers, writing files |
| **Merging-data.md** | Attribute joins (merge), spatial joins (sjoin, sjoin_nearest), appending GeoDataFrames (pd.concat), predicate options |
| **Projections.md** | CRS concepts, EPSG codes, set_crs vs to_crs, re-projecting, pyproj integration, WKT/PROJ formats |
| **Geometric-manipulations.md** | Constructive methods (buffer, centroid, convex_hull, concave_hull, envelope, simplify, segmentize, offset_curve, delaunay_triangles, union_all), affine transforms (rotate, scale, skew, translate), worked examples |
| **Set-operations-with-overlay.md** | overlay() method: union, intersection, difference, symmetric_difference, identity — set-theoretic operations between two GeoDataFrames |
| **Aggregation-with-dissolve.md** | dissolve() method: spatial groupby, geometry union + attribute aggregation, aggfunc parameter |
| **Indexing-and-selecting-data.md** | Standard pandas indexing (loc, iloc) on GeoDataFrames, coordinate-based indexing with cx bounding box slicer |
| **Making-maps-and-plots.md** | Static plotting with plot(), choropleth maps, legends, colormaps, classification schemes (mapclassify), multi-layer plots, matplotlib integration |
| **Interactive-mapping.md** | explore() method, folium/leaflet.js integration, choropleth, tooltips, popups, custom tiles (xyzservices), multi-layer interactive maps |
| **Geocoding.md** | geocode() and reverse_geocode() via geopy, provider options (Photon, Nominatim, Google, Bing), API keys |
| **Sampling-points.md** | sample_points() method, random point sampling from polygons and lines |
| **How-to.md** | Drop duplicate geometries using normalize() + drop_duplicates() |

---

## Advanced-guide/

| File | Covers |
|---|---|
| **Spatial-indexing.md** | R-tree principles, STRtree, sindex.query() scalar and bulk queries, predicate filtering, performance optimization |
| **Migration-from-PyGEOS-geometry-backend-to-Shapely-2.0.md** | PyGEOS deprecation, migration to Shapely 2.0, code patterns to update (values.data → array) |
| **Migration-from-the-Fiona-to-the-Pyogrio-read-write-engine.md** | Fiona vs Pyogrio engine differences, performance gains, schema parameter removal, EMPTY geometry handling |
| **Missing-and-empty-geometries.md** | Distinction between None (missing) and POLYGON EMPTY (empty), behavior in spatial operations, propagation rules |
| **Re-projecting-using-GDAL-with-Rasterio-and-Fiona.md** | Advanced re-projection via GDAL/Fiona/Rasterio, antimeridian cutting, transform_geom patterns |
