//
//  ListCell.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 18.07.2021.
//

import Foundation
import UIKit


open class ListCell<T> : UICollectionViewCell {
    
    
    
    var data : T!
    
    var inputController : UIViewController?
    
    
    public let splitView = UIView(backgroundColor: UIColor(white: 0.65, alpha: 0.55))
    
    
    func addSplit(leftSpace : CGFloat = 0) {
        
        addSubview(splitView)
        
        splitView.anchor(top: nil,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor,
                         leading: leadingAnchor,
                         padding: .init(top: 0, left: leftSpace, bottom: 0, right: 0),
                         size: .init(width: 0, height: 0.5))
        
    }
    
    func addSplit(leadingAnchor : NSLayoutXAxisAnchor) {
        
        addSubview(splitView)
        
        splitView.anchor(top: nil,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor,
                         leading: leadingAnchor,
                         size: .init(width: 0, height: 0.5))
        
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        createViews()
    }
    
    open func createViews() {
        
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
