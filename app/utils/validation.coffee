fs = require("fs")

###
Node validator
Extended to include inArray(arr) validation
@return {Class}  Validator class
###
exports.validator = ->
  Validator = require("validator").Validator
  Validator::error = (msg) ->
    @_errors.push msg
    this

  Validator::getErrors = ->
    errors = @_errors
    @_errors = []
    errors

  Validator::inArray = (arr) ->
    @error @str + " is not a valid option"  if arr.indexOf(@str) < 0
    this #Allow method chaining
  Validator::stringWithSpace = (str) ->
    /^([a-zA-Z]){1}([ a-zA-Z0-9]){0,48}$/
  Validator::string = (str) ->
    /^([a-zA-Z]){1}([a-zA-Z0-9]){0,48}$/
  Validator::email = (str) ->
    /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/ 

  validator = new Validator()
  validator
 
###
Reads disposable email file and validates email
@param  {[type]}   email    [description]
@param  {Function} callback [description]
@return {[type]}            [description]
###
exports.disposableEmail = (email, cb) ->
  badEmailsTxt = "domains.txt"
  badEmails = []
  emailParts = email.split("@")
  array = fs.readFileSync(badEmailsTxt).toString().split("\n")
  disposable = true
  for i of array
    badEmails.push array[i]  if array[i].charAt(0) and array[i].charAt(0) isnt "#"
  disposable = false  if badEmails.indexOf(emailParts[1]) < 0
  cb null, disposable