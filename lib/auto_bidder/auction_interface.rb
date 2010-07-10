module AuctionInterface
  
  def start_monitoring
    while true do
      reload_if_necessary

      @hours = hours
      @mins = mins
      @secs = secs
      print_stats

      if @hours == 0 && @mins == 0 && @secs == @bid_secs && ok_to_bid
        place_bid
        sleep 10
      end
    end
  end
  
  # --------------- #
  # Private methods #
  # --------------- #
  def ok_to_bid
    current_price = get_current_price
    current_price >= @min_price && ((@num_bids + 1) * @bid_cost + current_price) <= @max_price 
  end
  
  def reload_if_necessary
    # Reload every 8-10 minutes so the website doesn't think we've gone idle.  If @secs is 5 or less
    # put off the reload so we don't accidentally miss a bid opportunity.
    if (Time.now.to_i - @last_reload) / 60 >= @next_reload_in && @secs > 10
      @browser.reload
      recalculate_next_reload_time
    end
  end
  
  def hours
    begin
      get_hours
    rescue
      $log.error "Could not find hours element"
      @browser.reload
      -1
    end
  end

  def mins
    begin
      get_mins
    rescue
      $log.error "Could not find minutes element"
      @browser.reload
      -1
    end
  end

  def secs
    begin
      get_secs
    rescue
      $log.info "Could not find seconds element"
      @browser.reload
      -1
    end
  end
  
  def recalculate_next_reload_time
    @next_reload_in = (rand(3) + 8)
  end
  
  def connect_to_auction    
    sign_in unless signed_in?
    
    @last_reload = Time.now.to_i
    recalculate_next_reload_time
  end
  
  def place_bid
    $log.info <<-BIDDING
    \n=======================================
                 PLACING BID
         #{Time.now}
    =======================================
    BIDDING

    begin
      execute_bid
      @num_bids += 1

      # The server knows we're still here because we just placed a bid, so reset the next reload time.
      recalculate_next_reload_time
    rescue
      $log.error "Error while placing bid!"
    end
  end
  
  def print_stats
    @last_debug ||= Time.now.to_i
  
    # print debug every 10 seconds
    if Time.now.to_i - @last_debug > 10
      begin
        $log.debug %(#{Time.now.strftime "%m/%d/%Y %H:%M:%S"} - #{"%02d" % @hours}:#{"%02d" % @mins}:#{"%02d" % @secs}, #{get_formatted_price})
      rescue => e
        $log.error "Could not print debug statement\n#{e.backtrace.join("\n")}"
      end
      @last_debug = Time.now.to_i
    end
  
    sleep 0.01
  end
  private :ok_to_bid, :reload_if_necessary, :hours, :mins, :secs, :recalculate_next_reload_time, :place_bid, :print_stats
end