class CircularPath {

  ArrayList<PVector> waypoints; 
  ArrayList<PVector> arcs;
  ArrayList<PVector> detectors;
  float pathsize;
  float radius;

  CircularPath() {
    waypoints = new ArrayList<PVector>(); //tablica punktow wyznaczajacych segmenty trasy
    arcs = new ArrayList<PVector>(); // srodki okregow sciezki referencyjnej
    detectors = new ArrayList<PVector>(); //punkty stycznosci okregow ze sciezka liniowa
    pathsize = 100; //szerokosc korytarza
    radius = 50;
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
  
  float getAngle(PVector a, PVector b, PVector c){
  float ang;
    ang = atan2(c.y-b.y, c.x-b.x) - atan2(a.y-b.y, a.x-b.x);
      return ang;
    }
    
    float getLen(PVector a, PVector b){
      float result = sqrt(sq(b.x-a.x)+sq(b.y-a.y));
      return result;
    }
    
    PVector seekCenter(PVector a, PVector b, PVector c){
    float angle = getAngle(a,b,c)/2;
    
    //LEFT DETECTOR
    float mag1 = getLen(a,b);
    float high = b.y-a.y; //200
    float wide = b.x-a.x; //150
    
    float cent_dist = radius / sin(angle);
    float arc_dist = radius / tan(angle); //25
    float small_wide = arc_dist * wide / mag1;
    float small_high = arc_dist * high / mag1;
    
    PVector arc_detector_left = new PVector (b.x-small_wide, b.y-small_high);
    //RIGHT DETECTOR
    float mag2 = getLen(b,c);
    float high2 = c.y-b.y; //200
    float wide2 = c.x-b.x; //150

    float small_wide2 = arc_dist * wide2 / mag2;
    float small_high2 = arc_dist * high2 / mag2;
    
    PVector arc_detector_right = new PVector (b.x+small_wide2, b.y+small_high2);
    
    detectors.add(arc_detector_left);
    detectors.add(arc_detector_right);
    
    //CENTER COORDS
    PVector helper = new PVector (a.x, b.y);
    float beta = 360-degrees(getAngle(a,b,helper));
    float gamma = radians(180-degrees(angle)-beta);
    
    float center_high = cent_dist * sin(gamma);
    float center_wide = cent_dist * cos(gamma);
    PVector result = new PVector (b.x+center_wide, b.y-center_high);
    return result;
      
    }
    
    PVector seekCenter_inv(PVector a, PVector b, PVector c){
    float angle = getAngle(a,b,c)*(-1);
    angle = angle/2;
    
    float mag1 = getLen(a,b);
    float high = abs(b.y-a.y); //200
    float wide = b.x-a.x; //150
    
    float cent_dist = radius / sin(angle);
    float arc_dist = radius / tan(angle); //25
    float small_wide = arc_dist * wide / mag1;
    float small_high = arc_dist * high / mag1;
    
    PVector arc_detector_left = new PVector (b.x-small_wide, b.y+small_high);
    
    //RIGHT DETECTOR
    float mag2 = getLen(b,c);
    float high2 = abs(c.y-b.y); //200
    float wide2 = c.x-b.x; //150

    float small_wide2 = arc_dist * wide2 / mag2;
    float small_high2 = arc_dist * high2 / mag2;
    
    PVector arc_detector_right = new PVector (b.x+small_wide2, b.y+small_high2);
    
    detectors.add(arc_detector_left);
    detectors.add(arc_detector_right);
    
    PVector helper = new PVector (a.x, b.y);
    float beta = 360-degrees(getAngle(helper,b,a));
    float gamma = radians(180-degrees(angle)-beta);
    float center_high = cent_dist * sin(gamma);

    float center_wide = cent_dist * cos(gamma);

    PVector result = new PVector (b.x+center_wide, b.y+center_high);
    return result;
    }

  void arc_init(){
  for (int i = 1; i < waypoints.size()-1; i++) {
      PVector Wi = waypoints.get(i-1); 
      PVector Wj = waypoints.get(i); 
      PVector Wk = waypoints.get(i+1);
      PVector center;
      float angle_check = getAngle(Wi,Wj,Wk);
      float angle_inv = getAngle(Wk,Wj,Wi);
  
      if (degrees(angle_check) > 0 && degrees(angle_check) < 180){
        center = seekCenter(Wi,Wj,Wk); 
      //  print("szukam zwykly");
       }
      else {
        //print("szukam odwrocony");
       if (abs(degrees(angle_check)) > 180) center = seekCenter(Wi,Wj,Wk);      
       else center = seekCenter_inv(Wi,Wj,Wk);
      }
    arcs.add(center);
    
    }
     
     print(detectors);
     print("\n");
     print(arcs);
  }
  
  void plot() {
    //obrys korytarza
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
    

    for (PVector o : arcs) {
    stroke(0);
    strokeWeight(1);
    noFill();
    circle(o.x, o.y, radius*2);
    }
    
     for (int i =0; i<detectors.size()-1; i=i+2) {
    stroke(255,155,0);
    strokeWeight(1);
    noFill();
    circle(detectors.get(i).x, detectors.get(i).y, 10);
    stroke(0,23,255);
    strokeWeight(1);
    noFill();
    circle(detectors.get(i+1).x, detectors.get(i+1).y, 10);
    }
    
    
  }
}
