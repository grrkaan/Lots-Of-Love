//
//  ProfileViewModel.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 18.02.2021.
//

import UIKit

class UserProfileViewModel {
    
    let userID : String
    let attrString : NSAttributedString
    let viewImgs : [String]
    let infoLocation :NSTextAlignment
    
    
    init(attrString : NSAttributedString, viewImgs : [String], infoLocation :NSTextAlignment, userID : String) {
        self.userID = userID
        self.attrString = attrString
        self.viewImgs = viewImgs
        self.infoLocation = infoLocation
    }
    
    fileprivate var imgIndex = 0 {
        
        didSet {
            
            let imgUrl = viewImgs[imgIndex]
            
            imgIndexObs?(imgIndex, imgUrl)
        }
    }
    
    var imgIndexObs : ( (Int, String?) -> ())?
    
    
     func nextImg(){
        imgIndex = imgIndex + 1 >= viewImgs.count ? 0 : imgIndex + 1
    }
    
     func prevImg(){
        imgIndex = imgIndex - 1 < 0 ? viewImgs.count - 1 : imgIndex - 1
    }
}


protocol ProfileViewModelCreate {
    func userProfileViewModelCreate() -> UserProfileViewModel 
}
