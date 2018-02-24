//
//  LoginViewController.swift
//  Chatty
//
//  Created by Ruben A Gonzalez on 2/21/18.
//  Copyright © 2018 Ruben A Gonzalez. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {


    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(_ sender: Any) {
        registerUser()
    }
    
    
    @IBAction func login(_ sender: Any) {
        signIn()
    }
    
    func signIn() {
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
                
                // Create alert controller to handle sing in errors
                let alertController = UIAlertController(title: "Error Signing In!", message: "Incorrect username or password", preferredStyle: .alert)
                
                // Exit Alert
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // Return from function and fill the text fields
                    return
                }
                
                // Add the OK action to the alert controller
                alertController.addAction(OKAction)
                
                // Show alert
                self.present(alertController, animated: true) {}
                
            } else {
                print("User logged in successfully")
                // display view controller that needs to shown after successful login
                
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    func registerUser() {
        // Check if username and password fields are filled
        if ((usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!) {
            
            let alertController = UIAlertController(title: "Text Fields Empty!", message: "Fill in the username and password fields", preferredStyle: .alert)
            
            // Exit Alert
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // Return from function and fill the text fields
                return
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            
            present(alertController, animated: true) {}
            
        }
            
            // Create a new user
        else {
            // initialize a user object
            let newUser = PFUser()
            
            // set user properties
            newUser.username = usernameTextField.text
            newUser.password = passwordTextField.text
            
            // call sign up function on the object
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                    
                    // Create alert controller to handle sign up errors
                    let alertController = UIAlertController(title: "Error Signing Up!", message: "Username is already taken", preferredStyle: .alert)
                    
                    // Exit Alert
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        // Return from function and fill the text fields
                        return
                    }
                    
                    // add the OK action to the alert controller
                    alertController.addAction(OKAction)
                    
                    self.present(alertController, animated: true) {}
                    
                } else {
                    print("User Registered successfully")
                    // manually segue to logged in view
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
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
