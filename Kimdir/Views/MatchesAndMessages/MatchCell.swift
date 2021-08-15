//
//  MatchCell.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 15.08.2021.
//

import Foundation
import UIKit

class  MatchCell: ListCell<Match> {
    
    let profileImg = UIImageView(UIImage(named: "riri-1")!, contentMode: .scaleAspectFill)
    let lblUsername = UILabel(text: "Rihanna", font: .systemFont(ofSize: 15), textColor: .darkGray, textAlignment: .center, numberOfLines: 2)
    
   
    override var data: Match!{
        didSet{
            lblUsername.text = data.userName
            profileImg.sd_setImage(with: URL(string: data.profileImgUrl))
        }
    
    

    }
    
    override func createViews() {
        super.createViews()
       
        profileImg.clipsToBounds = true
        profileImg.resizing(.init(width: 80, height: 80))
        profileImg.layer.cornerRadius = 40
        createStackView(createStackView(profileImg,alignment: .center),lblUsername)
    }
    
}
