class Bigdeal
  include AuctionInterface

  def initialize(url, options)
    @auction_url = url
    @auction_id = @auction_url.match(/([\d]+\Z)/)[0]
    @browser = BrowserInterface.new @auction_url
  
    @max_price = options[:max_price]
    @min_price = options[:min_price]
    @bid_cost = options[:bid_cost]
    @bid_secs = options[:bid_secs]
    @username = options[:username]
    @password = options[:password]
    
    @num_bids = 0
  end

  def get_current_price
    @browser.span(:id, "#{@auction_id}-price").text.delete('$').to_f
  end

  def signed_in?
    @browser.link(:text, /Logout/).exists?
  end

  def sign_in
    @browser.link(:text, /Login/).click
    @browser.text_field(:id, "userNameOrEmail").set(@username)
    @browser.text_field(:id, "password").set(@password)
    @browser.form(:action, /login/).submit
  end

  def get_hours
    @browser.span(:id, "#{@auction_id}-hours_remaining").text.to_i
  end

  def get_mins
    @browser.span(:id, "#{@auction_id}-minutes_remaining").text.to_i
  end

  def get_secs
    @browser.span(:id, "#{@auction_id}-seconds_remaining").text.to_i
  end

  def execute_bid
    @browser.div(:id, "#{@auction_id}-bid_button").click
  end

  def get_formatted_price
    @browser.span(:id, @auction_id + "-price").text
  end
end