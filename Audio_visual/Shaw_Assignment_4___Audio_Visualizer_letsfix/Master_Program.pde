import oscP5.*;
import netP5.*;

ArrayList circleArr;
ArrayList sqrArr;

String name;

int backgroundColor = 0;
int shot = 0;

float v_pad1 = 1.0f;
float v_pad2 = 1.0f;

float v_fader2 = 0.0f;
float v_fader3 = 0.0f;
float v_fader4 = 0.0f;
float v_fader5 = 0.5f;
float v_fader6 = 0.5f;
float v_fader7 = 0.5f;
float v_fader8 = 0.5f;
float v_fader9 = 0.1f;
float v_fader10 = 0.1f;
float v_fader11 = 0.1f;

float v_rotary2 = 0.4f;
float v_rotary3 = 0.01f;
float v_toggle1 = 0.0f;
float v_toggle2 = 0.0f;
float v_toggle3 = 0.0f;
float v_toggle4 = 0.0f;
float v_toggle5 = 1.0f;
float v_toggle6 = 1.0f;
float v_toggle7 = 0.0f;
float v_toggle8 = 0.0f;
float v_toggle9 = 0.0f;
float v_toggle10 = 0.0f;
float v_ypad1 = 0.0f;
float v_push1 = 0.0f;
float v_push2 = 0.0f;
float v_push3 = 0.0f;
float v_push4 = 0.0f;
float v_push5 = 0.0f;
float v_xpad1 = 0.0f;
float fft_cent = 0.0f;
float fft_rms = 0.0f;
float fft_flux = 0.0f;
float fft_roff50 = 0.0f;
fftCircle c1 = new fftCircle(fft_cent, fft_rms, fft_flux, fft_roff50);
PVector v_pad;

int startingShapes = 0;
int circleNumber = startingShapes;
int sqrNumber = startingShapes;

boolean sketchFullScreen() {
  return true;
}

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  background(255);
  sqrArr = new ArrayList();
  circleArr = new ArrayList();
  v_pad = new PVector(v_pad1, v_pad2);
  frameRate(40);
  //size(1000,650, OPENGL);
  size(displayWidth, displayHeight, OPENGL);
  oscP5 = new OscP5(this, 14002);
  for (int i = 0; i < startingShapes; i++) {
    circleArr.add( new Mover(int(random(0, width)), int(random(0, height)), random(1, 10), random(1, 10), int(v_fader2), int(random(255)), int(random(255))));
    sqrArr.add(new Squares(int(random(0, width)), int(random(0, height)), random(1, 10), random(1, 10), int(v_fader2), int(random(255)), int(random(255))));
  }
}

void draw() { 
  smooth();
  if (backgroundColor > 0) {
   //background(backgroundColor); 
  }
  if (v_toggle5 > 0) {
    //print("updating movers");
    for (int i = 0; i < circleArr.size() - 1; i++) {
      Mover a = (Mover) circleArr.get(i);
      a.update();
      a.display(int(fft_rms), int(fft_cent));
      a.locCheck();
    }
  }
  if (v_toggle6 > 0) {
    //print("updating squares");
    for (int i = 0; i < sqrArr.size() - 1; i++) {
      Squares s = (Squares) sqrArr.get(i);
      s.update();
      s.display(int(fft_rms), int(fft_cent));
      s.locCheck();
    }
  }
}

void sqrSend(OscMessage sqrMsg) {
  sqrMsg = new OscMessage("/sqrInfo/Number");
  sqrMsg.add(sqrArr.size());
}

