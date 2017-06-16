//
//  PhotoViewerTableViewController.swift
//  PhotoViewer
//
//  Created by Mansoor Naseem on 6/14/17.
//  Copyright © 2017 Mansoor Naseem. All rights reserved.
//

import UIKit
import PhotoDataManager

class PhotoViewerTableViewController: UITableViewController {
    
    public var photoArray: Array<PhotoDataObject> = Array<PhotoDataObject>()
    
    var refreshInProgress = false
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoViewerTableViewController.handleFetchDataDone(notification:)), name: Notification.Name(PhotoViewerConstants.kNotificationFetchedPhotosDone), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoViewerTableViewController.handleFetchDataFailed(notification:)), name: Notification.Name(PhotoViewerConstants.kNotificationFetchedPhotosFailed), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoViewerTableViewController.handleFetchedPhotoArrayFailure(notification:)), name: Notification.Name(PhotoDataManagerConstants.kNotificationFetchedPhotoArrayFailure), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoViewerTableViewController.handleFetchedCursorPhotoArrayFailure(notification:)), name: Notification.Name(PhotoDataManagerConstants.kNotificationFetchedCursorPhotoArrayFailure), object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = "Photos"
        
        fetchData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        let photoObject = photoArray[indexPath.row]
        let manager = PhotoDataManager.sharedInstance
        cell.textLabel?.lineBreakMode = .byWordWrapping;
        cell.textLabel?.numberOfLines = 0;
        if let thumbnailUrlString = photoObject.thumbnailUrlString {
            manager.fetchImage(urlString: thumbnailUrlString) { (image) in
                cell.imageView?.image = image
                if let photoId = photoObject.feedObjectId, let photoTitle = photoObject.title, let albumId = photoObject.albumId {
                    cell.textLabel?.text = "ID: \(String(describing: photoId)) - Album ID: \(albumId). \(String(describing: photoTitle))"
                }
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "PhotoViewDetailViewController") as! PhotoViewDetailViewController
        detailViewController.photoObject = photoArray[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        guard refreshInProgress == false else {
            return
        }
        refreshInProgress = true
        let manager = PhotoDataManager.sharedInstance
        manager.fetchPhotoDataWithCursor { (cursorArray, error) in
            
            if let error = error {
                //self.handleFetchedPhotoArrayFailure(notification: nil)
            }
            self.photoArray = cursorArray!
            self.tableView.reloadData()
            sender.endRefreshing()

            sleep(UInt32(1.0))
            self.refreshInProgress = false
        }
    }
    
}

extension PhotoViewerTableViewController {

    fileprivate func fetchData() {
        let manager = PhotoDataManager.sharedInstance
        manager.fetchPhotoDataWithCursor { (cursorArray, error) in
            self.photoArray = cursorArray!
            self.tableView.reloadData()
        }
    }
    
    func handleFetchDataDone(notification: Notification){
        self.fetchData()
    }
    
    func handleFetchDataFailed(notification: Notification){

        // Show alert and ask user to pull to refresh
        let title = NSLocalizedString("No Data", comment: "")
        
        let message = NSLocalizedString("There is no data. Please pull to refresh. Thanks.", comment: "")
        
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: {(alert: UIAlertAction!) in
            // Custom code after tapping OK
        })
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(action)
        
        self.present(alertController, animated: true) {
            
        }
    }
    
    //kNotificationFetchedPhotoArrayFailure
    func handleFetchedPhotoArrayFailure(notification: Notification){

        
        let title = NSLocalizedString("Error", comment: "")
        let message = NSLocalizedString("Error fetching all data,", comment: "")
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: {(alert: UIAlertAction!) in
            // Custom code after tapping OK
            self.refreshControl?.endRefreshing()
        })
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(action)
        
        self.present(alertController, animated: true) {
            
        }

    }
    
    //kNotificationFetchedCursorPhotoArrayFailure
    func handleFetchedCursorPhotoArrayFailure(notification: Notification){
        
        self.refreshControl?.endRefreshing()
        let title = NSLocalizedString("Error", comment: "")
        let message = NSLocalizedString("Error fetching recent data,", comment: "")
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: {(alert: UIAlertAction!) in
            // Custom code after tapping OK
        })
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(action)
        
        self.present(alertController, animated: true) {
            self.refreshControl?.endRefreshing()
        }

    }
}

