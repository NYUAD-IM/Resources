int numVerts = 40;
float lineWidth = 4;

//Nice colour scheme:
color purple = #57068b;
color orange = #5337b9;
color blue   = #a40063;
color white  = #6f09b0;
color mainCol= #57068b;
color text   = #23241e;

PVector[] controlPoints = new PVector[7];
PVector[] fixedPoints = new PVector[7];
PVector[] noisePoints = new PVector[7];

boolean isIM = true; //Should font lines be on?



void setup(){
  smooth();
  size(500 ,500);
  
  //Original control points. Essentially IM in square font.
  controlPoints[0] = new PVector(width/4, height/3);
  controlPoints[1] = new PVector(width/2, height/3);
  controlPoints[2] = new PVector(3*width/4, height/3);
  controlPoints[3] = new PVector(width/2+width/8, height/2);
  controlPoints[4] = new PVector(width/4, 2*height/3);
  controlPoints[5] = new PVector(width/2, 2*height/3);
  controlPoints[6] = new PVector(3*width/4, 2*height/3);
  
  for(int i = 0; i < noisePoints.length; i++){
    fixedPoints[i] = new PVector(controlPoints[i].x, controlPoints[i].y);
  }
  for(int i = 0; i < noisePoints.length; i++){
    noisePoints[i] = new PVector(random(0,100), random(0,100));
  }

  frameRate(20);
}

void draw(){
  
  background(255);
  strokeWeight(1);

  connectingLines();
  
  randomisePoints();
  
  if(isIM){
    fontLines();
  }

}

void vertLines(){
  strokeWeight(1);
  for(int i = 0; i < numVerts; i++){
    if(random(1) < 0.33){
      stroke(orange);
    }else if(random(1) < 0.66){
      stroke(white);
    }else{
      stroke(blue);
    }
    float posX = width/numVerts*i;
    line(posX, 0, posX, height);
  }
}
void logoLines(){
  float halfW = width/2;
  float quarterW = width/4;
  
  strokeWeight(1);
  stroke(255);
  
  //M
  line(quarterW,0,quarterW,height);
  line(halfW,0,halfW,height);
  line(3*quarterW,0,3*quarterW,height);
  
  line(halfW, height/3, halfW + quarterW/2, height/2);
  line(3*quarterW, height/3, halfW + quarterW/2, height/2);

  //I
  line(0, height/3, width, height/3);
  line(0, 2*height/3, width, 2*height/3);
}

void fontLines(){
  
  stroke(mainCol);
  strokeWeight(lineWidth);
  //IM Letter Lines
  line(controlPoints[0].x, controlPoints[0].y, controlPoints[4].x, controlPoints[4].y);
  line(controlPoints[1].x, controlPoints[1].y, controlPoints[5].x, controlPoints[5].y);
  line(controlPoints[2].x, controlPoints[2].y, controlPoints[6].x, controlPoints[6].y);
  line(controlPoints[1].x, controlPoints[1].y, controlPoints[3].x, controlPoints[3].y);
  line(controlPoints[2].x, controlPoints[2].y, controlPoints[3].x, controlPoints[3].y);

}

void connectingLines(){
  float alpha = 100;
  
  //Some best-guessed aesthetics for internal connecting lines
  for(int i = 0; i < controlPoints.length; i++){
    for (int j = 0; j < controlPoints.length; j++){
      if(j!=i && !(i == 0 && j == 2) && !(i == 2 && j == 0) && !(i == 4 && j == 6) && 
          !(i == 6 && j == 4) && !(i == 1 && j == 6)  && !(i == 2 && j == 5)
          && !(i == 6 && j == 1)  && !(i == 5 && j == 2)){
        if(i%3==0){
          stroke(orange);
        }else if(i%3==1){
          stroke(purple);
        }else{
          stroke(blue);
        }
        strokeWeight(0.2);
        if(i % 2 == 0);
        line(controlPoints[i].x, controlPoints[i].y, controlPoints[j].x, controlPoints[j].y);
      }
    }
    
    //Connect to edges
    if(i%3==0){
      stroke(color(red(orange), green(orange), blue(orange), alpha));
    }else if(i%3==1){
      stroke(color(red(purple), green(purple), blue(purple), alpha));
    }else{
      stroke(color(red(blue), green(blue), blue(blue), alpha));
    }
    
    strokeWeight(0.1);
    if(i%2 == 0 ){
      line(controlPoints[i].x, controlPoints[i].y, 0,0);
      line(controlPoints[i].x, controlPoints[i].y, 0, height);
    }else{
      line(controlPoints[i].x, controlPoints[i].y, width, 0);
      line(controlPoints[i].x, controlPoints[i].y, width, height);
    }
  }
  
  
  
}

void randomisePoints(){
  for(int i = 0; i < controlPoints.length; i++){
    
    controlPoints[i].x = fixedPoints[i].x + noise(noisePoints[i].x) * width/6-width/12;
    controlPoints[i].y = fixedPoints[i].y + noise(noisePoints[i].y) * width/6-width/12;
    
    noisePoints[i].x += 0.01;
    noisePoints[i].y += 0.01;
  }
}




void keyReleased(){
  //Some vague control systems thrown together:
  if(key=='s'){
    saveFrame("imLogo_######.png");
  }
  if(key=='l'){
    isIM = !isIM;
  }
  
  if(key == 'a'){
    noLoop();
  }
  
}

PVector pointOnALine(PVector firstPoint, PVector secondPoint, float distance){
  // P = d(B - A) + A
  return PVector.sub(secondPoint,firstPoint).mult(distance).add(firstPoint);
}