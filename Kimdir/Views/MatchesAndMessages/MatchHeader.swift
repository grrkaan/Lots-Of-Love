//
//  MatchHeader.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 15.08.2021.
//

import Foundation
import UIKit


class MatchHeader: UICollectionReusableView {
    
    
    let lblHotMatches = UILabel(text: "Hot Matches", font: .boldSystemFont(ofSize: 19), textColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
    let lblMessages = UILabel(text: "Last DM's", font: .boldSystemFont(ofSize: 19), textColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
    let matchesHorizontalController = MatchesHorizontalController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createStackView(createStackView(lblHotMatches).padLeft(22),
                        matchesHorizontalController.view,
                        createStackView(lblMessages).padLeft(22),
                        spacing: 22).withMarging(.init(top: 22, left: 0, bottom: 5, right: 0))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
