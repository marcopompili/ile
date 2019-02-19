local http = require "socket.http"
local https = require "ssl.https"

local feed = {
   name = "",
   url = "",
   debug = false,
   cache = {}
}

function feed.tag_match(tagname)
   return "<" .. tagname .. "[^>]*>(.-)</" .. tagname .. ">"
end

function feed:parse(body)
   local i = 0
   for item in string.gmatch(body, feed.tag_match("item")) do
      feed.cache[i] = {
	 title = string.match(item, feed.tag_match("title")),
	 date = string.match(item, feed.tag_match("pubDate")),
	 description = string.match(item, feed.tag_match("description"))
      }
      i = i + 1
   end
end

function feed:poll()
   local res, code, headers, status = https.request(feed.url)
   if code == 200 then
      self:parse(res)
   else
      return false
   end
end

function feed:debug(state)
   self.debug = state
end

local mt = {}

function mt.__call(...)
   return feed.new(...)
end

function mt.__tostring()
   local str = feed.name .. " feed from: " .. feed.url .. "\n---\n"
   
   for k, v in pairs(feed.cache) do
      str = str .. "TITLE: " .. v.title .. "\n" ..  "DATE: " .. v.date .. "\n" .. "DESCRIPTION: "  .. v.description .. "\n---\n"
   end

   return str
end

function feed.new(name, url)
   feed.name = name
   feed.url = url
   return setmetatable(feed, mt)
end

return feed
