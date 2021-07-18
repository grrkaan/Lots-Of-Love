//
//  TextFieldIntend.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 18.07.2021.
//

import Foundation
import UIKit

class TextFieldInted: UITextField {
    
    let padding : CGFloat
    
    public init(placeholder: String? = nil ,padding : CGFloat = 0 ,cornerRadius : CGFloat = 0, keyboardType : UIKeyboardType = .default, backgroundColor: UIColor = UIColor.clear, isSecureTextEntry : Bool = false) {
        
        
        self.padding = padding
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        layer.cornerRadius = cornerRadius
        self.keyboardType = keyboardType
        self.backgroundColor = backgroundColor
        self.isSecureTextEntry = isSecureTextEntry
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
