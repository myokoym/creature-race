module Scene
  class Battle < Base
    def initialize(game)
      super(game)
      @comments = []
      @command_cursor = 0
      @gameover = false
      @player_x = 0
      @course_width = 1000
      @wait = 60
      @start_buffer = 128
      @goal_buffer = 64
    end

    def update
      if @wait > 0
        @wait -= 1
      elsif @course_width >= @player_x
        @player_x += 5
      end
    end

    def draw
      draw_background
      draw_line
      draw_player
      draw_status_window_frame
      draw_distance
      draw_talk_window_frame
      if @comments.empty?
        draw_command_window_frame
        draw_command_cursor
      else
        draw_comment
      end
    end

    def button_down(id)
      case id
      when :k_space
        if @comments.empty?
          case @command_cursor
          when 0
            damage = 5
            @game.boss.damage(damage)
            @comments << [
              "#{@game.player.name} のこうげき",
              "#{@game.boss.name} にあたった",
              "",
            ]
            @comments << [
              "#{@game.boss.name} のはんげき",
              "#{@game.player.name} にあたった",
              "",
              0,
              10,
            ]
          when 1
            damage = 2
            @game.player.damage(damage)
            @comments << [
              "#{@game.boss.name} のこうげき",
              "#{@game.player.name} はひっしによけた",
              "",
            ]
            check_gameover
          when 2
            @comments << [
              "#{@game.player.name} はにげだした",
              "しかし まわりこまれてしまった",
              "",
            ]
            @comments << [
              "#{@game.boss.name} のこうげき",
              "#{@game.player.name} にあたった",
              "",
              0,
              5,
            ]
          end
        else
          @comments.shift
          if @gameover && @comments.empty?
            if @game.player.hp > 0
              @game.set_scene(:gameclear)
            else
              @game.set_scene(:gameover)
            end
          end
          if @comments[0] && !@gameover
            @game.boss.damage(@comments[0][3]) if @comments[0][3]
            if @comments[0][4]
              @game.player.damage(@comments[0][4])
              check_gameover
            end
          end
        end
      when :k_up
        @command_cursor -= 1
        @command_cursor = 0 if @command_cursor < 0
      when :k_down
        @command_cursor += 1
        @command_cursor = 2 if @command_cursor > 2
      end
    end

    def check_gameover
      if @game.player.hp == 0
        @comments << [
          "#{@game.player.name} はまけてしまった",
          "",
          "",
        ]
        @gameover = true
      elsif @game.player.hp == 1
        @comments << [
          "はぁ つかれちゃった",
          "",
          "",
        ]
        @comments << [
          "かえろ",
          "",
          "",
        ]
        @gameover = true
      end
    end

    def draw_background
      lane_y = @game.window_height / 3
      image = @game.image(:tree)
      y = lane_y - image.height
      if @game.window_width < (@course_width - @player_x)
        x = @player_x
      else
        x = @course_width - @game.window_width
      end
      ((@course_width - @start_buffer - @goal_buffer) / image.width).times do |i|
        image.draw(image.width * i - x + @start_buffer,
                   y,
                   ZOrder::PLAYER)
      end
    end

    def draw_line
      lane_y = @game.window_height / 3
      image = @game.image(:line)
      x = @game.player.image.width * 2
      y = lane_y
      4.times do |i|
        window_draw(x - @player_x,
                    y + image.height * i,
                    image)
      end
      if @game.window_width < (@course_width - @player_x)
        x = @course_width - @player_x - @start_buffer - @goal_buffer - image.width
      else
        x = @course_width - @game.window_width + @game.player.image.width
      end
      4.times do |i|
        window_draw(x + @start_buffer,
                    y + image.height * i,
                    image)
      end
    end

    def draw_player
      lane_y = @game.window_height / 3
      image = @game.player.image
      y = lane_y
      if @game.window_width < (@course_width - @player_x)
        x = image.width
      elsif @course_width >= (@player_x + @start_buffer)
        x = @game.window_width - (@course_width - @player_x) + image.width
      else
        x = @game.window_width - image.width
      end
      window_draw(x, y, image)
    end

    def draw_distance
      draw_num(@game.window_width - 100, 0, @course_width - @player_x)
    end

    def draw_command_window_frame
      draw_window_frame(x: 0,
                        y: @game.window_height - (16 * 9),
                        inner_width: 9,
                        inner_height: 7)

      draw_kana(CHAR_WIDTH * 3,
                @game.window_height - (16 * 9) + CHAR_WIDTH * 2,
                "こうたい")
      draw_kana(CHAR_WIDTH * 3,
                @game.window_height - (16 * 9) + CHAR_WIDTH * 4,
                "とくぎ")
      draw_kana(CHAR_WIDTH * 3,
                @game.window_height - (16 * 9) + CHAR_WIDTH * 6,
                "あきらめる")
    end

    def draw_command_cursor
      window_draw(CHAR_WIDTH * 2,
                  @game.window_height - (16 * 9) + CHAR_WIDTH * (@command_cursor + 1) * 2,
                  @font_cursor[0])
    end

    def draw_comment
      3.times do |i|
        draw_kana(CHAR_WIDTH * 2,
                  TALK_WINDOW_Y + CHAR_WIDTH * 2 * (i + 1),
                  @comments[0][i])
      end
      draw_next_sign
    end
  end
end
