import java.util.*;

List<boid> flock = new ArrayList<boid>();

void setup()
{
  size(1500,1000);
  flock.add(new boid());
  for (int i = 0; i < 200; i++)
  {
    flock.add(new boid());
  }
  
}

void draw()
{
  background(0);
  for (boid x : flock)
  {
    x.edge();
    x.flocking(flock);
    x.update();
    x.show();
  }
  
  println(frameRate);
  println(flock.size());
}


void mousePressed()
{
  for (int i = 0; i < 100; i++)
  {
    flock.add(new boid(new PVector(mouseX + i, mouseY)));
  }
}
