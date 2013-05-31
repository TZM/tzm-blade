# /src/utils/emailer.coffee

config = require "../config/config"
emailer = require("nodemailer")
fs      = require("fs")
_       = require("underscore")

class Emailer

  options: {
    #template: 
    #to: 
      #name:
      #surname:
      #email:
  }
  data: {
    #pass: 
    #link:
  }
  # Define attachments here
  attachments: [
    fileName: "logo.png"
    filePath: "./public/images/email/logo.png"
    cid: "logo@zmgc.net"
  ]

  constructor: (@options, @data)->
  
  send: (callback)->
    console.log @data
    html = "follow this <a href=#{@data.link}>link</a><br> to reset your password<img class='cid:logo@zmgc.net'></img>" if @options.template is 'reset'
    html = "follow this <a href=#{@data.link}>link</a><br> to verify your email anddress and create account<br><img class='cid:logo@zmgc.net'></img>" if @options.template is "activation"

    #FIXME doesnt work getHtml() cannot put @data to template, unexpected token '=' at (<h3><%= pass %></h3>)
    #html = @getHtml(@options.template, @data)

    attachments = @getAttachments(html)
    messageData =
      to: "'#{@options.to.name} #{@options.to.surname}' <#{@options.to.email}>"
      from: "'ZMGC.NET'"
      subject: @options.subject
      html: html
      generateTextFromHTML: true
      attachments: attachments
    transport = @getTransport()
    transport.sendMail messageData, callback

  getTransport: ()->
    emailer.createTransport "SMTP",
      service: "Gmail"
      auth:
        user: config.SMTP.user,
        pass: config.SMTP.pass

  getHtml: (templateName, data)->
    templatePath = "./views/emails/#{templateName}.html"
    templateContent = fs.readFileSync(templatePath, encoding="utf8")
    _.template templateContent, data, {interpolate: /\{\{(.+?)\}\}/g}

  getAttachments: (html)->
    attachments = []
    for attachment in @attachments
      attachments.push(attachment) if html.search("cid:#{attachment.cid}") > -1
    attachments

exports = module.exports = Emailer
