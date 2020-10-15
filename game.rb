require 'gosu'
GRAVITY = 5
JUMP_VEL=2
FIRE_VEL=15
BACKGROUND_SCROLL_SPEEED= 0.5

class Tutorial < Gosu::Window
    def initialize
        super 640,480
        self.caption="Tutorial Game"
       
        @meteor= Meteor.new(200,0,1,self)
        @player= Player.new(320,height-30,0)
        # @player.warp(320,height-30)
        #using hash to put images
        @images={
            background_image: Gosu::Image.new(self,"sky.jpg",true),
            meteor_image: Gosu::Image.new("meteor.png"),
            fire_image: Gosu::Image.new("fire.png")
        }
       
        @bkg_scroll_y,@fire_vel_y,@fire_y,@fire_x=0,0,0,@player.x
       
    end

    def update
        #background scroll
        @bkg_scroll_y+= BACKGROUND_SCROLL_SPEEED

        if @bkg_scroll_y> height
            @bkg_scroll_y=0
        end
        
        if Gosu.button_down? Gosu::KB_LEFT 
            @player.move_left
        end
        if Gosu.button_down? Gosu::KB_RIGHT 
            @player.move_right
        end

        if Gosu.button_down? Gosu::KB_SPACE and @fire_vel_y==0
            @fire_vel_y = -FIRE_VEL
            @fire_x= @player.x
        end

        if @fire_y<-height
            @fire_y=@fire_vel_y=0      
        end
        @fire_y+=@fire_vel_y
        @meteor.update
    end

    def draw 
        @player.draw
        @meteor.draw
        @images[:background_image].draw(0,@bkg_scroll_y,0)
        @images[:background_image].draw(0,@bkg_scroll_y-height,0)
        @images[:fire_image].draw_rot(@fire_x,@player.y+@fire_y+30,1,0,0.45,0,0.04,0.04);                
              
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
    attr_accessor :x,:y,:angle

    def initialize(x,y,angle)
        @image=Gosu::Image.new("starfighter.bmp")
        @x=x 
        @y=y 
        @angle=angle
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
    @image.draw_rot(@x,@y,2,@angle)
    end

end

class Meteor
    attr_accessor :met_x, :met_y , :met_vel_y
    
    def initialize (met_x,met_y,met_vel_y,window)
        @meteor_image= Gosu::Image.new("meteor.png")
        @met_x=met_x
        @met_y=met_y
        @met_vel_y=met_vel_y
        @window=window
    end

    def update
        if @met_y <= @window.height 
            @met_vel_y += GRAVITY*(@window.update_interval/1000.0)
            @met_y-= -@met_vel_y
        else
            @met_y,@met_vel_y=0,0
            @met_x= rand(@window.width)
            puts @met_x,@met_y,@met_vel_y
        end
        
    end

    
    def draw
        @meteor_image.draw(@met_x,@met_y,2,0.05,0.05)      
    end
end

Tutorial.new.show