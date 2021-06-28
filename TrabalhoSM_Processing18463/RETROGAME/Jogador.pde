public class Jogador
{
  float x, y;
  
  int w, h;
  
  PImage play = loadImage("player.png");
  
 Jogador(float x1, float y1, int w1, int h1)
 {
   x = x1;
   y = y1;
   w = w1;
   h = h1;
 }
 
 void imprime()
 {
   imageMode(CENTER);
   image(play, x, y, w, h);
   imageMode(CORNER);
 }
  
}
 
 
 
