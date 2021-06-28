public class ECGM
{
  float x, y;
  
  float veloc;
  
  int diam = 30;
  
  int w;
  
  PImage logo = loadImage("ecgm.png");
  
  ECGM(float posx, float posy, float v)
  {
    x = posx;
    y = posy;
    
    w = 30;
    veloc = v;
  }
  
  void moveEcgm()
  {
    y += veloc;
    
    imageMode(CENTER);
    image(logo, x, y, w, w);
    imageMode(CORNER);
  }
}
