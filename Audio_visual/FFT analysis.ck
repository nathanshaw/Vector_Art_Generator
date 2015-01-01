adc => FFT fft =^ Centroid cent => blackhole;
fft =^ RMS rms => blackhole;
fft =^ Flux flux => blackhole;
fft =^ RollOff roff50 => blackhole;


SndBuf kick => Pan2 kickP => dac;
SndBuf snare => Pan2 snareP => dac;
SndBuf hiHat => Pan2 hiHatP => dac;
SndBuf click => Pan2 clickP => dac;
SndBuf other => Pan2 otherP => dac;

SinOsc saw1 => blackhole;

[38,50,52,48,52,0,0,38,50,0,0,59,61,59,50,38,60,55,51,0,0,0,38,50,52,48,52,0,0,38,50,0,0,59,61,59,50,38,60,55,51,0,0,0] @=> int melody[];

string kick_samples[5];//load up an array with all the kick samples
me.dir() + "/audio/kick_01.wav" => kick_samples[0];
me.dir() + "/audio/kick_02.wav" => kick_samples[1];
me.dir() + "/audio/kick_03.wav" => kick_samples[2];
me.dir() + "/audio/kick_04.wav" => kick_samples[3];
me.dir() + "/audio/kick_05.wav" => kick_samples[4];

string snare_samples[3];//loads up snare array

me.dir() + "/audio/snare_01.wav" => snare_samples[0];
me.dir() + "/audio/snare_02.wav" => snare_samples[1];
me.dir() + "/audio/snare_03.wav" => snare_samples[2];

string hiHat_samples[4];//hihat array

me.dir() + "/audio/hihat_01.wav" => hiHat_samples[0];
me.dir() + "/audio/hihat_02.wav" => hiHat_samples[1];
me.dir() + "/audio/hihat_03.wav" => hiHat_samples[2];
me.dir() + "/audio/hihat_04.wav" => hiHat_samples[3];

string click_samples[5];//click array

me.dir() + "/audio/click_01.wav" => click_samples[0];
me.dir() + "/audio/click_02.wav" => click_samples[1];
me.dir() + "/audio/click_03.wav" => click_samples[2];
me.dir() + "/audio/click_04.wav" => click_samples[3];
me.dir() + "/audio/click_05.wav" => click_samples[4];

string other_samples[7];//all other samples

me.dir() + "/audio/clap_01.wav" => other_samples[0];
me.dir() + "/audio/cowbell_01.wav" => other_samples[1];
me.dir() + "/audio/stereo_fx_01.wav" => other_samples[2];
me.dir() + "/audio/stereo_fx_02.wav" => other_samples[3];
me.dir() + "/audio/stereo_fx_03.wav" => other_samples[4];
me.dir() + "/audio/stereo_fx_04.wav" => other_samples[5];
me.dir() + "/audio/stereo_fx_05.wav" => other_samples[6];
//assigns specific samples to each Sound Buff
snare_samples[0] => snare.read;
kick_samples[1] => kick.read;  
hiHat_samples[1] => hiHat.read;
click_samples[0] => click.read;
other_samples[1] => other.read;

//this part of the code sets everything to the off position
kick.samples() => kick.pos;//sets all the sound buffs to the end of their samples so they dont play at the begenning of the recording.
snare.samples() => snare.pos;
hiHat.samples() => hiHat.pos;
click.samples() => click.pos;
other.samples() => other.pos;

0 => saw1.gain;
440 => saw1.freq;

//fft settings
256 => fft.size;
256 => int WinSize;
//sets the windowing of the FFT
Windowing.hann(WinSize) => fft.window;

//variables for the gate
0 => int gate;
0.4 => float threshold;
//variables for spectral rolloff
0.5 => roff50.percent;
//gives me the sample rate
second/samp => float samplerate;
//setting up OSC
"localhost" => string hostname;
14002 => int port;
OscRecv orec;
12000 => orec.port;
//get command line

0 => int squareNumber;

