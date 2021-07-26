
Path path;
Vehicle v1;

void setup() {
  size(1000, 1000);
  // Call a function to generate new Path object
  path = new Path();
  path.addPoint(0, height/2);
  path.addPoint(random(10, width/2), random(10, height));
  //path.addPoint(random(width/3, width), random(10, height));
  path.addPoint(random(width/2, width), random(10, height));
  path.addPoint(width, random(10, height));

  v1 = new Vehicle(new PVector(0, height/2), 2, 0.04);
}

void draw() {
  background(181, 243, 223);
  path.plot();
  v1.analize(path);
  v1.move();
  v1.arrive(path);
}
