class SceneBattleTest < Test::Unit::TestCase
  setup do
    @game = Main.new.game
    @scene = Scene::Battle.new(@game)
    @course_width = 1000
    @scene.instance_variable_set(:@course_width, @course_width)
    @start_line_x = -32
    @goal_line_x = @course_width - @start_line_x
  end

  sub_test_case "window_x" do
    sub_test_case "player_x is 0" do
      setup do
        @player_x = 0
      end

      test "player" do
        x = @player_x
        assert_equal(
          @game.window_width - @game.player.image.width * 2,
          @scene.player_window_x(@player_x)
        )
      end

      test "start line" do
        x = @start_line_x
        assert_equal(
          @game.window_width - @game.player.image.width * 2 - @start_line_x,
          @scene.object_window_x(x, @player_x)
        )
      end
    end

    sub_test_case "player_x is 128" do
      setup do
        @player_x = 128
      end

      test "player" do
        assert_equal(
          @game.window_width - @game.player.image.width * 2,
          @scene.player_window_x(@player_x)
        )
      end

      test "start line" do
        assert_equal(
          @game.window_width - @game.player.image.width * 2 - @start_line_x + @player_x,
          @scene.object_window_x(@start_line_x, @player_x)
        )
      end
    end

    sub_test_case "player_x is 1000" do
      setup do
        @player_x = 1000
      end

      test "player" do
        assert_equal(
          @scene.instance_variable_get(:@goal_buffer),
          @scene.player_window_x(@player_x)
        )
      end

      test "goal line" do
        assert_equal(
          -@start_line_x,
          @scene.object_window_x(@goal_line_x, @player_x)
        )
      end
    end
  end
end
