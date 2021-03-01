//
//  User.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 18.02.2021.
//

import UIKit
struct User : ProfileViewModelCreate{
    var userName : String?
    var job : String?
    var age : Int?
    //let profileImgs : [String]
    var profileImgUrl : String
    var userId : String
    
    init(datas : [String : Any]) {
        self.userName = datas["UserName"] as? String ?? ""
        self.age = datas["Age"] as? Int
        self.job = datas["Job"] as? String
        self.profileImgUrl = datas["ImgUrl"] as? String ?? ""
        self.userId = datas["UserId"] as? String ?? ""
    }
   
    func userProfileViewModelCreate() -> UserProfileViewModel {
        
        let attrText = NSMutableAttributedString(string: "\(userName ?? ""),", attributes: [.font: UIFont.systemFont(ofSize: 30,weight: .heavy)])
        let ageStr = age != nil ? "\(age!)" : "***"
        let jobStr = job != nil ? "\(job!)" : "***"
        
        attrText.append(NSAttributedString(string: " \(ageStr)", attributes: [.font : UIFont.systemFont(ofSize: 30, weight: .regular)]))
        attrText.append(NSAttributedString(string: "\n\(jobStr)", attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return UserProfileViewModel(attrString: attrText, viewImgs: [profileImgUrl], infoLocation: .left)
    }
}
