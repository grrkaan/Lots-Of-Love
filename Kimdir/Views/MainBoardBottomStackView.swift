//
//  MainBoardBottomStackView.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 14.02.2021.
//

import UIKit

class MainBoardBottomStackView: UIStackView {

    static func createButton(img : UIImage) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
    }
    
    let refreshBtn = createButton(img: #imageLiteral(resourceName: "yenile"))
    let disLikeBtn = createButton(img: #imageLiteral(resourceName: "disLike"))
    let superLikeBtn = createButton(img: #imageLiteral(resourceName: "superLike"))
    let likeBtn = createButton(img: #imageLiteral(resourceName: "like"))
    let boostBtn = createButton(img: #imageLiteral(resourceName: "boost"))
    
    
    override init(frame : CGRect){
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        

        [refreshBtn,disLikeBtn,superLikeBtn,likeBtn,boostBtn].forEach { (btn) in
            self.addArrangedSubview(btn)
        }
        
    }

    required init(coder: NSCoder) {
        fatalError("init(coder) eklenmedi")
    }
    
}
