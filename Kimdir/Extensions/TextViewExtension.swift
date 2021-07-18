//
//  TextViewExtension.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 18.07.2021.
//

import Foundation
import UIKit

extension UITextView {
    
    
    convenience init(text : String?, font : UIFont? = UIFont.systemFont(ofSize: 15), textColor : UIColor = .black, textAlignment : NSTextAlignment = .left) {
        
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        
        
    }
    
}
