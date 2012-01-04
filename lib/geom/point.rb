module Geom
  # Point defined by coordinates x, y, z
  class Point
    attr_accessor :x, :y, :z

    def initialize(*args)
      @x, @y, @z = args.flatten
    end

    def -(point)
      Point.new(@x - point.x, @y - point.y, @z - point.z)
    end

    def +(point)
      Point.new(@x + point.x, @y + point.y, @z + point.z)
    end

    def ==(point)
      (@x - point.x).abs < TOLERANCE &&
      (@y - point.y).abs < TOLERANCE &&
      (@z - point.z).abs < TOLERANCE
    end
    alias_method :eql?, :==
    alias_method :coincident?, :==

    def hash
      (@x.to_int ^ @y.to_int ^ @z.to_int)
    end

    def distance_to_point(point)
      x_dist = @x - point.x
      y_dist = @y - point.y
      z_dist = @z - point.z
      Math.sqrt(x_dist * x_dist + y_dist * y_dist + z_dist * z_dist)
    end

    def distance_to_plane(plane)
      n = Vector.new(plane.a, plane.b, plane.c)
      l = n.length
      d = (plane.d / (l * l))
      pnt = Point.new((plane.a * d), (plane.b * d), (plane.c * d))
      vec = Vector.new(self, pnt)
      vec.dot(n) / l
    end

    def translate(direction, distance=1)
      transation_vector = direction.unitize.scale distance
      Point.new(@x + transation_vector.x, @y + transation_vector.y, @z + transation_vector.z)
    end

    def transform(rectangular_coordinate_system)
      m = Transformation.new(rectangular_coordinate_system).matrix
      tx = m[0,0] * @x + m[0,1] * @y + m[0,2] * @z + m[0,3] * 1.0
      ty = m[1,0] * @x + m[1,1] * @y + m[1,2] * @z + m[1,3] * 1.0
      tz = m[2,0] * @x + m[2,1] * @y + m[2,2] * @z + m[2,3] * 1.0
      Point.new(tx, ty, tz)
    end

    def project_onto_line(line)
      l = line.xa * line.xa + line.ya * line.ya + line.za * line.za
      m = 2 * (line.x0 - self.x) * line.xa + 2 * (line.y0 - self.y) * line.ya + 2 * (line.z0 - self.z) * line.za
      t = -m / (2 * l)
      Point.new(line.x0 + line.xa * t, line.y0 + line.ya * t, line.z0 + line.za * t)
    end

    def project_onto_line_along_vector(line, vector)
      ref_line = Line.new(@x, vector.x, @y, vector.y, @z, vector.z)
      line.intersection_with_line(ref_line)
    end

    def project_onto_plane(plane)
      n = plane.normal
      q = self.to_vector

      r = (q.dot(n) - plane.d) / n.length

      result = q - n.unitize.scale(r)
      result.to_point
    end

    def project_onto_plane_along_vector(plane, vector)

      l = Math.sqrt(plane.a * plane.a + plane.b * plane.b + plane.c * plane.c)
      d = (plane.d / (l * l))
      q = Point.new((plane.a * d), (plane.b * d), (plane.c * d))
      v = Vector.new(q, self)

      u = plane.normal
      w = vector.scale((v.dot(u) / vector.dot(u)))
      r = q.to_vector + (v - w)

      r.to_point
    end

    def between?(first_point, second_point, include_ends=true)
      line = Line.new(first_point, second_point)
      projected_point = self.project_onto_line(line)

      distance_12 = first_point.distance_to_point(second_point)
      distance_T1 = first_point.distance_to_point(projected_point)
      distance_T2 = second_point.distance_to_point(projected_point)

      if include_ends
        (distance_T1 < distance_12) && (distance_T2 < distance_12)
      else
        (distance_T1 <= distance_12) && (distance_T2 <= distance_12)
      end
    end

    def on_plane?(plane)
      projected_point = self.project_onto_plane(plane)
      projected_point.distance_to_point(self).abs <= TOLERANCE
    end

    def on_line?(line)
      projected_point = self.project_onto_line(line)
      self.Distance(projected_point) <= Tolerance
    end

    def self.remove_coincident(points)
      points.uniq
    end

    def self.average(points)
      tx, ty, tz = 0, 0, 0
      num = points.size.to_f
      points.each do |point|
        tx += point.x
        ty += point.y
        tz += point.z
      end
      Point.new(tx/num, ty/num, tz/num)
    end

    def to_vector
      Vector.new(@x,@y,@z)
    end

    def to_s
      "Point(%.3f,%.3f,%.3f)" % [@x, @y, @z]
    end

    def to_a
      [@x, @y, @z]
    end

  end
end
