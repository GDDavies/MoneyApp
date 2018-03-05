# MoneyApp

This is a light version of the moneybox app using the moneybox test/staging environment written in Swift 4. It allows the user to login and view their current products along with their current respective balances. They can then drill down in to the details of each account to view different metrics, for example the ISA account details will show the user their remaining annual allowance.

### Authorisation
Each logged in user is authorised using a token with a sliding expiration of 5 mins. For each relevant network call, the app checks the response for a `401 Unauthorized` and if it is found then the user is logged out.

### Limitations/Future Improvements
There are some basic unit tests included to test the network calls to the API however in future these tests would be improved so that the resulting data from the network calls in injected. This would mean that the tests wouldn't require a valid auth token - currently they do and so only unauthenticated network calls are currently tested.

The primary goal of the tests should be to test how the app responds to the received data however as they currently stand they also test the api endpoints which is outside the scope of the tests. If there are to be lots of tests then this would cause uneccessary strain on the servers. It is also not ideal to run these tests on the production environment when/if the app is eventually moved over.

## Installation Instructions
1. Clone repository to local directory
2. Run `pod install` in terminal to install Cocoapods
3. Open MoneyApp.xcworkspace in Xcode
4. Run project
