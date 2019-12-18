require "gosu"

class GameWindow < Gosu::Window
  class << self
    def draw(x, y, image)
      image.draw(x, y, ZOrder::UI)
    end
  end

  def initialize(images)
    super(640, 480)
    self.caption = "Creature Race"
    @background_image = Gosu::Image.new("images/white.png")
  end

  def draw
    fill_image(@background_image, ZOrder::BACKGROUND)
  end

  def fill_image(image, z_order)
    (window_height / image.height).times do |y|
      (window_width / image.width).times do |x|
        image.draw(image.width * x,
                   image.height * y,
                   z_order)
      end
    end
  end

  def button_down(id)
    symbol = gosu_id_to_symbol(id)
    if symbol == :m_lbutton
      if window_mouse_y < window_height / 3
        symbol = :k_up
      elsif window_mouse_y > window_height / 3 * 2
        symbol = :k_down
      else
        symbol = :k_space
      end
    end
    if symbol == :k_escape
      close # TODO: for debugging
    end
    game_button_down(symbol)
  end

  def gosu_id_to_symbol(id)
    case id
    when Gosu::KB_SPACE
      :k_space
    when Gosu::KB_ESCAPE
      :k_escape
    when Gosu::KB_ENTER
      :k_enter
    when Gosu::KB_LEFT
      :k_left
    when Gosu::KB_RIGHT
      :k_right
    when Gosu::KB_UP
      :k_up
    when Gosu::KB_DOWN
      :k_down
    when Gosu::MS_LEFT
      :m_lbutton
    when Gosu::MS_RIGHT
      :m_rbutton
    end
  end

  def window_width
    self.width
  end

  def window_height
    self.height
  end

  def window_mouse_x
    self.mouse_x
  end

  def window_mouse_y
    self.mouse_y
  end
end

require "./lib/files"
Files::LIST.each do |path|
  require "./lib/#{path}"
end

class Main
  attr_reader :game
  def initialize
    @game = Game.new({
      font: Gosu::Image.load_tiles("font/misaki_gothic_x2.png", 16, 16),
      butasan: Gosu::Image.new("images/butasan.png"),
      akazukin: Gosu::Image.new("images/akazukin.png"),
      white: Gosu::Image.new("images/white.png"),
      tree: Gosu::Image.new("images/tree.png"),
      line: Gosu::Image.new("images/line.png"),
    })
  end

  def show
    @game.show
  end
end
