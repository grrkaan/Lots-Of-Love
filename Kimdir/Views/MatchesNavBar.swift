//
//  MatchesNavBar.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 22.07.2021.
//

import Foundation
import UIKit

class MatchesNavBar : UIView {
   
    
    let btnBack = UIButton(image: UIImage(named: "alev")!, tintColor: .lightGray)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let dmIcon = UIImageView((UIImage(named: "mesaj")?.withRenderingMode(.alwaysTemplate))!, contentMode: .scaleAspectFit)
        dmIcon.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        let lblMessages = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 21), textColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), textAlignment: .center)
        
        let lblFeed = UILabel(text: "Feed", font: .boldSystemFont(ofSize: 21), textColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), textAlignment: .center)
        
        createStackView(dmIcon.setHeight(40),createHorizontalStackView(lblMessages,lblFeed,distribution: .fillEqually).padTop(10))
        
        addShadow(opacity: 0.15, radius: 10, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        
        addSubview(btnBack)
        
        btnBack.anchor(top: safeAreaLayoutGuide.topAnchor,
                       bottom: nil,
                       trailing: nil,
                       leading: leadingAnchor,
                       padding: .init(top: 12, left: 12, bottom: 0, right: 0),
                       size: .init(width: 35, height: 35))
        
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
