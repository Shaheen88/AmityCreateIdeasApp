//
//  IdeaViewModel.swift
//  AMCIdeas
//
//  Created by Shaheen on 12/10/20.
//

import Foundation

enum IdeaOptionModelType: Int {
    case undefine = 0, ideaTitle, ideaDescription, ideaSortDescription, ideaFavoriate
}

enum IdeaViewMode: Int {
    case undefine = 0, create, view, edit
}

struct IdeaOptionModel {
    let sectionTitle: String
    let placeHolder: String
    var value: String
    let type: IdeaOptionModelType
}

protocol IdeaCreateDelegate : class {    // 'class' means only class types can implement it
    func didPressedSaveIdea(title: String, sortDescription: String, description: String) -> Void
}
