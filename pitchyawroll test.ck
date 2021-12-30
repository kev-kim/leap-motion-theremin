//theremin.ck
//Recieve hand data
OscRecv orec;
6441 => orec.port;
// start listening (launch thread)
orec.listen();
//listen for left, right hand position oscEvent
orec.event("/hand/right/pos, f f f f f f") @=> OscEvent righthpos;
//currently unused
orec.event("/hand/left/pos, f f f") @=> OscEvent lefthpos;

//theremin with TriOsc
TriOsc sound => NRev rev => dac;
0.1 => rev.mix;
0 => sound.freq;
SinOsc vib;
vib => blackhole;
0 => vib.freq;

fun void right(){
    while(true)
    { 
        righthpos => now; // wait for events to arrive.
        // grab the next message from the queue
        while( righthpos.nextMsg() != 0 )
        {
            //get left palm pos
            righthpos.getFloat() => float rightx;
            righthpos.getFloat() => float righty;
            righthpos.getFloat() => float rightz;
            righthpos.getFloat() => float pitch;
            righthpos.getFloat() => float yaw;
            righthpos.getFloat() => float roll;
            <<<"pitch: " + pitch>>>;
            <<<"yaw: " + yaw>>>;
            <<<"roll: " + roll>>>;
            //<<<righty>>>;
            
             // Simple y pos to note conversion
            Std.ftom(righty*2) $ int => int note;
            <<<note>>>;
            if(rightz>50) {Math.fabs(rightz*(0.05)) => vib.freq;}
            else {0 => vib.freq;}
            Std.mtof(note) + (vib.last() * 20) => sound.freq;
            
            /* custom scale - 6 note
            6 => int notes;
            300/notes => int inter;
            [73,75,78,80,82,85] @=> int scale[];
            // d major[62,64,66,67,69,71,73] @=> int scale[];
            float freq;
            if(righty<100+inter) {Std.mtof(scale[0]) => freq;}
            else if(100+inter<righty&&righty<100+inter*2) {Std.mtof(scale[1]) => freq;}
            else if(100+inter*2<righty&&righty<100+inter*3) {Std.mtof(scale[2]) => freq;}
            else if(100+inter*3<righty&&righty<100+inter*4) {Std.mtof(scale[3]) => freq;}
            else if(100+inter*4<righty&&righty<100+inter*5) {Std.mtof(scale[4]) => freq;}
            else if(100+inter*5<righty) {Std.mtof(scale[5]) => freq;}
            
            if(rightz>50) {Math.fabs(rightz*(0.05)) => vib.freq;}
            else {0 => vib.freq;}
            freq + vib.last()*20 => sound.freq;
            */
        }
    }
}

fun void left(){
    while(true)
    {
        lefthpos => now;
        
        while(lefthpos.nextMsg()!= 0)
        {
            lefthpos.getFloat() => float leftx;
            lefthpos.getFloat() => float lefty;
            lefthpos.getFloat() => float leftz;
            
            if(lefty > 150)
            {
                Math.fabs(lefty*(0.001)) => sound.gain;
            }
            else
            {
                0 => sound.gain;
            }
        }
    }
}

spork ~ right();
spork ~ left();

while(true) 1::second=>now;