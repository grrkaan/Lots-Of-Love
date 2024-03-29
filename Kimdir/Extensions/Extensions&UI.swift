//
//  Extensions&UI.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 14.02.2021.
//

import UIKit


struct AnchorConstraints {
    
    var top : NSLayoutConstraint?
    var bottom : NSLayoutConstraint?
    var trailing : NSLayoutConstraint?
    var leading : NSLayoutConstraint?
    var width : NSLayoutConstraint?
    var height : NSLayoutConstraint?
    
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView{
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                trailing: NSLayoutXAxisAnchor?,
                leading: NSLayoutXAxisAnchor?,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) -> AnchorConstraints{
        
        translatesAutoresizingMaskIntoConstraints = false
        var aConstraint = AnchorConstraints()
        
        if let top = top {
            aConstraint.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let bottom = bottom {
            aConstraint.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let leading = leading {
            aConstraint.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let trailing = trailing {
            aConstraint.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            aConstraint.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            aConstraint.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [aConstraint.top,aConstraint.bottom,aConstraint.trailing,aConstraint.leading,aConstraint.width,aConstraint.height].forEach { $0?.isActive = true }
        
        return aConstraint
    }
    
    func fillSuperView(padding: UIEdgeInsets = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let sTop = superview?.topAnchor {
            topAnchor.constraint(equalTo: sTop, constant: padding.top).isActive = true
        }
        
        if let sBottom = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: sBottom, constant: -padding.bottom).isActive = true
        }
        
        if let sTrailing = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: sTrailing, constant: -padding.right).isActive = true
        }
        
        if let sLeading = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: sLeading, constant: padding.left).isActive = true
        }
    }
    
    func centeredSuperView(size : CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        
        if let centerX = superview?.centerXAnchor{
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if let centerY = superview?.centerYAnchor{
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
    }
    
    
    
    func centerX(_ anchor : NSLayoutXAxisAnchor) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: anchor).isActive = true
    }
    
    func centerY(_ anchor : NSLayoutYAxisAnchor) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: anchor).isActive = true
    }
    
    func centerXSuperView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let superViewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superViewCenterXAnchor).isActive = true
        }
    }
    
    func centerYSuperView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let superViewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superViewCenterYAnchor).isActive = true
        }
    }
    
    @discardableResult
    func constraintHeight(_ height : CGFloat) -> AnchorConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var const = AnchorConstraints()
        
        const.height = heightAnchor.constraint(equalToConstant: height)
        const.height?.isActive = true
        return const
    }
    
    @discardableResult
    func constraintWidth(_ width : CGFloat) -> AnchorConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var const = AnchorConstraints()
        
        const.width = widthAnchor.constraint(equalToConstant: width)
        const.width?.isActive = true
        return const
    }
    
    
    func addShadow(opacity : Float = 0, radius : CGFloat = 0, offset : CGSize = .zero , color : UIColor = .black){
        
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor

    }
    
    convenience init (backgroundColor : UIColor = .clear) {
        
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
    
    
    
    
    
}
