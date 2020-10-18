class Fire
    attr_accessor :x ,:y, :vel_y, :emerge
    def initialize(window)
        @window=window
        @fire_image= Gosu::Image.new("images/fire.png")   
        @fire_sound= Gosu::Sample.new("sounds/fire.wav")
        @emerge=false
        @x,@y=x,y
        @vel=-20
    end

    def launch(x)
        @emerge=true
        @x=x
        @y=@window.height-30
        @fire_sound.play
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