        class Mover {
     
     PVector location;
    PVector velocity;
    PVector padForce;
    int red, green, blue;
    
    Mover(float x, float y, float xSpeed, float ySpeed, int r, int g, int b){
    location = new PVector(x,y);
    velocity = new PVector(xSpeed,ySpeed); 
    padForce = new PVector((v_pad1 - 1) * 30,(v_pad2 - 1) * 30);
    green = g;
    red = r;
    blue = b;
    }
    
    void update(){
      padForce = new PVector((v_pad1 - 1)*10,(v_pad2 - 1)*10);
      location.add(padForce);
     location.add(velocity); 
     padForce.x = 0;
     padForce.y = 0;
    }
    
    void display(int rms, int cent){
      strokeWeight(sqrt(cent/700));
      stroke(int((v_fader6*254) + 1),int((v_fader7*254) + 1),int((v_fader8*254)+1));
     
      fill(int((v_fader4*254) + 1),int((v_fader2*254) + 1),int((v_fader3*254)+1));
      ellipse(location.x,location.y, sqrt(rms) + 0.5, sqrt(rms) + 0.5); 
    }
    
    void locCheck(){
     if ((location.x > width) || (location.x < 0) || (v_toggle3 > 0)){
       padForce.x = padForce.x * -0.5; 
      velocity.x = velocity.x * -1; 
     }
     if ((location.y > height) || (location.y < 0) || (v_toggle4 > 0)){
       padForce.y = padForce.y * -0.5; 
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
    }
    }
