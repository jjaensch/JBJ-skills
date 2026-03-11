# GeoSeries
## Constructor
|Code|Functionality|
|---|---|
|GeoSeries([data, index, crs])| A Series object designed to store shapely geometry objects.|

## General methods and attributes
|Code|Functionality|
|---|---|
|GeoSeries.area| Returns a Series containing the area of each geometry in the GeoSeries expressed in the units of the CRS.|
|GeoSeries.boundary| Returns a GeoSeries of lower dimensional objects representing each geometry's set-theoretic boundary.|
|GeoSeries.bounds| Returns a DataFrame with columns minx, miny, maxx, maxy values containing the bounds for each geometry.|
|GeoSeries.total_bounds| Returns a tuple containing minx, miny, maxx, maxy values for the bounds of the series as a whole.|
|GeoSeries.length| Returns a Series containing the length of each geometry expressed in the units of the CRS.|
|GeoSeries.geom_type| Returns a Series of strings specifying the Geometry Type of each object.|
|GeoSeries.offset_curve(distance[, ...])| Returns a LineString or MultiLineString geometry at a distance from the object on its right or its left side.|
|GeoSeries.distance(other[, align])| Returns a Series containing the distance to aligned other.|
|GeoSeries.hausdorff_distance(other[, align, ...])| Returns a Series containing the Hausdorff distance to aligned other.|
|GeoSeries.frechet_distance(other[, align, ...])| Returns a Series containing the Frechet distance to aligned other.|
|GeoSeries.representative_point()| Returns a GeoSeries of (cheaply computed) points that are guaranteed to be within each geometry.|
|GeoSeries.exterior| Returns a GeoSeries of LinearRings representing the outer boundary of each polygon in the GeoSeries.|
|GeoSeries.interiors| Returns a Series of List representing the inner rings of each polygon in the GeoSeries.|
|GeoSeries.minimum_bounding_radius()| Returns a Series of the radii of the minimum bounding circles that enclose each geometry.|
|GeoSeries.minimum_clearance()| Returns a Series containing the minimum clearance distance, which is the smallest distance by which a vertex of the geometry could be moved to produce an invalid geometry.|
|GeoSeries.x| Return the x location of point geometries in a GeoSeries|
|GeoSeries.y| Return the y location of point geometries in a GeoSeries|
|GeoSeries.z| Return the z location of point geometries in a GeoSeries|
|GeoSeries.m| Return the m coordinate of point geometries in a GeoSeries|
|GeoSeries.get_coordinates([include_z, ...])| Gets coordinates from a GeoSeries as a DataFrame of floats.|
|GeoSeries.count_coordinates()| Returns a Series containing the count of the number of coordinate pairs in each geometry.|
|GeoSeries.count_geometries()| Returns a Series containing the count of geometries in each multi-part geometry.|
|GeoSeries.count_interior_rings()| Returns a Series containing the count of the number of interior rings in a polygonal geometry.|
|GeoSeries.set_precision(grid_size[, mode])| Returns a GeoSeries with the precision set to a precision grid size.|
|GeoSeries.get_precision()| Returns a Series of the precision of each geometry.|
|GeoSeries.get_geometry(index)| Returns the n-th geometry from a collection of geometries.|

## Unary predicates
|Code|Functionality|
|---|---|
|GeoSeries.is_closed| Returns a Series of dtype('bool') with value True if a LineString's or LinearRing's first and last points are equal.|
|GeoSeries.is_empty| Returns a Series of dtype('bool') with value True for empty geometries.|
|GeoSeries.is_ring| Returns a Series of dtype('bool') with value True for features that are closed.|
|GeoSeries.is_simple| Returns a Series of dtype('bool') with value True for geometries that do not cross themselves.|
|GeoSeries.is_valid| Returns a Series of dtype('bool') with value True for geometries that are valid.|
|GeoSeries.is_valid_reason()| Returns a Series of strings with the reason for invalidity of each geometry.|
|GeoSeries.is_valid_coverage(*[, gap_width])| Returns a bool indicating whether a GeoSeries forms a valid coverage|
|GeoSeries.invalid_coverage_edges(*[, gap_width])| Returns a GeoSeries containing edges causing invalid polygonal coverage|
|GeoSeries.has_m| Returns a Series of dtype('bool') with value True for features that have a m-component.|
|GeoSeries.has_z| Returns a Series of dtype('bool') with value True for features that have a z-component.|
|GeoSeries.is_ccw| Returns a Series of dtype('bool') with value True if a LineString or LinearRing is counterclockwise.|

