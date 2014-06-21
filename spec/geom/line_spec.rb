require_relative '../spec_helper.rb'
require 'geom/line'

module Geom
  describe Line do
    describe "Construction" do
      before do
        @valid_attributes = [1, 2, 3, 4, 5, 6]
        @attributes = [:x0, :xa, :y0, :ya, :z0, :za]
      end

      it "should create a valid instance from an array of parameters" do
        line = Line.new(@valid_attributes)
        @attributes.each_with_index{|value, index| expect(line.send(value)).to eq(@valid_attributes[index]) }
      end

      it "should create a valid instance from two points" do
        line = Line.new(Point.new(1, 3, 5), Point.new(3, 7, 11))
        @attributes.each_with_index{|value, index| expect(line.send(value)).to eq(@valid_attributes[index]) }
      end
    end

    describe "Equality" do
      it "should determine equality with another line" do
        line_1 = Line.new(Point.new(0, 0, 0), Point.new(2, 2, 2))
        line_2 = Line.new(Point.new(0, 0, 0), Point.new(2, 2, 2))
        expect(line_1).to eq(line_2)
      end
    end

    describe "Return types" do
      it "should return a summary string" do
        expect(Line.new(1,2,3,1,0,0).to_s).to eq("Line(1.000,2.000,3.000,1.000,0.000,0.000)")
      end

      it "should return a hash code" do
        expect(Line.new(1,2.88,3,1,-45.111,101).hash).to eq(-73)
      end
    end

    describe "Intersection" do
      it "should determine intersection with another line" do
        line_1 = Line.new(Point.new(0, 0, 0), Point.new(10, 10, 0))
        line_2 = Line.new(Point.new(8, 0, 0), Point.new(8, 100, 0))
        expect(line_1.intersection_with_line(line_2)).to eq(Point.new(8, 8, 0))
      end

      it "should raise exception when lines are parallel" do
        line_1 = Line.new(1, 1, 3, -1, 0, 2)
        line_2 = Line.new(1, 2, 3, -2, 0, 4)
        expect {line_1.intersection_with_line(line_2)}.to raise_error(ArgumentError, "Lines are parallel")
      end

      it "should raise exception when lines are skew" do
        line_1 = Line.new(1, 1, 3, -1, 0, 2)
        line_2 = Line.new(1, 2, 3, -2.5, 0.3, 4)
        expect {line_1.intersection_with_line(line_2)}.to raise_error(ArgumentError, "Lines do not intersect")
      end

      it "should calculation intersection with a plane" do
        plane = Plane.new(Point.new(0, 0, 0), Vector.new(0, 0, 1))
        line = Line.new(Point.new(2, 2, 10), Point.new(2, 2, 20))
        expect(line.intersection_with_plane(plane)).to eq(Point.new(2, 2, 0))
      end
    end

    describe "Parameters" do
      it "should calculate closest approach parameter" do
        line_1 = Line.new(Point.new(0, 0, 0), Point.new(1, 1, 0))
        line_2 = Line.new(Point.new(0.5, -0.5, 0), Point.new(0.5, -0.1, 0))
        expect(line_1.closest_approach_parameter(line_2)).to be_within(0.001).of(0.5)
      end

      it "should calculate point at parameter" do
        line = Line.new(1, 1, 3, -1, 0, 2)
        expect(line.point_at_parameter(5)).to eq(Point.new(6, -2, 10))
      end

      describe "should calculate parameter" do
        before do
          @start_point = Point.new(-1, -1, -1)
          @end_point   = Point.new(1, 1, 1)
          @mid_point   = Point.new(0, 0, 0)
          @line = Line.new(@start_point, @end_point)
        end

        it "at start point" do
          expect(@line.parameter_at_point(@start_point)).to eq(0)
        end

        it "at end point" do
          expect(@line.parameter_at_point(@end_point)).to eq(1)
        end

        it "at mid point" do
          expect(@line.parameter_at_point(@mid_point)).to eq(0.5)
        end

        it "at point beyond end point" do
          expect(@line.parameter_at_point(Point.new(10,10,10))).to eq(5.5)
        end

      end

      describe "should determine if a line is on a plane" do
        before do
          @plane = Plane.new(0, 0, 1, 0)
        end
        it "when a line is on a plane" do
          line_1 = Line.new(Point.new(1, 1, 0), Point.new(2, -3, 0))
          expect(line_1.on_plane?(@plane)).to be_truthy
        end

        it "when a line is parallel to a plane" do
          line_2 = Line.new(Point.new(1, 1, 1), Point.new(2, -3, 1))
          expect(line_2.on_plane?(@plane)).to be_falsey
        end
        it "when a line intersects plane" do
          line_3 = Line.new(Point.new(1, 1, 0), Point.new(2, -3, 1))
          expect(line_3.on_plane?(@plane)).to be_falsey
        end
      end
    end
  end
end