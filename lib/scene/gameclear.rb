module Scene
  class Gameclear < Base
    def initialize(game)
      super(game)
    end

    def draw
      draw_alphabet(@game.window_width / 3 + CHAR_WIDTH * 2,
                    @game.window_height / 2 - CHAR_WIDTH,
                    "game clear")
      draw_good_night
    end

    def button_down(id)
    end
  end
end
