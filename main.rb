#this will eventually be some sort of DNA simulation

begin
require 'rubygems'
rescue LoadError; end

require 'ruby-processing'
load 'node.rb'

class Animator < Processing::App
  attr_accessor :queue
  def setup
    smooth
    ellipse_mode(CENTER)
    puts "\n\nSTART_OF_PROGRUM\n--------------------"
    
    @font = $app.create_font("Univers45.vlw", 66)
    text_font(@font, 14)
  
    @o_instructions = [0,0,0]
    @node = []
    @node[0] = Node.new(@o_instructions,20)
  
    @time_constant = 50
    @counter = 0
    @queue = []
  end
  
  def draw
    background 200, 220, 240
    fill 0
    text("intro text",190,20,160,200)
    @node.each do |nod|
      nod.draw
    end
    duplicate_at_intervals
    spread_em
  end
  
  def key_pressed
    puts key
  end
  
  def mouse_pressed
    sizz = @node.size
    sizz.times do |index|
      @node[sizz-1-index].mouse_pressed(mouse_x, mouse_y)
    end
  end
  
  def mouse_released
    
  end

  def rond value
    if value < 1.0 && value >= 0.0
      return 1.0
    elsif value < 1.0 && value >= 0.0
      return -1.0
    else
      return value
    end
  end
  
  def newnode ins, coor, color
    r=14
    @node[@node.size] = Node.new(ins, 20)
    @queue.push @node[@node.size-1]
    @node[@node.size-1].coords = [coor[0]+rond(rand(5)-2),coor[1]+rond(rand(5)-2)]
    @node[@node.size-1].color = [color[0]+rand(r)-r/2,color[1]+rand(r)-r/2,color[2]+rand(r)-r/2]
  end

  def spread_em
    @node.each do |nod|
      #if the node is off-screen, delete it
      if (nod.coords[0]+nod.size < 0 ) || (nod.coords[0]-nod.size > width ) || (nod.coords[1]+nod.size < 0 ) || (nod.coords[1]-nod.size > height )
        @node.delete nod 
        @queue.delete nod
      end
      @node.each do |nod2|
        if nod2 != nod && !nod2.nil? && !nod.nil?
          #check to see if they overlap, if so, move them both away a little
          distance = dist(nod.coords[0],nod.coords[1],nod2.coords[0],nod2.coords[1])
          if distance < nod.size + nod2.size
            #move them away from each other a little (round up to one or down to -1)
            nod.coords[0] = nod.coords[0] + rond(nod.coords[0]-nod2.coords[0])/distance
            nod.coords[1] = nod.coords[1] + rond(nod.coords[1]-nod2.coords[1])/distance
          end
        end
      end
    end
  end

  def duplicate_at_intervals
    @counter += 1
    if @counter == @time_constant
      @counter = 0
      nod = @queue[0]
      @queue.delete @queue[0]
      while nod.nil? && @queue.size != 0
        nod = @queue[0]
        @queue.delete @queue[0]
      end
      @queue.push nod
      nod.reproduce if !nod.nil?
    end
  end
end

Animator.new :title => "DNA simulator", :width => 350, :height => 350

#ideas: always produce new cell away from the pack
# => split evenly, like cells normally do (animation!?!?)
