require_relative '../spec_helper.rb'
require 'geom/rectangular_coordinate_system'

module Geom
  describe RectangularCoordinateSystem do

    before(:each) do
      @origin  = Point.new(0,0,0)
      @ivector = Vector.new(1,0,0)
      @jvector = Vector.new(0,1,0)
      @kvector = Vector.new(0,0,1)
      @rcs = RectangularCoordinateSystem.new
    end

    it "should construct a RCS using x-vector and xy-plane normal vector" do
      RectangularCoordinateSystem.new_from_xvector_and_xyplane(@origin, @ivector, @jvector).should == @rcs
    end

    it "should construct a RCS using y-vector and yz-plane normal vector" do
      RectangularCoordinateSystem.new_from_yvector_and_yzplane(@origin, @jvector, @ivector).should == @rcs
    end

    it "should construct a RCS using z-vector and zx-plane normal vector" do
      RectangularCoordinateSystem.new_from_zvector_and_zxplane(@origin, @kvector, @jvector).should == @rcs
    end

    it "should return a summary string" do
      RectangularCoordinateSystem.new.to_s.should == "RCS[Point(0.000,0.000,0.000) X-Vector(1.000,0.000,0.000) Y-Vector(0.000,1.000,0.000) Z-Vector(0.000,0.000,1.000)]"
    end

  end
end

