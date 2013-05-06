/* --------------------------------------------------------------------------
 * SimpleOpenNI IR Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / zhdk / http://iad.zhdk.ch/
 * date:  02/16/2011 (m/d/y)
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;

float threshold = 150.0;
int xPos = 0;
int yPos = 0;

PGraphics pg;

SimpleOpenNI  context;

void setup()
{
  context = new SimpleOpenNI(this);

  pg = createGraphics(200,200);
 
  // enable depthMap generation 
  if(context.enableDepth() == false)
  {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }
  
  // enable ir generation
  if(context.enableIR() == false)
  {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }
  
  background(0);
  //size(context.depthWidth() + context.irWidth() + 10, context.depthHeight());
   size(400,480); 
   frameRate(30);
}

void draw()
{
  //background(0, 0.1);
  fill(0,3);
  rect(0,0,width,height);
  // update the cam
  context.update();
  
  // draw depthImageMap
  //image(context.depthImage(),0,0);
  
  // draw irImageMap
  PImage infrared = context.irImage();
  PImage filtered = createImage(200,200, ARGB);
  PImage crop = createImage(200,200,RGB);
  
  pg.beginDraw();
  pg.image(infrared,-190,-262);
  pg.endDraw(); 
  image(pg, 0,0);
  //image(context.irImage(),0,0);
  
  infrared.loadPixels();
  filtered.loadPixels();
  
//  for (int cols=0; cols < 640; cols++){
//    for (int rows=0; rows < 480; rows++){
//      color pixel =  infrared.get(cols,rows);
//      if (brightness(pixel) > 50) {
//         filtered.pixels[cols*rows] = color(255);
//      }else{
//         filtered.pixels[cols*rows] = color(0);
//      }
//    }
//  }
  for (int p=0; p < 200*200; p++){
      color pixel =  pg.pixels[p];
      
      float y = map(brightness(pixel), threshold - 20, threshold + 20, 0, 255);
      filtered.pixels[p] = color(255, y);
      
//      if (brightness(pixel) > threshold) {
//         filtered.pixels[p] = color(255);
//      }else{
//         //filtered.pixels[p] = color(0);
//         filtered.pixels[p] = color(0,0);
//      }
  }
  image(filtered,200,0);
  
  text("Threshold: " + threshold, 0, 250);
}

void keyPressed() {
  background(0);
  
  if(keyCode == 38) {
    threshold+=5;
  } else if (keyCode == 40) {
    threshold-=5;
  }
}
