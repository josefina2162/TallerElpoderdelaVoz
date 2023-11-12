import oscP5.*;
import processing.video.*;

OscP5 oscP5;
Movie video1;
Movie videoDuda;
PImage imagen1;
float umbralSonido = 80.0;
float amplitudSonido;
int estado = 0; // 
int tiempoInicio;
int duracionImagen = 120000; //
void setup() {
  size(1920, 1080);

  
  oscP5 = new OscP5(this, 12345); 

  // Carga los videos
  video1 = new Movie(this, "1.mp4");
  videoDuda = new Movie(this, "duda.mp4");

  // Carga la imagen
  imagen1 = loadImage("1.jpeg");

  video1.loop();

  // Inicializa el tiempo de inicio
  tiempoInicio = millis();
}

void draw() {
  background(0);

  // Verifica el estado actual 
  switch (estado) {
    case 0: // Video1
      if (amplitudSonido >= umbralSonido) {
        if (!video1.isPlaying()) {
          video1.play();
          videoDuda.pause();
        }
        image(video1, 0, 0, width, height);
      } else {
        if (!videoDuda.isPlaying()) {
          videoDuda.loop();
          video1.pause();
        }
        image(videoDuda, 0, 0, width, height);
      }

      // Verifica si el video1 ha terminado
      if (video1.time() == video1.duration()) {
        estado = 2; // Cambia al estado de la imagen
        tiempoInicio = millis(); 
      }
      break;

    case 1: // VideoDuda
      break;

    case 2: // Imagen1
      image(imagen1, 0, 0, width, height);

      
      if (millis() - tiempoInicio >= duracionImagen) {
        estado = 0; // Vuelve al primer estado después de 2 minutos
        //video1.play();
        //videoDuda.pause();
      }
      break;
  }

  println("amp:" + amplitudSonido);
}

void oscEvent(OscMessage m) {
  if (m.addrPattern().equals("/amp")) {
    amplitudSonido = m.get(0).floatValue();
  }
}


void movieEvent(Movie video) {
  video.read();
}
