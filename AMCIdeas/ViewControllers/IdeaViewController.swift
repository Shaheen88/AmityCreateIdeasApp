//
//  IdeaViewController.swift
//  AMCIdeas
//
//  Created by Shaheen on 11/10/20.
//

import UIKit
import Firebase

class IdeaViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: iVars
    var items: Array<IdeaOptionModel>?
    var idea: Idea?
    var viewMode:IdeaViewMode = .undefine
    weak var delegate : IdeaCreateDelegate?
    
    // MARK: static init method
    static func initViewController() -> IdeaViewController {
        let viewController = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "IdeaViewController") as! IdeaViewController
        
        return viewController
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBar()
        
        tableView.register(UINib(nibName: "InputTableViewCell", bundle: nil), forCellReuseIdentifier: "InputTableViewCell")
        
        prepareDefaultData()

    }
    
    func prepareNavigationBar() {
        self.title = "Create Idea"
        // Do any additional setup after loading the view.
       
        let backButtonImage = UIImage(named: "back-icon")?.withRenderingMode(.alwaysOriginal)
        let backButtonItem = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backBarButtonPressed))

        navigationItem.leftBarButtonItem = backButtonItem
        
        if idea != nil {
            if idea!.createdBy == Auth.auth().currentUser?.email ?? "" {
                viewMode = .edit
            } else {
                viewMode = .view
            }
        } else {
            viewMode = .create
        }
        
        if viewMode == .create || viewMode == .edit {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewMode == .create ? "Save" : "Update", style: .done, target: self, action: #selector(saveBarButtonPressed))
        } else {
            var favImage: UIImage? = nil
            if idea != nil && idea!.favorites.contains(Auth.auth().currentUser?.email ?? "") {
                favImage = UIImage(named: "favorite_cell_Bar_act")?.withRenderingMode(.alwaysTemplate)
            } else {
                favImage = UIImage(named: "favorite_cell_Bar")?.withRenderingMode(.alwaysTemplate)
            }
            
            let favButtonItem = UIBarButtonItem(image: favImage, style: .plain, target: self, action: #selector(favoriteBarButtonPressed))
            navigationItem.rightBarButtonItem = favButtonItem
        }
    }
    
    // MARK: Bar Button Action
    @objc func backBarButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func favoriteBarButtonPressed() {
        var favorites = idea?.favorites
        if idea!.favorites.contains(Auth.auth().currentUser?.email ?? "") {
            favorites = favorites?.filter { $0 != (Auth.auth().currentUser?.email)! }
        } else {
            favorites?.append((Auth.auth().currentUser?.email)!)
        }
        
        idea?.ref?.updateChildValues([
            "favorites": favorites as Any
        ])
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveBarButtonPressed() {
        
        let titleOptionModel = items?.filter { idea in
            return idea.type == .ideaTitle
        }.first
        
        let sortDescriptionOptionModel = items?.filter { idea in
            return idea.type == .ideaSortDescription
        }.first
        
        let descriptionOptionModel = items?.filter { idea in
            return idea.type == .ideaDescription
        }.first
        
        guard
            let title = titleOptionModel?.value,
            let sortDescription = sortDescriptionOptionModel?.value,
            let description = descriptionOptionModel?.value,
            title.count > 0,
            sortDescription.count > 0,
            description.count > 0
            else {
                return
            }
        
        if idea != nil {
            idea?.ref?.updateChildValues([
                "title": title,
                "sortDescription": sortDescription,
                "description":description,
                "updatedAt": [".sv": "timestamp"]
            ])
        } else {
            self.delegate?.didPressedSaveIdea(title: title, sortDescription: sortDescription, description: description)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Helper Method
    func prepareDefaultData() -> Void {
        let optionTitle = IdeaOptionModel.init(sectionTitle: "Title", placeHolder: "Enter Idea Title", value: idea?.title ?? "", type: .ideaTitle)
        let optionSortDescription = IdeaOptionModel.init(sectionTitle: "Sort Description", placeHolder: "Enter Sort Description", value: idea?.sortDescription ?? "", type: .ideaSortDescription)
        let optionDescription = IdeaOptionModel.init(sectionTitle: "Description", placeHolder: "Enter Description", value: idea?.description ?? "", type: .ideaDescription)

        self.items = [optionTitle, optionSortDescription, optionDescription]

        self.tableView.reloadData()
    }
    
    func updateHeightOfRow(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = tableView.sizeThatFits(CGSize(width: size.width,
                                                    height: CGFloat.greatestFiniteMagnitude))
        
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            tableView.scrollToRow(at: IndexPath.init(row: 0, section: textView.tag), at: .bottom, animated: false)
        }
    }
}

extension IdeaViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let optionModel = self.items?[section]
        
        return optionModel?.sectionTitle
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let titleView = view as! UITableViewHeaderFooterView
        titleView.textLabel?.textColor = UIColor.gray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCell") as! InputTableViewCell
        
        if viewMode == .view {
            cell.textView.isEditable = false
        } else {
            cell.textView.isEditable = true
            cell.textView.delegate = self
            cell.textView.tag = indexPath.section
        }
        
        let optionModel = self.items?[indexPath.section]
        
        if (optionModel?.value == "") {
            cell.textView.text = optionModel?.placeHolder
            cell.textView.textColor = UIColor.lightGray
        } else {
            cell.textView.text = optionModel?.value
            cell.textView.textColor = UIColor.black
        }
        
        return cell
    }
}

extension IdeaViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            let optionModel = self.items?[textView.tag]
            textView.text = optionModel?.placeHolder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateHeightOfRow(textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var optionModel = self.items?[textView.tag]
        let currentText = textView.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: text)
        optionModel?.value = replacementText
        self.items?[textView.tag] = optionModel!

        return true
    }
}
