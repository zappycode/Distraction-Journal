//
//  DistractionsInterfaceController.swift
//  Distraction Journal
//
//  Created by Nick Walter on 10/5/16.
//  Copyright © 2016 Zappy Code. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class DistractionsInterfaceController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    
    var distractions = ["YouTube", "Twitter", "Day Dreaming", "Snapchat", "Food", "Hulu"]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        table.setNumberOfRows(distractions.count, withRowType: "distractionrow")
        
        for index in 0..<distractions.count {
            if let row = table.rowController(at: index) as? DistractionRowController {
                row.label.setText(distractions[index])
            }
        }
        
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let distraction = distractions[rowIndex]
        let date = Date()
        
        WCSession.default().transferUserInfo(["date":date, "name":distraction])
        
        pop()
    }
}
