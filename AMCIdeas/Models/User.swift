//
//  User.swift
//  AMCIdeas
//
//  Created by Shaheen on 12/10/20.
//

import Foundation
import Firebase

struct User {
  
  let uid: String
  let email: String
  
  init(user: Firebase.User) {
    uid = user.uid
    email = user.email!
  }
  
  init(uid: String, email: String) {
    self.uid = uid
    self.email = email
  }
}
