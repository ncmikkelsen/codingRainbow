import processing.video.*;

Capture cam;

PImage targetImage;
ArrayList<Painter> painters;
int currentFit;
int lastFit;
int piclength;
int generation = 0;

void setup() {
  size(640, 480);
  background(0);

  String[] cameras = Capture.list();
  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    // The camera can be initialized directly using an element
    // from the array returned by list():
    cam = new Capture(this, cameras[3]);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);

    // Start capturing the images from the camera
    cam.start();
  }
  //delay(10000);
  //cam.read();
  //targetImage = cam;
  targetImage = loadImage("hacker.jpg");
  piclength = 640 * 480;



  painters = new ArrayList<Painter>();
  painters.add(new Painter());
  currentFit = 2147483647;
  calculateFitness();
  println(currentFit);
  println(lastFit);
  painters.add(new Painter());
  calculateFitness();
  println(currentFit);
  println(lastFit);
}

void draw() {
  calculateFitness();
  evolve();
  show();
  println("Generation:\t" + generation + "\tCurrentFit\t" + currentFit + "\tlastFit\t" + lastFit);
}

void calculateFitness() {
  lastFit = currentFit;
  currentFit = 0;
  loadPixels();
  targetImage.loadPixels();

  for (int i = 0; i < piclength; i++) {
    color currentColor = pixels[i];
    color targetColor = targetImage.pixels[i];
    currentFit += abs(dist(red(targetColor), green(targetColor), blue(targetColor), red(currentColor), green(currentColor), blue(currentColor)));
  }
}

void evolve() {
  if (currentFit < lastFit) {
    painters.add(new Painter());
  } else {
    painters.set(painters.size() - 1, new Painter());
    currentFit = lastFit;
  }
  generation++;
}

void show() {
  for (Painter p : painters) {
    p.show();
  };
}

void reset() {
  background(255);
  painters = new ArrayList<Painter>();
  painters.add(new Painter());
  generation = 0;
  lastFit = 0;
  currentFit = 0;
}

void keyPressed() {
  if (key == ' ') {
    println("Nyt billede");
    cam.read();
    targetImage = cam;
    reset();
  }
}