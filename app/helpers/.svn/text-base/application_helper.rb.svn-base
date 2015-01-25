# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Friendly time will generate a Twitter-like representation of when something occurred
  # ("just a moment ago", a minute ago)
  def friendly_time(old_time)
    val = Time.now - old_time
    #puts val
    if val < 10 then
      result = 'just a moment ago'
    elsif val < 40  then
      result = 'less than ' + (val * 1.5).to_i.to_s.slice(0,1) + '0 seconds ago'
    elsif val < 60 then
      result = 'less than a minute ago'
    elsif val < 60 * 1.3  then
      result = "1 minute ago"
    elsif val < 60 * 50  then
      result = "#{(val / 60).to_i} minutes ago"
    elsif val < 60  * 60  * 1.4 then
      result = 'about 1 hour ago'
    elsif val < 60  * 60 * (24 / 1.02) then
      result = "about #{(val / 60 / 60 * 1.02).to_i} hours ago"
    else
      result = old_time.strftime("%B %d, %Y")
    end
    result
  end

  # Returns a string shortened to a specific number of words, followed by an ellipsis.
  # Added by Doug Maier
  def truncate_words(text, length = 30, end_string = ' …')
    return if text == nil
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
  
  def current_url?(controller)
    params[:controller] == controller ? "active" : nil
  end

end