# Geom

A 3D geometry library that includes Point, Vector, Line, Plane, Coordinate System and Transformation objects.

Geom is not intended for high-performance/volume geometric calculations but rather to simplify geometric calculations.

## Geometric Entities

* Point
* Vector
* Plane
* Line
* Rectangular Coordinate System
* Transformation

## Installation

    gem install geom

## Usage

Below is an example showing some of the features


```ruby
p1 = Geom::Point.new(1,1,0)
p2 = Geom::Point.new(9,3,0)

v1 = Geom::Vector.new(0,1,0)
p3 = p1.translate(v1, 10)
d1 = p2.distance_to_point(p3)

pnts = [p1, p2, p3]
ave_pnt = Geom::Point.average(pnts)

pln1 = Geom::Plane.new(p1,p2,p3)
p4 = Geom::Point.new(0,0,-10).project_onto_plane(pln1)
v2 = pln1.normal

ln1 = Geom::Line.new(p1,p2)
p5 = p3.project_onto_line(ln1)

rcs = Geom::RectangularCoordinateSystem.new_from_xvector_and_xyplane(p1,v1, v2)
t1 = Geom::Transformation.new(rcs)
p6 = p3.transform(rcs)
```

## TODO

* Add new geometric entities: Ray, Line-Segment, Polyline, CircularArc, 2D Shapes (Circle, Triangle, Polygon)
* Improve Transformation functionality to include: rotation angle and axis

## License

MIT License. Copyright 2011 Ennova.