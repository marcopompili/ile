local rss = require("./rss")

local hackfeed = rss.new("Hackernews", "https://hnrss.org/newest")

hackfeed:poll()

print(hackfeed)
