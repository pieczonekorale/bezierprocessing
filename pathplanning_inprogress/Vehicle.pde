
class Vehicle {
  PVector center; //wspolrzedne srodka pojazdu
  PVector velocity; //predkosc biezaca
  PVector acceleration; //przyspieszenie liniowe
  float size; //rozmiar pojazdu
  float pull_limiter; //ograniczenia predkosci i sily
  float velocity_limiter;
 // float psi; //kat odchylenia
  //float rad_acceleration; //przyspieszenie i predkosc katowa
 // float rad_velocity;
  PVector errangle; //blad odchylenia
  PVector found_futureloc;
  float step; //probka czasu, w jakiej analizowana bedzie kolejna pozycja samochodu
  int current;


  Vehicle(PVector start_position, float a, float b) {
    center = start_position;
    size = 10.0;
    velocity_limiter = 3;
    pull_limiter= 0.2;
    acceleration = new PVector(0, 0);
    velocity = new PVector(velocity_limiter, 0);
    errangle = new PVector(0,0);
    found_futureloc = new PVector(0,0);
 //   psi = 0.0;
  //  rad_velocity = 0.0;
    //rad_acceleration = 0.0;
    step = 50.0;
    current = 0; // aktualny segment, gdzie jesteśmy
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

   void analize(Path p) {
    PVector future_velocity = velocity.get(); 
    future_velocity.normalize(); //sprawdzenie kierunku wektora predkosci
    future_velocity.mult(2); //wydluzenie wektora predkosci o tyle, ile klatek "do przodu" chcemy policzyc predkosc
    PVector future_location = PVector.add(center, future_velocity); //sprawdzenie lokalizacji samochodu 1 probke czasu do przodu
    PVector dir;
    //liczenie bledu ycerr (odleglosc biezacej pozycji pojazdu od sciezki referencyjnej) i yerr (odleglosc przyszlej lokalizacji od sciezki) - realizowane poprzednio na wzorze odleglosci punktu od prostej
    PVector yerr_normal = null; 
    PVector normal_cross_fixed = null;
    float min_distance=1000;  
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

    if (min_distance > 0) {
      print(min_distance);
      print("\n");
    PVector correct_target = PVector.sub(normal_cross_fixed, center);

  //  correct_target.normalize();
    //correct_target.mult(velocity_limiter);
    PVector dir_correction = PVector.sub(correct_target, velocity);
   // dir_correction.limit(pull_limiter); 
    acceleration.add(dir_correction);
    }
    //found_futureloc = normal_cross_fixed;
    
   // fill(255, 255, 0);
    //stroke(0);
    //circle(found_futureloc.x,found_futureloc.y,10);
   }
   
   //aktualizacja wartosci
    void param_update() {
    velocity.add(acceleration);
    //velocity.limit(velocity_limiter);
    center.add(velocity);
    acceleration.mult(0);
   // rad_acceleration = 0.0;
    errangle = PVector.add(found_futureloc, velocity);
    //print(errangle.x, errangle.y +"/n");
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
  
}
