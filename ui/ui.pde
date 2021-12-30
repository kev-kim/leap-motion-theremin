//author: Kevin Kim
//ui for theremin
import netP5.*;
import oscP5.*;
import com.leapmotion.leap.*;

Controller controller = new Controller();
Frame frame = controller.frame();

OscP5 oscP5;
NetAddress local;

void setup()
{
   size(600,600);
   frameRate(60);
   /* start oscP5, listening for incoming messages at port 6444 */
   oscP5 = new OscP5(this,6447);
   local = new NetAddress("localhost",6447);
}

void drawCirc(float x, float y, int r, int g, int b){
  //fill(255,255,255);
  ellipse(x+300.0,600-y,50,50);
  //noFill();
}

void draw()
{
   background(0);
   Frame frame = controller.frame();
   text("Theremin by Kevin Kim", 5, 15);
   text(frame.hands().count() + "Hands", 5, 30);
   text( "x(l):", 5, 50);
   text( "y(l):", 5, 65);
   text( "z(l):", 5, 80);
   
   text( "x(r):", 105, 50);
   text( "y(r):", 105, 65);
   text( "z(r):", 105, 80);
   
   rect(5,85,590,510);
   
   int notes = 6;
   int inter = 300/notes;
   
   for(int i = 0; i < 6; i++)
   {
     int temp = 600-(100+inter*(i+1));
     line(5,temp,595,temp); 
   }
   
   OscMessage lefthpos = new OscMessage("/hand/left/pos");
   OscMessage righthpos = new OscMessage("/hand/right/pos");

    for(Hand hand : frame.hands())
    {
      if(hand.isLeft())
      {
        float x = hand.palmPosition().getX();
        float y = hand.palmPosition().getY();
        float z = hand.palmPosition().getZ();
        
        text( "       " + x, 5, 50);
        text( "       " + y, 5, 65);
        text( "       " + z, 5, 80);
        
        lefthpos.add(x);
        lefthpos.add(y);
        lefthpos.add(z);
        
        oscP5.send(lefthpos, local); 
        drawCirc(x,y,253,102,0);
      } 
      else if(hand.isRight())
      {
        float x = hand.palmPosition().getX();
        float y = hand.palmPosition().getY();
        float z = hand.palmPosition().getZ();
        /*
        float pitch = hand.direction().pitch();
        float yaw = hand.direction().yaw();
        float roll = hand.direction().roll();
        */
        
        text( "       " + x, 105, 50);
        text( "       " + y, 105, 65);
        text( "       " + z, 105, 80);
        
        righthpos.add(x);
        righthpos.add(y);
        righthpos.add(z);
        /*
        righthpos.add(pitch);
        righthpos.add(yaw);
        righthpos.add(roll);
        */
        
        oscP5.send(righthpos, local); 
        drawCirc(x,y,0,120,255);
      }
    }
}
