class Character
  attr_reader :name
  attr_reader :image
  attr_reader :lv
  attr_reader :hp
  def initialize(name, lv, image)
    @name = name
    @lv = lv
    @hp = @lv
    @image = image
  end

  def lv_up
    @lv += 1
    hp_max
  end

  def hp_max
    @hp = @lv
  end

  def damage(pow)
    @hp -= pow
    @hp = 0 if @hp < 0
  end
end
