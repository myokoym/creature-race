class Character
  attr_reader :name
  attr_reader :image
  attr_reader :lv
  attr_reader :speed
  attr_reader :stamina
  attr_reader :stamina_max
  def initialize(name:, lv:, speed:, stamina:, image:)
    @name = name
    @lv = lv
    @speed = speed
    @stamina = stamina
    @stamina_max = stamina_max
    @image = image
  end

  def lv_up
    @lv += 1
  end

  def damage(pow)
    @stamina -= pow
    @stamina = 0 if @stamina < 0
  end
end
