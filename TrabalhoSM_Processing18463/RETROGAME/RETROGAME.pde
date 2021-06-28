import processing.sound.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import processing.video.*;

Capture video; // armazena captura do video

AudioIn inputAudio; //recolhe o som do microfone
Amplitude aAmplitude; //  amlpitude do som recolhido 

PImage prevFrame; //guarda o frame anterior compara com o frame atual

float threshold = 50; //limite para o qual se deve armazenar a posição dos pixeis para saber se há movimento

PImage ecgm; 
PImage frut1;
PImage frut2;
PImage frut3;
PImage frut4;
PImage frut5;
PImage frut6;
PImage frut7;
PImage frut8;
PImage frut9;
PImage fundo;

int moveX = 0; // soma das posições dos pixeis
int mediaMove = 0; // pixeis armazenados  posição media
int posX; 
int mexePixels = 5; //velocidade player 
float posPlayerX; 
float posPlayerY; 


Jogador player;
ArrayList<Frutas> frut = new ArrayList<Frutas>(); //Array que armazena as fruta
ArrayList<Inimigos> inimigo = new ArrayList<Inimigos>(); //Array que armazena os inimigos
ArrayList<ECGM> coleciona = new ArrayList<ECGM>(); //Array que armazena os logos

int tiposfrut;
int tiposIni,stage;
//criação de cada inimigo, logo e frutas
int time = 0;  
int time2 = 0;
int time3 = 0;

int vidas = 7; //vidas player 
int score = 0; //pontuação player

boolean gameOver = false; 

PFont f; //fonte de texto

Minim minim;
Minim minim3;
Minim minim4;

AudioPlayer somFundo, somMissil, somItem;

void setup()
{
  stage = 0;
  size(640, 480);
  
  video = new Capture(this, 640, 480, 30);
  video.start();
  
 
  prevFrame = createImage(video.width, video.height, RGB);
  
 
  posX = width/2;
  

  inputAudio = new AudioIn(this, 0);

 
  inputAudio.start();

 
  aAmplitude = new Amplitude(this);

  
  aAmplitude.input(inputAudio);
  
  frut1 = loadImage("tiro1.png");
  frut2 = loadImage("tiro2.png");
  frut3 = loadImage("tiro3.png");
  frut4 = loadImage("tiro4.png");
  frut5 = loadImage("tiro5.png");
  frut6 = loadImage("tiro6.png");
  frut7 = loadImage("tiro7.png");
  frut8 = loadImage("tiro8.png");
  frut9 = loadImage("tiro9.png");
  
  fundo = loadImage("293.png");
  
  f = loadFont("font.vlw");
  
  tiposfrut = criaTipo();
  tiposIni = criaTipo();
  carregaSons();
  somFundo.loop();
  
}

