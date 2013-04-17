#
# * octodex
# * https://github.com/hemanth/octodex
# *
# * Copyright (c) 2013 Hemanth.HM
# * Licensed under the MIT license.
# 

jsdom = require("jsdom")
exports.octodex = (callback) ->
  jsdom.env "http://octodex.github.com/", ["http://code.jquery.com/jquery.js"], (errors, window) ->
    $ = window.$
    imgs = []
    $("a.preview-image > img").each ->
      imgs.push $(this).attr("data-src")

    randocat = imgs[Math.floor(Math.random() * imgs.length)]
    callback randocat  if typeof callback is "function"