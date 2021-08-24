class BezierPath {

  ArrayList<PVector> waypoints; 
  ArrayList<PVector> controlpoints;
  float pathsize;
  PVector target, target2;

  BezierPath() {
    waypoints = new ArrayList<PVector>(); //tablica punktow wyznaczajacych segmenty trasy
    controlpoints = new ArrayList<PVector>();
    pathsize = 100; //szerokosc korytarza
    target = new PVector();
    target2 = new PVector();
  }


  PVector path_start() {
     return waypoints.get(0);
  }

  PVector path_end() {
     return waypoints.get(waypoints.size()-1);
  }
    void addPoint(float x, float y) {
    PVector p = new PVector(x, y);
    waypoints.add(p);
  }
  
PVector formula(PVector u, PVector v){
    PVector p1= u.copy();
    PVector p2 = v.copy();
    //p1.y += 1000;
    //p2.y +=1000;
    float a = (p1.y - p2.y) / (p1.x - p2.x); //ODWROCIC WSPOLRZEDNE!!
    float b = p1.y - a * p1.x;
    PVector result = new PVector(a,b);
    return result;
  }
    
  float getAngle(PVector a, PVector b, PVector c){
  float ang;
    ang = atan2(c.y-b.y, c.x-b.x) - atan2(a.y-b.y, a.x-b.x);
  //  print(degrees(ang));
      return radians(degrees(ang));
    }
    
   PVector getBisector(PVector W1, PVector W2, PVector W3)
{
  float angle=getAngle(W3,W2,W1)/2;
  float angle_sin = sin(angle);
  float angle_cos = cos(angle);
  PVector bisector = W3.copy();
  PVector corner = W2.copy();
  
  // translate point back to origin:
  bisector.x -= corner.x;
  bisector.y -= corner.y;

  // rotate point
  float x_upd = bisector.x * angle_cos - bisector.y * angle_sin;
  float y_upd = bisector.x * angle_sin + bisector.y * angle_cos;

  // translate point back:
  bisector.x = x_upd + corner.x;
  bisector.y = y_upd + corner.y;
  return bisector;
}
 
  void ControlPoints(PVector A, PVector B, PVector C){
       PVector P = getBisector(A,B,C); //punkt na dwusiecznej (obrot wektora BC o polowe kata ABC)

       PVector Q = new PVector (B.x, -B.y); //uproszczenie do ukladu tradycyjnego (nie do góry nogami)
       PVector R = new PVector (P.x, -P.y);
       PVector eq = formula(Q,R); //policzenie rownania dwusiecznej
       // print(eq);
      
        //rownanie prostej prostopadlej 
        float a = -1/eq.x;
        float b = Q.y + (-1*a)*Q.x;
        PVector eq2 = new PVector(a,b);
        //print(eq2);
        
        //policzenie punktow kontrolnych dla b-r i b+r
        float cp1_y= eq2.x*(B.x-(pathsize))+eq2.y;
        float cp2_y= eq2.x*(B.x+(pathsize))+eq2.y;
        PVector CP1 = new PVector(B.x-(pathsize), abs(cp1_y));
        PVector CP2 = new PVector(B.x+(pathsize), abs(cp2_y));
        controlpoints.add(CP1);
        controlpoints.add(B);
        controlpoints.add(B);
        controlpoints.add(CP2);
    }
  
  
  void bezierCompute(){
    controlpoints.add(path_start()); // bezier 1 CP 0
    PVector W1 = path_start();
    PVector W2 = waypoints.get(1);
    PVector W3 = waypoints.get(2);
    PVector W4 = waypoints.get(3);
    float w = (W2.x - W1.x)*0.1;
    float h = (W2.y - W1.y)*0.1; 
    target.x = W1.x + w;
    target.y = W1.y +h;
    controlpoints.add(target); //bezier 1 CP2
    ControlPoints(W1,W2,W3);
    ControlPoints(W2,W3,W4);
    float w2 = (W4.x - W3.x)*0.1;
    float h2 = (W4.y - W3.y)*0.1;
    target2.x = W4.x - w2;
    target2.y = W4.y - h2;
    controlpoints.add(target2);
    controlpoints.add(W4);
    print(controlpoints);
  }
  

  
  void plot() {
    //obrys korytarza
    stroke(0);
      fill(255);
      circle(10, 10, 20);
      
    stroke(255);
    strokeWeight(pathsize);
    noFill();
    beginShape();
    for (PVector v : waypoints) {
      vertex(v.x, v.y);
    }
    endShape();
    
    //obrys sciezki referencyjnej
    stroke(0);
    strokeWeight(1);
    noFill();
    beginShape();
    for (PVector v : waypoints) {
      vertex(v.x, v.y);
    }
    endShape();
    
    
    stroke(0);
    strokeWeight(1);
    noFill();
    beginShape();
    for (PVector cp : controlpoints) {
      circle(cp.x, cp.y, 20);
    }
    endShape();
  
  PVector cp1 = controlpoints.get(0);
    PVector cp2 = controlpoints.get(1);
    PVector cp3 = controlpoints.get(2);
    PVector cp4 = controlpoints.get(3);
    PVector cp5 = controlpoints.get(4);
    PVector cp6 = controlpoints.get(5);
    PVector cp7 = controlpoints.get(6);
    PVector cp8 = controlpoints.get(7);
    PVector cp9 = controlpoints.get(8);
    PVector cp10 = controlpoints.get(9);
    PVector cp11 = controlpoints.get(10);
    PVector cp12 = controlpoints.get(11);
    
      stroke(255,100,0);
    strokeWeight(1);
    noFill();
    beginShape();
    bezier(cp1.x, cp1.y, cp2.x, cp2.y, cp3.x, cp3.y, cp4.x, cp4.y);
    bezier(cp5.x, cp5.y, cp6.x, cp6.y, cp7.x, cp7.y, cp8.x, cp8.y);
    bezier(cp9.x, cp9.y, cp10.x, cp10.y, cp11.x, cp11.y, cp12.x, cp12.y);
    endShape();
    
    stroke(0,235,255);
    strokeWeight(1);
    noFill();
    beginShape();
    for (PVector cp : controlpoints) {
      vertex(cp.x, cp.y);
    }
    endShape();
  }
  
}
