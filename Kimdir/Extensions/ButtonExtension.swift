//
//  ButtonExtension.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 18.07.2021.
//

import Foundation
import UIKit


extension UIButton {
    
    
    convenience init(title : String, titleColor : UIColor, titleFont : UIFont = .systemFont(ofSize: 15), backgroundColor : UIColor = .clear, target : Any? = nil, action : Selector? = nil) {
        
        self.init(type: .system)
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        
        self.titleLabel?.font = titleFont
        self.backgroundColor = backgroundColor
        
        if let action = action {
            
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    
    convenience init(image: UIImage, tintColor : UIColor? = nil, target : Any? = nil, action : Selector? = nil) {
        
        self.init(type: .system)
        
        if tintColor == nil {
            setImage(image, for: .normal)
        }else {
            
            setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        if let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
        
        
    }
    
    
}
