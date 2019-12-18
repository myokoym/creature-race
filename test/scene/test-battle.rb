class SceneBattleTest < Test::Unit::TestCase
  sub_test_case "x_to_window_x" do
    setup do
      @game = Main.new.game
      @scene = Scene::Battle.new(@game)
    end

    test "player_x is 0" do
      @scene.x_to_window_x(0, 0)
    end
  end
end
