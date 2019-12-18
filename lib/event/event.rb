class Event
  attr_reader :event_pages
  attr_reader :current_page_index
  def initialize(event_pages)
    @event_pages = event_pages
    @current_page_index = 0
  end

  def current_page
    @event_pages[@current_page_index]
  end

  def next
    @current_page_index += 1
    if @current_page_index < @event_pages.size
      return true
    end
    false
  end
end
