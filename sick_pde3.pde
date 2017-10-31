//http://www.learningprocessing.com/examples/chapter-13/example-13-5-polar-to-cartesian/
//http://sicktoolbox.sourceforge.net/docs/sicktoolbox-quickstart.pdf
import processing.serial.*;

final int rate = 38400;

Serial port;
int[] frame;


int serialCounter;

int nextFrameTime;
int framePeriod = 50;


byte[] values={0x02, 0x00, 0x02, 0x00, 0x30, 0x01, 0x31, 0x18};


void setup()
{
  size( 1200, 800 );
 
  frameRate(1);
  frame = new int[1466];
  background(0);
  stroke(255);
  point (400,400);

  initSerial();

  //noStroke();
  //noSmooth();
  nextFrameTime = millis();
}

void draw()
{
  int count=9;
  float grad=0;
  int r;
  if( millis() >= nextFrameTime )
  {
    requestFrame();
    do
    {
      r = 256 * frame[count] + frame[count+1];
      //r=500;
      float x = r * cos(grad*0.01745329251994329576923690768489);
      float y = r * sin(grad*0.01745329251994329576923690768489);
      point (600+(1.5*x),700-(1.5*y));
      println(grad, x,y, cos(grad), sin(grad));
      //background(245);
      count=count+2;
      grad=grad+0.5;
    }  
    while (count != 731);
    nextFrameTime = millis() + framePeriod;
  }
}


void initSerial()
{
  String portName = Serial.list()[0];
  //portName = "/dev/ttyS0";
  port = new Serial(this, portName, rate, 'E' , 8 ,1 );
  println("Using " + portName + " as serial device.");
}

void requestFrame()
{
  port.write(values);
  int incoming;
  int count=0;
  do
  {
    incoming = port.read();
    frame[count] = incoming;
    count++;
    println(count, incoming);
   }
  while (count != 733);
}