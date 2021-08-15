//
//  Message.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 15.08.2021.
//

import Foundation
import UIKit
import Firebase


struct Message {
    let message : String
    let myDM : Bool

    let currentUserId : String
    let loverId : String
    let timestamp : Timestamp


    init(messageData : [String : Any]) {
      
        self.message = messageData["Message"] as? String ?? ""
        self.currentUserId = messageData["CurrentUserId"] as? String ?? ""
        self.loverId = messageData["LoverId"] as? String ?? ""
        self.timestamp = messageData["Timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.myDM = Auth.auth().currentUser?.uid == self.currentUserId
        
    }
}