void draw()
{
 if (stage == 0) {
    
    PImage menuback = loadImage("11891.png");
    background(menuback);
    fill(224, 166, 49);
    textAlign(CENTER);
    textSize(18);
    text("Bem vindo ao Retro Game! Pressione qualquer tecla para continuar!", width/2 + 5, height/2 + 150  );

    fill(224, 166, 49);
    textAlign(CENTER);
    text("Tente eleminar os enimigos e colectar os logos de ECGM!", width/2 + 10, height/2 + 190  );
    if (keyPressed == true) {
      stage = 1;
    }
  }
 
  
  if( (stage == 1) &&(!gameOver))
  {
   
    loadPixels();//carrega os pixeis todos
    video.loadPixels();//carrega os pixeis da captura de video
    prevFrame.loadPixels();//carrega os pixeis da imagem armazenada
    
    
    moveX = 0;
    mediaMove = 0;
    
    //algoritmo responsável pela deteção de movimento da captura de vídeo
    for(int x = 0; x < video.width; x++)  {
      for(int y = 0; y < video.height; y++)    {
        int loc = x + y * video.width; //indice de cada pixel        
        //--inverter a imagem na horizontal
        int loc2 = (video.width - x - 1) + y * video.width;        
        pixels[loc2] = video.pixels[loc];        
        color current = video.pixels[loc];//vai buscar o pixel da captura de video que está na posição loc
        color previous = prevFrame.pixels[loc];//vai buscar o pixel da imagem armazenada que está na posição loc
        //armazena a cor de cada pixel
        float r1 = red(current);
        float g1 = green(current);
        float b1 = blue(current);
        float r2 = red(previous);
        float g2 = green(previous);
        float b2 = blue(previous);
        float diff = dist(r1, g1, b1, r2, g2, b2);//faz a diferença de cor entre um pixel e outro
        
        if(diff > threshold)   {
          moveX += x;
          mediaMove++;  } } }  
    updatePixels();//recarrega todos os pixeis da imagem
    if(mediaMove != 0)//faz a posição média dos pixeis guardados
    {
      moveX = moveX / mediaMove;
    }
     
    if(moveX > posX + mexePixels / 2)
    {
      posX += mexePixels;
    }
    else if(moveX < posX - mexePixels / 2)
    {
      posX -= mexePixels;
    }
    
    posPlayerX = width - posX;
    posPlayerY = height - 50;
    
    player = new Jogador(posPlayerX, posPlayerY, 40, 50);
    
    
    image(fundo, 150, 0, width - 150, height);
    
    
    tiposIni = criaTipo();
    
    iniciaIni();
    
    iniciaEcgm();
    
    //move todas as frut
    for(int i=0; i<frut.size();i++)
    {
      Frutas b = frut.get(i);
      b.moveBala();
    }
    
    
    float volume = aAmplitude.analyze();//regista a amplitude do som captado
    float limite = 0.1;
    
    // amplitude maior limite cria uma fruta
    if(volume > limite && millis() > time + 500)
    {
      Frutas bal = new Frutas(int(posPlayerX), int(posPlayerY), 8, tiposfrut);
      frut.add(bal);
      tiposfrut = criaTipo();
      somMissil.play(0);
      time = millis();
    }
    
    //move os inimigos
    for(int j=0; j<inimigo.size(); j++)
    {
      Inimigos i = inimigo.get(j);
      i.moveIni();
      if(frut.size() > 0)
      {
        //colisão fruta inimigo, elimina
        for(int k = 0; k < frut.size(); k++)
        {
          Frutas b = frut.get(k);
          if(rectRect(b.posfrutaX, b.posfrutaY, b.rectW, b.rectH, i.x, i.y, int(i.w), int(i.h)) )
          {
            inimigo.remove(j);
            frut.remove(k);
            
            break;
          }
        }
      }
    }
    
    //move os itens colecionáveis
    for(int a = 0; a < coleciona.size(); a++)
    {
      ECGM e = coleciona.get(a);
      e.moveEcgm();
    }
    
    //retira vida quando um inimigo chega ao fim
    for(int i = 0; i < inimigo.size(); i++)
    {
      Inimigos ini = inimigo.get(i);
      
      if(ini.y > height)
      {
        vidas = vidas - 1;
        inimigo.remove(ini);
       
      }
    }
    
    //aumenta a pontuação LOGOS fim 
    for(int a = 0; a < coleciona.size(); a++)
    {
      ECGM e = coleciona.get(a);
      if(rectRect(int(player.x), int(player.y), player.w, player.h, int(e.x), int(e.y), e.w, e.w))
      {
        score++;
        coleciona.remove(e);
        somItem.play(0);
      }
    }
    
    
    if(vidas == 0)
    {
      gameOver = true;
      stage = 2;
      
    }
    
    player.imprime();
    
    fill(30,42,119);
    rect(0, 0, 150, height);
    
    desenhaTexto();
    
    if(tiposfrut == 1)
    {
      image(frut1, 50, 200, 50, 100);
    }
    else if(tiposfrut == 2)
    {
      image(frut2, 50, 200, 50, 100);
    }
    else if(tiposfrut == 3)
    {
      image(frut3, 50, 200, 50, 100);
    }
    else if(tiposfrut == 4)
    {
      image(frut4, 50, 200, 50, 100);
    }
    else if(tiposfrut == 5)
    {
      image(frut5, 50, 200, 50, 100);
    }
    else if(tiposfrut == 6)
    {
      image(frut6, 50, 200, 50, 100);
    }
    else if(tiposfrut == 7)
    {
      image(frut7, 50, 200, 50, 100);
    }
    else if(tiposfrut == 8)
    {
      image(frut8, 50, 200, 50, 100);
    }
    else if(tiposfrut == 9)
    {
      image(frut9, 50, 200, 50, 100);
    }
   
    pushMatrix(); 
    scale(-1,1); 
    image(video.get(), -150, 0, 150, 100);
    popMatrix(); 

    
  }
  if (stage == 2) //GAME OVER
  {
    clear();
    PImage fim = loadImage("fim.png");
    background(fim);
    fill(224, 166, 49);
    textAlign(CENTER);
    textSize(20);
    
    text("Ohhh,Perdeu! Tente novamente!", width/2, height/2);
   
    text("Pontuação: ", width/2 - 10, (height/2) + 30);
   
    text(score, width/2 + 50, (height/2) + 30);
    
    text("Pressione qualquer tecla para voltar ao Jogo!", width/2, height/2 + 60);
  if (keyPressed == true) {
    eliminaTudo(); //mini-bug
      stage = 1;
    }
    
  }
  
}

