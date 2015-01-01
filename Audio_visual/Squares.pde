
class Squares {
   
   PVector location;
  PVector velocity;
  PVector padForce;
  int red, green, blue;
  float XSpeed, YSpeed;
  int displayChance = 1;
  
  Squares(float x, float y, float xSpeed, float ySpeed, int r, int g, int b){
  location = new PVector(x,y);
 XSpeed = xSpeed;
 YSpeed = ySpeed;
  velocity = new PVector(xSpeed ,ySpeed); 
  padForce = new PVector((v_pad1 - 1) * 3,(v_pad2 - 1) * 3);
  green = g;
  red = r;
  blue = b;
  }
  
  void update(){
   // XSpeed += (v_pad1 - 1);
  //YSpeed += (v_pad2 - 1);
  //velocity = new PVector(YSpeed ,YSpeed); 
  
  //padForce = new PVector(,);
  
   location.add(padForce);
   location.add(velocity); 
  
   padForce.x = (v_pad1 - 1) * 10;
     padForce.y = (v_pad2 - 1) * 10;
 
   
  }
  
  void display(int rms, int cent){
    displayChance = displayChance * -1;
    strokeWeight(sqrt(cent/500));
    stroke(int((v_fader4*254) + 1),int((v_fader2*254) + 1),int((v_fader3*254)+1));
    fill(int((v_fader6*254) + 1),int((v_fader7*254) + 1),int((v_fader8*254)+1));
    rect(location.x,location.y, (sqrt(rms)* displayChance) + 0.5 ,(sqrt(rms)*displayChance) + 0.5); 
  }
  
  void locCheck(){
   if ((location.x > width) || (location.x < 0) || (v_toggle7 > 0)){
    padForce.x = padForce.x * -1; 
    velocity.x = velocity.x * -1;
   }
   
   if ((location.y > height) || (location.y < 0) || (v_toggle8 > 0)){
    padForce.y = padForce.y * -1; 
    velocity.y = velocity.y * -1;
   }
   if ((location.x > width + 500) || (location.x < - 5000)){
       location.x = int(random(0,width));
       location.y = int(random(0,height));
     }
     if ((location.y > height + 500) || (location.y < -500)){
       location.x = int(random(0,width));
       location.y = int(random(0,height));
     }
  }}

