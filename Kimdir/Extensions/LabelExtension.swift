//
//  LabelExtension.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 18.07.2021.
//

import Foundation
import UIKit

extension UILabel {
    
    
    convenience init(text: String? = nil, font : UIFont? = UIFont.systemFont(ofSize: 15), textColor : UIColor = .black, textAlignment : NSTextAlignment = .left, numberOfLines : Int = 1) {
        
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
    
    
    
}
