import processing.sound.SoundFile;
import java.util.ArrayList;
import java.util.HashMap;

final int loopDuration = 8 * 60;

public class Note {
  private PVector position;
  private float noteWidth, noteHeight;
  private SoundFile sound;

  private int prevMillis = 0;

  public Note(int index, char wb) {
    this.noteWidth = width / 15;
    this.noteHeight = 220;

    this.position = new PVector(index * this.noteWidth, height - this.noteHeight);
    this.sound = new SoundFile(processing_code.this, "sounds/" + wb + index + ".mp3");
  }

  public void play() {
    this.sound.play();
  }

  public void playNote() {
    int delayed = millis() - this.prevMillis;
    if (mousePressed && delayed > 250) {
      if (abs(this.position.x + this.noteWidth / 2 - mouseX) < (this.noteWidth / 2) && abs(this.position.y + this.noteHeight / 2 - mouseY) < (this.noteHeight / 2)) {
        if (loopStation.recording) {
          loopStation.add(this.sound);
        } else {
          this.play();
        }
        this.prevMillis = millis();
      }
    }
  }

  public void display() {
    fill(255);
    strokeWeight(1);
    stroke(200);
    rect(this.position.x, this.position.y, this.position.x + this.noteWidth, this.position.y + this.noteHeight);

    this.playNote();
  }
}

public class LoopStation {
  public boolean recording;
  public ArrayList<ArrayList<HashMap<String, Object>>> loops;

  public LoopStation() {
    this.recording = false;
    this.loops = new ArrayList<ArrayList<HashMap<String, Object>>>();
  }

  public void record() {
    this.loops.add(new ArrayList<HashMap<String, Object>>());
    this.recording = true;
  }

  public void add(SoundFile sound) {
    HashMap<String, Object> data = new HashMap<String, Object>();
    data.put("sound", sound);
    data.put("timestamp", float(frameCount % loopDuration));
    this.loops.get(this.loops.size() - 1).add(data);
  }

  public void playAll() {
    for (ArrayList<HashMap<String, Object>> loop : this.loops) {
      for (HashMap<String, Object> data : loop) {
        if (float(frameCount % loopDuration) == (float) data.get("timestamp")) {
          ((SoundFile) data.get("sound")).play();
        }
      }
    }
  }
}

public class Midi {
  private Note[] whiteNotes;
  public Midi() {
    this.whiteNotes = new Note[15];

    for (int i = 0; i < this.whiteNotes.length; i++) {
      this.whiteNotes[i] = new Note(i, 'w');
    }
  }

  public void display() {
    background(48);
    for (Note note : this.whiteNotes) {
      note.display();
    }

    fill(97, 194, 242);
    noStroke();
    println(frameCount);
    ellipse(map(frameCount % loopDuration, 0, loopDuration, 0, width), height - 220 - 40, 15, 15);
  }
}

Midi midi;
LoopStation loopStation;

void setup() {
  frameRate(60);
  size(1000, 600);
  midi = new Midi();
  loopStation = new LoopStation();
}

void draw() {
  midi.display();
  loopStation.playAll();
}


void keyPressed() {
  if (key == 'r') {
    loopStation.record();
  }
}
