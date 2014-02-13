mongoose = require "mongoose"
require "express-mongoose"

#Exports
module.exports = ->
    mongoose.model "User", require "../models/user/user"
