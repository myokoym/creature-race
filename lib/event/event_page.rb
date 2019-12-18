class EventPage
  attr_reader :character
  attr_reader :comments
  def initialize(character, comments)
    @character = character
    @comments = comments
  end
end
