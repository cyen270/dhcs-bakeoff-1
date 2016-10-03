import java.awt.AWTException;
import java.awt.Rectangle;
import java.awt.event.InputEvent;
import java.awt.Robot;
import java.util.ArrayList;
import java.util.Collections;
import processing.core.PApplet;

//when in doubt, consult the Processsing reference: https://processing.org/reference/

int margin = 200; //set the margina around the squares
final int padding = 50; // padding between buttons and also their width/height
final int buttonSize = 40; // padding between buttons and also their width/height
ArrayList<Integer> trials = new ArrayList<Integer>(); //contains the order of buttons that activate in the test
ArrayList<Boolean> grow = new ArrayList<Boolean>();
int trialNum = 0; //the current trial number (indexes into trials array above)
int startTime = 0; // time starts when the first click is captured
int finishTime = 0; //records the time of the final click
int hits = 0; //number of successful clicks
int misses = 0; //number of missed clicks
Robot robot; //initalized in setup 

int numRepeats = 3; //sets the number of times each button repeats in the test

void setup()
{
  size(700, 700); // set the size of the window
  noCursor(); //hides the system cursor if you want
  noStroke(); //turn off all strokes, we're just using fills here (can change this if you want)
  textFont(createFont("Arial", 16)); //sets the font to Arial size 16
  textAlign(CENTER);
  frameRate(60);
  ellipseMode(CENTER); //ellipses are drawn from the center (BUT RECTANGLES ARE NOT!)
  //rectMode(CENTER); //enabling will break the scaffold code, but you might find it easier to work with centered rects

  try {
    robot = new Robot(); //create a "Java Robot" class that can move the system cursor
  } 
  catch (AWTException e) {
    e.printStackTrace();
  }

  //===DON'T MODIFY MY RANDOM ORDERING CODE==
  for (int i = 0; i < 16; i++) //generate list of targets and randomize the order
      // number of buttons in 4x4 grid
    for (int k = 0; k < numRepeats; k++)
      // number of times each button repeats
      trials.add(i);
      
  for (int i = 0; i < 16; i++) {
      grow.add(false);  
  }

  Collections.shuffle(trials); // randomize the order of the buttons
  System.out.println("trial order: " + trials);
  
  frame.setLocation(0,0); // put window in top left corner of screen (doesn't always work)
}


void draw()
{
  background(255); //set background to black

  if (trialNum >= trials.size()) //check to see if test is over
  {
    fill(0); //set fill color to white
    //write to screen (not console)
    text("Finished!", width / 2, height / 2); 
    text("Hits: " + hits, width / 2, height / 2 + 20);
    text("Misses: " + misses, width / 2, height / 2 + 40);
    text("Accuracy: " + (float)hits*100f/(float)(hits+misses) +"%", width / 2, height / 2 + 60);
    text("Total time taken: " + (finishTime-startTime) / 1000f + " sec", width / 2, height / 2 + 80);
    text("Average time for each button: " + ((finishTime-startTime) / 1000f)/(float)(hits+misses) + " sec", width / 2, height / 2 + 100);  
    cursor(HAND);
    return; //return, nothing else to do now test is over
  }

  fill(255); //set fill color to white
  text((trialNum + 1) + " of " + trials.size(), 40, 20); //display what trial the user is on
  
  for (int i = 0; i < 16; i++)// for all button
    drawButton(i, false); //draw button
    
  Rectangle bounds = getButtonLocation(trials.get(trialNum));
  Rectangle bounds_next;
  if (trialNum < numRepeats * 16 - 1) 
    bounds_next = getButtonLocation(trials.get(trialNum+1));
  else 
    bounds_next = bounds;
  fill(0);
  
  
  // Make active rectangle larger
   for (int i = 0; i < 16; i++) {
     Rectangle cur = getButtonLocation(i);
     int x = cur.x;
     int y = cur.y;
     int w = cur.width;
     int h = cur.height;
     
     if ((x <= mouseX) && (mouseX < x + w ) && (y <= mouseY) && (mouseY < y + h )) {
       grow.set(i, true);
       drawButton(i, false);
       if (i == trials.get(trialNum)) {
         drawButton(i, true); 
       }
     }
     grow.set(i, false); 
   }

  stroke(0);
  strokeWeight(5);
  fill(0);
  drawpointer(bounds, bounds_next);
  
  noStroke();
  fill(255);


  //fill(255, 0, 0, 200); // set fill color to translucent red
  //ellipse(mouseX, mouseY, 20, 20); //draw user cursor as a circle with a diameter of 20
}