## Binary predicates
|Code|Functionality|
|---|---|
|GeoSeries.contains(other[, align])| Returns a Series of dtype('bool') with value True for each aligned geometry that contains other.|
|GeoSeries.contains_properly(other[, align])| Returns a Series of dtype('bool') with value True for each aligned geometry that is completely inside other, with no common boundary points.|
|GeoSeries.crosses(other[, align])| Returns a Series of dtype('bool') with value True for each aligned geometry that cross other.|
|GeoSeries.disjoint(other[, align])| Returns a Series of dtype('bool') with value True for each aligned geometry disjoint to other.|
|GeoSeries.dwithin(other, distance[, align])| Returns a Series of dtype('bool') with value True for each aligned geometry that is within a set distance from other.|
|GeoSeries.geom_equals(other[, align])| Returns a Series of dtype('bool') with value True for each aligned geometry equal to other.|
|GeoSeries.geom_equals_exact(other, tolerance)| Return True for all geometries that equal aligned other to a given tolerance, else False.|
|GeoSeries.geom_equals_identical(other[, align])| Return True for all geometries that are identical aligned other, else False.|
|GeoSeries.intersects(other[, align])| Returns a Series of dtype('bool') with value True for each aligned geometry that intersects other.|
|GeoSeries.overlaps(other[, align])| Returns True for all aligned geometries that overlap other, else False.|
|GeoSeries.touches(other[, align])| Returns a Series of dtype('bool') with value True for each aligned geometry that touches other.|
|GeoSeries.within(other[, align])| Returns a Series of dtype('bool') with value True for each aligned geometry that is within other.|
|GeoSeries.covers(other[, align])| Returns a Series of dtype('bool') with value True for each aligned geometry that is entirely covering other.|
|GeoSeries.covered_by(other[, align])| Returns a Series of dtype('bool') with value True for each aligned geometry that is entirely covered by other.|
|GeoSeries.relate(other[, align])| Returns the DE-9IM intersection matrices for the geometries|
|GeoSeries.relate_pattern(other, pattern[, align])| Returns True if the DE-9IM string code for the relationship between the geometries satisfies the pattern, else False.|

## Set-theoretic methods
|Code|Functionality|
|---|---|
|GeoSeries.clip_by_rect(xmin, ymin, xmax, ymax)| Returns a GeoSeries of the portions of geometry within the given rectangle.|
|GeoSeries.difference(other[, align])| Returns a GeoSeries of the points in each aligned geometry that are not in other.|
|GeoSeries.intersection(other[, align])| Returns a GeoSeries of the intersection of points in each aligned geometry with other.|
|GeoSeries.symmetric_difference(other[, align])| Returns a GeoSeries of the symmetric difference of points in each aligned geometry with other.|
|GeoSeries.union(other[, align])| Returns a GeoSeries of the union of points in each aligned geometry with other.|

