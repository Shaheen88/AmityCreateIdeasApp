//
//  AuthViewController.swift
//  AMCIdeas
//
//  Created by Shaheen on 11/10/20.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
      super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            gotoHomeView()
        } else {
            Auth.auth().addStateDidChangeListener() { auth, user in
                if user != nil {
                    self.emailTextField.text = nil
                    self.passwordTextField.text = nil
                    
                    self.gotoHomeView()
                }
            }
        }
    }
    
    // MARK: Actions
    @IBAction func signInButtonDidPressed(_ sender: AnyObject) {
                
      guard
        let email = emailTextField.text,
        let password = passwordTextField.text,
        email.count > 0,
        password.count > 0
        else {
          return
      }

      Auth.auth().signIn(withEmail: email, password: password) { user, error in
        if let error = error, user == nil {
          let alert = UIAlertController(title: "Sign In Failed",
                                        message: error.localizedDescription,
                                        preferredStyle: .alert)

          alert.addAction(UIAlertAction(title: "OK", style: .default))

          self.present(alert, animated: true, completion: nil)
        }
      }
        
    }
    
    @IBAction func signUpButtonDidPressed(_ sender: AnyObject) {
      let alert = UIAlertController(title: "Sign Up",
                                    message: "AMCIdeas Sign Up",
                                    preferredStyle: .alert)
      
      let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
        
        let emailField = alert.textFields![0]
        let passwordField = alert.textFields![1]
        
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
          if error == nil {
            Auth.auth().signIn(withEmail: emailField.text!,
                               password: passwordField.text!)
          }
        }
      }
      
      let cancelAction = UIAlertAction(title: "Cancel",
                                       style: .cancel)
      
      alert.addTextField { textEmail in
        textEmail.placeholder = "Enter your email"
      }
      
      alert.addTextField { textPassword in
        textPassword.isSecureTextEntry = true
        textPassword.placeholder = "Enter your password"
      }
      
      alert.addAction(saveAction)
      alert.addAction(cancelAction)
      
      present(alert, animated: true, completion: nil)
    }
    
    // Route Funtion
    
    func gotoHomeView() -> Void {
        let sceneDelegate = UIApplication.shared.connectedScenes
            .first!.delegate as! SceneDelegate
        
        sceneDelegate.window!.rootViewController = UINavigationController.init(rootViewController: HomeViewController.initViewController())
        sceneDelegate.window!.makeKeyAndVisible()
    }
  }

  extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == emailTextField {
        passwordTextField.becomeFirstResponder()
      }
      if textField == passwordTextField {
        textField.resignFirstResponder()
      }
      return true
    }
  }
