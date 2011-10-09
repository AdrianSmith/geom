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

    it "should determine if another plane is equal" do
      plane_1 = Plane.new(Point.new(0, 3, 0), Vector.new(0, 3, 0))
      plane_2 = Plane.new(Point.new(0, 3, 0), Vector.new(0, 3, 0))
      plane_1.should == plane_2
    end

    it "should calculate the plane normal vector" do
      test_plane = Plane.new(@valid_attributes)
      normal = test_plane.normal
      normal.x.should be_within(0.001).of(-0.707)
      normal.y.should be_within(0.001).of(0.707)
      normal.z.should be_within(0.001).of(0)
    end

    it "should return a summary string" do
      Plane.new(1,2,3,1).to_s.should == "Plane(0.267,0.535,0.802,0.267)"
    end

  end
end