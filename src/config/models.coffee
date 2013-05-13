mongoose = require("mongoose")
require "express-mongoose"


#Exports
module.exports = ->
  
  #  Load User model
  mongoose.model "User", require("../models/user/user")