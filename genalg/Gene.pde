/*=====================================
   Each gene contains the code for a specific trait
   Instance Variables:
      genotype: int array to store a binary number
      value: corresponding base 10 number of the genotype
      geneLength: desired length of the gene
  ====================================*/
class Gene {
  int geneLength;
  int[] genotype;
  int value;
  
  /*===================================== 
  Takes the length of the gene as a parameter,
  randomly sets every bit in the genotype array to
  a 1 or a 0, then calcuate the value.
  ====================================*/
  Gene(int l) {
    geneLength = l;
    genotype = new int[geneLength];
    for (int i = 0; i < genotype.length; i++) {
      int r = (int) random(2);
      genotype[i] = r;
    }
    value = 0;
    for (int i = 0; i < genotype.length; i++) {
      value += genotype[i];
    setValue();
    }
  }
  
  
  /*=====================================
    Create a new gene that is a copy
    of the parameter
  ====================================*/
   Gene(Gene g) {
    geneLength = g.geneLength;
    genotype = g.genotype;
    value = g.value;
  }
  
  /*=====================================
    Pick a random element from genotype
    and switch it from 1 to 0 or vice-versa
  ====================================*/ 
  void mutate() {
    int i = int(random(geneLength));
    genotype[i] = (genotype[i]==1 ? 0 : 1);
  }
  
  /*=====================================
  Go through the genotype and set value to the
  correct base 10 equivalent of the binary number
  ====================================*/
   void setValue() {
    value = 0;
    for (int i = genotype.length - 1; i >= 0; i--) {
      value += pow(2, geneLength - 1 - i) * genotype[i];
    }
  }
  
  /*=====================================
    Print the genotype array and value.
    Used for debugging and development only
  ====================================*/
  void display() {
    println(genotype);
    println(value);
  }
}
