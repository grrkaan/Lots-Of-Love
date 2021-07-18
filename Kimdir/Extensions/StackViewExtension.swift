//
//  StackViewExtension.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 18.07.2021.
//

import Foundation
import UIKit


extension UIStackView {
    
    @discardableResult
    func withMarging(_ margin : UIEdgeInsets) -> UIStackView {
        
        
        layoutMargins = margin
        isLayoutMarginsRelativeArrangement = true
        return self
    }
    
    @discardableResult
    func padTop(_ top : CGFloat) -> UIStackView {
        
        layoutMargins.top = top
        isLayoutMarginsRelativeArrangement = true
        return self
    }
    
    @discardableResult
    func padBottom(_ bottom : CGFloat) -> UIStackView {
        
        layoutMargins.bottom = bottom
        isLayoutMarginsRelativeArrangement = true
        return self
    }
    
    @discardableResult
    func padRight(_ right : CGFloat) -> UIStackView {
        
        layoutMargins.right = right
        isLayoutMarginsRelativeArrangement = true
        return self
    }
    
    @discardableResult
    func padLeft(_ left : CGFloat) -> UIStackView {
        
        layoutMargins.left = left
        isLayoutMarginsRelativeArrangement = true
        return self
    }
    
    
        
}
