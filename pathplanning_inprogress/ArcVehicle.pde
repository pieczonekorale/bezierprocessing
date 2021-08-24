
class ArcVehicle {
  PVector center; //wspolrzedne srodka pojazdu
  PVector velocity; //predkosc biezaca
  PVector acceleration; //przyspieszenie liniowe
  float size; //rozmiar pojazdu
  float pull_limiter; //ograniczenia predkosci i sily
  float velocity_limiter;
  float angle; //kat odchylenia
  float rad_acceleration; //przyspieszenie i predkosc katowa
  float rad_velocity;
  PVector errangle; //blad odchylenia
  PVector found_futureloc;
  float step; //probka czasu, w jakiej analizowana bedzie kolejna pozycja samochodu

  ArcVehicle(PVector start_position, float a, float b) {
    center = start_position;
    size = 10.0;
    velocity_limiter = 2;
    pull_limiter= 0.05;
    acceleration = new PVector(0, 0);
    velocity = new PVector(velocity_limiter, 0);
    errangle = new PVector(0,0);
    found_futureloc = new PVector(0,0);
    angle = 0.0;
    rad_velocity = 0.0;
    rad_acceleration = 0.0;
    step = 10.0;
  }
  
  public void move() {
    param_update();
    display();
  }
  
    //uzyskanie punktu przeciecia prostej prostopadlej do odcinka ab i przechodzacej przez punkt p
    PVector dotProduct(PVector point, PVector a, PVector b) {
      PVector point_distance = PVector.sub(point, a);
      PVector len = PVector.sub(b, a);
      len.normalize(); 
      len.mult(point_distance.dot(len));
      PVector result = PVector.add(a, len);
      return result;
  }
  
  //odleglosc srodka samochodu od okregu
  float arcDist(PVector point, PVector arc, float pathsize){
   return abs(sqrt(sq(point.x- arc.x) + sq(point.y- arc.y) - pathsize));
  }
  
   PVector arcAnalize(PVector future_loc, PVector arc){
   PVector cararc = future_loc.get();
   cararc.sub(arc);
   cararc.normalize();
   cararc.mult(50);
   PVector target = arc.get();
   target.add(cararc);
    return target;

 //   found_futureloc = target;
   }


  PVector ifArc(CircularPath path, PVector future_location){
  //KOLKO
    PVector det1 = path.detectors.get(0);
    PVector det2 = path.detectors.get(1);
    if (future_location.x > det1.x && future_location.x < det2.x) {
      return path.arcs.get(0); 
    }
    else {
      PVector det3 = path.detectors.get(2);
      PVector det4 = path.detectors.get(3);
      if (future_location.x > det3.x && future_location.x < det4.x){
        return path.arcs.get(1); 
      }
      else {
        PVector det5 = path.detectors.get(4);
        PVector det6 = path.detectors.get(5);
      if (future_location.x > det5.x && future_location.x < det6.x){
      return path.arcs.get(2); 
      }
      
       else {PVector papaj = new PVector(2137,2137);
     return papaj;}
      }
    }
  }

   void analize(CircularPath path) {
      //LINIA
     // print("linia");
    //liczenie bledu ycerr (odleglosc biezacej pozycji pojazdu od sciezki referencyjnej) i yerr (odleglosc przyszlej lokalizacji od sciezki) - realizowane poprzednio na wzorze odleglosci punktu od prostej
     PVector future_velocity = velocity.get(); 
    future_velocity.normalize(); //sprawdzenie kierunku wektora predkosci
    future_velocity.mult(20); //wydluzenie wektora predkosci o tyle, ile klatek "do przodu" chcemy policzyc predkosc
    PVector future_location = PVector.add(center, future_velocity); //sprawdzenie lokalizacji samochodu 1 probke czasu do przodu
    PVector dir;
    //liczenie bledu ycerr (odleglosc biezacej pozycji pojazdu od sciezki referencyjnej) i yerr (odleglosc przyszlej lokalizacji od sciezki) - realizowane poprzednio na wzorze odleglosci punktu od prostej
    PVector yerr_normal = null; 
    PVector normal_cross_fixed = null;
    float min_distance=1000;  
    PVector arc_check= ifArc(path, future_location);
    if (arc_check.x!=2137&&arc_check.y!=2137){
    normal_cross_fixed = arcAnalize(future_location, arc_check);
    print("kolo");
    }
    else {
            for (int i = 0; i < path.waypoints.size()-1; i++) {

      // Look at a line segment
      PVector Wi = path.waypoints.get(i);
      PVector Wj = path.waypoints.get(i+1);
      PVector normal_cross = dotProduct(future_location, Wi, Wj);
      if (normal_cross.x < Wi.x || normal_cross.x > Wj.x) {
        normal_cross = Wj.get();
      }
      float distance = PVector.dist(future_location, normal_cross);
      if (distance < min_distance) {
        min_distance = distance;
        yerr_normal = normal_cross;

        dir = PVector.sub(Wj, Wi);
        dir.normalize();
        dir.mult(10);
        normal_cross_fixed = normal_cross.get();
        normal_cross_fixed.add(dir);
      }
    }
    }

  fill(255, 255, 0);
 stroke(0);
circle(normal_cross_fixed.x, normal_cross_fixed.y, 10);

// jezeli odleglosc od idealnej sciezki nie wynosi 0 trzeba skorygowac cel
    if (min_distance > 0) {
    PVector correct_target = PVector.sub(normal_cross_fixed, center);
    if (correct_target.mag() == 0) return;
    correct_target.normalize();
    correct_target.mult(velocity_limiter);
    PVector dir_correction = PVector.sub(correct_target, velocity);
   // dir_correction.limit(pull_limiter); 
    acceleration.add(dir_correction);
    }
  //  found_futureloc = normal_cross_fixed;
      }
   
   //aktualizacja wartosci
    void param_update() {
    velocity.add(acceleration);
    velocity.limit(velocity_limiter);
    center.add(velocity);
    acceleration.mult(0);
    rad_acceleration = 0.0;
    errangle = PVector.add(found_futureloc, velocity);
    //print(errangle.x, errangle.y +"/n");
        fill(255, 255, 0);
    stroke(0);
    circle(found_futureloc.x, found_futureloc.y, 10);
  }

void arrive(Path p) {
    if (center.x > p.path_end().x + size) {
      return;
//powinien sie zatrzymac
    }
  }
  
  void display() {
    float psi = velocity.heading() + radians(90); 
    fill(175);
    stroke(0);
    fill(255, 255, 0);
    stroke(0);
    pushMatrix();
    translate(center.x, center.y);
    rotate(psi);
    beginShape();
    vertex(-size, -size*2);
    vertex(-size, size*2);
    vertex(size, size*2);
    vertex(size, -size*2);
    endShape();
    popMatrix();

  }
  
}///
