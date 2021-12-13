//
//  AddItemTableViewController.swift
//  CoreDataBucketList
//
//  Created by Safa Falaqi on 13/12/2021.
//

import UIKit

class AddItemTableViewController: UITableViewController {

    var item:String?
    var indexPath:NSIndexPath?
    
    @IBOutlet weak var itemText: UITextField!
    weak var delegate:AddItemTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemText.text = item
    }

    @IBAction func savedButtonPressed(_ sender: UIBarButtonItem) {
        let text = itemText.text!
        delegate?.itemSaved(by: self,with: text, at: indexPath)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.cancelButtonPressed(by: self)
    }
    
}
