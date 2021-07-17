//
//  DMButton.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 17.07.2021.
//

import UIKit


class KSButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
        let gLayer = CAGradientLayer()
        let firstColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        let lastColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        
        gLayer.colors = [firstColor.cgColor, lastColor.cgColor]
        gLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let cornerRad = rect.height / 2
        let maskLayer = CAShapeLayer()
        let maskPath = CGMutablePath()
        
        maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRad).cgPath)
        maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerRadius: cornerRad).cgPath)
        
        maskLayer.fillRule = .evenOdd
        maskLayer.path = maskPath
        
        self.layer.insertSublayer(gLayer, at: 0)
        self.layer.cornerRadius = cornerRad
        clipsToBounds = true
        
        gLayer.mask = maskLayer
        gLayer.frame = rect
        
        
        
    }
}
