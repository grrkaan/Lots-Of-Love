//
//  Advertisement.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 24.02.2021.
//

import UIKit

struct Advertisement : ProfileViewModelCreate{
    
    let title : String
    let brandName : String
    let posterImgName : String
    
    func userProfileViewModelCreate() -> UserProfileViewModel { 
        
        let attrText = NSMutableAttributedString(string: "\(title)", attributes: [.font: UIFont.systemFont(ofSize: 35,weight: .heavy)])
        attrText.append(NSAttributedString(string: "\n \(brandName)", attributes: [.font : UIFont.systemFont(ofSize: 25, weight: .bold)]))
        
        return UserProfileViewModel(attrString: attrText, viewImgs: [posterImgName], infoLocation: .center, userID: " ")
    }
}
