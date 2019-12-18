module Scene
  class Base
    KANA_CODEPOINT_BASE = "ぁ".ord
    ALPHABET_CODEPOINT_BASE = "A".ord
    CHAR_WIDTH = 16
    TALK_WINDOW_Y = 480 - CHAR_WIDTH * 9

    def initialize(game)
      @game = game
      font = @game.image(:font)
      @font_cursor = font.slice(32 + 18, 1)
      @font_star = font.slice(94 - 5, 1)
      @font_num = font.slice(94 * 2 + 15, 10)
      @font_alphabet = font.slice(94 * 2 + 32, 27)
      @font_kana = font.slice(94 * 3, 94)
      @font_frame = font.slice(94 * 7, 33)
      @font_triangle = font.slice(94 * 1 + 3, 4)
    end

    def update
    end

    def draw
    end

    private

    def draw_boss
      window_draw(@game.window_width / 2 - @game.boss.image.width / 2,
                  @game.window_height / 2 - @game.boss.image.height / 2,
                  @game.boss.image)
    end

    def draw_status_window_frame
      draw_window_frame(x: 0,
                        y: 0,
                        inner_width: 7,
                        inner_height: 5)

      draw_kana(40, 0, @game.player.name)
      draw_kana(16, 32, "はやさ")
      draw_num(16 * 5, 32, @game.player.speed, 3)
      draw_kana(16, 64, "げんき")
      draw_num(16 * 5, 64, @game.player.stamina, 3)
    end

    def draw_talk_window_frame
      draw_window_frame(x: 0,
                        y: @game.window_height - (16 * 9),
                        inner_width: @game.window_width / 16 - 2,
                        inner_height: 7)
    end

    def draw_window_frame(x:, y:, inner_width:, inner_height:)
      window_draw(x, y, @font_frame[2])
      draw_horizontal_line(x + CHAR_WIDTH,
                           y,
                           inner_width,
                           @font_frame[0])
      window_draw(x + CHAR_WIDTH * (inner_width + 1),
                  y,
                  @font_frame[3])

      inner_height.times do |y_index|
        window_draw(x,
                    y + CHAR_WIDTH * (y_index + 1),
                    @font_frame[1])
        draw_horizontal_line(x + CHAR_WIDTH,
                             y + CHAR_WIDTH * (y_index + 1),
                             inner_width,
                             @font_frame[-1])
        window_draw(x + CHAR_WIDTH * (inner_width + 1),
                    y + CHAR_WIDTH * (y_index + 1),
                    @font_frame[1])
      end

      window_draw(x,
                  y + CHAR_WIDTH * (inner_height + 1),
                  @font_frame[5])
      draw_horizontal_line(x + CHAR_WIDTH,
                           y + CHAR_WIDTH * (inner_height + 1),
                           inner_width,
                           @font_frame[0])
      window_draw(x + CHAR_WIDTH * (inner_width + 1),
                  y + CHAR_WIDTH * (inner_height + 1),
                  @font_frame[4])
    end

    def draw_next_sign
      window_draw(@game.window_width - 32, @game.window_height - 32, @font_triangle[3])
    end

    def draw_good_night
      draw_alphabet(@game.window_width / 3 * 2,
                    @game.window_height - CHAR_WIDTH * 4,
                    "good night")
      window_draw(@game.window_width / 3 * 2 + CHAR_WIDTH * 10,
                  @game.window_height - CHAR_WIDTH * 4,
                  @font_star[0])
    end

    def draw_horizontal_line(x, y, size, char)
      size.times do |i|
        window_draw(x + CHAR_WIDTH * i,
                    y,
                    char)
      end
    end

    def draw_vartical_line(x, y, size, char)
      size.times do |i|
        window_draw(x,
                    y + CHAR_WIDTH * i,
                    char)
      end
    end

    def draw_num(x, y, num, digit=0)
      text = num.to_s
      padding_size = 0
      if text.size < digit
        padding_size = digit - text.size
        padding_size.times do |i|
          window_draw(x + i * 8 * 2, y, @font_kana[-1])
        end
      end
      text.each_char.with_index do |char, i|
        window_draw(x + (i + padding_size) * 8 * 2,
                    y,
                    @font_num[char.to_i])
      end
    end

    def draw_alphabet(x, y, text)
      text.each_char.with_index do |char, i|
        if char == " "
          index = -1
        else
          index = char.upcase.ord - ALPHABET_CODEPOINT_BASE
        end
        window_draw(x + i * CHAR_WIDTH,
                    y,
                    @font_alphabet[index])
      end
    end

    def draw_kana(x, y, text)
      text.each_char.with_index do |char, i|
        if char == " " || char == "　"
          index = -1
        else
          index = char.ord - KANA_CODEPOINT_BASE
        end
        window_draw(x + i * CHAR_WIDTH, y, @font_kana[index])
      end
    end

    def window_draw(x, y, image)
      GameWindow.draw(x, y, image)
    end
  end
end
