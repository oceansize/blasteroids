#!/usr/bin/env ruby -w
require 'gosu'
require './lib/player.rb'
require './lib/projectile.rb'
require './lib/asteroid.rb'


class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    @background_image = Gosu::Image.new(self, "assets/background.png", true)
    @player = Player.new(self) # Self refers to the window
    @projectiles = []
    @asteroids = Asteroid.spawn(self, 3)
  end

  def draw
    @background_image.draw(0,0,0)
    @player.draw
    @projectiles.each { |projectile| projectile.draw }
    @asteroids.each   { |asteroid| asteroid.draw     }
  end

  def update
    @player.move
    control_player
    @asteroids.each      { |asteroid| asteroid.move  }
    @asteroids.reject!   { |asteroid| asteroid.dead? }
    detect_collisions
    @projectiles.each    { |projectile| projectile.move  }
    @projectiles.reject! { |projectile| projectile.dead? }
  end

  def control_player
    if button_down? Gosu::KbLeft
      @player.turn_left
    end
    if button_down? Gosu::KbRight
      @player.turn_right
    end
    if button_down? Gosu::KbUp
      @player.accelerate
    end
  end

  def button_down(id)
    close if id == Gosu::KbQ # Creates'quit' function
    if id == Gosu::KbSpace
      @projectiles << Projectile.new(self, @player)
    end
  end

  def detect_collisions
    @asteroids.each do |asteroid|
      if collision?(asteroid, @player)
        puts 'kaboom'
      end
    end
    @projectiles.each do |projectile|
      @asteroids.each do |asteroid|
        if collision?(projectile, asteroid)
          projectile.kill
          asteroid.kill
        end
      end
    end
  end

  def collision?(object_1, object_2)
    hitbox_1, hitbox_2 = object_1.hitbox, object_2.hitbox
    common_x = hitbox_1[:x] & hitbox_2[:x]
    common_y = hitbox_1[:y] & hitbox_2[:y]
    common_x.size > 0 && common_y.size > 0
  end

end

window = GameWindow.new
window.show