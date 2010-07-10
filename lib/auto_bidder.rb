require 'safariwatir'
require 'optparse'
require 'auto_bidder/auction_interface'
require 'auto_bidder/bigdeal'
require 'auto_bidder/browser_interface'
require 'logger'
require 'uri'

class AutoBidder
  def initialize(url, options)
    @num_bids = 0
  
    # Glean the TLD name from the host and use it to create the auction interface
    host = URI.parse(url).host
    begin
      @auction_interface = Module.const_get(host.split(".")[-2].capitalize).new(url, options)
    rescue NameError
      $log.fatal "Auction site #{host} not supported"
    end
  end

  def start
    @auction_interface.connect_to_auction
    @auction_interface.start_monitoring
  end
end

def parse_command_line
  # This hash will hold all of the options
  # parsed from the command-line by
  # OptionParser.
  options = {}

  optparse = OptionParser.new do|opts|
    # Set a banner, displayed at the top
    # of the help screen.
    opts.banner = "Usage: auto-bidder [options] URL"

    # Define the options, and what they do
    options[:verbose] = false
    opts.on('-v', '--verbose', 'Be more verbose') do
      options[:verbose] = true
    end
    
    opts.on("-x", "--max-price PRICE", Float, 'Maximum price you are willing to pay for the auction item') do |max_price|
      options[:max_price] = max_price
    end
    
    opts.on("-n", "--min-price [PRICE]", Float, 'Minimum price the auction item must reach before bidding starts') do |min_price|
      options[:min_price] = min_price || 0.0
    end
    
    opts.on("-c", "--bid-cost COST", Float, 'How much each bid actually costs you') do |bid_cost|
      options[:bid_cost] = bid_cost
    end
    
    opts.on("-u", "--username USER", 'Username of your account for the auction site') do |username|
      options[:username] = username
    end
    
    opts.on("-s", "--bid-seconds [SECONDS]", Integer, 'How many seconds remaining on the clock before a bid is placed') do |bid_secs|
      options[:bid_secs] = bid_secs || 1
    end
    
    # This displays the help screen, all programs are
    # assumed to have this option.
    opts.on( '-h', '--help', 'Display this screen' ) do
      puts opts
      exit
    end
  end

  # Parse the command-line. Remember there are two forms
  # of the parse method. The 'parse' method simply parses
  # ARGV, while the 'parse!' method parses ARGV and removes
  # any options found there, as well as any parameters for
  # the options. What's left is the list of files to resize.
  optparse.parse! ARGV
  
  ensure_option_is_present options, :max_price, optparse
  ensure_option_is_present options, :bid_cost, optparse
  ensure_option_is_present options, :username, optparse
  
  url = ARGV[0]
  unless url
    puts "URL must be given"
    puts optparse
    exit 1
  end
  
  ARGV.clear
  
  if options[:username]
    print "Auction site password:"
    options[:password] = gets.chomp
  end
  
  $log = Logger.new(STDOUT)
  $log.level = options[:verbose] ? Logger::DEBUG : Logger::INFO

  $log.debug "Verbose logging turned on" if $log.debug?
  
  [url, options]
end

def ensure_option_is_present(options, name, parser)
  if !options.has_key? name
    puts "Option #{name} is required"
    puts parser
    exit 1
  end
end

url, options = parse_command_line
AutoBidder.new(url, options).start