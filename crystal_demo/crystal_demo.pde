import oscP5.*;
import netP5.*;

// declare variables here
Crystal demo;
int[] a;
int count;
boolean done;
OscP5 in;
int node;

void setup() {
  // do things like screen size and var initialization here
  size( 500, 500, P3D); // set up screen for 3d
  demo = new Crystal(27);
  frameRate( 30 );
  
  directionalLight(51, 102, 126, -1, 0, 0);
  in = new OscP5(this, 7000);
  
  done = true;
  
  stroke( 0 );
  line( 100, -100, 0, 400, -400, 0);
}

void draw() {
  // actual functional code goes here
  background(175);
  demo.show();
  
  if( done == false ) {
    demo.points[node].mark();
    done = true;
  }
  
  if( mousePressed ) {
    for( int i = 0; i < demo.points.length; i++ ) {
      demo.points[i].marked = false;
      demo.points[i].c = color( 0 );
    }
  }
}  

void oscEvent( OscMessage msg ) {
  if( msg.addrPattern().substring(1, 6).equals("nodes") ) {
    String pat = msg.addrPattern();
    node = int( pat.substring( pat.length() - 2 ) );
    println( "node: " + node );
    done = false;
  }
}

