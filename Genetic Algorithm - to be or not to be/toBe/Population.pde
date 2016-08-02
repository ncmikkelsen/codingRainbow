class Population {
  DNA[] population;
  int generation = 0;
  boolean found = false;


  Population(String target, float mutationRate) { 
    population = new DNA[1000];
    for (int i = 0; i< population.length; i++) {
      population[i] = new DNA(target, mutationRate);
    }
    calculateFitness();
  }

  Population(String target, float mutationRate, int popSize) {
    population = new DNA[popSize];
    for (int i = 0; i < population.length; i++) {
      population[i] = new DNA(target, mutationRate);
    }
    calculateFitness();
  }


  void calculateFitness() {
    for (int i = 0; i < population.length; i++) {
      if (population[i].fitness() == 1) {
        found = true;
      }
    }
  }

  void mate() {
    ArrayList<DNA> matingPool = createMatingPool();

    for (int i = 0; i < population.length; i++) {
      DNA firstMate = matingPool.get((int) random(matingPool.size()));
      DNA secondMate = matingPool.get((int) random(matingPool.size()));
      DNA child = firstMate.crossover(secondMate);
      population[i] = child;
    }
  }

  void update() {
    mate();
    generation++;
    calculateFitness();
  }

  ArrayList<DNA> createMatingPool() {
    ArrayList<DNA> matingPool = new ArrayList<DNA>();

    //float totalFitness = 0;
    //for (DNA dna : population) {
    //  totalFitness += dna.fitness;
    //}
    for (int i = 0; i < population.length; i++) {
      DNA dna = population[i];
      float percent = dna.fitness * 100;
      for (int j = 0; j < percent; j++) {
        matingPool.add(dna);
      }
    }
    return matingPool;
  }

  DNA findBestDNA() {
    calculateFitness();
    DNA bestDNA = population[0];
    for (int i = 1; i < population.length; i++) {
      DNA thisDNA = population[i];
      if (thisDNA.fitness > bestDNA.fitness) {
        bestDNA = thisDNA;
      }
    }
    return bestDNA;
  }
} 