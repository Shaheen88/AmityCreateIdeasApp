//
//  Idea.swift
//  AMCIdeas
//
//  Created by Shaheen on 12/10/20.
//

import Foundation
import Firebase

struct Idea {
  
  let ref: DatabaseReference?
  let key: String
  let title: String
  let sortDescription: String
  let description: String
  let createdBy: String
  let createdAt: TimeInterval
  let updatedAt: TimeInterval
  var favorites: Array<String>
  
  init(title: String, sortDescription: String, description: String, createdBy: String, createdAt: TimeInterval, updatedAt: TimeInterval, favorites: Array<String>, key: String = "") {
    self.ref = nil
    self.key = key
    self.title = title
    self.sortDescription = sortDescription
    self.description = description
    self.createdBy = createdBy
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.favorites = favorites
  }
  
  init?(snapshot: DataSnapshot) {
    guard
      let value = snapshot.value as? [String: AnyObject],
      let title = value["title"] as? String,
      let sortDescription = value["sortDescription"] as? String,
      let description = value["description"] as? String,
      let createdBy = value["createdBy"] as? String,
      let createdAt = value["createdAt"] as? TimeInterval,
      let updatedAt = value["updatedAt"] as? TimeInterval else {
      return nil
    }
    
    let favorites = value["favorites"] as? Array<String>
    
    self.ref = snapshot.ref
    self.key = snapshot.key
    self.title = title
    self.sortDescription = sortDescription
    self.description = description
    self.createdBy = createdBy
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.favorites = favorites ?? []
  }
  
  func toAnyObject() -> Any {
    return [
        "title": title,
        "sortDescription": sortDescription,
        "description": description,
        "createdBy": createdBy,
        "createdAt": [".sv": "timestamp"],
        "updatedAt": [".sv": "timestamp"],
        "favorites": favorites
    ]
  }
}
