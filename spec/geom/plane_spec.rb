require_relative '../spec_helper.rb'
require 'geom/plane.rb'

module Geom
  describe Plane do
    before(:each) do
      @valid_attributes = [-10, 10, 0, 4]
    end

    it "should create a valid instance from an array of coordinates" do
      plane = Plane.new(@valid_attributes)
      plane.a.should be_within(0.001).of(-0.707)
      plane.b.should be_within(0.001).of(0.707)
      plane.c.should be_within(0.001).of(0.0)
      plane.d.should be_within(0.001).of(0.283)
    end

    it "should create a valid instance from three numbers" do
      plane = Plane.new(Point.new(0, 3, 0), Vector.new(0, 3, 0))
      plane.a.should == 0
      plane.b.should == 1
      plane.c.should == 0
      plane.d.should == 3
    end

    it "should calculate the plane normal vector" do
      test_plane = Plane.new(@valid_attributes)
      normal = test_plane.normal
      normal.x.should be_within(0.001).of(-0.707)
      normal.y.should be_within(0.001).of(0.707)
      normal.z.should be_within(0.001).of(0)
    end

    it "should calculate minimum distance to point" do
      plane_1 = Plane.new(3, 2, 6, 6)
      point_1 = Point.new(1, 1, 3)
      plane_1.distance_to(point_1).should be_within(0.001).of(-2.429)

      plane_2 = Plane.new(2, 3, 4, 20)
      point_2 = Point.new(1, 2, 3)
      plane_2.distance_to(point_2).should be_within(0.001).of(0.0)
    end

    it "should determine if line is on plane" do
      # Line on plane
      plane = Plane.new(0, 0, 1, 0)

      line_1 = Line.new(Point.new(1, 1, 0), Point.new(2, -3, 0))
      plane.line_on?(line_1).should be_true

      # Line parallel to plane
      line_2 = new Line(Point.new(1, 1, 1), Point.new(2, -3, 1))
      plane.line_on?(line_2).should be_false

      # Line intersects plane
      line_3 = new Line(Point.new(1, 1, 0), Point.new(2, -3, 1))
      plane.line_on?(line_2).should be_false
    end
  end
end