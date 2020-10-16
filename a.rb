require 'minigl'
require 'gosu'
include MiniGL
class MyGame < GameWindow
    def initialize
        super 640, 480, false
        self.caption = 'My First Game'
        @sprite = Sprite.new(320,240,:boom,6,1)
        
    end
    def update
        @sprite.animate([0,1,2,3,4,5],10)  
    end
    def draw
        @sprite.draw
    end
   
end

MyGame.new.show