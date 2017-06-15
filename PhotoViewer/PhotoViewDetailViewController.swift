//
//  PhotoViewDetailViewController.swift
//  PhotoViewer
//
//  Created by Mansoor Naseem on 6/15/17.
//  Copyright © 2017 Mansoor Naseem. All rights reserved.
//

import UIKit
import PhotoDataManager

class PhotoViewDetailViewController: UIViewController {
    
    var photoObject:PhotoDataObject?
    
    @IBOutlet weak var photoMainImageView:UIImageView!
    @IBOutlet weak var photoIdLabel:UILabel!
    @IBOutlet weak var albumIdLabel:UILabel!
    @IBOutlet weak var photoTitleLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let photoObject = photoObject, let photoId = photoObject.feedObjectId, let photoTitle = photoObject.title, let albumId = photoObject.albumId {
            photoIdLabel.text = "ID: \(String(describing: photoId))"
            albumIdLabel.text = "Album ID: \(albumId). \(String(describing: photoTitle))"
            photoTitleLabel.text = photoTitle
            if let urlString = photoObject.urlString {
                let manager = PhotoDataManager.sharedInstance
                manager.fetchImage(urlString: urlString) { (image) in
                    self.photoMainImageView.image = image
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
