//
//  DetailedViewController.swift
//  cse335f18_lab04-archer_patrick
//
//  Created by Patrick Archer on 9/27/18.
//  Copyright © 2018 Patrick Archer - Self. All rights reserved.
//

import UIKit
import AVKit
import Foundation
import CoreData

class DetailedViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    
    // var to store segue-passed location that user selected in table view
    var userSelectedEntry:location?
    
    var userSelectedEntity:LocationEntity?

    @IBOutlet weak var label_locationName: UILabel!
    @IBOutlet weak var label_locationDescription: UILabel!
    
    @IBOutlet weak var image_LocImage: UIImageView!
    
    // handles what happens when user presses "CHANGE PICTURE" button
    @IBAction func button_changePicture(_ sender: UIButton) {
        
        // display alert to user asking what source the image will be from (camera or storage library)
        let alertMsg:String = "Please select your desired image source."
        let alert = UIAlertController(title: "Update Location Image", message: alertMsg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "CAMERA", style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.sourceType = UIImagePickerControllerSourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
            } else {
                print("ERROR: No camera on device.")
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "LIBRARY", style: .default, handler: { action in
            
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.picker.modalPresentationStyle = .popover
            self.present(self.picker, animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true)
        
    }
    
    @IBAction func barbutton_editEntry(_ sender: UIBarButtonItem) {
        
        // display alert to user asking what source the image will be from (camera or storage library)
        let alertMsg:String = "To save changes, please press SUBMIT. Else press CANCEL."
        let alert = UIAlertController(title: "Edit Location Info", message: alertMsg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "SUBMIT", style: .default, handler: { action in
            
            //self.userSelectedEntry?.locName = alert.textFields![0].text!
            self.userSelectedEntity?.cdName = alert.textFields![0].text!
            //self.userSelectedEntry?.locDescription = alert.textFields![1].text!
            self.userSelectedEntity?.cdDescription = alert.textFields![1].text!
            
            self.label_locationName.text! = (self.userSelectedEntity?.cdName)!
            self.label_locationDescription.text! = (self.userSelectedEntity?.cdDescription)!
            
        }))
        
        // [0] - locName textfield
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = self.userSelectedEntity?.cdName
            //textField.placeholder = self.userSelectedEntry?.locName
        })
        
        // [1] - locDesc textfield
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = self.userSelectedEntity?.cdName
            //textField.placeholder = self.userSelectedEntry?.locDescription
        })
        
        self.present(alert, animated: true)
        
    }
    
    @IBAction func barbutton_done(_ sender: UIBarButtonItem) {
        // configure segue prep and loc object/info transfer
    }
    
    
    
    
    
    
    
    /*==========================================================*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        picker.delegate = self
        
        // set initial label values to user-selected location info
        self.label_locationName.text = userSelectedEntity?.cdName
        self.label_locationDescription.text = userSelectedEntity?.cdDescription
        //self.image_LocImage.image = userSelectedEntity?.cdImage      //UIImage(userSelectedEntity?.cdImage)// as? UIImage
        
        
        if let passedImage = userSelectedEntity?.cdImage {
            self.image_LocImage.image =  UIImage(data: passedImage as Data)
        } else {
            self.image_LocImage.image = nil
        }
        
        
        //self.label_locationName.text = userSelectedEntry?.locName
        //self.label_locationDescription.text = userSelectedEntry?.locDescription
        
        // load initial image to display to user
        //fruitValues[indexPath.row].fruitImageName)
        //self.image_LocImage.image = UIImage(named: (userSelectedEntry?.locImageName)!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*==========================================================*/

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /*==========================================================*/
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        picker .dismiss(animated: true, completion: nil)
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.image_LocImage.image = selectedImage
        userSelectedEntity?.cdImage = UIImagePNGRepresentation(selectedImage!)! as NSData
        
            
        
        
        //userSelectedEntity?.cdImage = (info[UIImagePickerControllerOriginalImage] as! NSData)
        //self.image_LocImage.image=info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    

}







