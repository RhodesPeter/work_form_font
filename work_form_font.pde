import fontastic.*;

Fontastic f;

int[] list;
int posX, posY;
PVector axis;
PFont font;
int max;
int charWidth = 900;
PFont myFont;

void setup() {
  colorMode(RGB, 255, 255, 255);
  size(400, 400);
  font = createFont("FreeSans.ttf", 200);
  textFont(font);
  textAlign(CENTER, CENTER);
  fill(0);
  textSize(charWidth / 5f);

  initFont();
  createFont();
  writeFile();
}

// needed by Fontastic to setup font
void initFont() {
  f = new Fontastic(this, "work-form-typeface"); // create new Fontastic object - Everytime you run the file it will overwrite the file!

  // add letters to the font, without adding shapes. This setup is needed by Fontastic.
  for (char c : Fontastic.alphabet) {
    f.addGlyph(c); // add all uppercase letters from the alphabet
  }

  for (char c : Fontastic.alphabetLc) {
    f.addGlyph(c); // add all lowercase letters from the alphabet
  }

  f.setAuthor("work-form");
  f.setVersion("0.1");
  f.setAdvanceWidth(int(charWidth * 1.1));
}

void createFont () {
  for (char c : Fontastic.alphabet) {
    drawLetter(c); // add all uppercase letters from the alphabet
  }

  for (char c : Fontastic.alphabetLc) {
    drawLetter(c); // add all lowercase letters from the alphabet
  }  
};

void drawLetter(char currentLetter) {  
  background(#FFFAF5); // clear screen (previous letter if there is one) Remove this for interesting effect.

  list = new int[width*height];
  max = 40; // The number of shapes per letter
  text(currentLetter, width/2, height/2-70); // draws the text on the screen and it's position on the screen

  PVector[] pnts = new PVector[max]; // Define a PVector array containing the points of the shape

  loadPixels(); // The pixels[] array contains the values for all the pixels in the display window

  for (int y = 0; y<=height-1; y++) {
    for (int x = 0; x<=width-1; x++) {
      color pb = pixels[y*width+x];
      if (red(pb)<5) {  
        list[y*width+x]=0;
      } else {  
        list[y*width+x]=1;
      }
    }
  }

  updatePixels(); // Updates the display window with the data in the pixels[] array

  int i=0;

  while (i < max) { // loops until all the dots are used (the max value)
    axis = new PVector(int(random(100, width-100)), int(random(100, height-100)));
    
    if (list[int(axis.y*width+axis.x)] == 0) {
      pnts[i] = axis;
      i++;
    }
  }

  for (int index = 0; index < pnts.length-1; index++) {
    PVector p = pnts[index];
    PVector[] points = new PVector[6];

    float shapeSize = 50;

    int resolution = 6; // the number of points defining the shape (3 triangle, 4 a square etc.)
    points = new PVector[resolution];

    for (int j=0; j<resolution; j++) {
      float angle = TWO_PI/(resolution * 1f) * j;
      float x = p.x * 5 + sin(angle) * shapeSize;
      float y = -p.y * 5 + cos(angle) * shapeSize;
      x += (width/2f) / width/2f * noise(i+millis()/1000f) * 2000;
      y -= (height/2f) / height/2f * noise(i * 2+millis()/1000f) * 2000;
      points[j] = new PVector(x, y);
    }

    f.getGlyph(currentLetter).addContour(points);
  }  
}

void writeFile () {
  println("All characters built successfully!");

  f.buildFont(); // write ttf file
  f.cleanup(); // delete all glyph files that have been created while building the font

  myFont = createFont(f.getTTFfilename(), 200);
}
