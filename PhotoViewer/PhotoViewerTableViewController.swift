//
//  PhotoViewerTableViewController.swift
//  PhotoViewer
//
//  Created by Mansoor Naseem on 6/14/17.
//  Copyright © 2017 Mansoor Naseem. All rights reserved.
//

import UIKit

class PhotoViewerTableViewController: UITableViewController {
    
    var items = ["one", "two", "three", "four", "five" , "six", "seven", "eight" , "nine" , "ten" , "eleven" , "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen"]
    
    override func viewDidLoad() {
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = "Photos"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

}

