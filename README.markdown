# AutoBidder: Win without trying

This library places bids on online auction sites for you automatically while you do other important things, like walking your dog.

## Installing

    gem install auto-bidder
    
## Usage

AutoBidder is intended to be ran from the command line:

    Chad-Boyds-iMac:~ cboyd$ auto-bidder --help
    Usage: auto-bidder [options] URL
        -v, --verbose                    Be more verbose
        -x, --max-price PRICE            Maximum price you are willing to pay for the auction item
        -n, --min-price [PRICE]          Minimum price the auction item must reach before bidding starts
        -c, --bid-cost COST              How much each bid actually costs you
        -u, --username USER              Username of your account for the auction site
        -s, --bid-seconds [SECONDS]      How many seconds remaining on the clock before a bid is placed
        -h, --help                       Display this screen
        
It is a gem, though.  So I suppose you could use it within your own project.

AutoBidder works by utilizing [Watir](http://watir.com), an open-source library for automating web browsers.  The AutoBidder library will launch a Safari window and connect to the URL you supply on the command line.

    Chad-Boyds-iMac:~ cboyd$ auto-bidder --max-price 130 --min-price 10 --bid-cost .75 --verbose -u "hoverlover@gmail.com" http://bigdeal.com/auctionid/ipad/ipad-64gb-wi-fi/28397
    Auction site password:
    D, [2010-07-10T09:50:56.283923 #35283] DEBUG -- : Verbose logging turned on
    D, [2010-07-10T09:51:12.010979 #35283] DEBUG -- : 07/10/2010 09:51:12 - 00:00:18, $9.95
    D, [2010-07-10T09:51:23.002764 #35283] DEBUG -- : 07/10/2010 09:51:23 - 00:00:07, $9.95
    
Above you can see where auto-bidder has been started and some of the output from the program.  Using the options above, bidding will not commence until the auction price has reached at least 10.00 and will cease when the price has reached 130.01.  `--bid-secs` was not specified, so it defaults to 1 second on the auction clock before a bid will be placed.  As you can see, when the `--verbose` option is specified the auction clock and current price will be output every 10 seconds.

## Notes

### Safari Only

**Watir** supports IE, Firefox, Safari and Chrome.  AutoBidder uses Safari only, however.  Feel free to fork this project and implement any or all of the other browsers if you wish.

### Supported Auction Sites

For now, only [BigDeal.com](http://www.bigdeal.com) is the only auction site supported.  However, AutoBidder was built from the ground up to support multiple auction sites.  Feel free to fork away and implement others.

## TODO

Write some specs!