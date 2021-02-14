//
//  MainBoardTopStackView.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 14.02.2021.
//

import UIKit

class MainBoardTopStackView: UIStackView {
    
    
    let imgFlame = UIImageView(image: #imageLiteral(resourceName: "alev"))
    let btnProfile = UIButton(type: .system)
    let btnDM = UIButton(type: .system)
    
    
    override init(frame : CGRect){
        super.init(frame: frame)
      
        
        imgFlame.contentMode = .scaleAspectFit
        btnProfile.setImage(#imageLiteral(resourceName: "profil").withRenderingMode(.alwaysOriginal), for: .normal)
        btnDM.setImage(#imageLiteral(resourceName: "mesaj").withRenderingMode(.alwaysOriginal), for: .normal)
      
        [btnProfile,UIView(),imgFlame,UIView(),btnDM].forEach {
            (v) in addArrangedSubview(v)
        }
        
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 18, bottom: 0, right: 18)
        
    }

    required init(coder: NSCoder) {
        fatalError("init(coder) eklenmedi")
    }

}
