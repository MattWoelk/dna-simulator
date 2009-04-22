#This is a node, which should contain a piece of DNA, and the instructions to make more DNA.

class Node
  attr_accessor :instructions, :coords, :color, :size
  def initialize instructions, size
    @instructions = instructions
    @coords = [100,100]
    @size = size
    @color = [200, 200, 80]
  end

  def reproduce
    $app.newnode @instructions, @coords, @color
  end

  def draw
    $app.fill @color[0], @color[1], @color[2]
    $app.stroke 255
    $app.ellipse(@coords[0],@coords[1],@size*2,@size*2)
  end

  def mouse_pressed(x, y)
    if $app.dist(x,y,@coords[0],@coords[1]) <= @size
      reproduce
    end
  end
end
