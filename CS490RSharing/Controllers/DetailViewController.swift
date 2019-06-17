//
//  DetailViewController.swift
//  CS490RSharing
//
//  Created by Jonathan G. Dzialo on 2/27/19.
//  Copyright © 2019 Group6. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class DetailViewController: UIViewController {
    
    let storageRef = Storage.storage().reference()
    
    var post:Posts?
    private let db = Firestore.firestore()
    private var channelReference: CollectionReference {
        return db.collection("channels")
    }
    private var channels = [Channel]()
    private var channelListener: ListenerRegistration?
    @IBOutlet weak var postLocation: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var postType: UILabel!
    @IBOutlet weak var postQuantity: UILabel!
    @IBOutlet weak var postNotes: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if let post = post{
        postLocation.text = selectedPost?.location
        postTime.text = selectedPost?.time
        postType.text = selectedPost?.type
        postQuantity.text = selectedPost?.quantity
        postNotes.text = selectedPost?.notes
        
        // Create a reference to the file you want to download
        let picRef = storageRef.child("Images/" +
            (selectedPost?.userID)! + (selectedPost?.type)! + ".jpeg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        picRef.getData(maxSize: 1 * 2048 * 2048) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error.localizedDescription)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                self.postImage.image = image
            }
        }
        //postImage.image = UIImage(named: (selectedPost?.userID)! + (selectedPost?.type)!)
       // }
       
    }
    
    @IBAction func chat(_ sender: Any) {
        //var query = channelReference.whereField("name", isEqualTo: selectedPost?.location ?? "id")
        channelReference.document("DZYik9jwLDPkQ0Enn5u8").getDocument { (document, error) in
            if let document = document, document.exists {
                //let dataDescription = document.data()
                //print("Document data: \(dataDescription ??)")
                let channel = Channel(id: document.documentID, name: (selectedPost?.location)!)
                let vc = ChatViewController(user: Auth.auth().currentUser!, channel: channel)
                print(Auth.auth().currentUser!,channel)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                print("Document does not exist")
            }
        }
        //let channel = data
        //let vc = ChatViewController(user: Auth.auth().currentUser!, channel: channel)
        //print(Auth.auth().currentUser!,channel)
        //navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
