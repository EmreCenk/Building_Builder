

import java.util.Map;
import java.util.HashSet;
class Building{
  // what's a building, if not just a bunch of lines stuck together?
  ArrayList<Line> lines; // a list of lines in case I need them at some point
  HashMap<Point, HashSet<Point>> graph; // maps points to points that they are adjacent to (basically an adjacency list where the points are nodes and lines are edges)
  Building(){
    this.lines = new ArrayList<Line>();
    this.graph = new HashMap<Point, HashSet<Point>>();
  }
  
  
  void add_node(Point point_1, Point point_2){
    if (this.graph.get(point_1) == null){
      HashSet<Point> a = new HashSet<Point>();
      a.add(point_2);
      this.graph.put(point_1, a);
    }
    else this.graph.get(point_1).add(point_2);

  
  }
  void add_line(Line l){
    this.add_node(l.p1, l.p2);
    this.add_node(l.p2, l.p1);
    this.lines.add(l);
  }
  
  ArrayList<Point> get_points(){
    ArrayList<Point> points = new ArrayList<Point>();
    for (Point point: this.graph.keySet()) points.add(point);
    return points;
   }
  ArrayList<Point> get_sorted_points(){
    // returns a list of sorted points (depending on their height)

    return merge_sort(this.get_points());
  }

  
  void reset_forces(){
    for (Point name: this.graph.keySet()) {
      name.force.x = 0;
      name.force.y = 0;
    }

  }
  
  void update(){
    // the order that we traverse the points is crucial
    // to find the proper net force, we have to traverse the points from highest to lowest height
    
    this.reset_forces();
    float magnitude;
    PVector pole_vector = new PVector(0, 0);
    int non_visited_neighbour_count;
    
    //HashMap<Point, Boolean> travelled = new HashMap<Point, Boolean>();
    //for (Point p: this.graph.keySet()) travelled.put(p, false);
    
    ArrayList<Point> points = this.get_sorted_points();
    for (Point p: points){
      non_visited_neighbour_count = 0;
      p.apply_force(new PVector(0, p.m * g)); // F = m*a (in this case, a=g to calculate force of gravity on the point)
      
      // count how many of the neighbours we haven't travelled to yet: 
      for (Point neighbour: this.graph.get(p)){
        if (neighbour.position.y >= p.position.y) // neighbour is below us in terms of height, we're chilling
          non_visited_neighbour_count += 1;
      }
      
      magnitude = p.force.mag();
      magnitude /= non_visited_neighbour_count;
      
      for (Point neighbour: this.graph.get(p)){
        if (neighbour.position.y <= p.position.y) continue;// neighbour is higher than us in terms of height, we're NOT chilling
        pole_vector.x = neighbour.position.x; pole_vector.y = neighbour.position.y;
        pole_vector.sub(p.position);
        pole_vector.normalize().mult(magnitude);
        neighbour.apply_force(pole_vector);

      }
      
    }    

    //for (Line l: this.lines) l.update();
  }
  
  void draw_forces(){
    stroke(color(255, 0, 0));
    for (Point name: this.graph.keySet()) {
      draw_vector(name.position, name.force);
    }
    stroke(0);
  }
  
  PVector get_center_of_mass(){
    return calculate_center_of_mass(this.get_points());
  }
  
  void draw_center_of_mass(){
    PVector O = this.get_center_of_mass();
    circle(O.x, O.y, 20);
  }
  
  void paint(){
    for (Line l: this.lines) l.paint();
  }
  

  void print_graph(){
    for (Point name: this.graph.keySet()) {
      PVector asdf = name.position;
      println(asdf, ": ");
      for (Point p: this.graph.get(name)){
        PVector value = p.position;
        println("-", value);
      }
  
    println();println();
  
    }
  }
  
}
