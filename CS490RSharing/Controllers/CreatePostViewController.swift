//
//  CreatePostViewController.swift
//  CS490RSharing
//
//  Created by Jonathan G. Dzialo on 2/13/19.
//  Copyright © 2019 Group6. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import UserNotifications



class CreatePostViewController: UIViewController {
    
    @IBOutlet weak var foodImageView: UIImageView!
    var imagePicker = UIImagePickerController()
    var refPosts: DatabaseReference!
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    var foodImage: UIImage!
    @IBOutlet weak var foodLocationTextField: UITextField!
    @IBOutlet weak var timePostedTextField: UITextField!
    @IBOutlet weak var foodTypeTextField: UITextField!
    @IBOutlet weak var foodQuantityTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextView!
    
    private var channelReference: CollectionReference {
        return db.collection("channels")
    }
    private var imageReference: StorageReference{
        return Storage.storage().reference().child("images")
    }
    private var channels = [Channel]()
    //private var channelListener: ListenerRegistration?
    private let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Post"
        
        refPosts = Database.database().reference().child("Posts")
        
        imagePicker.delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            (granted, error) in
            if granted {
                print("yes")
            } else {
                print("No")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createPost(_ sender: Any) {
        addPost()
        createChannel()
        sendNotification()
        addImagetoStorage()
        print("Post added!")
        
        foodLocationTextField.text = ""
        timePostedTextField.text = ""
        foodTypeTextField.text = ""
        foodQuantityTextField.text = ""
        notesTextField.text = ""
        foodImageView.image = nil
        
        ToastView.shared.short(self.view, txt_msg: "Post Created!")
        //Timer.scheduledTimer(timeInterval: 3, target: self, selector:#selector(CreatePostViewController.delayPostCreation), userInfo: nil, repeats: false)
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllPostsTableViewController")
        //self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func delayPostCreation(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllPostsTableViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func chooseFromCameraRoll(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func addPost(){
        
        let key = refPosts.childByAutoId().key
        let userID = Auth.auth().currentUser!.uid
        let group = ["location": foodLocationTextField.text! as String,
                     "time": timePostedTextField.text! as String,
                     "id":key,
                     "type": foodTypeTextField.text! as String,
                     "quantity": foodQuantityTextField.text! as String,
                     "notes": notesTextField.text! as String,
                     "userID": userID as String]
        refPosts.child(key!).setValue(group)
    }
    
    private func createChannel() {
        guard let channelName = foodLocationTextField.text else {
            return
        }
        
        let channel = Channel(id: "",name: channelName)
        channelReference.addDocument(data: channel.representation) { error in
            if let e = error {
                print("Error saving channel: \(e.localizedDescription)")
            }else{
                print("Document Added")
            }
        }
    }
    
    private func sendNotification(){
        let content = UNMutableNotificationContent()
        content.title = foodLocationTextField.text!
        content.subtitle = foodTypeTextField.text!
        content.body = foodQuantityTextField.text!
        
        
        let imageName = "newmessage"
        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else {
            print("no image")
            return }
        
        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        
        content.attachments = [attachment]
        
       
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
        
       
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    private func addImagetoStorage(){
        let userID = Auth.auth().currentUser!.uid
        let imageRef = storage.child("Images/" + userID + foodTypeTextField.text! + ".jpeg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        imageRef.putData(foodImage.jpegData(compressionQuality: 0.8)!,metadata:metaData) { (data,error) in
            if error == nil{
                print("image upload successful")
            }
            else{
                print(error?.localizedDescription)
            }
 
        }
        
    }

}

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            foodImageView.image = image
            foodImage = image
            /*
            let imageRef = storage.child("Images/image.jpeg")
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            imageRef.putData(image.jpegData(compressionQuality: 0.8)!,metadata:metaData) { (data,error) in
                if error == nil{
                    print("image upload successful")
                }
                else{
                    print(error?.localizedDescription)
                }
            }
             */
        }
        dismiss(animated: true, completion: nil)
    }
}
