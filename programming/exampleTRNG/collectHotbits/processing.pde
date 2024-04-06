import processing.serial.*;

Serial serialPort;
ArrayList<Integer> receivedIntegers = new ArrayList<Integer>();
ArrayList<Integer> tenThousandIntegers = new ArrayList<Integer>();
int packageN = 1;
int firstNumbers = 20;

void setup() {
  size(400, 300);
  String portName = "COM3";
  serialPort = new Serial(this, portName, 9600);
}

void draw() {
  
  Integer receivedInteger = 0;
  
  while (serialPort.available() > 0) {
    String data = serialPort.readStringUntil('\n');
    if (data != null) {
      data = trim(data); // Remove whitespace characters
      if (!data.isEmpty()) {
        
        if (firstNumbers > 0) {
          firstNumbers--;
          continue;
        }
        
        try {
          receivedInteger = Integer.parseInt(data);
          if (!tenThousandIntegers.contains(receivedInteger)) {
            receivedIntegers.add(receivedInteger);
            tenThousandIntegers.add(receivedInteger);
          }
          if (receivedIntegers.size() >= 1000) {
            saveIntegersToFile(packageN++);
            receivedIntegers.clear();
          }
          if (tenThousandIntegers.size() >= 10000) {
            tenThousandIntegers.remove(0);
          }
          
        } catch (NumberFormatException e) {
          println("Error parsing integer: " + data);
        }
      }
    }
  }
  
  // Display received integers
  background(255);
  textAlign(CENTER, CENTER);
  textSize(16);
  fill(0);
  text("Received Integers:", width/2, 20);
  text(receivedIntegers.size(), width/2, 70);
  
}

void saveIntegersToFile(int packageNumber) {
  // Create a new file in the sketch's data folder
  String[] lines = new String[receivedIntegers.size()];
  for (int i = 0; i < receivedIntegers.size(); i++) {
    lines[i] = String.valueOf(receivedIntegers.get(i));
  }
  saveStrings("hotbits/package" + packageNumber + ".txt", lines);
  println("Saved received integers to file: hotbits/package" + packageNumber + ".txt");
}
