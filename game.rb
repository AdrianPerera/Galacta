require 'gosu'
require_relative 'player'
require_relative 'meteor'
require_relative 'fire'

GRAVITY = 3
BACKGROUND_SCROLL_SPEEED= 0.5

#--------------------------------------------MainGame Class----------------------------------------------------------------------------
class MainGame < Gosu::Window
    def initialize
        super 640,480
        self.caption="Galacta"
        @player= Player.new(320,height-55)
        @meteor= Meteor.new(200,0,1,self)
        @fire= Fire.new(self)
        #using hash to put images
        @images={
            background_image: Gosu::Image.new(self,"images/sky.jpg",true),
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

MainGame.new.show