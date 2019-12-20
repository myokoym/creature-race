module Scene
  class Battle < Base
    def initialize(game)
      super(game)
      @comments = []
      @command_cursor = 0
      @gameover = false
      @player_x = 0
      @boss_x = 0
      @course = @game.course(2)
      @wait = 60
      @start_buffer = 192
      @goal_buffer = 64
      @game.player.reset
      @game.boss.reset
      @comments << [
        "はじめっ",
        "",
        "",
      ]
    end

    def update
      if @wait > 0
        @wait -= 1
      elsif @course.length > @player_x &&
            @course.length > @boss_x
        unless @comments.empty?
          @comments.shift
        end
        @game.player.damage!
        @game.boss.damage!
        @player_x += @game.player.real_speed
        @boss_x += @game.boss.real_speed
      else
        process_gameover
      end
    end

    def draw
      draw_background
      draw_line
      draw_player
      draw_boss
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
          when 1
            check_gameover
          when 2
          end
        else
          @comments.shift
          if @gameover && @comments.empty?
            @game.set_scene(:gameover)
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

    def process_gameover
      return if @gameover
      @gameover = true
      if @course.length <= @player_x
        @comments << [
          "#{@game.player.name} のかち",
          "",
          "",
        ]
      elsif @course.length <= @boss_x
        @comments << [
          "#{@game.player.name} はまけてしまった",
          "",
          "",
        ]
      end
    end

    def draw_background
      lane_y = @game.window_height / 3
      image = @game.image(:tree)
      y = lane_y - image.height
      (@course.length / image.width).times do |i|
        image.draw(object_window_x(image.width * (i + 1)),
                   y,
                   ZOrder::PLAYER)
      end
    end

    def draw_line
      lane_y = @game.window_height / 3
      image = @game.image(:line)
      y = lane_y
      start_x = image.width
      goal_x = @course.length + image.width
      4.times do |i|
        window_draw(object_window_x(start_x),
                    y + image.height * i,
                    image)
        window_draw(object_window_x(goal_x),
                    y + image.height * i,
                    image)
      end
    end

    def draw_player
      lane_y = @game.window_height / 3
      image = @game.player.image
      y = lane_y
      window_draw(player_window_x(@player_x), y, image)
    end

    def draw_boss
      image = @game.boss.image
      lane_y = @game.window_height / 3 + image.height
      y = lane_y
      window_draw(object_window_x(@boss_x), y, image)
    end

    def object_window_x(x, player_x=nil)
      player_x ||= @player_x
      if @game.window_width <
         (@course.length + @goal_buffer) - (player_x - @start_buffer)
        (@game.window_width + player_x) - (x + @start_buffer)
      else
        @course.length - x + @goal_buffer
      end
    end

    def player_window_x(player_x)
      if @game.window_width <
         (@course.length + @goal_buffer) - (player_x - @start_buffer)
        @game.window_width - @start_buffer
      else
        @course.length - player_x + @goal_buffer
      end
    end

    def draw_distance
      draw_num(@game.window_width - 100, 0, @course.length - @player_x)
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
