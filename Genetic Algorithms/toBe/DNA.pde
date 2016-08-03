class DNA {
  String target;
  float mutationRate;
  float fitness;
  char[] genes;

  DNA (String _target, float _mutationRate) {
    target = _target;
    mutationRate = _mutationRate;
    genes = new char[target.length()];
    for(int i = 0; i < genes.length; i++){
      genes[i] = (char) random(32, 128);
    }
  }

  DNA (String _target, float _mutationRate, char[] _genes) {
    target = _target;
    mutationRate = _mutationRate;
    genes = _genes;
  }

  DNA crossover(DNA other){
    char[] newGenes = new char[genes.length];
    // Creates a cutoff point in the middle of the two words
    //int cutoff = newGenes.length / 2; 
    
    // Creates a cutoff point at a random point
    int cutoff = (int) random(1, newGenes.length - 1);

    for (int i = 0; i < newGenes.length; i++) {
      // Mutates if percentage change is hit
      if(random(1) < mutationRate){
        newGenes[i] = (char) random(32, 128);
      } else if(i < cutoff){
        newGenes[i] = this.genes[i];
      } else {
        newGenes[i] = other.genes[i];
      }
    }
    
    return new DNA(target, mutationRate, newGenes);
  }

  float fitness(){
    int score = 0;
    for (int i = 0; i < genes.length; i++) {
      if(genes[i] == target.charAt(i)){
        score++;
      }
    }
    fitness = float(score)/target.length();
    return fitness;
  }


}