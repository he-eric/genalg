// Constants
int POPULATION_SIZE = 16;

//fun variables
//PImage img = loadImage("myface.png");
boolean face;

// Global variables
float x, y;
int SPACE = 10;
int selectedX;
int selectedY;
int bestX;
int bestY;
boolean continuous;
float totalFitness;
int speed; 
int generation;
float mutationRate = 0.05;

int GRID_RADIUS = 50; // radius of the grid; note, is one-half the grid width
int GRID_WIDTH = 2 * GRID_RADIUS;
int GRID_COUNT = ceil(sqrt(POPULATION_SIZE));
int WIDTH = GRID_COUNT * GRID_RADIUS; // window width

// The individuals
Individual[] population;
Individual selected;

/*=====================================
  Create an initial population of randomly
  generated individuals.
  Set up the basic window properties.
  ====================================*/
/*
  i            x          y
  0            100        100
  1            300        
  2            500
  3            700
  ___
  4                       300
  5
  6
  7
  ___
  8
*/

void setup() {
  size(GRID_COUNT*GRID_RADIUS*2+GRID_COUNT*SPACE, GRID_COUNT*GRID_RADIUS*2+GRID_COUNT*SPACE );
  population = new Individual[POPULATION_SIZE];
  /*
  for(int i=0; i<POPULATION_SIZE; i++) {
    float cx = GRID_RADIUS * (2 * (i % GRID_COUNT) + 1);
    float cy = GRID_RADIUS * (2 * (i / GRID_COUNT) + 1);
    population[i] = new Individual(cx, cy);
  }
  */
  populate();
  selected = population[(int)random(POPULATION_SIZE)];
  for (int i = 0; i < POPULATION_SIZE; i++) { //SET THE FITNESS OF EVERY INDIVIDUAL
    population[i].setFitness(selected);
  }
  setTotalFitness();
  //matingSeason();
}

/*=====================================
  Redraw every Individual in the population
  each frame. Make sure they are drawn in a grid without
  overlapping each other.
  If an individual has been selected (by the mouse), draw a box
  around it and draw a box around the individual with the
  highest fitness value.
  If mating mode is set to continuous, call mating season.
  ====================================*/
void draw() {
  background(255);
  //keyPressed();
  for(Individual i : population) {
    i.display();
    //i.printIndividual();
    //System.out.println("END");
  }
  if (selected != null) {
    noFill();
    rect(selected.phenotype.x - GRID_RADIUS, selected.phenotype.y - GRID_RADIUS, GRID_RADIUS*2, GRID_RADIUS*2);
  }
  if (face) {
    //image(img, 0, 0);
  }
  findBest();
  //mouseClicked();
  //mutate();
  if (continuous) {
    matingSeason();
  }
  test();
  }


/*=====================================
  When the mouse is clicked, set selected to
  the individual clicked on, and set 
  selectedX and selectedY so that a box can be
  drawn around it.
  ====================================*/
  
 
void mouseClicked() {
  int x = mouseX / (GRID_RADIUS*2 + SPACE );
  int y = mouseY / (GRID_RADIUS*2 + SPACE );
  int i = y*GRID_COUNT + x;
  selected = population[i];

}

/*====================================
  The following keys are mapped to actions:
  
  Right Arrow: move forward one generation
  Up Arrow:    speed up when in continuous mode
  Down Arrow:  slow down when in continuous mode
  Shift:  toggle continuous mode
  Space:  reset the population
  f: toggle fitness value display
  s: toggle smiley display
  m: increase mutation rate
  n: decrease mutation rate
  ==================================*/
void keyPressed() {
  if (key == 'a') {
   generation++;
   matingSeason();
  }
  if (keyCode == 38) {
    if (continuous) {
      speed++;
    }
  }
  if (keyCode == 40) {
    if (continuous) {
      speed--;
    }
  }
  if (keyCode == 16) {
    continuous = true;
  }
  if (key == ' ') {
    populate();
  }
  if (key == 'f') {
    //toggle fitness value display
  }
  if (keyPressed) {  //toggle smiley display
  face = true;
  }
  if (key == 'm') {
    mutationRate = mutationRate + 0.01;
  }
  if (key == 'n') {
    mutationRate = mutationRate - 0.01;
  }
  println(keyCode); // displays the integer value of the key pressed
}


