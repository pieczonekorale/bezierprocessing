
BezierPath path;
//CircularPath path;
//ArcVehicle v1;
//Path path;
//Vehicle v1;
BezierVehicle v1;

void setup() {
  size(1700, 1000);
// path = new CircularPath();
  path = new BezierPath();
// path = new Path();
  path.addPoint(0.0, 500.0);
  path.addPoint(100.202297, 300.25505);
  path.addPoint(707.25504, 760.81305);
 // path.addPoint(740.2396, 560.9685);
  //path.addPoint(883.2396, 304.9685);
  path.addPoint(width, random(100, height-400));
 // path.arc_init();

  //v1 = new ArcVehicle(new PVector(0, height/2), 2, 0.04);
// v1 = new Vehicle(new PVector(0, height/2), 2, 0.04);
  v1 = new BezierVehicle(new PVector(0, height/2), 2, 0.04);
  
  path.bezierCompute();
  //print(path.controlpoints);
}

void draw() {
  background(181, 243, 223);
  path.plot();;
 v1.analize(path);
  v1.move();
}
