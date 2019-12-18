class Character
  attr_reader :name
  attr_reader :image
  attr_reader :lv
  attr_reader :speed
  attr_reader :stamina
  attr_reader :stamina_max
  attr_reader :stamina_counter
  def initialize(name:, lv:, speed:, stamina:, image:)
    @name = name
    @lv = lv
    @speed = speed
    @stamina = stamina
    @stamina_max = stamina_max
    @image = image
    reset
  end

  def lv_up
    @lv += 1
  end

  def damage!
    return if @stamina <= 0
    @stamina_counter -= 1
    if @stamina_counter < 0
      @stamina -= 1
      reset
    end
  end

  def reset
    @stamina_counter = 10
  end

  def real_speed
    if @stamina > 0
      @speed / 4
    else
      @speed / 10
    end
  end
end
