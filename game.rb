require 'gosu'
GRAVITY = 10
JUMP_VEL=2

class Tutorial < Gosu::Window
    def initialize
        super 640,480
        self.caption="Tutorial Game"
        #using hashes to put images 
        @images={
            background_image: Gosu::Image.new(self,"sky.jpg",true),
            meteor_image: Gosu::Image.new("meteor.png")
        }
        @met_x,@met_y,@met_vel_y=200,0,1
        @player= Player.new
        @player.warp(320,height-30)
        @scroll_y=0
    end

    def update
        @scroll_y+=3
        if @scroll_y> height
            @scroll_y=0
        end
        
        if Gosu.button_down? Gosu::KB_LEFT 
            @player.move_left
        end
        if Gosu.button_down? Gosu::KB_RIGHT 
            @player.move_right
        end
        if Gosu.button_down? Gosu::KB_SPACE
            @met_vel_y-=JUMP_VEL
        end
        if @met_y<=height 
            @met_vel_y+= GRAVITY*(update_interval/1000.0)
            @met_y-=-@met_vel_y
        end
    end

    def draw 
        @player.draw
        @images[:meteor_image].draw(@met_x,@met_y,2,0.1,0.1)
        @images[:background_image].draw(0,@scroll_y,0)
        @images[:background_image].draw(0,@scroll_y-height,0)
    end

    def button_down(id)
        if id == Gosu::KB_ESCAPE
            close
        else
            super
        end
    end
end

class Player
    def initialize
        super
        @image=Gosu::Image.new("starfighter.bmp")
        @x=@y=@vel_x=@vel_y=@angle=0.0
        @score = 0
    end
    def warp(x,y)
        @x,@y= x,y 
    end 
    def move_left
        if @x>25
            @x -=5  
        end
        
    end
    def move_right
        if @x<640-25
            @x +=5
        end
    end

    def draw
    @image.draw_rot(@x,@y,1,@angle)
    end
end

Tutorial.new.show