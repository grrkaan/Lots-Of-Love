//
//  AgeRangeCell.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 4.03.2021.
//

import UIKit

class AgeRangeCell: UITableViewCell {
    
    
    let minSlider : UISlider = {
        
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 90
        return slider
    }()
    
    let maxSlider : UISlider = {
        
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 90
        return slider
    }()
    
    let lblMin : UILabel = {
        
        let lbl = AgeRangeLabel()
        lbl.text = "Min Age"
        return lbl
    }()
    
    let lblMax : UILabel = {
        
        let lbl = AgeRangeLabel()
        lbl.text = "Max Age"
        return lbl
    }()
    
    
    class AgeRangeLabel : UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        let stackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [lblMin,minSlider]),
            UIStackView(arrangedSubviews: [lblMax,maxSlider])
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
      
        contentView.addSubview(stackView)
        
        addSubview(stackView)
        _ = stackView.anchor(top: topAnchor,
                             bottom: bottomAnchor,
                             trailing: trailingAnchor,
                             leading: leadingAnchor,
                             padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
