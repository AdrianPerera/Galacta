class Meteor
    attr_accessor :met_x, :met_y , :met_vel_y , :exploded , :time_hit 
    def initialize (met_x,met_y,met_vel_y,window)
        @met_x=met_x
        @met_y=met_y
        @met_vel_y=met_vel_y
        @window=window
        @meteor_image= Gosu::Image.new("images/meteor.png")
        @boom_anim= Gosu::Image.load_tiles("images/boom.png",127,127)
        @exploded=false
        @time_hit=nil       
    end

    def hitByFire(fire)
        return Gosu::distance(fire.x,fire.y,@met_x,@met_y)<30
    end

    def respawn
        @met_y,@met_vel_y=0,0
        @met_x= rand(@window.width-20)
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
                @window.score+=10
                respawn
            end
        else
            @meteor_image.draw(@met_x,@met_y,2,0.05,0.05)    
        end

    end
end