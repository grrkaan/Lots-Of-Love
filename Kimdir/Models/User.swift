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
    var profileImgUrlFirst : String?
    var profileImgUrlScnd : String?
    var profileImgUrlThird : String?
    var userId : String
    var minAge : Int?
    var maxAge : Int?
    
    init(datas : [String : Any]) {
        self.userName = datas["UserName"] as? String ?? ""
        self.age = datas["Age"] as? Int
        self.job = datas["Job"] as? String
        self.profileImgUrlFirst = datas["ImgUrlFirst"] as? String
        self.profileImgUrlScnd = datas["ImgUrlScnd"] as? String
        self.profileImgUrlThird = datas["ImgUrlThird"] as? String
        self.userId = datas["UserId"] as? String ?? ""
        self.minAge = datas["MinAge"] as? Int
        self.maxAge = datas["MaxAge"] as? Int
    }
   
    func userProfileViewModelCreate() -> UserProfileViewModel {
        
        let attrText = NSMutableAttributedString(string: "\(userName ?? ""),", attributes: [.font: UIFont.systemFont(ofSize: 30,weight: .heavy)])
        let ageStr = age != nil ? "\(age!)" : "***"
        let jobStr = job != nil ? "\(job!)" : "***"
        
        attrText.append(NSAttributedString(string: " \(ageStr)", attributes: [.font : UIFont.systemFont(ofSize: 30, weight: .regular)]))
        attrText.append(NSAttributedString(string: "\n\(jobStr)", attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        var imgUrl = [String]()
        if let url = profileImgUrlFirst , !url.isEmpty { imgUrl.append(url) }
        if let url = profileImgUrlScnd  , !url.isEmpty { imgUrl.append(url) }
        if let url = profileImgUrlThird  ,!url.isEmpty { imgUrl.append(url) }
        
        return UserProfileViewModel(attrString: attrText, viewImgs: imgUrl, infoLocation: .left)
    }
}
