require_relative '../spec_helper.rb'
require 'geom/plane'

module Geom
  describe Plane do
    before do
      @valid_attributes = [-10, 10, 0, 4]
      @tol = 0.001
    end

    describe "Construction" do
      it "should create a valid instance from an array of coordinates" do
        plane = Plane.new(@valid_attributes)
        expect(plane.a).to be_within(@tol).of(-0.707)
        expect(plane.b).to be_within(@tol).of(0.707)
        expect(plane.c).to be_within(@tol).of(0.0)
        expect(plane.d).to be_within(@tol).of(0.283)
      end

      it "should create a valid instance from three numbers" do
        plane = Plane.new(Point.new(0, 3, 0), Vector.new(0, 3, 0))
        expect(plane.a).to eq(0)
        expect(plane.b).to eq(1)
        expect(plane.c).to eq(0)
        expect(plane.d).to eq(3)
      end
    end

    describe "Equality" do
      it "should determine if another plane is equal" do
        plane_1 = Plane.new(Point.new(0, 3, 0), Vector.new(0, 3, 0))
        plane_2 = Plane.new(Point.new(0, 3, 0), Vector.new(0, 3, 0))
        expect(plane_1).to eq(plane_2)
      end

      it "should calculate the plane normal vector" do
        test_plane = Plane.new(@valid_attributes)
        normal = test_plane.normal
        expect(normal.x).to be_within(@tol).of(-0.707)
        expect(normal.y).to be_within(@tol).of(0.707)
        expect(normal.z).to be_within(@tol).of(0)
      end
    end

    describe "Return types" do
      it "should return a summary string" do
        expect(Plane.new(1,2,3,1).to_s).to eq("Plane(0.267,0.535,0.802,0.267)")
      end

      it "should return a hash code" do
        expect(Plane.new(1,2.88,2,-45.111).hash).to eq(-12)
      end
    end
  end
end