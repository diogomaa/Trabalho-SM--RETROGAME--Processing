public class Inimigos
{
  int x, y;
  
  float veloc;
  
  int diam = 35;
  
  float w, h;
  
  int tipo;
  
  PImage inimigo1 = loadImage("ini1.png");
  PImage inimigo2 = loadImage("ini2.png");
  PImage inimigo3 = loadImage("ini3.png");
  PImage inimigo4 = loadImage("ini4.png");
  PImage inimigo5 = loadImage("ini5.png");
  
  Inimigos(int posx, int posy, float v, int t)
  {
    x = posx;
    y = posy;
    
    w = 30;
    h=40;
    
    veloc = v;
    
    tipo = t;
  }
  
  void moveIni()
  {
    y += veloc;
    
      imageMode(CENTER);
      if(tipo == 1)
      {
        image(inimigo1, x, y, w, h);
      }
      if(tipo == 2)
      {
        image(inimigo2, x, y, w, h);
      }
      if(tipo == 3)
      {
        image(inimigo3, x, y, w, h);
      }
      if(tipo == 4)
      {
        image(inimigo4, x, y, w, h);
      }
      if(tipo == 5)
      {
        image(inimigo5, x, y, w, h);
      }
      
      imageMode(CORNER);
  }
}
