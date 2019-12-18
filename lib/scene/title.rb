module Scene
  class Title < Base
    def initialize(game)
      super(game)
    end

    def draw
      draw_alphabet(@game.window_width / 3,
                    @game.window_height / 3,
                    "Creature Race")
      draw_alphabet(@game.window_width / 3 + CHAR_WIDTH,
                    @game.window_height / 3 * 2,
                    "press space")
    end

    def button_down(id)
      case id
      when :k_space
        @game.init_game
        @game.set_scene(:talk)
      end
    end
  end
end
