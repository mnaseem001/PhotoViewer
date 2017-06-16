//
//  AppDelegate.swift
//  PhotoViewer
//
//  Created by Mansoor Naseem on 6/13/17.
//  Copyright © 2017 Mansoor Naseem. All rights reserved.
//

import UIKit
import PhotoDataManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("didFinishLaunchingWithOptions")

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("applicationDidBecomeActive")
        // Use the PhotoDataManager Package
        // Get sharedInstance (a singleton)
        // - use the server url dependency for this app
        // After fetch is done successful or failed send notification
        // Prefect all thumbnail images
        // - Takes rougly over 67 seconds to download 5000 thumbnail images on a very good WIFI
        // - NOTE: Prefetch may need be turned off in case network issue
        let manager = PhotoDataManager.sharedInstanceWith(urlString: PhotoViewerConstants.kPhotoServerUrlString)
        manager.fetchPhotoData { (photoDataArray, error) in
            
            if error == nil {
                NotificationCenter.default.post(name: Notification.Name(PhotoViewerConstants.kNotificationFetchedPhotosDone), object: nil)
                // Prefetch All images
                manager.loadImages {
                    // Done fetching.
                    print("done fetching")
                }
                
            } else {
                
                self.showFetchDataError(error: error)
                NotificationCenter.default.post(name: Notification.Name(PhotoViewerConstants.kNotificationFetchedPhotosFailed), object: nil)
                
            }
            
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    fileprivate func showFetchDataError (error: Error?)  {
        
        let title = NSLocalizedString("Fetching Data Error", comment: "")
        var errorString = "No Error Returned."
        
        if let error = error {
            errorString = error.localizedDescription
        }
        
        let message = NSLocalizedString("Something went wrong fetching the data. Maybe you are not connected. Exact Error from the call: \(errorString)", comment: "")
        
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: {(alert: UIAlertAction!) in
            // Custom code after tapping OK
        })
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(action)
        
        self.window?.rootViewController?.present(alertController, animated: true) {
            
        }
        
    }

}

