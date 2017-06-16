# PhotoViewer iOS App

### Requirements:

 * Build a simple photo viewing app for iOS
 * The deployment target must be iOS 9.0+.
 * Download and parse the JSON found at this URL:http://jsonplaceholder.typ icode.com/photos
 * Display the images found at the `thumbnailUrl` key for each node in the JSON, in either a UITableView or UICollectionView.
 *  When tapped, display the image found at the `url` key in a detail view for each item in the UITableView or UICollectionView.
 *  Write unit tests where appropriate.
 *  Add the ability for the user to pull to refresh your initial list view.


### Architecture:

* PhotoViewer App is built using UINavigation View Controller
* PhotoViewerTableViewController (UITableViewController) is used to show list of photo thumbnails
* PhotoViewerDetailViewController (UIViewController) is used to show detail view of each photo item 
* PhotoViewerUITests smoke tests Table View and Detail view
* PhotoDataManager Framework built seperately to Fetch all Datata from Server, Prefetch all Thumbnail Images, fetch individual images, cache images, and fetch partial data for pagination (Pull to Refresh)
* PhotoDataManagerTests provide 100% test coverage for PhotoDataManager data fetching, parsing, provinding chunks of larfer data, prefecthing all thumbnails, and fetch individual images and caching
* AlamoFire and Object Mapper are used together to fetch data and parse JSON to swift structs
* KingFisher is used to prefetch all thumbnail images and cache them
* KingFisher is also used to download each larger image on demand and cache them as well


### Installation & Software:

* At root of PhotoViewer App run>> pod install
* If you don't have cocoapods please download the gem
* Open PhotoViewer.xcworkspace in XCode 8 and iOS 10.3 (Swift 3)
* Run the app using XCode 
* UITests and Framework Tests can be run using the PhotoViewer Scheme
* Framework Tests can be run independently using the PhotoDataManagerScheme

### Functionality:

* PhotoViewer App fetches data at start of the App
* PhotoViewerTableViewController invokes initial data to be fetched from server using PhotoDataManager
* PhotoViewerTableViewController then loads a smaill chunk of that data into the table. FetchSize can be configured to smaller or larger amount
* At the same time of initial start all thumbnails are fetched in chunks to not put heavy load on the App
* Pull to Refresh loads data in small configurable chunks and is in reverse order
* When a row of photo item is tapped a detail photo screen is pushed on Navigation stack
* Back button is provided to go back to PhotoViewerTableViewController
* PhotoViewerTableViewer also has a refresh button item in the top left corner that will fetch data from server again