## Constructive methods and attributes
|Code|Functionality|
|---|---|
|GeoSeries.boundary| Returns a GeoSeries of lower dimensional objects representing each geometry's set-theoretic boundary.|
|GeoSeries.buffer(distance[, resolution, ...])| Returns a GeoSeries of geometries representing all points within a given distance of each geometric object.|
|GeoSeries.centroid| Returns a GeoSeries of points representing the centroid of each geometry.|
|GeoSeries.concave_hull([ratio, allow_holes])| Returns a GeoSeries of geometries representing the concave hull of vertices of each geometry.|
|GeoSeries.convex_hull| Returns a GeoSeries of geometries representing the convex hull of each geometry.|
|GeoSeries.envelope| Returns a GeoSeries of geometries representing the envelope of each geometry.|
|GeoSeries.extract_unique_points()| Returns a GeoSeries of MultiPoints representing all distinct vertices of an input geometry.|
|GeoSeries.force_2d()| Forces the dimensionality of a geometry to 2D.|
|GeoSeries.force_3d([z])| Forces the dimensionality of a geometry to 3D.|
|GeoSeries.make_valid(*[, method, keep_collapsed])| Repairs invalid geometries.|
|GeoSeries.minimum_bounding_circle()| Returns a GeoSeries of geometries representing the minimum bounding circle that encloses each geometry.|
|GeoSeries.maximum_inscribed_circle(*[, ...])| Returns a GeoSeries of geometries representing the largest circle that is fully contained within the input geometry.|
|GeoSeries.minimum_clearance()| Returns a Series containing the minimum clearance distance, which is the smallest distance by which a vertex of the geometry could be moved to produce an invalid geometry.|
|GeoSeries.minimum_clearance_line()| Returns a GeoSeries of linestrings whose endpoints define the minimum clearance.|
|GeoSeries.minimum_rotated_rectangle()| Returns a GeoSeries of the general minimum bounding rectangle that contains the object.|
|GeoSeries.normalize()| Returns a GeoSeries of normalized geometries to normal form (or canonical form).|
|GeoSeries.orient_polygons(*[, exterior_cw])| Returns a GeoSeries of geometries with enforced ring orientation.|
|GeoSeries.remove_repeated_points([tolerance])| Returns a GeoSeries containing a copy of the input geometry with repeated points removed.|
|GeoSeries.reverse()| Returns a GeoSeries with the order of coordinates reversed.|
|GeoSeries.sample_points(size[, method, ...])| Sample points from each geometry.|
|GeoSeries.segmentize(max_segment_length)| Returns a GeoSeries with vertices added to line segments based on maximum segment length.|
|GeoSeries.shortest_line(other[, align])| Returns the shortest two-point line between two geometries.|
|GeoSeries.simplify(tolerance[, ...])| Returns a GeoSeries containing a simplified representation of each geometry.|
|GeoSeries.simplify_coverage(tolerance, *[, ...])| Returns a GeoSeries containing a simplified representation of polygonal coverage.|
|GeoSeries.snap(other, tolerance[, align])| Snap the vertices and segments of the geometry to vertices of the reference.|
|GeoSeries.transform(transformation[, include_z])| Returns a GeoSeries with the transformation function applied to the geometry coordinates.|

## Affine transformations
|Code|Functionality|
|---|---|
|GeoSeries.affine_transform(matrix)| Return a GeoSeries with translated geometries.|
|GeoSeries.rotate(angle[, origin, use_radians])| Returns a GeoSeries with rotated geometries.|
|GeoSeries.scale([xfact, yfact, zfact, origin])| Returns a GeoSeries with scaled geometries.|
|GeoSeries.skew([xs, ys, origin, use_radians])| Returns a GeoSeries with skewed geometries.|
|GeoSeries.translate([xoff, yoff, zoff])| Returns a GeoSeries with translated geometries.|

## Linestring operations
|Code|Functionality|
|---|---|
|GeoSeries.interpolate(distance[, normalized])| Return a point at the specified distance along each geometry|
|GeoSeries.line_merge([directed])| Returns (Multi)LineStrings formed by combining the lines in a MultiLineString.|
|GeoSeries.project(other[, normalized, align])| Return the distance along each geometry nearest to other|
|GeoSeries.shared_paths(other[, align])| Returns the shared paths between two geometries.|

