//
//  UIView&StackExtension.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 18.07.2021.
//

import Foundation
import UIKit

extension UIView {
    
    
    fileprivate func _createStackView(_ axis : NSLayoutConstraint.Axis = .vertical, views : [UIView], spacing : CGFloat = 0, alignment : UIStackView.Alignment = .fill, distribution : UIStackView.Distribution = .fill) -> UIStackView {
        
        
        let sv = UIStackView(arrangedSubviews: views)
        sv.axis = axis
        sv.spacing = spacing
        sv.alignment = alignment
        sv.distribution = distribution
        addSubview(sv)
        sv.fillSuperView()
       
        return sv
    }
    
    @discardableResult
    fileprivate func createStackView(_ views: UIView... , spacing : CGFloat = 0, alignment : UIStackView.Alignment = .fill, distribution : UIStackView.Distribution = .fill) -> UIStackView {
        return _createStackView(.vertical, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
    }
    
    @discardableResult
    fileprivate func createHorizontalStackView(_ views: UIView... , spacing : CGFloat = 0, alignment : UIStackView.Alignment = .fill, distribution : UIStackView.Distribution = .fill) -> UIStackView {
        return _createStackView(.horizontal, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
    }
    
    @discardableResult
    func resizing<T : UIView>(_ size : CGSize) -> T {
        
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
        return self as! T
    }
    
    
    func setHeight(_ height : CGFloat) -> UIView {
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    func setWidth(_ width : CGFloat) -> UIView {
        
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    
    func addBorder<T : UIView>(width : CGFloat, color : UIColor) -> T {
        
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        
        return self as! T
    }
    
}


extension UIEdgeInsets {
    
    static public func edgeInsets(_ value : CGFloat) -> UIEdgeInsets {
        return .init(top: value, left: value, bottom: value, right: value)
    }
}

extension UIImageView {
    
    convenience init(image : UIImage, contentMode : UIView.ContentMode = .scaleAspectFill) {
       
        self.init(image: image)
        self.contentMode = contentMode
        self.clipsToBounds = true
    }
    
    
}
