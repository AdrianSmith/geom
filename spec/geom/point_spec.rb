require_relative '../spec_helper.rb'
require 'geom/point'

module Geom
  describe Point do
    before do
      @valid_attributes = [1.1, -2, 10]
    end

    describe "Construction" do
      it "should create a valid instance from an array of coordinates" do
        point = Point.new(@valid_attributes)
        expect(point.x).to eq(@valid_attributes[0])
        expect(point.y).to eq(@valid_attributes[1])
        expect(point.z).to eq(@valid_attributes[2])
      end

      it "should create a valid instance from three numbers" do
        point = Point.new(@valid_attributes[0], @valid_attributes[1], @valid_attributes[2])
        expect(point.x).to eq(@valid_attributes[0])
        expect(point.y).to eq(@valid_attributes[1])
        expect(point.z).to eq(@valid_attributes[2])
      end
    end

    describe "Arithmetic" do
      before do
        @first_point = Point.new(0,0,0)
        @second_point = Point.new(1,2,3)
      end

      it "should allow addition with another point" do
        result = @first_point + @second_point
        expect(result).to eq(Point.new(1,2,3))
      end

      it "should allow subtraction with another point" do
        result = @first_point - @second_point
        expect(result).to eq(Point.new(-1,-2,-3))
      end
    end

    describe "Return Types" do
      it "should return as point" do
        expect(Point.new(@valid_attributes).to_vector).to eq(Vector.new(@valid_attributes))
      end

      it "should return as array" do
        expect(Point.new(@valid_attributes).to_a).to eq(@valid_attributes)
      end

      it "should return a summary string" do
        expect(Point.new(@valid_attributes).to_s).to eq("Point(1.100,-2.000,10.000)")
      end

      it "should return a hash code" do
        expect(Point.new(1,2.88,-45.111).hash).to eq(-48)
      end
    end

    describe "should calculate minimum distance" do
      it "to another point" do
        expect(Point.new(0,0,0).distance_to_point(Point.new(1,3,2))).to eq(Math.sqrt(1*1 + 3*3 + 2*2))
      end

      it "to a plane when the point is remote from the plane" do
        plane_1 = Plane.new(3, 2, 6, 6)
        point_1 = Point.new(1, 1, 3)
        expect(point_1.distance_to_plane(plane_1)).to be_within(0.001).of(-2.429)
      end

      it "to a plane when the point is on the plane" do
        plane_2 = Plane.new(2, 3, 4, 20)
        point_2 = Point.new(1, 2, 3)
        expect(point_2.distance_to_plane(plane_2)).to be_within(0.001).of(0.0)
      end
    end

    it "should calculated the average of an array of points" do
      points = [Point.new(0,0,0), Point.new(1,1,1), Point.new(10,-10,2)]
      average_point = Point.new(11/3.0, -9/3.0, 3/3.0)
      expect(Point.average(points)).to eq(average_point)
    end

    describe "should determine coincidence" do
      before do
        @p1 = Point.new(1,-1,0)
        @p2 = Point.new(1,-1,0)
        @p3 = Point.new(1.1,-1,0)
      end

      it "with another identical point" do
        expect(@p1.coincident?(@p2)).to be_truthy
      end

      it "with a non-identical point" do
        expect(@p1.coincident?(@p3)).to be_falsey
      end

      it "from an array of points and remove any coincident points" do
        expect(Point.remove_coincident([Point.new(1,-1,0), Point.new(1,-1,0), Point.new(1,-1,0), Point.new(1.1,-1,0)]).size).to eq(2)
      end
    end

    describe "should determine if a point is between two points" do
      before do
        @p1 = Point.new(0,-1,0)
        @p2 = Point.new(4,-1,0)
        @p3 = Point.new(9,-1,0)
      end
      it "when the point is bounded" do
        expect(@p2.between?(@p1, @p3)).to be_truthy
      end

      it "when the point is not bounded" do
        expect(@p1.between?(@p2, @p3)).to be_falsey
      end
    end

    describe "should determine if point is on plane" do
      before do
        @plane = Plane.new(0, 0, 1, 1)
        @point_1 = Point.new(0, 0, 1)
        @point_2 = Point.new(0, 0, 2)
        @point_3 = Point.new(0, 0, 1.0000000001)
      end

      it "when the point is on the plane" do
        expect(@point_1.on_plane?(@plane)).to be_truthy
      end

      it "when the point is not on the plane" do
        expect(@point_2.on_plane?(@plane)).to be_falsey
      end

      it "when the point is close but not on the plane" do
        expect(@point_3.on_plane?(@plane)).to be_falsey
      end
    end

    describe "Projection" do
      it "should be projected normal (dropped) onto plane" do
        z_plane = Plane.new(0, 0, 1, 0)
        oblique_plane = Plane.new(-1, 1, 0, 0)
        oblique_offset_plane = Plane.new(0, 0, 1, 10)

        point_1 = Point.new(1, 1, 1)
        point_2 = Point.new(0, 1, 0)

        expect(point_1.project_onto_plane(z_plane)).to eq(Point.new(1, 1, 0))
        expect(point_2.project_onto_plane(oblique_plane)).to eq(Point.new(0.5, 0.5, 0))
        expect(point_1.project_onto_plane(oblique_offset_plane)).to eq(Point.new(1, 1, 10))
      end

      it "should be projected along a vector onto plane" do
        plane = Plane.new(Point.new(1,1,3), Point.new(0,0,3), Point.new(-1,1,3))
        direction = Vector.new(1,1,4)
        start_point = Point.new(5,5,0)
        end_point = start_point.project_onto_plane_along_vector(plane, direction)

        expect(end_point.x).to be_within(0.001).of(5.75)
        expect(end_point.y).to be_within(0.001).of(5.75)
        expect(end_point.z).to be_within(0.001).of(3)
      end

      it "should be projected normal (dropped) onto line" do
        line = Line.new(1, 1, 3, -1, 0, 2)
        point_1 = Point.new(1, 1, 5)
        expect(point_1.project_onto_line(line)).to eq(Point.new(3, 1, 4))

        point_2 = Point.new(1, 3, 0)
        expect(point_2.project_onto_line(line)).to eq(Point.new(1, 3, 0))
      end

      it "should be projected along a vector onto line" do
        line = Line.new(Point.new(0, 0, 0), Point.new(2, 0, 0))
        point = Point.new(0, 1, 0)
        direction = Vector.new(1, -1, 0)
        expect(point.project_onto_line_along_vector(line, direction)).to eq(Point.new(1, 0, 0))
        expect(point).to eq(Point.new(0, 1, 0))
      end
    end

    describe "Translation" do
      it "should translate along a vector" do
        p = Point.new(1,0,0)
        v = Vector.new(1,0,0)
        expect(p.translate(v)).to eq(Point.new(2,0,0))
        expect(p).to eq(Point.new(1,0,0))
      end

      it "should translate along a vector a specified distance" do
        p = Point.new(0,0,1)
        v = Vector.new(0,1,0)
        expect(p.translate(v, 10)).to eq(Point.new(0,10,1))
        expect(p).to eq(Point.new(0,0,1))
      end
    end

    describe "Transformation:" do
      it "should transform into a coordinate system" do
        p1 = Point.new(2,2,0)
        p2 = Point.new(5,5,0)
        vx = Vector.new(1,0,0)
        vy = Vector.new(0,1,0)
        vz = Vector.new(0,0,1)
        rcs = RectangularCoordinateSystem.new_from_xvector_and_xyplane(p2, vy, vz)
        expect(p1.transform(rcs)).to eq(Point.new(-3,3,0))
        expect(p1).to eq(Point.new(2,2,0))
      end
    end
  end
end