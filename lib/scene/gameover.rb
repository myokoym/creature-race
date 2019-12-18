module Scene
  class Gameover < Base
    def initialize(game)
      super(game)
    end

    def draw
      draw_alphabet(@game.window_width / 3 + CHAR_WIDTH * 2,
                    @game.window_height / 2 - CHAR_WIDTH,
                    "game over")
    end

    def button_down(id)
      case id
      when :k_space
        @game.set_scene(:title)
      end
    end
  end
end
