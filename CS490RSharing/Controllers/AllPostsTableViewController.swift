//
//  AllPostsTableViewController.swift
//  CS490RSharing
//
//  Created by Jonathan G. Dzialo on 2/13/19.
//  Copyright © 2019 Group6. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

var selectedPost: Posts?
class AllPostsTableViewController: UITableViewController,UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let indexPath = tableView?.indexPathForRow(at: location)
        let cell = tableView?.cellForRow(at: indexPath!)
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        let post = currentPosts[indexPath!.row]
        detailVC!.post = post
        previewingContext.sourceRect = cell!.frame
        
        return detailVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit DetailViewController: UIViewController) {
        show(DetailViewController,sender: self)
    }
    
    
    var ref: DatabaseReference!
    var currentPosts = [Posts]()
    var reversePosts = [Posts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        fetchPosts()
        
        if (traitCollection.forceTouchCapability == UIForceTouchCapability.available){
            registerForPreviewing(with: self, sourceView: tableView)
        }else{
            print("Failed")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentPosts.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPost = currentPosts[indexPath.row]
        performSegue(withIdentifier: "descSegue", sender: self)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        let eachPost = reversePosts[indexPath.row]
        print(currentPosts)
        cell.textLabel?.numberOfLines = 5
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.text = "Post Location: \(eachPost.location ?? "Location")\nFood Quantity: \(eachPost.quantity ?? "quantity")\nTime: \(eachPost.time ?? "Time") \nType: \(eachPost.type ?? "Type")"
        
        cell.textLabel?.textColor = UIColor.black
        
        let storageRef = Storage.storage().reference()
        let picRef = storageRef.child("Images/" + reversePosts[indexPath.row].userID! + reversePosts[indexPath.row].type! + ".jpeg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        picRef.getData(maxSize: 1 * 2048 * 2048) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error.localizedDescription)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                let cellImg : UIImageView = UIImageView(frame: CGRect(x: 300, y: 0, width: 115, height: 115))
                cellImg.layer.cornerRadius = 20.0;
                cellImg.layer.masksToBounds = true;
                cellImg.image = image
                cell.addSubview(cellImg)
                //cell.imageView?.image = image
            }
        }
        return cell
        
    }
    
    
    func fetchPosts(){
        Database.database().reference().child("Posts").observe(.childAdded, with: {  (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject]{
                
                let post = Posts()
                post.setValuesForKeys(dictionary)
                self.currentPosts.append(post)
                self.reversePosts = self.currentPosts.reversed()
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        })
    }
    
}
