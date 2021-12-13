//
//  ViewController.swift
//  CoreDataBucketList
//
//  Created by Safa Falaqi on 13/12/2021.
//

import UIKit
import CoreData

class BucketListViewController: UITableViewController,AddItemTableViewControllerDelegate {
    
    var items = [BucketListItem]()

    let manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].text!
        
        return cell
        
    }
    //here indexPath will be the sender
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "ItemSegue", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        manageObjectContext.delete(item)
        saveContext()
//        do {
//            try manageObjectContext.save()
//        }catch{
//            print("\(error)")
//        }
        
        items.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ItemSegue", sender: sender)
    }
    
    
    //we only need one segue in here and based on the sender we identify whether add or edit
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if sender is UIBarButtonItem{
            let navigationController = segue.destination as! UINavigationController
            let addItemTabelController = navigationController.topViewController as! AddItemTableViewController
            addItemTabelController.delegate = self
        }else if sender is NSIndexPath{
            let navigationController = segue.destination as! UINavigationController
            let addItemTabelController = navigationController.topViewController as! AddItemTableViewController
            addItemTabelController.delegate = self
            
           let indexPath = sender as! NSIndexPath
            let item = items[indexPath.row]
            addItemTabelController.item = item.text!
            addItemTabelController.indexPath = indexPath
            
        }
    }
    
    func fetchAllItems(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BucketListItem")
        do{
            let result = try manageObjectContext.fetch(request)
            items = result as! [BucketListItem]
        }catch{
            print("\(error)")
        }
        
    }
    func cancelButtonPressed(by controller: AddItemTableViewController) {
       dismiss(animated: true)
    }
    
    func itemSaved(by controller: AddItemTableViewController, with text:String, at indexPath:NSIndexPath?) {
        if let ip = indexPath{
            let item = items[ip.row]
            item.text = text
        }else{
            let item = NSEntityDescription.insertNewObject(forEntityName: "BucketListItem", into: manageObjectContext) as! BucketListItem
            item.text = text
            items.append(item)
        }
        saveContext()
//        do {
//            try manageObjectContext.save()
//        }catch{
//            print("\(error)")
//        }
        
        tableView.reloadData()
        dismiss(animated: true)
    }
    

}
