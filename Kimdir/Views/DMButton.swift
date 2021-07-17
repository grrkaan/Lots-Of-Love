//
//  DMButton.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 17.07.2021.
//

import UIKit


class DMButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
        let gLayer = CAGradientLayer()
        let firstColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        let lastColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        
        gLayer.colors = [firstColor.cgColor, lastColor.cgColor]
        gLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        self.layer.insertSublayer(gLayer, at: 0)
        self.layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        
        gLayer.frame = rect
        
        
        
    }
}
