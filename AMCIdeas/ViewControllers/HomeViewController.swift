//
//  HomeViewController.swift
//  AMCIdeas
//
//  Created by Shaheen on 11/10/20.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: iVAr
    var items: [Idea] = []
    var user: User!
    let ref = Database.database().reference(withPath: "amc-idea")

    // MARK: static init method
    static func initViewController() -> HomeViewController {
        let viewController = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController

         return viewController
     }
    
    // MARK: UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBar()
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        
        loadIdeaList()
        loadUserData()
    }
    
    func prepareNavigationBar() {
        self.title = "AM Ideas"
        // Do any additional setup after loading the view.
       
        let backButtonImage = UIImage(named: "add-icon")?.withRenderingMode(.alwaysTemplate)
        let backButtonItem = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(addItemBarButtonPressed))

        navigationItem.rightBarButtonItem = backButtonItem
    }
    
    // MARK: Bar Button Action
    @objc func addItemBarButtonPressed() {
        let viewController = IdeaViewController.initViewController()
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Helper Method
    func loadIdeaList() -> Void {
        ref.queryOrdered(byChild: "createdAt").observe(.value, with: { snapshot in
          var newItems: [Idea] = []
          for child in snapshot.children {
            if let snapshot = child as? DataSnapshot,
              let idea = Idea(snapshot: snapshot) {
              newItems.append(idea)
            }
          }
          
          self.items = newItems
          self.tableView.reloadData()
        })
    }
    
    func loadUserData() -> Void {
        Auth.auth().addStateDidChangeListener { auth, user in
          guard let user = user else { return }
          self.user = User(user: user)
        }
    }
}

extension HomeViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        
        cell.setUpDate(idea: items[indexPath.row])
        
        return cell
    }
}

extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = IdeaViewController.initViewController()
        viewController.delegate = self
        viewController.idea = items[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}


extension HomeViewController : IdeaCreateDelegate {
    func didPressedSaveIdea(title: String, sortDescription: String, description: String) {
        let idea = Idea.init(title: title, sortDescription: sortDescription, description: description, createdBy: self.user.email, createdAt: 0, updatedAt: 0, favorites: [])
        
        let ideaRef = self.ref.child("idea-\(items.count + 1)")
        
        ideaRef.setValue(idea.toAnyObject())
    }
}
