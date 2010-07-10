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

## Notes

### Safari Only

**Watir** supports IE, Firefox, Safari and Chrome.  AutoBidder uses Safari only, however.  Feel free to fork this project and implement any or all of the other browsers if you wish.

### Supported Auction Sites

For now, only [BigDeal.com](http://www.bigdeal.com) is the only auction site supported.  However, AutoBidder was built from the ground up to support multiple auction sites.  Feel free to fork away and implement others.

## TODO

Write some specs!