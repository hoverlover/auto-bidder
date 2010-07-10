class BrowserInterface < Watir::Safari

  def initialize(url)
    super()
    @url = url
  
    begin
      goto @url
    rescue
      $log.error "Failed to load website.  Will retry."
      retry
    end
  end

  def reload
    $log.debug "reloading ..."
    begin
      goto @url
      @last_reload = Time.now.to_i
      sleep 5 # give the browser time to finish loading before continuing
    rescue
      $log.error "Failed to reload.  Will retry."
      retry
    end
  end
end