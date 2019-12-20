require "dxopal"
include DXOpal

base_dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
$LOAD_PATH.unshift(File.join(base_dir, "data"))
$LOAD_PATH.unshift(File.join(base_dir, "lib"))

class GameWindow
  class << self
    def draw(x, y, image)
      Window.draw(x, y, image)
    end
  end

  def initialize
    super
  end

  def draw
  end

  def window_width
    Window.width
  end

  def window_height
    Window.height
  end
end

require_remote "./lib/files.rb"
Files::LIST.each do |path|
  require_remote "./lib/#{path}.rb"
end

Image.register(:akazukin, "images/akazukin.png")
Image.register(:butasan, "images/butasan.png")
Image.register(:tree, "images/tree.png")
Image.register(:line, "images/line.png")
Image.register(:font, "font/misaki_gothic_x2.png")

class Game
  def window_button_down
    if key_push?(:k_space)
      id = :k_space
    elsif key_push?(:k_enter)
      id = :k_enter
    elsif key_push?(:k_escape)
      id = :k_escape
    elsif key_push?(:k_up)
      id = :k_up
    elsif key_push?(:k_down)
      id = :k_down
    elsif key_push?(:k_left)
      id = :k_left
    elsif key_push?(:k_right)
      id = :k_right
    end
    if mouse_push?(:m_lbutton)
      if mouse_y < self.window_height / 3
        id = :k_up
      elsif mouse_y > self.window_height / 3 * 2
        id = :k_down
      else
        id = :k_space
      end
    end
    game_button_down(id)
  end

  # TODO: not implemented yet in window_button_down()
  #def key_down?(key)
  #  Input.key_down?(symbol_to_constant(key))
  #end

  def key_push?(key)
    Input.key_push?(symbol_to_constant(key))
  end

  # TODO: not implemented yet in window_button_down()
  #def mouse_down?(key)
  #  Input.mouse_down?(symbol_to_constant(key))
  #end

  def mouse_push?(key)
    Input.mouse_push?(symbol_to_constant(key))
  end

  def symbol_to_constant(symbol)
    case symbol
    when :k_space
      K_SPACE
    when :k_escape
      K_ESCAPE
    when :k_enter
      K_ENTER
    when :k_left
      K_LEFT
    when :k_right
      K_RIGHT
    when :k_up
      K_UP
    when :k_down
      K_DOWN
    when :m_lbutton
      M_LBUTTON
    when :m_rbutton
      M_RBUTTON
    end
  end

  def mouse_x
    Input.mouse_x
  end

  def mouse_y
    Input.mouse_y
  end
end

Window.load_resources do
  Window.bgcolor = [255, 255, 255]
  game = Game.new({
    akazukin: Image[:akazukin],
    butasan: Image[:butasan],
    tree: Image[:tree],
    line: Image[:line],
    font: Image[:font].slice_tiles(94, 8),
  })
  Window.loop do
    game.update
    game.draw
    game.window_button_down
  end
end
