class boid
{
  PVector pos;
  PVector acc;
  PVector velo;
  Float maxSpeed;
  Float maxForce;
  int lookRadius;
  int avoidRadius;
  int mouseRadius;
  float r;

  boid() {
    this.pos = new PVector(random(width), random(height));
    this.acc = new PVector(0, 0);
    this.velo = new PVector(random(-1, 2), random(-1, 2));
    this.maxForce = 1.0;
    this.maxSpeed = 3.5;
    this.lookRadius = 50;
    this.avoidRadius = 35;
    this.mouseRadius = 70;
    r = 2;
  }
  
  boid(PVector pos)
  {
    this.pos = pos;
    this.acc = new PVector(0, 0);
    this.velo = new PVector(random(-1, 2), random(-1, 2));
    this.maxForce = 0.03;
    this.maxSpeed = 3.0;
    this.lookRadius = 50;
    this.avoidRadius = 35;
    r = 2;
    
  }

  PVector align(List<boid> boids)
  {
    PVector steer = new PVector();
    int total = 0;

    for (boid neighbour : boids)
    {
      float dist = this.pos.dist(neighbour.pos);
      if (neighbour != this && dist < this.lookRadius)
      {
        steer.add(neighbour.velo);
        total++;
      }
    }
    if (total > 0)
    {
      steer.div(total);
      steer.setMag(this.maxSpeed);
      steer.sub(velo);
      steer.limit(this.maxForce);
    }
    return steer;
  }

  PVector cohere(List<boid> boids)
  {
    PVector steer = new PVector();
    int total = 0;

    for (boid neighbour : boids)
    {
      float dist = this.pos.dist(neighbour.pos);
      if (neighbour != this && dist < this.lookRadius)
      {
        steer.add(neighbour.pos);
        total++;
      }
    }
    if (total > 0)
    {
      steer.div(total);
      steer.sub(this.pos);
      steer.setMag(this.maxSpeed);
      steer.sub(this.velo);
      steer.limit(this.maxForce);
    }
    return steer;
  }

  PVector separate(List<boid> boids)
  {
    PVector steer = new PVector();
    int total = 0;

    for (boid neighbour : boids)
    {
      float dist = this.pos.dist(neighbour.pos);
      
      if (neighbour != this && dist < this.avoidRadius)
      {
        PVector diff = PVector.sub(this.pos, neighbour.pos);
        diff.div(dist*dist);
        steer.add(diff);
        total++;
      }
    }
    if (total > 0)
    {
      steer.div(total);
      steer.setMag(this.maxSpeed);
      steer.sub(this.velo);
      steer.limit(this.maxForce);
    }
    return steer;
  }

PVector avoidMouse(List<boid> boids)
{
  PVector steer = new PVector();
    int total = 0;

    for (boid neighbour : boids)
    {
      float dist = this.pos.dist(new PVector(mouseX, mouseY));
      if (dist < this.mouseRadius)
      {
        PVector diff = PVector.sub(this.pos, new PVector(mouseX, mouseY));
        diff.div(dist*dist);
        steer.add(diff);
        total++;
      }
    }
    if (total > 0)
    {
      steer.div(total);
      steer.setMag(this.maxSpeed);
      steer.sub(this.velo);
      steer.limit(this.maxForce);
    }
    return steer;
  
}





  void edge()
  {
    if (pos.x > width)
    {
      pos.x = 0;
    }
    if (pos.x < 0)
    {
      pos.x = width;
    }
    if (pos.y > height)
    {
      pos.y = 0;
    }
    if (pos.y < 0)
    {
      pos.y = height;
    }
  }

  void flocking(List<boid> boids)
  {
    PVector alignment = this.align(boids);
    PVector cohesion = this.cohere(boids);
    PVector separation = this.separate(boids);
    PVector avoidMice = this.avoidMouse(boids);

    acc = alignment.add(cohesion);
    acc.add(separation);
    acc.add(avoidMice);
  }


  void update()
  {
    this.pos.add(velo);
    this.velo.add(acc);
    this.velo.limit(this.maxSpeed);
    this.acc.mult(0);
  }


  void show()
  {
 
    // Draw a triangle rotated in the direction of velocity
    float theta = this.velo.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
    fill(200, 100);
    stroke(255);
    pushMatrix();
    translate(this.pos.x, this.pos.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  
  }
}
