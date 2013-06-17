mongoose = require "mongoose"

inviteSchema = new Schema
  email:
    type: String
  name:
    type: String
  surname:
    type: String
  status:
    type: String
    enum: ["pending", "accepted"]
    default: "pending"
  clicks:
    type: Number
    default: 0
  created_at:
    type: Date
    default: Date.now

inviteSchema.methods.send = ()->
  options =
    to:
      email: @email
      name: @name
      surname: @surname
    subject: "Invite from ZMGC"
    template: "invite"
  Emailer = require "../utils/emailer"
  emailer = new Emailer options, @
  emailer.send (err, result)->
    if err
      console.log err

Invite = mongoose.model("Invite", inviteSchema)
exports = module.exports = Invite