#     C3 = new CoordinateSystemRectangular(origin, jVector, iVector, CoordinateSystemRectangular.DefinitionMethod.YVectorXYPlane);
#     //YVectorYZPlane
#     C4 = new CoordinateSystemRectangular(origin, jVector, kVector, CoordinateSystemRectangular.DefinitionMethod.YVectorYZPlane);
#     //ZVectorZXPlane
#     C5 = new CoordinateSystemRectangular(origin, kVector, iVector, CoordinateSystemRectangular.DefinitionMethod.ZVectorZXPlane);
#     //ZVectorYZPlane
#     C6 = new CoordinateSystemRectangular(origin, kVector, jVector, CoordinateSystemRectangular.DefinitionMethod.ZVectorYZPlane);
#
#     Assert.IsTrue(C1.Equals(C2));
#     Assert.IsTrue(C2.Equals(C3));
#     Assert.IsTrue(C3.Equals(C4));
#     Assert.IsTrue(C4.Equals(C5));
#     Assert.IsTrue(C5.Equals(C6));
# }
#
# //Parallel vectors
# [Test, ExpectedException(typeof(GeomException), "Geometry error: Input vectors are collinear")]
# public void ConstrGeneric1()
# {
#     rcs = new CoordinateSystemRectangular(new Point(0, 0, 0), new Vector(0, 0, 1), new Vector(0, 0, 1), CoordinateSystemRectangular.DefinitionMethod.XVectorXYPlane);
# }
#
# [Test, ExpectedException(typeof(GeomException), "Geometry error: Input points are collinear")]
# public void ConstrPoints()
# {
#     rcs = new CoordinateSystemRectangular(new Point(0, 0, 0), new Point(0, 0, 1), new Point(0, 0, 5));
# }
#
# [Test, ExpectedException(typeof(GeomException), "Geometry error: Input vectors are not orthogonal")]
# public void ConstrVectors()
# {
#     rcs = new CoordinateSystemRectangular(new Point(0,0,0), new Vector(0,0,1), new Vector(0,1,1));
# }
#
# [Test]
# public void FuncEquals()
# {
#     Point origin = new Point(0, 0, 0);
#     rcs = new CoordinateSystemRectangular(origin, new Vector(1, 0, 0), new Vector(0, 0, 1));
#     Assert.IsFalse(rcs.Equals(origin));
# }
#
# //For coverage
# [Test]
# public void FuncGetHashCode()
# {
#     rcs = new CoordinateSystemRectangular(new Point(1, 2, 3), new Point(2, 3, 4), new Point(0, 1, 4));
#     int hc = (int)rcs.Origin.GetHashCode() ^ (int)rcs.XVector.GetHashCode() ^
#         (int)rcs.YVector.GetHashCode() ^ (int)rcs.ZVector.GetHashCode();
#
#     Console.WriteLine(hc);
#     Assert.AreEqual(hc, rcs.GetHashCode());
# }
#
# //For coverage
# [Test]
# public void FuncToString()
# {
#     rcs = new CoordinateSystemRectangular(new Point(0, 0, 0), new Vector(1, 0, 0), new Vector(0, 0, 1));
#     string s = rcs.ToString();
#     //Console.WriteLine(s);
# }
#
# [Test]
# public void FuncTransform()
# {
#     o1 = new Point(0, 0, 0);
#     x1 = new Point(1, 0, 0);
#     xy1 = new Point(0, 1, 0);
#
#     o2 = new Point(1, 1, 0);
#     x2 = new Point(2, 2, 0);
#     xy2 = new Point(1, 0, 0);
#
#     cs1 = new GKN.Geom.CoordinateSystems.CoordinateSystemRectangular(o1, x1, xy1);
#     cs2 = new GKN.Geom.CoordinateSystems.CoordinateSystemRectangular(o2, x2, xy2);
#
#     GKN.Geom.Transformation t = new GKN.Geom.Transformation(cs1, cs2);
#
#     trans = new CoordinateSystemRectangular(new Point(0, 0, 0), new Point(1, 0, 0), new Point(0, 1, 0));
#     trans.Transform(t);
#
#     //the following test values have been verified from a Mathcad spreadsheet
#     Assert.AreEqual(-1.41421356, trans.Origin.X, GlobalVariables.DefaultTestTolerance);
#     Assert.AreEqual(0, trans.Origin.Y);
#     Assert.AreEqual(0, trans.Origin.Z);
#
#     Assert.AreEqual(0.70711, trans.XVector.X, GlobalVariables.DefaultTestTolerance);
#     Assert.AreEqual(0.70711, trans.XVector.Y, GlobalVariables.DefaultTestTolerance);
#     Assert.AreEqual(0, trans.XVector.Z, GlobalVariables.DefaultTestTolerance);
#
#     Assert.AreEqual(0.70711, trans.YVector.X, GlobalVariables.DefaultTestTolerance);
#     Assert.AreEqual(-0.70711, trans.YVector.Y, GlobalVariables.DefaultTestTolerance);
#     Assert.AreEqual(0, trans.YVector.Z, GlobalVariables.DefaultTestTolerance);
#
#     Assert.AreEqual(0, trans.ZVector.X, GlobalVariables.DefaultTestTolerance);
#     Assert.AreEqual(0, trans.ZVector.Y, GlobalVariables.DefaultTestTolerance);
#     Assert.AreEqual(-1, trans.ZVector.Z, GlobalVariables.DefaultTestTolerance);
#
# }
#
# [Test]
# public void FuncTransform2()
# {
#     o1 = new Point(0, 0, 0);
#     x1 = new Point(1, 0, 0);
#     xy1 = new Point(0, 1, 0);
#
#     o2 = new Point(1, 2, 3);
#     x2 = new Point(2, 6, 5);
#     xy2 = new Point(6, 5, 8);
#
#     cs1 = new GKN.Geom.CoordinateSystems.CoordinateSystemRectangular(o1, x1, xy1);
#     cs2 = new GKN.Geom.CoordinateSystems.CoordinateSystemRectangular(o2, x2, xy2);
#
#     GKN.Geom.Transformation t = new GKN.Geom.Transformation(cs1, cs2);
#
#     trans = new CoordinateSystemRectangular(new Point(0, 0, 0), new Point(1, 0, 0), new Point(0, 1, 0));
#     trans.Transform(t);
#
#     //the following test values have been verified from a Mathcad spreadsheet
#     Assert.AreEqual(-3.27326835, trans.Origin.X, GlobalVariables.DefaultTestTolerance);
#     Assert.AreEqual(-1.36246, trans.Origin.Y, GlobalVariables.DefaultTestTolerance);
#     Assert.AreEqual(1.19558, trans.Origin.Z, GlobalVariables.DefaultTestTolerance);
#
#     Assert.AreEqual(0.21822, trans.XVector.X, GlobalVariables.DefaultTestTolerance);
#     Assert.AreEqual(0.7537, trans.XVector.Y, GlobalVariables.DefaultTestTolerance);
#     Assert.AreEqual(0.61993, trans.XVector.Z, GlobalVariables.DefaultTestTolerance);
#
#     Assert.AreEqual(0.87287, trans.YVector.X, GlobalVariables.DefaultTestTolerance);
#     Assert.AreEqual(-0.43483, trans.YVector.Y, GlobalVariables.DefaultTestTolerance);
#     Assert.AreEqual(0.2214, trans.YVector.Z, GlobalVariables.DefaultTestTolerance);
#
#     Assert.AreEqual(0.43644, trans.ZVector.X, GlobalVariables.DefaultTestTolerance);
#     Assert.AreEqual(0.49281, trans.ZVector.Y, GlobalVariables.DefaultTestTolerance);
#     Assert.AreEqual(-0.75277, trans.ZVector.Z, GlobalVariables.DefaultTestTolerance);
#
# }
#
# [Test]
# public void FuncToTransformationMatrix()
# {
#     CoordinateSystemRectangular cs = new CoordinateSystemRectangular(new Point(1,2,3), new Point(2,6,5), new Point(6,5,8));
#     CoordinateSystemRectangular cs0 = new CoordinateSystemRectangular(new Point(0,0,0), new Point(1,0,0), new Point(0,1,0));
#     Math.Matrices.TransformationMatrix m = cs.ToTransformationMatrix();
#     m.Inverse();
#
#     Transformation t = new Transformation(cs0, cs);
#
#     Point transPoint = new Point(1, 1, 1);
#     double[] trans = new double[] { transPoint.X, transPoint.Y, transPoint.Z, 1 };
#     double[] trans2 = m*trans;
#
#     transPoint.Transform(t);
#
#     Assert.AreEqual(transPoint.X, trans2[0], GlobalVariables.DefaultTestTolerance);
#     Assert.AreEqual(transPoint.Y, trans2[1], GlobalVariables.DefaultTestTolerance);
#     Assert.AreEqual(transPoint.Z, trans2[2], GlobalVariables.DefaultTestTolerance);
# }