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
                if let photoId = photoObject.feedObjectId, let photoTitle = photoObject.title {
                    cell.textLabel?.text = "\(String(describing: photoId)). \(String(describing: photoTitle))"
                }
            }
        }


        return cell
    }
    
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
    
        guard refreshInProgress == false else {
            return
        }
        refreshInProgress = true
        let manager = PhotoDataManager.sharedInstance
        manager.fetchPhotoDataWithCursor { (cursorArray, error) in
            
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
        print("trying to fetch data")
        let manager = PhotoDataManager.sharedInstance

        
        manager.fetchPhotoDataWithCursor { (cursorArray, error) in
            
            self.photoArray = cursorArray!
            self.tableView.reloadData()
        }
        
    }
    
    func handleFetchDataDone(notification: Notification){
        
        print("now can I fetch data")
        self.fetchData()
    }
}

