# MoneyApp

This is a light version of the moneybox app using the moneybox test/staging environment written in Swift 4. It allows the user to login and view their current products along with their current respective balances. They can then drill down in to the details of each account to view different metrics, for example the ISA account details will show the user their remaining annual allowance.

### Authorisation
Each logged in user is authorised using a token with a sliding expiration of 5 mins. The app therefore needs to track when this token expires in order to invalidate the token currently being used and log the user out. A `refresh token` endpoint might be useful however considering the way the app is likely used, a user probably wouldn't be on a screen for more than 5 minutes without making any additional network calls.

## Installation Instructions
1. Clone repository to local directory
2. Run `pod install` in terminal to install Cocoapods
3. Open MoneyApp.xcworkspace in Xcode
4. Run project
