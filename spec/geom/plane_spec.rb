require_relative '../spec_helper.rb'
require 'geom/plane'
require 'geom/point'
require 'geom/vector'

module Geom
  describe Plane do
    before(:each) do
      @valid_attributes = [-10, 10, 0, 4]
    end

    it "should create a valid instance from an array of coordinates" do
      test_plane = Plane.new(@valid_attributes)
      test_plane.a.should be_within(0.001).of(-0.707)
      test_plane.b.should be_within(0.001).of(0.707)
      test_plane.c.should == 0
      test_plane.d.should be_within(0.001).of(0.283)
    end

    it "should create a valid instance from three numbers" do
      test_plane = Plane.new(Point.new(0, 3, 0), Vector.new(0, 3, 0))
      test_plane.a.should == 0
      test_plane.b.should == 1
      test_plane.c.should == 0
      test_plane.d.should == 3
    end

    it "should calculate the plane normal vector" do
      test_plane = Plane.new(@valid_attributes)
      normal = test_plane.normal
      normal.x.should be_within(0.001).of(-0.707)
      normal.y.should be_within(0.001).of(0.707)
      normal.z.should be_within(0.001).of(0)
    end

    it "should determine if point is on plane" do
      plane = Plane.new(0, 0, 1, 1)
      point_1 = Point.new(0, 0, 1)
      point_2 = Point.new(0, 0, 2)
      point_3 = Point.new(0, 0, 1.0000000001)

      plane.point_on?(point_1).should be_true
      plane.point_on?(point_2).should be_false
      plane.point_on?(point_3).should be_false
    end
  end
end