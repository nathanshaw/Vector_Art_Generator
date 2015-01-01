  class fftCircle{
   
    float cent, roff50,flux,rms;
    
   fftCircle(float cents, float rmss, float fluxs, float roff50s){
     float cent = cents;
     float roff50 = roff50s;
     float flux = fluxs;
     float rms = rmss;
   }
   void display (int rms){
     sphere(int(rms/2 + 5));
     println("displayed");
     //sphere(200);
   }
    void update (float cent, float rms, float flux, float roff50){
      println("Cent :" + cent);
  println("RMS :" + rms);
  println("Flux :" + flux);
  println("ROff 50 :" + roff50);
  
  
      strokeWeight(int(v_fader10 + v_rotary3 )* 10);
      //stroke(int((v_fader4*254) + 1),int((v_fader2*254) + 1),int((v_fader3*254)+1));
      noStroke();
      lights();
      
      fill(int((v_fader6*254) + 1),int((v_fader7*254) + 1),int((v_fader8*254)+1));
      translate(width/2,height/2,0);
      //translate(50,50,0);
      rotateX(roff50 / 800);
      rotateY(cent / 1300);    
      //sphereDetail(int(rms * 1000));
      sphereDetail(int(flux/20)+3);
      println("updating");
      
  }
  }
