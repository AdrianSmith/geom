require_relative '../spec_helper.rb'
require 'geom/line.rb'

module Geom
  describe Line do
    before(:each) do
      @valid_attributes = [1, 2, 3, 4, 5, 6]
    end

    it "should create a valid instance from an array of parameters" do
      line = Line.new(@valid_attributes)
      line.x0.should == 1
      line.xa.should == 2
      line.y0.should == 3
      line.ya.should == 4
      line.z0.should == 5
      line.za.should == 6
    end

    it "should create a valid instance from two points" do
      line = Line.new(Point.new(0, 0, 0), Point.new(2, 2, 2))
      line.x0.should == 0
      line.xa.should == 2
      line.y0.should == 0
      line.ya.should == 2
      line.z0.should == 0
      line.za.should == 2
    end

    it "should determine if line is on plane" do
      # Line on plane
      plane = Plane.new(0, 0, 1, 0)

      line_1 = Line.new(Point.new(1, 1, 0), Point.new(2, -3, 0))
      line_1.on_plane?(plane).should be_true

      # Line parallel to plane
      line_2 = Line.new(Point.new(1, 1, 1), Point.new(2, -3, 1))
      line_2.on_plane?(plane).should be_false

      # Line intersects plane
      line_3 = Line.new(Point.new(1, 1, 0), Point.new(2, -3, 1))
      line_3.on_plane?(plane).should be_false
    end

    describe "Intersection" do
      it "should determine intersection with another line" do
        line_1 = Line.new(Point.new(0, 0, 0), Point.new(10, 10, 0))
        line_2 = Line.new(Point.new(8, 0, 0), Point.new(8, 100, 0))
        line_1.intersection_with_line(line_2).should == Point.new(8, 8, 0)
      end

      it "should raise exception when does not intersection with another line" do
        line_1 = Line.new(1, 1, 3, -1, 0, 2)
        line_2 = Line.new(1, 2, 3, -2, 0, 4)
        expect{line_1.intersection_with_line(line_2)}.to raise_exception
      end

      it "should calculate closest approach parameter" do
        line_1 = Line.new(Point.new(0, 0, 0), Point.new(1, 1, 0))
        line_2 = Line.new(Point.new(0.5, -0.5, 0), Point.new(0.5, -0.1, 0))
        line_1.closest_approach_parameter(line_2).should be_within(0.001).of(0.5)
      end

      it "should calculate point at parameter" do
        line = Line.new(1, 1, 3, -1, 0, 2)
        line.point_at_parameter(5).should == Point.new(6, -2, 10)
      end

      it "should calculate parameter at point" do
        start_point = Point.new(0, 0, 0)
        end_point   = Point.new(1, 1, 0)
        mid_point   = Point.new(0.5, 0.5, 0)
        line = Line.new(start_point, end_point)
        line.parameter_at_point(start_point).should == 0
        line.parameter_at_point(end_point).should == 1
        line.parameter_at_point(mid_point).should == 0.5
      end

      it "should calculation intersection with a plane" do
        plane = Plane.new(Point.new(0, 0, 0), Vector.new(0, 0, 1))
        line = Line.new(Point.new(2, 2, 10), Point.new(2, 2, 20))
        line.intersection_with_plane(plane).should == Point.new(2, 2, 0)
      end
    end
  end
end