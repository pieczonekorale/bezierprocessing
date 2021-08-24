
//BezierPath path;
CircularPath path;
ArcVehicle v1;
PVector test;
//Path path;
//Vehicle v1;

void setup() {
  size(1000, 1000);
  path = new CircularPath();
  //path = new BezierPath();
  //path = new Path();
  test = PVector.fromAngle(0.01);
  path.addPoint(0.0, 600.0);
  path.addPoint(254.202297, 400.25505);
  path.addPoint( 507.25504, 660.81305);
  path.addPoint(740.2396, 560.9685);
  path.addPoint(883.2396, 304.9685);
  path.addPoint(width, random(10, height-400));
  path.arc_init();

  v1 = new ArcVehicle(new PVector(0, height/2), 2, 0.04);
 // v1 = new Vehicle(new PVector(0, height/2), 2, 0.04);
  
  //path.bezierCompute();
//  print(path.waypoints);
//print(path.detectors);
}

void draw() {
  background(181, 243, 223);
  path.plot();

 v1.analize(path);
  v1.move();
}
