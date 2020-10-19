require 'gosu'
require_relative 'player'
require_relative 'meteor'
require_relative 'fire'

GRAVITY = 3
BACKGROUND_SCROLL_SPEEED= 0.5
NO_OF_METEORS=4

#--------------------------------------------MainGame Class----------------------------------------------------------------------------
class MainGame < Gosu::Window
    attr_accessor :game_over, :score
    def initialize
        super 640,480
        self.caption="Galacta"
        @player= Player.new(320,height-55)
        @meteors=[]                     # Empty array of meteors
        (0..NO_OF_METEORS).each {|i| 
            @meteors.push(Meteor.new(rand(width-20),0,1,self))
        } #Generating Meteors
        @fire= Fire.new(self)
        @gameOverMusic=Gosu::Sample.new('sounds/gameover.mp3')
        @background_image=Gosu::Image.new(self,"images/sky.jpg",true)
        @bkg_scroll_y=0
        @font = Gosu::Font.new(25)
        @score=0
        @game_over=false
    end


    def update 
        #background scroll
        @bkg_scroll_y+= BACKGROUND_SCROLL_SPEEED

        if @player.lives==0
            @game_over=true     
        end     

        if @bkg_scroll_y> height
            @bkg_scroll_y=0
        end

        @meteors.each do |meteor|
            if @player.hitByMeteor(meteor)
                @player.time_hit=Time.now
                @player.exploded=true
                break
             end
        end
       

        if @fire.emerge 
            @meteors.each do |meteor|
                if meteor.hitByFire(@fire)
                    meteor.time_hit=Time.now
                    meteor.exploded=true
                end
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
        if Gosu.button_down? Gosu::KB_R
            @player.lives=3
            @score=0
            @game_over=false
            @game_running=true
        end

        if !@game_over
            @meteors.each {|meteor| meteor.update}
        end
    
        @fire.update
       
    end

    def draw 
        @background_image.draw(0,@bkg_scroll_y,0)
        @background_image.draw(0,@bkg_scroll_y-height,0)      
        @font.draw_text("Lives: #{@player.lives}", 10, 10, 3, 1.0, 1.0, Gosu::Color::YELLOW)
        @font.draw_text("Score: #{@score}", 10, 40, 3, 1.0, 1.0, Gosu::Color::GREEN)   
        if @game_over
            @font.draw_text("GAME OVER" , 180, height/2-50, 3, 2.0, 2.0, Gosu::Color::RED)      
            @font.draw_text("Press R to Restart\nPress ESC to Quit" , 220, height/2, 3, 1, 1.0, Gosu::Color::GREEN)
        else      
            @player.draw
            @meteors.each {|meteor| meteor.draw}
            @fire.draw
        end
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