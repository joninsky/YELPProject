/*:
 
 # Introduction
 
 Greetings! Please review this document and complete the following tasks. The goal of this exercise is to touch on various aspects of everyday iOS
 coding here at Weedmaps.
 
 You may spend no longer than 1 week to return back.
 
 You may go as deep as you like with your solution, the only ask is to meet the requirements. In general we want to get a sense of how well you understand iOS project development.
 
 
 
 
 # Requirements
 
 ## Overview

 - A project template has been provided for you which you should already have if you are reading this.
 - Build a Universal (iPhone, iPad) application that leverages the [Yelp API](https://www.yelp.com/developers/documentation/v3).
 We would like to see solutions making use of functional programming, types, protocols, and generics, etc.
 - Use 100% Swift if possible.
 - Avoid using 3rd party frameworks besides the networking framework provided (Alamofire). If you do decide to leverage additional 3rd party frameworks, be prepared to justify your reasoning for your decision.
 - Avoid downloading images or other assets unnecessarily. Make use of an image cache. (Show us how well you know GCD and threading)
 - Use Codable Protocol for Model Serialization. We have provided a Business.swift model, but feel free to add additional models.
 
 ## Networking
 
 - You will first need to build out the included Alamofire dependency using [CocoaPods](https://cocoapods.org/). We have already included a Podfile so you will just need to build the Pod dependency
 - We expect you to build your networking layer with scalability in mind. Try to avoid hard coded URLs when available and operate under the assumption that you could port this to a production ready application.
 
 ## Interface
 
 ![EXAMPLE](searchbar.png)
 
 - Build an interface with user submittable search query. Leverage the Yelp API w/ GPS coordinates from [CoreLocation.framework](https://developer.apple.com/documentation/corelocation).
 - Present the results in a UICollectionView.
 - There are additional instructions provided for you in the HomeViewController.swift class. When a user taps on a collection view cell, an action-sheet style UIAlertController with a choice to Cancel,
 Open in Safari, or Open in Webview. The details that you display can simply be the Yelp detail page that is likely provided for you in the initial API request.

 ![EXAMPLE](collectionview.png)
 
 - Page in additional data as the user reaches the end of the content.
 - Page in intervals of 15.
 - Cache search queries to disk and display past caches queries. The caching mechanism is up to you, just be sure that you can justify your reasoning for using a specific approach.
 
 ![EXAMPLE](recentsearches.png)
 
 - Use the BusinessCell.xib and BusinessCell.swift files to create your cell representation. The label should be able to autosize itself to include up to 3 lines of text.
 - Be sure to leverage Autolayout constraints to display your UI elements within the cell.
 - Support various width devices (should an iPad and iPhone SE share the same size traits?)
 - There is an additional FavoritesViewController.swift class that you may implement if you have additional time and want to show off more of your skills. This can simply display a UITableView or UICollectionView
 that lists the items that a user has tapped on, ranked by how often a user has viewed the details for a specific business. For example, if Joe's Pizza business detail view (either in Safari or from the WKWebView) was viewed twice via the details from the HomeViewController, and World's Best Burgers was viewed 4 times,
 the data would be displayed as World's Best Burgers in row 0 and Joe's Pizza in row 1.

 ## Tests
 
 - Add unit tests for any network interfaces created. These unit tests should make use of test data.
 - Add a minimum of 1 XCUI test testing part of your interface. There is an example test provided for you in the project template.
 
 ## Packaging
 
 - Package your source code and host in a publicly accessible git repository. [Github](https://www.Github.com), [Bitbucket](https://www.Bitbucket.com), and [Gitlab](https://www.Gitlab.com) offer free accounts.
 
 ## Notes
 
 - Avoid using 3rd party code. If you must, use [Carthage](https://github.com/Carthage/Carthage)
 - This exercise is intentionally generic to test various fundamentals. Focus on threading, access control(public/private), autolayout, error handling, etc
 - The project should compile with the current public released Xcode version and make use of build flag 'Treat Warnings as Errors'
 - Your project should not crash.
 
 
 ## Conclusion
 
 This exercise is intended to give you enough flexibility to showcase your strengths, while also touching on various fundamentals.
 
 The screenshots attached are only for reference purposes and should not be copied verbatim.

 */


/*:
 
 Jon's Notes
 
 I spent about 12 hours on the project
 
 ## Overview
 
 - Thank you
 - The app works on an iPad as well an iPhone. Constraints in story board use size calsses when needed and `UITraitCollection` when in code. A further improvement would be to make a split VC on an iPad
 - I ❤️ Swift! I'm realy excited there is a Swift with tensorflow project. If I could take a 3 months off to learn something it would be ML and computer vision stuff.
 - I'm using a framework I wrote. While I would have chosen SDWebImage to do the images I decided to make a lightweight cache on my own because you wan to see my knowledge aroud threading. What better place to show that then with images.
 - See above note.
 - Thank you for this!
 
 ## Networking
 
 - I decided to stick with the URLSession. The note in the HomeViewController -> "Be sure to leverage the searchDataTask and use it wisely!" was just waiting for me to give it a cancellable `URLSessionDataTask` to stop network requests as the user types.
 - I use protocols and generics to make connecting to and requesting from an API scalable. The core protocols live in the Protocols folder and are called `Authorization`, `APIDefinition`, and `GraphQLRequest`
 
 ## Interface
 
 ![EXAMPLE](searchbar.png)
 
 - Done
 - Done
 - Reviewed and Considered
 - Done
 
 ![EXAMPLE](collectionview.png)
 
 - Done
 - Done
 - Saved and accessable in a view conroller when you press the bookmarks navigation item.
 
 ![EXAMPLE](recentsearches.png)
 
 - Number of lines set to 3
 - Done
 - I adjust the way the size of the cell is calculated in the collection view
 - Did not have time
 
 ## Test
 
 - Filled in the two networking test. Used Mock Data for one.
 - Wrote an XCUITest to validate that two elements are set up correctly on the HomeViewController. UI Tests are a very weak are of mine 🙁
 
 ## Packaging
 
 - Available at `git clone https://github.com/joninsky/YELPProject.git`
 
 ## Notes
 
 - No third party libraries used.
 - I have poor error handling right now. I would want to make an error parser object to get human readable strign for each error and the record and display them in a globally acccesable way. Like an alert controller that takes an error object.
 - Compiles
 - I scrolled really really fast and tapped all around. No crashes yet!!
 
 ## Jon TODO
 
 - Review Access control of objects
 - Make comments
 - Write more tests
 - Refactor Home View Controller
 
 
 ## Jon other thoughts
 
 - I liked the project and chose the GraphQL API so I could learn something new. (Making GraphQL requests with URLSession)
 - UITest were really weak for me. I need to improve here.
 - I would love to spend more time on UI. I hit a wall of time and had some other things for my current job come up.
 
 
 */
