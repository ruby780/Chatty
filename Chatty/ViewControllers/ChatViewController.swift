//
//  ChatViewController.swift
//  Chatty
//
//  Created by Ruben A Gonzalez on 2/21/18.
//  Copyright © 2018 Ruben A Gonzalez. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var chatMessageField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    
    var messages: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.dataSource = self
        messageTableView.delegate = self
        
        // Auto size row height based on cell autolayout constraints
        messageTableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        messageTableView.estimatedRowHeight = 50
        messageTableView.separatorStyle = .none
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.refreshMessages), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        cell.bubbleView.layer.cornerRadius = 16
        cell.bubbleView.clipsToBounds = true
        
        let message = messages[indexPath.row]
        cell.messageLabel.text = message["text"] as? String
        if let user = message["user"] as? PFUser {
            // User found! update username label with username
            cell.userLabel.text = user.username
        } else {
            // No user found, set default username
            cell.userLabel.text = "🤖"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    @objc func refreshMessages() {
        // Add code to be run periodically
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
             if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            } else if let messages = messages {
                self.messages = messages
                self.messageTableView.reloadData()
            }
        }
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        
        chatMessage["text"] = chatMessageField.text ?? ""
        chatMessage["user"] = PFUser.current()
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.chatMessageField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