void drawpointer(Rectangle bounds, Rectangle bounds_next) {
  Rectangle upleft = getButtonLocation(0);
  Rectangle botright = getButtonLocation(15);
  int lower_x = upleft.x + 15;
  int upper_x = botright.x + botright.width - 15;
  int lower_y = upleft.y + 15;
  int upper_y = botright.y + botright.height - 15;
  if (mouseX < lower_x) mouseX = lower_x;
  if (mouseX > upper_x) mouseX = upper_x;
  if (mouseY < lower_y) mouseY = lower_y;
  if (mouseY > upper_y) mouseY = upper_y;
  ellipse(mouseX, mouseY, 20, 20);
  line(mouseX, mouseY, bounds.x + bounds.width / 2, bounds.y + bounds.width / 2);
  if (trialNum < numRepeats * 16 - 1) {
    if (trials.get(trialNum+1) != trials.get(trialNum)) {
      if (trialNum > 0 && (trials.get(trialNum) == trials.get(trialNum-1))) {
        noFill();
        beginShape();
        curveVertex(bounds.x + bounds.width / 2, bounds.y + bounds.width / 2);
        curveVertex(bounds.x + bounds.width / 2, bounds.y + bounds.width / 2);
        curveVertex(bounds.x + bounds.width / 2 - 20, bounds.y + bounds.width / 2 - 35);
        curveVertex(bounds.x + bounds.width / 2, bounds.y + bounds.width / 2 - 50);
        curveVertex(bounds.x + bounds.width / 2 + 20, bounds.y + bounds.width / 2 - 35);
        curveVertex(bounds.x + bounds.width / 2, bounds.y + bounds.width / 2);
        curveVertex(bounds.x + bounds.width / 2, bounds.y + bounds.width / 2);
        endShape();
      }
      line(bounds.x + bounds.width / 2, bounds.y + bounds.width / 2, bounds_next.x + bounds_next.width / 2, bounds_next.y + bounds_next.width / 2);
    }
    else {
      noFill();
      beginShape();
      curveVertex(bounds.x + bounds.width / 2, bounds.y + bounds.width / 2);
      curveVertex(bounds.x + bounds.width / 2, bounds.y + bounds.width / 2);
      curveVertex(bounds.x + bounds.width / 2 - 20, bounds.y + bounds.width / 2 - 35);
      curveVertex(bounds.x + bounds.width / 2, bounds.y + bounds.width / 2 - 50);
      curveVertex(bounds.x + bounds.width / 2 + 20, bounds.y + bounds.width / 2 - 35);
      curveVertex(bounds.x + bounds.width / 2, bounds.y + bounds.width / 2);
      curveVertex(bounds.x + bounds.width / 2, bounds.y + bounds.width / 2);
      endShape();
    }
  }
}

void mousePressed() // test to see if hit was in target!
{
  if (trialNum >= trials.size()) //if task is over, just return
    return;

  if (trialNum == 0) //check if first click, if so, start timer
    startTime = millis();

  if (trialNum == trials.size() - 1) //check if final click
  {
    finishTime = millis();
    //write to terminal some output:
    println("Hits: " + hits);
    println("Misses: " + misses);
    println("Accuracy: " + (float)hits*100f/(float)(hits+misses) +"%");
    println("Total time taken: " + (finishTime-startTime) / 1000f + " sec");
    println("Average time for each button: " + ((finishTime-startTime) / 1000f)/(float)(hits+misses) + " sec");
  }

  Rectangle bounds = getButtonLocation(trials.get(trialNum));
  
  //check to see if mouse cursor is inside button 
  if ((mouseX > bounds.x && mouseX < bounds.x + bounds.width) && (mouseY > bounds.y && mouseY < bounds.y + bounds.height)) // test to see if hit was within bounds
  {
    System.out.println("HIT! " + trialNum + " " + (millis() - startTime)); // success
    hits++; 
  }  
  else
  {
    System.out.println("MISSED! " + trialNum + " " + (millis() - startTime)); // fail
    misses++;
  }
  
  trialNum++; //Increment trial number

  //in this example code, we move the mouse back to the middle
  //robot.mouseMove(width/2, (height)/2); //on click, move cursor to roughly center of window!
}  

//probably shouldn't have to edit this method
Rectangle getButtonLocation(int i) //for a given button ID, what is its location and size
{
   int x = (i % 4) * (padding + buttonSize) + margin;
   int y = (i / 4) * (padding + buttonSize) + margin;
   return new Rectangle(x - padding / 2, y - padding / 2, buttonSize + padding, buttonSize + padding);
}

//you can edit this method to change how buttons appear
void drawButton(int i, boolean isAboveTarget)
{
  Rectangle bounds = getButtonLocation(i);
  if (isAboveTarget) 
    fill(100,200,100);
  else if (trials.get(trialNum) == i) // see if current button is the target
    fill(0, 255, 255); // if so, fill cyan
  else if ((trialNum < numRepeats * 16 - 1) && (trials.get(trialNum+1) == i)) {
    fill(115, 115, 115);
  }
  else
    fill(200); // if not, fill gray
  
  if (grow.get(i)) {
    rect(bounds.x, bounds.y, bounds.width, bounds.height); //draw button
  } else {
    rect(bounds.x + padding / 2, bounds.y + padding / 2, bounds.width - padding, bounds.height - padding);
  }
  
}

void mouseMoved()
{
   //can do stuff everytime the mouse is moved (i.e., not clicked)
   //https://processing.org/reference/mouseMoved_.html
   
   if (trialNum >= trials.size()) return;
   fill(0);
   Rectangle bounds = getButtonLocation(trials.get(trialNum));
   Rectangle bounds_next;
  if (trialNum < numRepeats * 16 - 1) 
    bounds_next = getButtonLocation(trials.get(trialNum+1));
  else 
    bounds_next = bounds;
   drawpointer(bounds, bounds_next);
   fill(255);
}

void mouseDragged()
{
  //can do stuff everytime the mouse is dragged
  //https://processing.org/reference/mouseDragged_.html
}

void keyPressed() 
{
  if (key == ' ' || key == 'a') {
    robot.mousePress(InputEvent.BUTTON1_MASK);
    robot.mouseRelease(InputEvent.BUTTON1_MASK);
  }
}