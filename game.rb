#!/usr/bin/env ruby -w
require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    @background_image = Gosu::Image.new(self, "assets/background.png", true)
  end

  def draw
    @background_image.draw(0,0,0)
  end

end

window = GameWindow.new
window.show