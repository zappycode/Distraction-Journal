//
//  ViewController.swift
//  Distraction Journal
//
//  Created by Nick Walter on 10/5/16.
//  Copyright © 2016 Zappy Code. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    var distractions : [Distraction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        table.dataSource = self
        table.delegate = self
        
        getDistractions()
        
        NotificationCenter.default.addObserver(forName: Notification.Name("weGotInfo"), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                self.getDistractions()
            }
        }
    }
    
    func getDistractions() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = Distraction.fetchRequest() as NSFetchRequest<Distraction>
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            distractions = try context.fetch(fetchRequest) as [Distraction]
            print(distractions)
        } catch {}
        
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return distractions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let distraction = distractions[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d h:mma"
        
        cell.textLabel?.text = "\(distraction.name!) - \(formatter.string(from: distraction.date as! Date))"
        
        return cell
    }
    
}