//if( me.args()) me.arg(0) => hostname;
//if( me.args() > 1 ) me.arg(1) => Std.atoi => port;
orec.listen();
orec.event("/sqrInfo/number, i") @=> OscEvent sqrInfoNum;
orec.event("/cirInfo, i") @=> OscEvent cirInfo;
//send message
OscSend xmit;
int circleNumber;
//int squareNumber;
xmit.setHost(hostname, port);
//listening for OSC
fun void update(int squareNumber)
{
}
fun void cirListen(){
    while(true){
        
        cirInfo => now;
        
        if( cirInfo.nextMsg() != 0)
        {
            cirInfo.getInt() => circleNumber;   
            //<<<circleNumber>>>;
        } 
        1::samp => now;
    }
} 

fun void sqrListen(){
    while(true){
        sqrInfoNum => now;
        if (sqrInfoNum.nextMsg() != 0)
        {
            sqrInfoNum.getInt() => squareNumber;
            
            for (0 => int i; i < squareNumber; i++){
                
                
                SqrOsc i => dac;
                Math.random2f(80,4000) => i.freq; 
                
                0.2 => i.gain;
                <<<"hello">>>;
            }
            //1::samp => now;
            //<<<"square Number :", squareNumber>>>;
        }        
    }
}  
//main loop
spork ~ sqrListen();
spork ~ cirListen();

while(true)
{
    //gets info from my FFT analysis and sends them to blobs
    //@=> int sqrBank =>
    
    rms.upchuck() @=> UAnaBlob blobRMS;
    flux.upchuck() @=> UAnaBlob blobFlux;
    roff50.upchuck();
    //<<<"50% Rolloff :" + roff50.fval(0) * samplerate / 2>>>;
    xmit.startMsg( "/fftInfo", "f,f,f,f");
    
    
    roff50.fval(0) * samplerate / 2 => xmit.addFloat;
    //converts the cent info into something useful
    
    //cent stuff
    cent.upchuck() @=> UAnaBlob blob;
    blob.fval(0) * samplerate/2 => float centInfo;
    //<<<"Cent :" + centInfo>>>;  
    
    centInfo => xmit.addFloat;
    //spectral flux
    blobFlux.fval(0)* 0.91 => saw1.gain;
    blobFlux.fval(0) * 100 => float fluxInfo;
    fluxInfo $ int => int fluxInfoInt;
    
    //<<<"Flux :" + fluxInfo>>>;
    //<<<fluxInfoInt>>>;
    if (fluxInfo == 0){
     Std.mtof(Math.random2(30,54)) => saw1.freq;
     //<<<"gain changed">>>;   
    }
    else if (fluxInfoInt % 89 == 1){
        0 => kick.pos;
        fluxInfoInt / 10 => kick.rate;
        0.7 => kick.gain;
        //<<<"kick">>>;
    }
    else if (fluxInfoInt % 91 == 1){
        0 => snare.pos;
        fluxInfoInt / 10 => snare.rate;
        Math.random2f(0,0.8) => snare.gain;
        //<<<"kick">>>;
    }
    else if (fluxInfoInt > 95){
        hiHat_samples[Math.random2(0,3)] => hiHat.read;
        0 => hiHat.pos;
        fluxInfoInt / 10 => hiHat.rate;
        Math.random2f(0,0.8) => hiHat.gain;
        //<<<"kick">>>;
    }

    else{
     //0 => saw1.gain;   
    }
    fluxInfo => xmit.addFloat;
    //move time
    
    
    //the RMS section of the loop
    blobRMS.fval(0) * 100000 => float rmsInfo;
    //<<<"RMS :" + rmsInfo>>>;
    
    rmsInfo => xmit.addFloat;
    
    
    //gated RMS
    if((rmsInfo > threshold) && (gate == 0)){
        //<<<"bang">>>;
        1 => gate;   
    }
    else if ((rmsInfo < threshold) && (gate == 1))
    {
        0 => gate;   
    }
    
    WinSize::samp => now;
}
