---
name: Geopandas-1.1.0
description: 'Geopandas 1.1.0 reference and coding guidance. Use when: working with gpd, GeoDataFrame, GeoSeries, spatial joins, geometric operations, coordinate reference systems, geospatial file I/O (shapefile, GeoJSON, GeoPackage). Version-aware — warns on API differences.'
argument-hint: Infuse Geopandas 1.1.0 docs.
user-invocable: true
disable-model-invocation: false
---

# Skill contents for "Geopandas 1.1.0"

## Purpose
This skill infuses Github Copilot with reference materials and coding guidance specific to Geopandas version 1.1.0. It helps the agent understand when to apply geospatial operations, how to use GeoDataFrames and GeoSeries, and provides version-aware advice on API usage and common pitfalls. 

### When to Use
- When referencing "geopandas", "gpd", "geoseries" or "geodataframe" in prompt queries. 
- When working with geospatial data (Geojson, shapefile, GeoPackage, shp, gdb, Postgis, WKT, WKB).
- When you need to perform geospatial operations (spatial join, dissolve, buffer, clip, difference, union, geometric operations, geometry).

### Procedure
1. Identify which GeoPandas concepts the user's question involves (I/O, spatial ops, CRS, plotting, etc.).
2. List files in the relevant reference subdirectory- Advanced-guide, User-guide, API-references - then read the most applicable one.
3. Construct the answer using version 1.1.0 APIs — cite which reference file was consulted.
4. If the answer involves packages beyond GeoPandas, name them explicitly.


### Notes / Constraints 
- If the user mentions a version other than 1.1.0, warn that reference material may not match.
- Check the project's requirements.txt or active environment to identify related geodata packages in use.
- Warn the user of when mixing Arcpy and Geopandas functionalities, as they can cause conflicts.
- Always provide the user in chat responses, what other geodata related packages are activated in the current project and are proposed to be used for a given chat response, if any.

```markdown
.github/skills/Geodata/geopandas-1.1.0/
├── SKILL.md            # Required — entry point (name + description + instructions)
└── references/         # Supplementary docs loaded on demand
    ├── Advanced-guide/  # Optional — in-depth guides and best practices
    ├── User-guide/      # Optional — user-focused guidance and examples
    └── API-references/  # Optional — detailed API documentation
```
