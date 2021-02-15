//
//  MainProfileView.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 15.02.2021.
//

import UIKit

class MainProfileView: UIView {
    
    fileprivate let profileImg = UIImageView(image:#imageLiteral(resourceName: "steve-halama-dfwFFQLvc0s-unsplash") )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        
        addSubview(profileImg)
        profileImg.fillSuperView()
        
        
        let panG = UIPanGestureRecognizer(target: self, action: #selector(profilePanCatch))
        addGestureRecognizer(panG)
    }
    
    
    
    @objc func profilePanCatch(panGesture : UIPanGestureRecognizer){
        
        
        
        switch panGesture.state {
        
        case .changed :
            swipeAnimation(panGesture)
            
        case .ended :
            endSwipeAnimation(panGesture)
            
            
        default :
            break
        }
        
        
    }
    
    
    fileprivate func endSwipeAnimation(_ panGesture : UIPanGestureRecognizer) {
        
        let outBorder : CGFloat = 120
        let translationWay : CGFloat = panGesture.translation(in: nil).x > 0 ? 1 : -1
        
        let discardProfileFlag : Bool = abs(panGesture.translation(in: nil).x) > outBorder
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut,
                       animations: {
                        if discardProfileFlag {
                            
                            self.frame = CGRect(x: 600 * translationWay, y: 0, width: self.frame.width, height: self.frame.height)
                            
                        }else {
                            self.transform = .identity
                        }
                        
                       })
        { (_) in
            self.transform = .identity
            if discardProfileFlag {
                self.removeFromSuperview()
            }
        }
        
        
    }
    
    fileprivate func swipeAnimation(_ panGesture: UIPanGestureRecognizer) {
        
        let translation = panGesture.translation(in: nil)
        
        let angle : CGFloat = translation.x / 15
        let radianAngle = (angle * .pi) / 180
        
        let swipeTransform = CGAffineTransform(rotationAngle: radianAngle)
        self.transform = swipeTransform.translatedBy(x: translation.x, y: translation.y)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
