/*=====================================
  Each individual contains an array of genes that code for
  particular traits to be visually represented as a
  regular polygon.
  Instance variables:
      chromosome
        An array of genes, each entry corresponding to a
        specific trait in the following order:
          sides: number of sides
          rad: the distance from the center of the regular polygon to any vertex
          red_color: red value
          green_color: green value
          blue_color: blue value
          x_factor: "wobble" factor for x values
          y_factor: "wobble" factor for y values
      phenotype
        A regular polygon object with traits that correspond to
        the values found in chromosome.
      fitness
        How "close" the Individual is to the desired state
====================================*/
class Individual {
  /*=====================================
    Number of genes in each chromosome and the
    unique indentifiers for each gene type
  ====================================*/
  int CHROMOSOME_LENGTH = 7;
  int SIDES = 0;
  int RAD = 1;
  int RED_COLOR = 2;
  int GREEN_COLOR = 3;
  int BLUE_COLOR = 4;
  int X_FACTOR = 5;
  int Y_FACTOR = 6;
  
  /*=====================================
    Constants defining how long each gene will be.
    For initial development, set these to lower
    values to make testing easier.
  ====================================*/
  int SIDE_GENE_SIZE = 7;
  int RADIUS_GENE_SIZE = 4;
  int COLOR_GENE_SIZE = 8;
  int FACTOR_GENE_SIZE = 4;
  
  //Instance variables
  Gene[] chromosome;
  Blob phenotype;
  float fitness;

  /*=====================================
    Create a new Individual by setting each entry in chromosome
    to a new randomly created gene of the appropriate length.
    
    After the array is populated, set phenotype to a new regular polygon
    with center cx, cy and properties that align with gene values.
    (for example, if the side gene is 4, the regular polygon should have 4
      sides...)
  ====================================*/
  Individual(float cx, float cy) {
    chromosome = new Gene[CHROMOSOME_LENGTH];
    chromosome[SIDES] = new Gene(SIDE_GENE_SIZE);
    chromosome[RAD] = new Gene(RADIUS_GENE_SIZE);
    chromosome[RED_COLOR] = new Gene(COLOR_GENE_SIZE);
    chromosome[GREEN_COLOR] = new Gene(COLOR_GENE_SIZE);
    chromosome[BLUE_COLOR] = new Gene(COLOR_GENE_SIZE);
    chromosome[X_FACTOR] = new Gene(FACTOR_GENE_SIZE);
    chromosome[Y_FACTOR] = new Gene(FACTOR_GENE_SIZE);
    // RED_COLOR, GREEN_COLOR, BLUE_COLOR
    /*
    for(int i=2; i<=4; i++) {
      chromosome[i] = new Gene(COLOR_GENE_SIZE);
    }
    // X_FACTOR, Y_FACTOR
    for(int i=5; i<=6; i++) {
      chromosome[i] = new Gene(FACTOR_GENE_SIZE);
    }
    */
    setPhenotype(cx, cy);
  }
  

  
  Individual(float cx, float cy, Gene[] chromo) {
    chromosome = new Gene[CHROMOSOME_LENGTH];
    for(int i=0; i<CHROMOSOME_LENGTH; i++) {
      chromosome[i] = chromo[i];
    }
    
    setPhenotype(cx, cy);
  }
  /*=====================================
    Call the display method of the phenotype. Make sure
    to set the fill color appropriately.
  ====================================*/
  void display() {
    fill(chromosome[2].value, chromosome[3].value, chromosome[4].value);
    phenotype.display();
  }
  
  /*=====================================
    Set phenotype to a new regular polygon with center (cx, cy) 
    and properties that align with gene values.
  ====================================*/
  void setPhenotype(float cx, float cy) {
    phenotype = new Blob(cx, cy, chromosome[SIDES].value, chromosome[RAD].value, chromosome[X_FACTOR].value, chromosome[Y_FACTOR].value);
  }
  
  /*=====================================
    Print the value of each gene in chromosome.
    Useful for debugging and development.
  ====================================*/
  void printIndividual() {
    for(Gene g : chromosome) {
      println(g.value);
    }
  }
  
  /*=====================================
    Return a new Individual based on the genes of the calling
    chromosome and the parameter other. A random number of
    genes should be taken from this individual and the
    rest from the other.
    The phenotype of the new Individual must be set, using cx and cy
    as the center.
  ====================================*/
  Individual mate(Individual other, int cx, int cy) {
    Gene[] newChromo = new Gene[CHROMOSOME_LENGTH];
    for(int i=0; i<CHROMOSOME_LENGTH; i++) {
      if(int(random(1))==0) {
        newChromo[i] = chromosome[i];
      }
      else {
        newChromo[i] = other.chromosome[i];
      }
    }
    
    Individual newIndividual = new Individual(cx, cy, newChromo); // What genius!
    return newIndividual;
  }
  
  /*=====================================
    Set the fitness value of the calling individual by
    comparing it to the parameter goal.
    The closer the two are, the higher the fitness value.
  ====================================*/
  void setFitness(Individual goal) {
    float diff = 0.000;
    float total = 0.000;
    for(int i=0; i<CHROMOSOME_LENGTH; i++) {
      // Add up difference, divide by total, result = percentage.
      diff += abs(goal.chromosome[i].value - chromosome[i].value);
      total += pow(chromosome[i].geneLength, 2);
    }
    fitness = 100.000 * (abs(1-diff/total));
  }
  
  /*=====================================
    Call the mutate method on a random number
    of genes.
  ====================================*/
  void mutate() {
    for(Gene g : chromosome) {
      if(int(random(1))==0) {
        g.mutate();
      }
    }
  }
}
