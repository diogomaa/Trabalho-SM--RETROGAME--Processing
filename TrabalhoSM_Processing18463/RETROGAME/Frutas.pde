public class Frutas
{
  int posfrutaX, posfrutaY;

  float veloBalaY;
  
  int rectW, rectH;
  
  int tipo;
  
  PImage tir1 = loadImage("tiro1.png");
  PImage tir2 = loadImage("tiro2.png");
  PImage tir3 = loadImage("tiro3.png");
  PImage tir4 = loadImage("tiro4.png");
  PImage tir5 = loadImage("tiro5.png");
  PImage tir6 = loadImage("tiro6.png");
  PImage tir7 = loadImage("tiro7.png");
  PImage tir8 = loadImage("tiro8.png");
  PImage tir9 = loadImage("tiro9.png");
  
  Frutas(int x, int y, float vel, int t)
  {
    posfrutaX = x;
    posfrutaY = y;
    
    rectW = 10;
    rectH = 20;
    
    veloBalaY = vel;
    
    tipo = t;
  }
  
  void moveBala()
  {
    posfrutaY -= veloBalaY;
    
    imageMode(CENTER);
    if(tipo == 1)
      {
        image(tir1, posfrutaX, posfrutaY, rectW, rectH);
      }
      if(tipo == 2)
      {
        image(tir2, posfrutaX, posfrutaY, rectW, rectH);
      }
      if(tipo == 3)
      {
        image(tir3, posfrutaX, posfrutaY, rectW, rectH);
      }
      if(tipo == 4)
      {
        image(tir4, posfrutaX, posfrutaY, rectW, rectH);
      }
        if(tipo == 5)
    {
        image(tir5, posfrutaX, posfrutaY, rectW, rectH);
      }
        if(tipo == 6)
      {
        image(tir6, posfrutaX, posfrutaY, rectW, rectH);
      }
        if(tipo == 7)
      {
        image(tir7, posfrutaX, posfrutaY, rectW, rectH);
      }
        if(tipo == 8)
      {
        image(tir8, posfrutaX, posfrutaY, rectW, rectH);
      }
        if(tipo == 9)
      {
        image(tir9, posfrutaX, posfrutaY, rectW, rectH);
      }
    
    imageMode(CORNER);
    
    if(posfrutaY < 0)
    {
      removeMe(this);
    }
  }

}
