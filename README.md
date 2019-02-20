# search-list
App use CocoaPods. To run the project you need to install dependencies and always open the Xcode workspace.
```
$ pod install
```
Access to Google search results is provided by free version of Google Custom Search JSON API. It has the following restrictions:

- 100 requests per day (resets at midnight Pacific Time)
- 10 results per request
- 100 first results in general

By default, number of requests is set to 10 (property countOfRequests in ViewController.swift). In the current version, app can show 1 result per request.
