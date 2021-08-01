//
//  MessageNavBar.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 1.08.2021.
//

import Foundation
import UIKit


class MessageNavBar: UIView {
    
    
    let profileImg = CircularImageView(width: 50,image:#imageLiteral(resourceName: "riri-4") )
    
    let userNameLbl = UILabel(text: "Riri", font: .systemFont(ofSize: 17))
    
    let backBtn = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
    
    let btnFlag = UIButton(image: #imageLiteral(resourceName: "flag"), tintColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
    
    fileprivate let match : Match
    
     init(match: Match) {
        
        self.match = match
        
        userNameLbl.text = match.userName
        profileImg.sd_setImage(with: URL(string: match.profileImgUrl))
        
        super.init(frame: .zero)
        
        backgroundColor =  .white
        addShadow(opacity: 0.3, radius: 10, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.5))
        
        let midSV = createHorizontalStackView(createStackView(profileImg,userNameLbl,spacing : 10,alignment: .center), alignment: .center)
        
        createHorizontalStackView(backBtn,midSV,btnFlag).withMarging(.init(top: 0, left: 15, bottom: 0, right: 15))
        
        
        
        
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
