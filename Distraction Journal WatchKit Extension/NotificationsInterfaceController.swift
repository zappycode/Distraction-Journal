//
//  NotificationsInterfaceController.swift
//  Distraction Journal
//
//  Created by Nick Walter on 10/6/16.
//  Copyright © 2016 Zappy Code. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications

class NotificationsInterfaceController: WKInterfaceController {
    
    @IBOutlet var picker: WKInterfacePicker!
    
    var hours = 1
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        var pickerItems : [WKPickerItem] = []
        
        for hour in 1...24 {
            
            let pickerItem = WKPickerItem()
            if hour == 1 {
                pickerItem.title = "\(hour) hour"
            } else {
                pickerItem.title = "\(hour) hours"
            }
            
            pickerItems.append(pickerItem)
        }
        
        picker.setItems(pickerItems)
        
        
        if let delegate = WKExtension.shared().delegate as? ExtensionDelegate {
            delegate.askForNotificationPermission()
        }
        
    }
    
    @IBAction func pickerChanged(_ value: Int) {
        hours = value + 1
    }
    
    @IBAction func startTapped() {
        
        for hour in 1...hours {
            
            let content = UNMutableNotificationContent()
            content.body = "Are you still working?"
            content.categoryIdentifier = "workingCategory"
            
            let seconds = 60 * 60 * hour
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
            
            let request = UNNotificationRequest(identifier: NSUUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if error != nil {
                    print("There was an error")
                } else {
                    print("There was no error")
                }
            }
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print(requests.count)
        }
        
        pop()
        
    }
    
    @IBAction func deleteTapped() {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print(requests.count)
        }
        
        pop()
        
    }
}
