//
//  Match.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 15.08.2021.
//

import Foundation



struct Match {
    let userName : String
    let profileImgUrl : String
    let userId : String
    
    init(data : [String : Any]) {
        self.userName = data["UserName"] as? String ?? ""
        self.profileImgUrl = data["ImgUrlFirst"] as? String ?? ""
        self.userId = data["UserId"] as? String ?? ""
    }
    
    
}
