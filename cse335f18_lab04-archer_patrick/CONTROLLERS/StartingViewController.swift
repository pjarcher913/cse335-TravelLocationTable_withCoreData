//
//  ViewController.swift
//  cse335f18_lab04-archer_patrick
//
//  Created by Patrick Archer on 9/27/18.
//  Copyright © 2018 Patrick Archer - Self. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class StartingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    var counter = 1

    /*
    // object instance of location object that has an array of locations
    // and the section headers for the location table
    var myLocList:locations =  locations()
    
    // dictionary with section headers as a key and location object as a value
    var locList = [String: [location]]()
    */
 
    // outlet for location table in main view
    @IBOutlet weak var locTable: UITableView!
    
    /*==========================================================*/
    // configure CoreData utilization
    
    // handler to the managege object context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //this is the array to store location entities from the coredata
    var fetchResults = [LocationEntity]()
    
    // func to handle when fetching record data from CoreData
    func fetchRecord() -> Int {
        // Create a new fetch request using the LocationEntity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationEntity")
        let sort = NSSortDescriptor(key: "cdName", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        var x = 0
        // Execute the fetch request, and cast the results to an array of LocationEntity objects
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [LocationEntity])!
        
        x = fetchResults.count
        
        print("fetchResults.count = \(x)")    // debug
        
        // return how many entities in the coreData
        return x
        
    }
    
    func updateLastRow() {
        let indexPath = IndexPath(row: fetchResults.count - 1, section: 0)
        self.locTable.reloadRows(at: [indexPath], with: .automatic)
    }

    /*==========================================================*/
    
    // action outlet for addLocation button
    @IBAction func button_addLocation(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Location", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter Location Name Here"
        })
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter Location Description Here"
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            let desc = alert.textFields![1].text!
            if let name = alert.textFields?.first?.text {
                
                // create a new entity object
                let ent = NSEntityDescription.entity(forEntityName: "LocationEntity", in: self.managedObjectContext)
                //add to the managed object context
                let newItem = LocationEntity(entity: ent!, insertInto: self.managedObjectContext)
                newItem.cdName = "\(name) \(self.counter)"
                newItem.cdDescription = "\(desc)"
                newItem.cdImage = nil
                
                // one more item added
                self.updateCounter()
                
                // save the updated context
                do {
                    try self.managedObjectContext.save()
                } catch _ {
                }
                
                self.locTable.reloadData()
                
                
                /*//print("Location Name: \(name)") // debug
                //print("Location Desc: \(desc)")   // debug
                
                //print(self.myLocList.locations.description) // debug
                
                let newLocation = location(lName: name, lDesc: desc, lImage: "newyork.jpg")
                self.myLocList.locations.append(newLocation)
                
                //print(self.myLocList.locations.description) // debug
                
                let LName = name
                let endIndex = LName.index((LName.startIndex), offsetBy: 1)
                let locationKey = String(LName[(..<endIndex)])
                
                // adding the new loc object to the dictionary
                if var locObjects = self.locList[locationKey] {
                    locObjects.append(newLocation)
                    self.locList[locationKey] = locObjects
                    self.locTable.reloadData()  // update table contents
                }else{
                    self.locList[locationKey] = [newLocation]
                    self.locTable.reloadData()  // update table contents
                }
                self.locTable.reloadData()  // update table contents
                
                print("Location Added: \(LName), with Description: \(desc)")    // debug
                print("Total number of locations stored: \(self.myLocList.locations.count)")    // debug*/
            }
            
        }))
        
        self.present(alert, animated: true)
    }
    
    /*==========================================================*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // build LocDictionary *<TODO>: only on first load*
        //createLocDictionary()
        
        // ...
        initCounter()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateLastRow()
    }
    
    /*==========================================================*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let selectedIndex: IndexPath = self.locTable.indexPath(for: sender as! UITableViewCell)!
        
        /*// access the section for the selected row
        let locKey = myLocList.tableSectionTitles[selectedIndex.section]
        
        // get the location object for the selected row in the section
        let loc = locList[locKey]![selectedIndex.row]*/
        
        let userSelectedEntity = fetchResults[selectedIndex.row]
        
        if(segue.identifier == "detailedViewSegue"){
            if let detailViewController: DetailedViewController = segue.destination as? DetailedViewController {
                
                print("Made it to detailedViewSegue locName selection method")    // debug
                
                //detailViewController.selectedLocation = loc.locName
                //detailViewController.passedLocName = loc.locName
                //detailViewController.passedLocDesc = loc.locDescription
                //detailViewController.passedLocImage = loc.locImageName    // prep for lab 05
                
                // pass user-selected location object to DetailedViewController
                //detailViewController.userSelectedEntry = loc
                
                detailViewController.userSelectedEntity = userSelectedEntity
                
            }
        }
    }
    
    // used by Exit handler to unwind segue and pass data to the original page
    @IBAction func unwindSegue(segue: UIStoryboardSegue)
    {
        print("Unwinding page segue")
        
        /*if let sourceViewController = segue.source as? DetailedViewController
        {
            let dataReceived:location? = sourceViewController.userSelectedEntry
            self.locList[(dataReceived?.locName)!] = [dataReceived!]
            
            // update table contents
            self.locTable.reloadData()

        }*/
    }
    
    /*==========================================================*/
    
    /*// delegate to set number of sections in table
    func numberOfSections(in tableView: UITableView) -> Int {
        // get the section count
        return myLocList.tableSectionTitles.count
        //return fetchResults.count
    }*/
    
    // delegate to count number of rows in a section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        
        // number of rows based on the coredata storage
        return fetchRecord()
        
        /*// get the section title
        let locKey = myLocList.tableSectionTitles[section]
        
        // use the section title to count how many locations are in that section
        if let locValues = locList[locKey]
        {
            return locValues.count
        }
        else {
            return 0
        }*/
    }
    
    /*// delegate to return the heading string for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // returns the heading for each section
        return myLocList.tableSectionTitles[section]
    }*/
    
    // delegate to build the actual table, including the section headers/keys and each row individually
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // add each row from coredata fetch results
        let Lcell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocTableViewCell
        Lcell.layer.borderWidth = 1.0
        Lcell.locTitle?.text = fetchResults[indexPath.row].cdName
        Lcell.locDescription.text = fetchResults[indexPath.row].cdDescription
        
        if let image = fetchResults[indexPath.row].cdImage {
            Lcell.locImage?.image =  UIImage(data: image as Data)
        } else {
            Lcell.locImage?.image = nil
        }
        
        return Lcell
        
        
        /*//let cell = tableView.dequeueReusableCell(withIdentifier: "fruitCell", for: indexPath) as! FruitTableViewCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "locCell", for: indexPath) as! LocTableViewCell
        let Lcell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocTableViewCell
        
        // get the section key
        let locKey = myLocList.tableSectionTitles[indexPath.section]
        
        // build each each row for section
        if let locValues = locList[locKey]{
            Lcell.locTitle.text = locValues[indexPath.row].locName;
            Lcell.locDescription.text = locValues[indexPath.row].locDescription;
            Lcell.locImage.image = UIImage(named: locValues[indexPath.row].locImageName)
        }
        
        return Lcell*/
        
    }
    
    // delegate to allow row entry editting
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // delegate to deal with swipe-to-delete entry functionality
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            // delete the selected object from the managed
            // object context
            managedObjectContext.delete(fetchResults[indexPath.row])
            // remove it from the fetch results array
            fetchResults.remove(at:indexPath.row)
            
            do {
                // save the updated managed object context
                try managedObjectContext.save()
            } catch {
                
            }
            // reload the table after deleting a row
            self.locTable.reloadData()
            
            
            
            
            
            
            
            /*// delete the selected object from the managed
            // object context
            managedObjectContext.delete(fetchResults[indexPath.row])
            // remove it from the fetch results array
            fetchResults.remove(at:indexPath.row)
            
            do {
                // save the updated managed object context
                try managedObjectContext.save()
            } catch {
                
            }
            // reload the table after deleting a row
            self.locTable.reloadData()
            
            /*// handle delete (by removing the data from dictionary and updating the tableview
            print("Inside tableView delete handler delegate.")  // debug
            
            let locKeyToRemove = myLocList.tableSectionTitles[indexPath.section]
            self.locList[locKeyToRemove] = []
            
            // update table contents
            self.locTable.reloadData()*/*/
        }
    }
    
    /*==========================================================*/
    
    /*func createLocDictionary() {
        // for each location in the location list from the loc object
        for loc in myLocList.locations {
            // extract the first letter as a string for the key
            let lName = loc.locName
            
            let endIndex = lName.index((lName.startIndex), offsetBy: 1)
            
            let locKey = String(lName[(..<endIndex)])
            
            // build the location object array for each key
            if var locObjects = locList[locKey] {
                locObjects.append(loc)
                locList[locKey] = locObjects
            } else {
                locList[locKey] = [loc]
            }
            
        }
    }*/
    
    /*==========================================================*/

    func initCounter() {
        counter = UserDefaults.init().integer(forKey: "counter")
    }
    
    func updateCounter() {
        counter += 1
        UserDefaults.init().set(counter, forKey: "counter")
        UserDefaults.init().synchronize()
    }
    
    /*==========================================================*/
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

