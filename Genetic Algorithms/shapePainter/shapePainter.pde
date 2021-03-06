import processing.video.*;

Capture cam;

PImage targetImage;
PImage backupImage;
ArrayList<Painter> painters;
int painterPopulation;
long currentFit;
int piclength;
int generation = 0;
color startCol = color(random(256), random(256), random(256));
boolean captureGenerations = true;
boolean captureCircles = true;
//Grabs a screenshot every captureRate frame.
int generationCaptureRate = 500;
//Grabs a screen every time the number of circles grouws with circleCaptureRate amount.
int circleCaptureRate = 100;
String folderName;
String directory = "C:/Users/N/Desktop/";
void setup() {
  size(640, 480);
  background(startCol);


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

  while (!cam.available()) {
    cam.read();
  }
  targetImage = cam;
  folderName = "" + year() + "_" + month() + "_" + day() + "_" + hour() + "_" + minute() + "_" + second() + "/";
  targetImage.save(directory + folderName + "targetImage.png");
  piclength = 640 * 480;



  painters = new ArrayList<Painter>();
  painterPopulation = 0;
  backupImage = createImage(width, height, ARGB);
  updateBackup();
  currentFit = calculateFitness();
  println(currentFit);
}

void draw() {
  evolve();
  println("Generation:\t" + generation + "\t CurrentFit:\t" + currentFit + "\t Circles:\t" + painterPopulation);
}

long calculateFitness() {
  long newFit = 0;
  loadPixels();
  targetImage.loadPixels();
  for (int i = 0; i < piclength; i++) {
    color currentColor = pixels[i];
    color targetColor = targetImage.pixels[i];
    newFit += (dist(red(targetColor), green(targetColor), blue(targetColor), red(currentColor), green(currentColor), blue(currentColor)));
  }
  return newFit;
}

void evolve() {
  show();
  if (captureGenerations && generation % generationCaptureRate == 0) {
    saveFrame(directory + folderName + "Generations/" + generation + ".png");
  }
  if (captureCircles && painterPopulation % circleCaptureRate == 0) {
    save(directory + folderName + "Circles/" + painterPopulation + ".png");
  }


  Painter candidatePainter = new Painter();
  candidatePainter.show();
  long newFit = calculateFitness();
  if (newFit < currentFit) {
    painters.add(candidatePainter);
    currentFit = newFit;
    painterPopulation++;
  }

  if (painters.size() >= 100) {
    updateBackup();
  }
  generation++;
}

void updateBackup() {
  loadPixels();
  backupImage.loadPixels();
  for (int i = 0; i < piclength; i++) {
    backupImage.pixels[i] = pixels[i];
  }
  backupImage.updatePixels();
  painters.clear();
}

void show() {
  background(startCol);
  image(backupImage, 0, 0, width, height);
  for (Painter p : painters) {
    p.show();
  };
}

void reset() {
  println("Resetting with a new picture!");

  background(startCol);
  updateBackup();
  generation = 0;
  cam.read();
  targetImage = cam;
  folderName = "" + year() + "_" + month() + "_" + day() + "_" + hour() + "_" + minute() + "_" + second() + "/";
  targetImage.save(directory + folderName + "targetImage.png");

  painters.clear();
  currentFit = calculateFitness();
}

void keyPressed() {
  if (key == ' ') {
    reset();
  }
}
