class Player 
    attr_accessor :x,:y,:exploded,:time_hit,:lives 
    attr_reader :explosion_sound

    def initialize(x,y)
        @image=Gosu::Image.new("images/starfighter.bmp")
        @explosion_sound= Gosu::Sample.new("sounds/explosion.wav")
        @x=x 
        @y=y 
        @boom_anim= Gosu::Image.load_tiles("images/boom.png",127,127)
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
            if Gosu::distance(meteor.met_x,meteor.met_y,@x,@y)<30  
                return true
            else
                return false
            end       
    end
    
    def draw
        if @exploded
            img = @boom_anim[Gosu.milliseconds / 150 % @boom_anim.size]
            img.draw(@x - img.width / 2.0, @y - img.height / 2.0,2, 1, 1)
            if Time.now-@time_hit>0.2
                @explosion_sound.play
                @exploded=false
                @lives-=1
                @x,@y=320,430
            end
        else
            @image.draw(@x,@y,2)
        end

    end

end