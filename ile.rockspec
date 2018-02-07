package = "ile"
version = "git"
source = {
   url = "https://github.com/marcopompili/ile.git",
   tag = "git"
}
description = {
   summary = "Layout, widgets and utilities for Awesome WM",
   detailed = [[
        Custom widget based on Cairo.
    ]],
   homepage = "https://github.com/marcopompili/ile",
   license = "GPL v2"
}
dependencies = {
   "lua >= 5.3",
   "awesome >= 4.0",
   "curl"
}
supported_platforms = { "linux" }
build = {
   type = "builtin",
   modules = { ile = "init.lua" }
}
