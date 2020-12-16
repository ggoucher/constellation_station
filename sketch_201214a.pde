
//Creating a star class, so that we can access future information and create connections
//between our constellations.
//Class adapted form processing quickstart
class Star {
  //star positioning
  public float x;
  public float y;
  
  //star size
  private float size;
  
  //star coloring 
  private float starGreen;
  private float starBlue;
  
  //star constellation collector
  public ArrayList<ArrayList> lines;
  
  //Storing canvas reference
  private PApplet canvas;
  
  Star(PApplet canvas, float x, float y) {
     //constructor
     this.canvas = canvas;
     
     //storing canvas reference
     this.x = x;
     this.y = y;

     //randomizing star ellipse size
     this.size = this.canvas.random(20,40);
     
     //radomizing color along lines of normal star colors, we don't want red stars, I don't find them relaxing!
     this.starGreen = this.canvas.random(100, 255);
     this.starBlue = this.canvas.random(100, 255);
     
     //initializing floatlist
     this.lines = new ArrayList<ArrayList>();
  }
  
  //adds a constellation line
  void add_line(float x1, float y1, float x2, float y2) {
      
    ArrayList<Float> ourPoints = new ArrayList<Float>();
    ourPoints.add(x1);
    ourPoints.add(y1);
    ourPoints.add(x2);
    ourPoints.add(y2);
    
    this.lines.add(ourPoints);
    
  }
  
  //removes a constellation line
  void remove_line(int index) {
      
    this.lines.remove(index);
  }
  
  //This method displays our stars!
  void display() {
    // This method specifies that the star will have no outline
    this.canvas.noStroke();

    // Specifies the fill for the star.
    this.canvas.fill(0, starGreen, starBlue);

    // Draws an ellipse on the screen to represent our star.
    this.canvas.ellipse(x, y, size, size);
  }
  
  //This method  displays our constellation lines
  void display_lines() {
    
    //This method allows us to display the lines we have beneath our stars.
    for (int i = 0; i < this.lines.size(); i++) {
      
      ArrayList<Float> lineToDraw = this.lines.get(i);
      
      stroke(255);
      //simply creates a line from our float array list
      this.canvas.line(lineToDraw.get(0), lineToDraw.get(1), lineToDraw.get(2), lineToDraw.get(3));
    }
  }
}

// Create an array of stars.
Star [] Stars = new Star[100];

// How many Stars we have already created.
int numStars = 0;

// The current index position in our Star array.
int currentStar = 0;

void setup() {
  size(700, 700);   
}

void draw() {
 //black background
 background(0, 0, 0);
 
    // Draw all lines that have been created.
  for (int i = 0; i < numStars; i++)
  {
    Stars[i].display_lines();
  }
   // Draw all stars that have been created.
  for (int i = 0; i < numStars; i++)
  {
    Stars[i].display();
  }
}

void mouseClicked() 
 {
   
    // Create a line from our current star to the next one. 
    if (currentStar >= 1) {
      
      //creating a line to preexisting star, if present
      for (int i = 0; i < numStars; i++) {
        
        if ((abs(Stars[i].x - mouseX) <= 50) && (abs(Stars[i].y - mouseY) <= 50)) {
          
           //adds the line between preexisting stars and ends the function.
           Stars[currentStar - 1].add_line(Stars[currentStar - 1].x, Stars[currentStar - 1].y, Stars[i].x, Stars[i].y);
           return;
        }
      }
      
      //creates a line to a new star
      Stars[currentStar - 1].add_line(Stars[currentStar - 1].x, Stars[currentStar - 1].y, mouseX, mouseY);
      print(Stars[currentStar - 1].lines);
    }
   
    // Create a Star and add it to the current index in our array.
    // The star should be placed where the user clicked.
    Stars[currentStar] = new Star(this, mouseX, mouseY);

    // Increase the current index to get ready for the next star.
    currentStar++;

    // Increase our total stars in play, if we haven't filled the array yet.
    if (numStars < Stars.length)
    {
      numStars++;
    }

    // Did we just use our last slot?  If so, we can reuse old slots.
    if (currentStar >= Stars.length)
    {
      currentStar = 0;
    }
 }
 
//to clear or backstep
void keyPressed() {
 
  //to clear
  if (key == ENTER) {
    
    for (int i = 0; i < numStars; i++) {
      Stars[i]=null;
    }
    
    currentStar=0;
    numStars=0;
  }
  
  //to backtrace
  if (key == 'b' && currentStar >= 1) {
    
    //steps back just one constellation point if the constellation lines were merely connectors
    if (Stars[currentStar - 1].lines.size() >= 1) {
      
      Stars[currentStar - 1].remove_line(Stars[currentStar - 1].lines.size() - 1);
    } else { //deletes the prior star and the constellation connecting it to the star before itself.
    
      Stars[currentStar - 1] = null;
      
      numStars--;
      currentStar--;
      
      if (numStars >= 1) {
        
        Stars[currentStar - 1].remove_line(Stars[currentStar - 1].lines.size() - 1);
      }
    }
  }
}