## Aggregating and exploding
|Code|Functionality|
|---|---|
|GeoSeries.build_area([node])| Creates an areal geometry formed by the constituent linework.|
|GeoSeries.constrained_delaunay_triangles()| Returns a GeoSeries with the constrained Delaunay triangulation of polygons.|
|GeoSeries.delaunay_triangles([tolerance, ...])| Returns a GeoSeries consisting of objects representing the computed Delaunay triangulation between the vertices of an input geometry.|
|GeoSeries.explode([ignore_index, index_parts])| Explode multi-part geometries into multiple single geometries.|
|GeoSeries.intersection_all()| Returns a geometry containing the intersection of all geometries in the GeoSeries.|
|GeoSeries.polygonize([node, full])| Creates polygons formed from the linework of a GeoSeries.|
|GeoSeries.union_all([method, grid_size])| Returns a geometry containing the union of all geometries in the GeoSeries.|
|GeoSeries.voronoi_polygons([tolerance, ...])| Returns a GeoSeries consisting of objects representing the computed Voronoi diagram around the vertices of an input geometry.|

## Serialization / IO / conversion
|Code|Functionality|
|---|---|
|GeoSeries.from_arrow(arr, **kwargs)| Construct a GeoSeries from a Arrow array object with a GeoArrow extension type.|
|GeoSeries.from_file(filename, **kwargs)| Alternate constructor to create a GeoSeries from a file.|
|GeoSeries.from_wkb(data[, index, crs, ...])| Alternate constructor to create a GeoSeries from a list or array of WKB objects|
|GeoSeries.from_wkt(data[, index, crs, ...])| Alternate constructor to create a GeoSeries from a list or array of WKT objects|
|GeoSeries.from_xy(x, y[, z, index, crs])| Alternate constructor to create a GeoSeries of Point geometries from lists or arrays of x, y(, z) coordinates|
|GeoSeries.to_arrow([geometry_encoding, ...])| Encode a GeoSeries to GeoArrow format.|
|GeoSeries.to_file(filename[, driver, index])| Write the GeoSeries to a file.|
|GeoSeries.to_json([show_bbox, drop_id, to_wgs84])| Returns a GeoJSON string representation of the GeoSeries.|
|GeoSeries.to_wkb([hex])| Convert GeoSeries geometries to WKB|
|GeoSeries.to_wkt(**kwargs)| Convert GeoSeries geometries to WKT|

## Projection handling
|Code|Functionality|
|---|---|
|GeoSeries.crs| The Coordinate Reference System (CRS) represented as a pyproj.CRS object.|
|GeoSeries.set_crs(**kwargs)| Missing description! |
|GeoSeries.to_crs([crs, epsg])| Returns a GeoSeries with all geometries transformed to a new coordinate reference system.|
|GeoSeries.estimate_utm_crs([datum_name])| Returns the estimated UTM CRS based on the bounds of the dataset.|

## Missing values
|Code|Functionality|
|---|---|
|GeoSeries.fillna([value, inplace, limit])| Fill NA values with geometry (or geometries).|
|GeoSeries.isna()| Detect missing values.|
|GeoSeries.notna()| Detect non-missing values.|

## Overlay operations
|Code|Functionality|
|---|---|
|GeoSeries.clip(mask[, keep_geom_type, sort])| Clip points, lines, or polygon geometries to the mask extent.|

## Plotting
|Code|Functionality|
|---|---|
|GeoSeries.plot(*args, **kwargs)| Plot a GeoSeries.|
|GeoSeries.explore(*args, **kwargs)| Interactive map based on folium/leaflet.js Interactive map based on GeoPandas and folium/leaflet.js|

## Spatial index
|Code|Functionality|
|---|---|
|GeoSeries.sindex| Generate the spatial index|
|GeoSeries.has_sindex| Check the existence of the spatial index without generating it.|

## Indexing
|Code|Functionality|
|---|---|
|GeoSeries.cx| Coordinate based indexer to select by intersection with bounding box.|

## Interface
|Code|Functionality|
|---|---|
|GeoSeries.__geo_interface__| Returns a GeoSeries as a python feature collection.|

Methods of pandas Series objects are also available, although not all are applicable to geometric objects and some may return a Series rather than a GeoSeries result when appropriate. The methods isna() and fillna() have been implemented specifically for GeoSeries and are expected to work correctly.