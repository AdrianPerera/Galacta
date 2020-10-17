require 'gosu'



GRAVITY = 3
BACKGROUND_SCROLL_SPEEED= 0.5

#--------------------------------------------MainGame Class----------------------------------------------------------------------------
class MainGame < Gosu::Window
    def initialize
        super 640,480
        self.caption="Galacta"
        @player= Player.new(320,height-30,0)
        @meteor= Meteor.new(200,0,1,self)
        @fire= Fire.new(self)
        #using hash to put images
        @images={
            background_image: Gosu::Image.new(self,"sky.jpg",true),
        }
        @bkg_scroll_y=0
        @font = Gosu::Font.new(25)
    end

    def update
        #background scroll
        @bkg_scroll_y+= BACKGROUND_SCROLL_SPEEED

        if @bkg_scroll_y> height
            @bkg_scroll_y=0
        end

        if @player.hitByMeteor(@meteor)
           @player.time_hit=Time.now
           @player.exploded=true
        end
        if @fire.emerge 
            if @meteor.hitByFire(@fire)
                @meteor.time_hit=Time.now
                @meteor.exploded=true
            end
        end
    
        if Gosu.button_down? Gosu::KB_LEFT 
            @player.move_left
        end
        if Gosu.button_down? Gosu::KB_RIGHT 
            @player.move_right
        end      

        if Gosu.button_down? Gosu::KB_SPACE and !@fire.emerge
            @fire.launch(@player.x.dup)
        end  

        @meteor.update
        @fire.update
       
    end

    def draw 
        @images[:background_image].draw(0,@bkg_scroll_y,0)
        @images[:background_image].draw(0,@bkg_scroll_y-height,0)      
        @player.draw
        @meteor.draw
        @fire.draw
        @font.draw_text("Lives: #{@player.lives}", 10, 10, 3, 1.0, 1.0, Gosu::Color::YELLOW)
        @font.draw_text("Score: #{@meteor.score}", 10, 40, 3, 1.0, 1.0, Gosu::Color::GREEN)
    end

    def button_down(id)
        if id == Gosu::KB_ESCAPE
            close
        else
            super
        end
    end
end


#-----------------------------------------------Fire Class-------------------------------------------------------------
class Fire
    attr_accessor :x ,:y, :vel_y, :emerge
    def initialize(window)
        @window=window
        @fire_image= Gosu::Image.new("fire.png")      
        @emerge=false
        @x,@y=x,y
        @vel=-20
    end

    def launch(x)
        @emerge=true
        @x=x-30
        @y=@window.height-30
    end

    def update
      if @emerge
        if @y>0 
            @y+= @vel
           else
            @y=@window.height-30
            @emerge=false
           end
        end
    end

    def draw
        if @emerge
            @fire_image.draw(@x,@y,1,0.04,0.04)
        end
    end
        
    
end





#------------------------------------------------Player Class ------------------------------------------------------------------------
class Player 
    attr_accessor :x,:y,:angle,:exploded,:time_hit,:lives

    def initialize(x,y,angle)
        @image=Gosu::Image.new("starfighter.bmp")
        @x=x 
        @y=y 
        @angle=angle
        @boom_anim= Gosu::Image.load_tiles("boom.png",127,127)
        @exploded=false
        @time_hit=nil
        @lives=3
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

    def hitByMeteor(meteor)
        return Gosu::distance(meteor.met_x,meteor.met_y,@x,@y)<30 
    end
    
    def draw
        if @exploded
            img = @boom_anim[Gosu.milliseconds / 150 % @boom_anim.size]
            img.draw(@x - img.width / 2.0, @y - img.height / 2.0,2, 1, 1)
            if Time.now-@time_hit>1
                @exploded=false
                @lives-=1
                @x,@y=320,450
            end
        else
            @image.draw_rot(@x,@y,2,@angle)
        end

    end

end
#---------------------------------------------------Meteor Class---------------------------------------------------------------------
class Meteor
    attr_accessor :met_x, :met_y , :met_vel_y , :exploded , :time_hit
    attr_reader :score
    
    def initialize (met_x,met_y,met_vel_y,window)
        @meteor_image= Gosu::Image.new("meteor.png")
        @met_x=met_x
        @met_y=met_y
        @met_vel_y=met_vel_y
        @window=window
        @boom_anim= Gosu::Image.load_tiles("boom.png",127,127)
        @exploded=false
        @time_hit=nil
        @score=0
    end

    def hitByFire(fire)
        return Gosu::distance(fire.x,fire.y,@met_x,@met_y)<30
    end

    def respawn
        @met_y,@met_vel_y=0,0
        @met_x= rand(@window.width)
    end


    def update
        if @met_y <= @window.height 
            @met_vel_y += GRAVITY*(@window.update_interval/1000.0)
            @met_y-= -@met_vel_y
        else
            respawn
        end 
    end
    
    def draw
         
        if @exploded
            img = @boom_anim[Gosu.milliseconds / 50 % @boom_anim.size]
            img.draw(@met_x -15, @met_y-15 ,2, 0.5, 0.5)
            if Time.now-@time_hit>0.2
                @exploded=false
                @score+=10
                respawn
            end
        else
            @meteor_image.draw(@met_x,@met_y,2,0.05,0.05)    
        end

    end
end


MainGame.new.show