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
    
    override func viewDidLoad() {
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoViewerTableViewController.handleFetchDataDone(notification:)), name: Notification.Name(PhotoViewerConstants.kNotificationFetchedPhotosDone), object: nil)
    }
    
    func handleFetchDataDone(notification: Notification){

        print("now can I fetch data")
        self.fetchData()
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
        if let thumbnailUrlString = photoObject.thumbnailUrlString {
            manager.fetchImage(urlString: thumbnailUrlString) { (image) in
                cell.imageView?.image = image
                cell.textLabel?.text = photoObject.title
            }
        }

        return cell
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
}

