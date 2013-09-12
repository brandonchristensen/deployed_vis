/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/50864*@* */

int 
X, Y;
final int
TEXT_COL      = #000000, //Black for text
BLUE_COLOR    = #0099FF, //Blue for Air Force
GREEN_COLOR   = #009900, //Green for Army
HOVER_COL     = #ffffff, //White hover
WORLD_TINT    = 0xffffffff, //tint of the earth
LINES_WEIGHT  = 6, 
BUFF_LINES_W  = 6;
float 
a, b;
PGraphics 
bg, 
hover;
PFont 
h0, h1, h2, h3;
//
Globe w;
Table t;
DataHolder[] data;



void setup() {
  //Buffers
  size(900, 700, P3D); 
  bg= createGraphics(width, height, P2D);  
  hover=  createGraphics(width, height, P3D);

  //Fonts
  h1= loadFont("Georgia-24.vlw");
  h2= loadFont("Verdana-16.vlw");

  //General settings
  X=  width/2+100;
  Y= height/2;
  createBackground (bg, X, Y, .1);
  //createBackground (bg,X,Y,.2);
  frameRate(30);
  cursor(CROSS);

  //Objects
  w= new Globe(250, 24, "world32k.jpg");
  t= new Table("coords.csv");
  data= new DataHolder[t.getNumRows()-1];
  for (int i=0;i<data.length;i++) data[i]= new DataHolder(i);
}

//Creates gradient behind the earth
void createBackground (PGraphics pg, int X, int Y, float f) { 
  int x, y;
  pg.beginDraw();
  pg.smooth();
  for (int i=0;++i<pg.width*pg.height;) 
  {
    pg.set (x=i%pg.width, y=i/pg.width, (255-round(dist(x, y, X, Y)*f))*0x010101);
  }
  pg.endDraw();
  background(pg);
}

////////////////////////////////////////////////////////////////////////////////////////

void draw() {
  background(bg);
  hover.beginDraw(); 
  hover.background(0); 
  hover.endDraw();
  lights();
  w.update();
  render(X, Y); 
  detectHover();
}

void render(int x, int y) {
  hover.beginDraw();
  pushMatrix();
  translate(x, y);
  hover.translate(x, y);
  pushMatrix();
  rotateX(w.rotation.x);
  rotateY(w.rotation.y);
  hover.rotateX(w.rotation.x);
  hover.rotateY(w.rotation.y);
  fill(WORLD_TINT);
  w.render();
  for (int i=0;i<data.length;i++) {
    data[i].render(g, false);
    data[i].render(hover, true);
  }
  popMatrix();
  popMatrix();
  hover.endDraw();
}

////////////////////////////////////////////////////////////////////////////////////////

void mouseDragged() {
  if (mouseButton==LEFT)  w.addRotation(mouseX, mouseY, pmouseX, pmouseY);
}

void detectHover() {
  int c=hover.get(mouseX, mouseY);
  int index= round(c/0x010101 + 254);  // (c / 65793) + 254
  for (int i=0; i<data.length; i++) {
    if (i==index) {
      data[i].setHoveredTo(true);
      println (c);
      fill(TEXT_COL);
      textFont(h1);
      text(data[i].LOCATION, 20, height-175);
      textFont(h2);
      text(data[i].YEAR+", "+data[i].WEEKS + " weeks", 20, height-150);
      text(data[i].OPERATION, 20, height-125);
      noFill();
    } // end if
    else {
      data[i].setHoveredTo(false);
    } // end else
  } // end for
} // end void detectHover
