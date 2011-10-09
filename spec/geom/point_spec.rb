require_relative '../spec_helper.rb'
require 'geom/point'

module Geom
  describe Point do
    before(:each) do
      @valid_attributes = [1.1, -2, 10]
    end

    it "should create a valid instance from an array of coordinates" do
      test_point = Point.new(@valid_attributes)
      test_point.x.should == @valid_attributes[0]
      test_point.y.should == @valid_attributes[1]
      test_point.z.should == @valid_attributes[2]
    end

    it "should create a valid instance from three numbers" do
      test_point = Point.new(@valid_attributes[0], @valid_attributes[1], @valid_attributes[2])
      test_point.x.should == @valid_attributes[0]
      test_point.y.should == @valid_attributes[1]
      test_point.z.should == @valid_attributes[2]
    end

    describe "Arithmetic:" do
      before(:each) do
        @first_point = Point.new(0,0,0)
        @second_point = Point.new(1,2,3)
      end

      it "should allow addition with another point" do
        result = @first_point + @second_point
        result.should == Point.new(1,2,3)
      end

      it "should allow subtraction with another point" do
        result = @first_point - @second_point
        result.should == Point.new(-1,-2,-3)
      end
    end

    describe "Return Types:" do

      it "should return as vector" do
        Point.new(@valid_attributes).to_vector.should == Vector.new(@valid_attributes)
      end

      it "should return as array" do
        Point.new(@valid_attributes).to_ary.should == @valid_attributes
      end
    end

    it "should calculated distance to another point" do
      Point.new(0,0,0).distance(Point.new(1,3,2)).should == Math.sqrt(1*1 + 3*3 + 2*2)
    end

    it "should calculated the average of an array of points" do
      points = [Point.new(0,0,0), Point.new(1,1,1), Point.new(10,-10,2)]
      average_point = Point.new(11/3.0, -9/3.0, 3/3.0)
      Point.average(points).should == average_point
    end

    it "should determine if coincidence with another point" do
      p1 = Point.new(1,-1,0)
      p2 = Point.new(1,-1,0)
      p3 = Point.new(1.1,-1,0)
      p1.coincident?(p2).should be_true
      p1.coincident?(p3).should be_false
    end

    it "should remove coincident points from an array of points" do
      Point.remove_coincident([Point.new(1,-1,0), Point.new(1,-1,0), Point.new(1,-1,0), Point.new(1.1,-1,0)]).size.should == 2
    end

    it "should determine if point is between two other points" do
      # p1 = Point.new(0,-1,0)
      # p2 = Point.new(4,-1,0)
      # p3 = Point.new(9,-1,0)
      # p2.between?(p1, p3).should be_true
      # p1.between?(p2, p3).should be_false
      pending("not implemented")
    end

    it "should determine if an array of point is collinear" do
      # Point.collinear?([Point.new(1,-1,0), Point.new(2,-1,0), Point.new(100000,-1,0)]).should == true
      # Point.collinear?([Point.new(1,-1.01,0), Point.new(2,-1,0), Point.new(100000,-1,0)]).should == false
      pending("not implemented")
    end

    describe "Projection:" do
      it "should be projected normal (dropped) onto plane" do
        z_plane = Plane.new(0, 0, 1, 0)
        oblique_plane = Plane.new(-1, 1, 0, 0)
        oblique_offset_plane = Plane.new(0, 0, 1, 10)

        point_1 = Point.new(1, 1, 1)
        point_2 = Point.new(0, 1, 0)

        point_1.project(z_plane).should == Point.new(1, 1, 0)
        point_2.project(oblique_plane).should == Point.new(0.5, 0.5, 0)
        point_1.project(oblique_offset_plane).should == Point.new(1, 1, 10)
      end

      it "should be projected along a vector onto plane" do

        plane = Plane.new(Point.new(1,1,3), Point.new(0,0,3), Point.new(-1,1,3))
        direction = Vector.new(1,1,4)
        start_point = Point.new(5,5,0)
        end_point = start_point.project_along(plane, direction)

        end_point.x.should be_within(0.001).of(5.75)
        end_point.y.should be_within(0.001).of(5.75)
        end_point.z.should be_within(0.001).of(3)
      end

      it "should be projected normal (dropped) onto line" do
        pending("not implemented")
      end 

      it "should be projected along a vector onto line" do
        pending("not implemented")
      end

      it "should be projected normal (dropped) onto line-segment" do
        pending("not implemented")
      end

      it "should be projected along a vector onto line-segment" do
        pending("not implemented")
      end
    end

    describe "Translation:" do
      it "should translate along a vector" do
        p = Point.new(1,0,0)
        v = Vector.new(1,0,0)
        p.translate(v).should == Point.new(2,0,0)
      end

      it "should translate along a vector a specified distance" do
        p = Point.new(0,0,1)
        v = Vector.new(0,1,0)

        p.translate(v, 10).should == Point.new(0,10,1)
      end
    end

    describe "Transformation:" do
    end

  end
end