int criaTipo()
{
  int t;
  t = int(random(1,10));
  return t;
}

//Evento que é iniciado sempre que uma nova frame entra
void captureEvent(Capture video)
{
  //--gravar a frame anterior para depois detetar o movimento
  //--antes de ler o novo frame, gravamos o anterior
  //--para podermos comparar
  prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
  prevFrame.updatePixels();
  
  //--ler a nova frame da câmara
  video.read();
}

//desenha texto jogo
void desenhaTexto()
{
  textFont(f, 16);
  fill(224, 166, 49);
  text("Vidas: ", width - 70, 20);
  text(vidas, width - 20, 20);
  text("Pontuação: ", width - 90, 40);
  text(score, width - 20, 40);
  fill(224, 166, 49);
  text("Diogo Amorim ", 60, height - 50);
  text("Nrº16463 ", 43, height - 30);
  fill(224, 166, 49);
  text("ECGM", 30, height - 10);
  text("Fruta: ", 30, height - 217);
}


//remove as balas/frutas que saem do ecrã
void removeMe(Frutas b)
{
  frut.remove(b);
  b = null;
}

//cria os inimigos 
void iniciaIni()
{
  if(millis() > time + 1000)
  {
    Inimigos i = new Inimigos(int(random(180, 610)), 0, 2, tiposIni);
    inimigo.add(i);
    time = millis();
  }
}

//cria os logos 
void iniciaEcgm()
{
  if(millis() > time2 + 2000)
  {
    ECGM e = new ECGM(random(180, 610), 0, 4);
    coleciona.add(e);
    time2 = millis();
  }
}

void keyPressed()
{
  //Quando o jogador perder, ao carregar num tecla qualquer, reinicia o jogo
  if(gameOver)
  {
    textAlign(LEFT);
    vidas = 7;
    score = 0;
    eliminaTudo();
    gameOver = false;
  }
}

//elimina todos os inimigos e logos
void eliminaTudo()
{
  for(int i = 0; i < inimigo.size(); i++)
  {
    Inimigos ini = inimigo.get(i);
    inimigo.remove(ini);
  }
  for(int j = 0; j < coleciona.size(); j++)
  {
    ECGM e = coleciona.get(j);
    coleciona.remove(e);
  }
}


//  sons usados no jogo
void carregaSons()
{
  minim = new Minim(this);
  somFundo = minim.loadFile("pacman_beginning.wav");
  
  minim3 = new Minim(this);
  somMissil = minim.loadFile("pacman_eatghost.wav");
  
  minim4 = new Minim(this);
  somItem = minim.loadFile("pacman_eatfruit.wav");
}


//retorna verdadeiro se ouver colisão entre um fruta e um inimigo

boolean rectRect(int x1, int y1, int w1, int h1, int x2, int y2, int w2, int h2) {
  
 
  if (x1+w1/2 >= x2-w2/2 && x1-w1/2 <= x2+w2/2 && y1+h1/2 >= y2-h2/2 && y1-h1/2 <= y2+h2/2) {
    return true;    
  }
  else {            
    return false;
  }
}
