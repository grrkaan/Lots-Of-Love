//
//  RegisterTextField.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 27.02.2021.
//

import UIKit

class CustomTextField: UITextField {

    let padding : CGFloat
    let height : CGFloat
    init(padding: CGFloat , height: CGFloat) {
        self.padding = padding
        self.height = height
        super.init(frame: .zero)
        layer.cornerRadius = 15
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        backgroundColor = .white
        textColor = UIColor.black
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: height)
    }
    
}
