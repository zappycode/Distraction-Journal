//
//  ExtensionDelegate.swift
//  Distraction Journal WatchKit Extension
//
//  Created by Nick Walter on 10/5/16.
//  Copyright © 2016 Zappy Code. All rights reserved.
//

import WatchKit
import WatchConnectivity
import UserNotifications

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate, UNUserNotificationCenterDelegate {

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        
        if WCSession.isSupported() {
            WCSession.default().delegate = self
            WCSession.default().activate()
        }
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompleted()
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompleted()
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompleted()
            default:
                // make sure to complete unhandled task types
                task.setTaskCompleted()
            }
        }
    }
    
    // Watch Connectivity
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if error != nil {
            print("Error: \(error)")
        } else {
            print("Ready to talk with iOS device")
        }
    }
    
    // Notification Fun
    
    func askForNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (authBool, error) in
            if authBool {
                
                let yesAction = UNNotificationAction(identifier: "yesAction", title: "Yes", options: [])
                
                let noAction = UNNotificationAction(identifier: "noAction", title: "No", options: [.foreground])
                
                let category = UNNotificationCategory(identifier: "workingCategory", actions: [yesAction, noAction], intentIdentifiers: [], options: [])
                
            
                UNUserNotificationCenter.current().setNotificationCategories([category])
                
                UNUserNotificationCenter.current().delegate = self
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "noAction" {
            WKExtension.shared().rootInterfaceController?.popToRootController()
            WKExtension.shared().rootInterfaceController?.pushController(withName: "distractions", context: nil)
        }
    }

}
