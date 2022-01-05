import processing.sound.*;

// Declare the sound source and FFT analyzer variables
SoundFile sample;
//AudioIn sample;
Amplitude rms;
FFT fft;
BeatDetector beatDetector;

// Define how many FFT bands to use (this needs to be a power of two)
int bands = 32;

int r, g, b;

// Define a smoothing factor which determines how much the spectrums of consecutive
// points in time should be combined to create a smoother visualisation of the spectrum.
// A smoothing factor of 1.0 means no smoothing (only the data from the newest analysis
// is rendered), decrease the factor down towards 0.0 to have the visualisation update
// more slowly, which is easier on the eye.
float smoothingFactor = 0.1;
float rmsSmoothingFactor = 0.01;

// Create a vector to store the smoothed spectrum data in
float[] sum = new float[bands];
float rmsSum;

// Variables for drawing the spectrum:
// Declare a scaling factor for adjusting the height of the rectangles
int scale = 1;

boolean wasBeat;

color orange = #FFA500;
color blue = #18CAE6;

public void setup() {
  fullScreen();
  //size(1000, 1000);
  frameRate(60);
  background(0);

  // Load and play a soundfile and loop it.
  // sample = new SoundFile(this, "apricots.mp3");
  sample = new SoundFile(this, "lone-digger.mp3");
  //sample = new SoundFile(this, "time-space.mp3");
  //sample = new SoundFile(this, "tokyo-drifting.mp3");
  //sample = new SoundFile(this, "higher-ground.mp3");
  println(sample.channels());
  sample.play();
    
    // Or, use an audio input as the source.
    //sample = new AudioIn(this, 0);
    //sample.start();

    // Create the FFT analyzer and connect the playing soundfile to it.
    fft = new FFT(this, bands);
    fft.input(sample);
    rms = new Amplitude(this);
    rms.input(sample);
    beatDetector = new BeatDetector(this);
    beatDetector.input(sample);
    beatDetector.sensitivity(250);
    wasBeat = false;
}

public void draw() {
  // Set background color, noStroke and fill color
  boolean isBeat = beatDetector.isBeat();
  if (isBeat && !wasBeat) {
    r = (int)random(0, 255);
    g = (int)random(0, 255);
    b = (int)random(0, 255);
  }
  wasBeat = isBeat;
  //background(r, g, b);
  background(0);
  noStroke();

  // Perform the analysis
  fft.analyze();

  rmsSum += (rms.analyze() - rmsSum) * rmsSmoothingFactor;
  drawSpectrumShape(12, 300, 100, "interiorMountains", blue);
  drawSpectrumShape(12, 350, 200, "exteriorValleys", blue);
  drawSpectrumShape(6, 75, 100, "exteriorValleys", orange);
}

public void drawSpectrumShape(int sides, float radius, float protrusion, String vizType, color fillColor) {
  float sideLength = 2 * radius * sin(radians(180/sides));
  float interiorAngle = radians(360/sides);
  pushMatrix();
  translate(width/2, height/2);
  translate(0, -radius);
  rotate(radians((360/sides)/2));
  for (int i = 0; i < sides; i++) {
    pushMatrix();
    renderSpectrum(0, 0, sideLength, protrusion, vizType, fillColor);
    //renderSpectrum(0, 0, sideLength, protrusion, vizType);
    translate(sideLength, 0);
    rotate(interiorAngle);
  }
  for (int i = 0; i < sides; i++) {
    popMatrix();
  }
  popMatrix();
}

public void renderSpectrum(float x, float y, float frameWidth, float frameHeight, String type, color fillColor) {
  float barWidth = (frameWidth/float(bands))/2;
  float middle = frameWidth/2;
  //fill(255*rmsSum, 0, 150*rmsSum);
  fill(fillColor);
  if (type == "exteriorBars") {
    for (int i = 0; i < bands; i++) {
      sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;
      rect(x+middle+(i*barWidth), y, barWidth, -sum[i]*frameHeight*scale);
      rect(x+middle-((i+1)*barWidth), y, barWidth, -sum[i]*frameHeight*scale);
    }
  }
  if (type == "exteriorMountains") {
    FloatList mountainPeaks = getMountainValues();
    for (int i = 0; i < mountainPeaks.size()-1; i++) {
      quad(i*barWidth, 0, i*barWidth, -mountainPeaks.get(i)*frameHeight*scale, (i+1)*barWidth, -mountainPeaks.get(i+1)*frameHeight*scale, (i+1)*barWidth, 0);
    }
  }
  if (type == "exteriorValleys") {
    FloatList valleyValues = getValleyValues();
      for (int i = 0; i < valleyValues.size()-1; i++) {
        quad(i*barWidth, 0, i*barWidth, -valleyValues.get(i)*frameHeight*scale, (i+1)*barWidth, -valleyValues.get(i+1)*frameHeight*scale, (i+1)*barWidth, 0);
      }
  }
  if (type == "interiorMountains") {
    FloatList mountainPeaks = getMountainValues();
    for (int i = 0; i < mountainPeaks.size()-1; i++) {
      quad(i*barWidth, 0, i*barWidth, mountainPeaks.get(i)*frameHeight*scale, (i+1)*barWidth, mountainPeaks.get(i+1)*frameHeight*scale, (i+1)*barWidth, 0);
    }
  }
}

public FloatList getValleyValues() {
  FloatList valleyPeaks = new FloatList(0.0);
  for (int i = 0; i < bands; i++) {
    sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;
    valleyPeaks.append(sum[i]);
  }
  for (int i = bands -2; i >= 0; i--) {
    valleyPeaks.append(sum[i]);
  }
  valleyPeaks.append(0.0);
  return valleyPeaks;
}

public FloatList getMountainValues() {
  FloatList mountainPeaks = new FloatList(0.0);
  for (int i = bands - 1; i >= 0; i--) {
    sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;
    mountainPeaks.append(sum[i]);
  }
  for (int i = 1; i < bands; i++) {
    mountainPeaks.append(sum[i]);
  }
  mountainPeaks.append(0.0);
  return mountainPeaks;
}