void oscEvent(OscMessage theOscMessage) {
  //println("Pattern: " + theOscMessage.addrPattern());
  String addr = theOscMessage.addrPattern();
  float  val  = theOscMessage.get(0).floatValue();

  if (addr.equals("/fftInfo")) {
    fft_roff50 = theOscMessage.get(0).floatValue();
    //println("Roll Off 50 :" + fft_roff50);
    fft_cent = theOscMessage.get(1).floatValue();
    //println("cent value :" + fft_cent);
    fft_flux = theOscMessage.get(2).floatValue();
    //println("Flux :" + fft_flux);
    fft_rms = theOscMessage.get(3).floatValue();
    //println("RMS :" + fft_rms);
  }
  else if (addr.equals("/1/fader4")) { 
    v_fader4 = val;
  }
  else if (addr.equals("/1/fader2")) { 
    v_fader2 = val;
  }
  else if (addr.equals("/1/fader3")) { 
    v_fader3 = val;
  }
  else if (addr.equals("/1/fader5")) { 
    v_fader5 = val;
  }
  else if (addr.equals("/1/fader6")) { 
    v_fader6 = val;
  }
  else if (addr.equals("/1/fader7")) { 
    v_fader7 = val;
  }
  else if (addr.equals("/1/fader8")) { 
    v_fader8 = val;
  }
  else if (addr.equals("/1/fader9")) { 
    v_fader9 = val;
  }
  else if (addr.equals("/1/fader10")) { 
    v_fader9 = val;
  }
  else if (addr.equals("/1/fader11")) { 
    v_fader9 = val;
  }
  else if (addr.equals("/1/rotary2")) { 
    frameRate(int((val * 150) + 1));
  }
  else if (addr.equals("/1/rotary3")) { 
    circleNumber = int(val * 75);
  }
  else if (addr.equals("/1/toggle1")) { 

  }
  else if (addr.equals("/1/toggle2")) { 
     backgroundColor = int(val * 127);
  }
  else if (addr.equals("/1/toggle3")) { 
    v_toggle3 = val;
  }
  else if (addr.equals("/1/toggle4")) { 
    v_toggle4 = val;
  }
  else if (addr.equals("/1/toggle5")) { 
    v_toggle5 = val;
  }
  else if (addr.equals("/1/toggle6")) { 
    v_toggle6 = val;
  }
  else if (addr.equals("/1/toggle7")) { 
    v_toggle7 = val;
  }
  else if (addr.equals("/1/toggle8")) { 
    v_toggle8 = val;
  }
  else if (addr.equals("/1/toggle9")) { 
    v_toggle9 = val;
  }
  else if (addr.equals("/1/toggle10")) { 
    if (val > 0) {
      background(125);
    }
  }
  else if (addr.indexOf("pad1") != -1) { 
    // get the first value as an integer
    v_pad1 = theOscMessage.get(0).floatValue();
    v_pad2 = theOscMessage.get(1).floatValue();
    // print("Activity" + v_pad1 + v_pad2);
  }
  else if (addr.equals("/1/push1")) { 
    //println("push1 bang");
    circleArr.add(new Mover(int(random(0, width)), int(random(0, height)), random(1, 10), random(1, 10), int(random(255)), int(random(255)), int(random(255))));
  }
  else if (addr.equals("/1/push2")) { 
    if (val > 0 && circleArr.size() > 0) {
      circleArr.remove(0);
    }
  }
  else if (addr.equals("/1/push3")) { 
    if (val > 0) {

      sqrArr.add(new Squares(int(random(0, width)), int(random(0, height)), random(1, 10), random(1, 10), int(random(255)), int(random(255)), int(random(255))));
    }
  }
  else if (addr.equals("/1/push4")) { 
    if (val > 0 && (sqrArr.size() > 0)) {
      sqrArr.remove(0);
    }
  }
  else if (addr.equals("/1/push5")) { 
    frameRate(.3);
    if (val > 0) {
      name = "Vector_Art" + str(shot) + ".jpg";
      println(name);
      save(name);
      shot++;
    }
    frameRate(50);
  }
  else if (addr.equals("/1/toggle8")) { 
    v_toggle8 = val;
  }
  else if (addr.equals("/fft/roff50")) {
    fft_roff50 = val;
    println(fft_roff50);
  }
  else if (addr.equals("/fft/cent")) {
    fft_cent = val;
    println(fft_roff50);
  } 
  else if (addr.equals("/fft/flux")) {
    fft_flux = val;
    println(fft_roff50);
  }
  else if (addr.equals("/fft/rms")) {
    fft_rms = val;
    println(fft_roff50);
  }
}

