class Game < GameWindow
  attr_reader :player, :boss
  def initialize(images)
    super
    @images = images
    init_game
  end

  def update
    @current_scene.update
  end

  def draw
    super
    @current_scene.draw
  end

  def game_button_down(id)
    @current_scene.button_down(id)
  end

  def set_scene(new_scene)
    @current_scene = @scenes[new_scene]
  end

  def init_game
    init_status
    init_scenes
  end

  def init_status
    @player = Character.new("ぶたさん", 20, @images[:butasan])
    @boss = Character.new("あかずきん", 10, @images[:akazukin])
  end

  def init_scenes
    @scenes = {}
    @scenes[:title] = Scene::Title.new(self)

    event_pages = [
      EventPage.new(@boss, ["こんにちは　わたし　あかずきん", "", ""]),
      EventPage.new(@boss, ["こんやの　おかずは　あなたよ", "", ""]),
      EventPage.new(@boss, ["#{@boss.name} があらわれた", "", ""]),
    ]
    @current_event = Event.new(event_pages)
    @scenes[:talk] = Scene::Talk.new(self, @current_event)

    @scenes[:battle] = Scene::Battle.new(self)
    @scenes[:gameover] = Scene::Gameover.new(self)
    @scenes[:gameclear] = Scene::Gameclear.new(self)

    @current_scene = @scenes[:battle]
  end

  def register_image(symbol, image)
    @images[symbol] = image
  end

  def image(symbol)
    @images[symbol]
  end
end
