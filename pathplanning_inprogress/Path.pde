class Path {

  ArrayList<PVector> waypoints; 
  float pathsize;

  Path() {
    waypoints = new ArrayList<PVector>(); //tablica punktow wyznaczajacych segmenty trasy
    pathsize = 100; //szerokosc korytarza
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
  }
}
