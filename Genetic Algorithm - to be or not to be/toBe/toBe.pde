Population pop;

void setup() {
  size(200, 200);
  pop = new Population("To be or not to be, that is the question.", 0.01, 1000);
}

void draw() {
  if (!pop.found) {
    pop.update();
    DNA bestDNA = pop.findBestDNA();
    String bestString = "";
    for (int i = 0; i < bestDNA.genes.length; i++) {
      bestString += bestDNA.genes[i];
    }
    background(255);
    println("Generation: " + pop.generation + "\t " + bestString);
  }
}