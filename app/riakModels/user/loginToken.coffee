mongoose = require("mongoose")
Schema = mongoose.Schema
uuid = require("uuid-v4")

loginTokenSchema = new Schema(
  email:
    type: String

  series:
    type: String

  token:
    type: String

  ip:
    type: String

  created:
    type: Date

  userAgent: {}
  location: {}
)

#Indexes
loginTokenSchema.index
  email: 1
  series: 1
  token: 1

loginTokenSchema.virtual("id").get ->
  @_id.toHexString()

loginTokenSchema.virtual("cookieValue").get ->
  JSON.stringify
    email: @email
    series: @series
    token: @token

loginTokenSchema.pre "save", (next) ->
  
  # Automatically create the token
  @token = uuid()
  @created = new Date()
  next()

###
LoginToken model
@type {Model}
###
module.exports = mongoose.model("LoginToken", loginTokenSchema)