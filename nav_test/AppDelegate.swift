//
//  AppDelegate.swift
//  nav_test
//
//  Created by mac on 9/14/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import GoogleMaps
import Parse
import Bolts



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var color = UIColor(red: 255/255, green: 167/255, blue: 18/255, alpha: 1.0)


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyDoYtGolwmkFa9sgSScFMB2TLOgS7LmK2c")
        
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("RWaJpkpPlTsVYwv6i8f0X0qJIKyEfHw8oGwxEERU",
            clientKey: "rkPZ4oQS4kmxSQIQ6D6QWYvB1aQryLqhLr5WTpNY")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
//        let userNotificationTypes = ([UIUserNotificationType.Alert, UIUserNotificationType.Badge,UIUserNotificationType.Sound]);
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced
            // in iOS 7). In that case, we skip tracking here to avoid double
            // counting the app-open.
            let oldPushHandlerOnly = !self.respondsToSelector(Selector("application:didReceiveRemoteNotification:fetchCompletionHandler:"))
            let noPushPayload: AnyObject? = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey]
            if oldPushHandlerOnly || noPushPayload != nil {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        
        //Receiving notifications when the app is closed
        // Extract the notification data
//        if let notificationPayload = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
//            
//            // Create a pointer to the Photo object
//            let photoId = notificationPayload["p"] as? NSString
//            let targetPhoto = PFObject(withoutDataWithClassName: "Photo", objectId: "xWMyZ4YEGZ")
//            
//            // Fetch photo object
//            targetPhoto.fetchIfNeededInBackgroundWithBlock {
//                (object: PFObject?, error:NSError?) -> Void in
//                if error == nil {
//                    // Show photo view controller
//                    let viewController = PhotoVC(photo: object);
//                    self.navController.pushViewController(viewController, animated: true);
//                }
//            }
//        }
        
        

        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        UINavigationBar.appearance().barTintColor = color
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        UISegmentedControl.appearance().tintColor = color
        
        let tabBarController = self.window?.rootViewController as! UITabBarController
        UITabBar.appearance().tintColor = UIColor.grayColor()
        UITabBar.appearance().selectedImageTintColor = color
        
        
        
        return true
    }
    
    //Push notifications
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
            //Process the deviceToken and send it to your server
        // Store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
        
    }
    //Push notifications
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
            //Log an error for debugging purposes, user doesn't need to know
            NSLog("Failed to get token; error: %@", error) 
    }
    
//    //Push notifications
//    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
//        // display the userInfo
//        print("Got a message from the server")
//        if let notification = userInfo["aps"] as? NSDictionary,
//            let alert = notification["alert"] as? String {
//                var localNotification:UILocalNotification = UILocalNotification()
//                print("Here is the notification sent from server: ", notification)
//                localNotification.alertAction = alert
//                localNotification.alertBody = "Woww it works!"
////                localNotification.fireDate = NSDate(timeIntervalSinceNow: 30)
//                localNotification.category = "INVITE_CATEGORY";
//                localNotification.accessibilityActivate();
//                
//                // call the completion handler
//                // -- pass in NoData, since no new data was fetched from the server.
//                completionHandler(UIBackgroundFetchResult.NoData)
//        }
//    }
    
    
    
//    //System Version
//    func getMajorSystemVersion() -> Int {
//        var version = UIDevice.currentDevice().systemVersion;
//        
//        return String(Array(UIDevice.currentDevice().systemVersion)[0]).toInt()!
//    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

