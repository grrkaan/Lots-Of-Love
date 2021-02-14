//
//  MainBoardBottomStackView.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 14.02.2021.
//

import UIKit

class MainBoardBottomStackView: UIStackView {

    override init(frame : CGRect){
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        let bottomSubViews = [#imageLiteral(resourceName: "yenile"),#imageLiteral(resourceName: "kapat"),#imageLiteral(resourceName: "superLike"),#imageLiteral(resourceName: "like"),#imageLiteral(resourceName: "boost")].map { (img) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
            
        }
        
        bottomSubViews.forEach { (v)  in
            addArrangedSubview(v)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder) eklenmedi")
    }
    
}
