module.exports =
  
  #validation
  VALIDATE_FIRST_NAME: "First Name is required"
  VALIDATE_LAST_NAME: "Last Name is required"
  VALIDATE_EMAIL: "Valid email required"
  VALIDATE_PASSWORD: "Password must be between 6 and 128 characters"
  VALIDATE_GENDER: "Gender is required"
  VALIDATE_TERMS: "Please confirm that you agree to the Terms and Conditions"
  DISPOSABLE_EMAIL: "We are a community here. Please do not use disposable email addresses"
  
  #registration
  USER_REGISTERED_AND_ACTIVE: "The email address entered is already registered. <br>Please <a href='/login'>Login</a>"
  USER_REGISTERED_NOT_ACTIVE: "The email address entered is not active. <br><a href='/user/activate'>Resend activation link</a>"
  ACTIVATION_LINK_GENERATED: "Please check your email for your account activation link"
  INVALID_ACTIVATION_KEY: "Cannot find user for selected activation link - did you try type in in? Click on the link in your email again or request a new one below"
  ACTIVATION_KEY_USED: "Your activation link has already been used. Please login below"
  DATABASE_USER_NOT_SAVED: "The user registration failed. Please try again."
  ACCOUNT_SUCCESSFULLY_ACTIVATED: "Account Successfully Activated"
  
  # Login
  USER_NOT_REGISTERED: "The email address entered is not registered. <br>Please <a href='/signup'>Sign Up</a>"
  INCORRECT_PASSWORD: "The password entered is incorrect. <br><a href='/forgotPassword'>Forgot Password</a>"
  missingLoginCredentials: "Email and Password are required"
  MAX_LOGIN_ATTEMPTS: "Too many login attempts. Try again in 5 minutes"
  USER_DEACTIVATED: "The email address entered is associated with a deactivated account. <br><a href='/user/activate'>Re-activate account</a>"
  
  # Forgot Password
  MISSING_EMAIL: "Email is required"
  PASSWORD_RESET_KEY_NOT_GENERATED: "The password reset link could not be generated at this time. Please try again"
  INVALID_PASSWORD_RESET_KEY: "Cannot find user for selected password reset link - did you try type in in? Click on the link in your email again or request a new one below"
  PASSWORD_RESET_KEY_USED: "Your password reset link has already been used. Please request a new one below"
  PASSWORD_RESET_KEY_EXPIRED: "Your password reset link has expired."
  PASSWORDS_DO_NOT_MATCH: "The passwords that you entered do not match. Please try again"
  PASSWORD_CHANGE_FAILED: "The password change did not save. Please try again"
  PASSWORD_CHANGE_SUCCESSFUL: "Password Successfully Changed"
  
  # Account Messages
  ACCOUNT_UPDATED: "Account successfuly updated"
  ACCOUNT_DEACTIVATED: "Account successfully deactivated"