/*====================================
  select will return a pseudorandom chromosome from the population
   Uses roulette wheel selection:
     A random number is generated between 0 and the total fitness .
     Go through the population and add each member's fitness until you exceed the random 
     number that was generated.
     Return the individual that the algorithm stopped on.
     Do not include the selected Blob as a possible return value.
  ==================================*/
Individual select() {
  int counter = 1;
  float addedSoFar = 0;
  float selectedFitness = random(totalFitness);
  while (selectedFitness > addedSoFar) {
     addedSoFar+=population[counter].fitness;
     if (counter < population.length-1) {
       System.out.println(counter);
       counter++;
     } 
  }
  return population[counter];
}

void test() {
  for (int i = 0; i < POPULATION_SIZE; i++) {
    System.out.println(population[i].fitness);
  }
    System.out.println("end");
}

/*====================================
  Replaces the current population with a totally new one by
  selecting pairs of Individuals and mating them.
  Make sure that totalFitness is set before you use select().
  The goal shape (selected) should always be the first Individual
  in the population, unmodified.
  ==================================*/
void matingSeason() {
  setTotalFitness();
  int x = 0;
  int y = 0;
  Individual[] newPopulation = new Individual[POPULATION_SIZE];
  int counter = 0;
  int len = ceil(sqrt(POPULATION_SIZE));
  int wid = ceil(sqrt(POPULATION_SIZE));
  for(int i = 0; i < len; i++) {
    for(int j = 0; j < wid; j++) {
      if (i == 0 && j == 0) {
        newPopulation[0] = selected;
      }
      else { 
        if (counter < POPULATION_SIZE) {
          Individual one = select();
          Individual two = select();
          newPopulation[j+i*wid] = one.mate(two, x+GRID_RADIUS, y+GRID_RADIUS);
          //There will be 10 pixels between each Individual
          x+=GRID_RADIUS*2+SPACE;
          counter++;
        }
      }
    }
    x=0;
    y+=GRID_RADIUS*2+SPACE;
  }
  mutate();
  for (int i = 0; i < POPULATION_SIZE; i++) {
    population[i] = newPopulation[i];
  }
}

/*====================================
  Randomly call the mutate method on an Individual (or Individuals)
  in the population.
  ==================================*/
void mutate() {
  for(Individual i : population) {
    if(int(random(100))<=mutationRate*100) {
      i.mutate();
    }
  }
}

/*====================================
  Set the totalFitness to the sum of the fitness values
  of each individual.
  Make sure that each individual has an accurate fitness value.
  ==================================*/
void setTotalFitness() {
  for(int i = 0; i<POPULATION_SIZE; i++) {
    totalFitness += population[i].fitness;
  }
}

/*====================================
  Fill the population with randomly generated Individuals.
  Make sure to set the location of each individual such that
  they display nicely in a grid.
  ==================================*/
void populate() {
  x = y = 0;
  int counter = 0;
  int len = ceil(sqrt(POPULATION_SIZE));
  int wid = ceil(sqrt(POPULATION_SIZE));
  for(int i = 0; i < len; i++) {
    for(int j = 0; j < wid; j++) {
      if (counter < POPULATION_SIZE) {
        Individual a = new Individual(x+GRID_RADIUS, y+GRID_RADIUS);
        population[j+i*wid] = a;
        //There will be 10 pixels between each Individual
        x+=GRID_RADIUS*2+SPACE;
        counter++;
      }
    }
    x=0;
    y+=GRID_RADIUS*2+SPACE;
  }
}

/*====================================
  Go through the population and find the Individual with the 
  highest fitness value.
  Set bestX and bestY so that the best Individual can have a 
  square border drawn around it.
  ==================================*/
void findBest() {
  bestX = bestY = 0;
  float bestFitness = 0;
  for(Individual i : population) {
    if(i.fitness > bestFitness) {
        //System.out.println("true"); TEST
        bestX = int(i.phenotype.x - 50);
        bestY = int(i.phenotype.y - 50);
    }
  }
  noFill();
  rect(bestX, bestY, GRID_RADIUS*2, GRID_RADIUS*2);
}  


