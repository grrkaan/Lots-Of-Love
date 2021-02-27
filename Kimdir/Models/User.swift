//
//  User.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 18.02.2021.
//

import UIKit
struct User : ProfileViewModelCreate{
    let userName : String
    let job : String
    let age : Int
    let profileImgs : [String]
    
    
    func userProfileViewModelCreate() -> UserProfileViewModel {
        
        let attrText = NSMutableAttributedString(string: "\(userName),", attributes: [.font: UIFont.systemFont(ofSize: 30,weight: .heavy)])
        attrText.append(NSAttributedString(string: " \(age)", attributes: [.font : UIFont.systemFont(ofSize: 30, weight: .regular)]))
        attrText.append(NSAttributedString(string: "\n\(job)", attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return UserProfileViewModel(attrString: attrText, viewImgs: profileImgs, infoLocation: .left)
    }
}
