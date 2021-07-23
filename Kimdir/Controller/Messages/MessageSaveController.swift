//
//  MessageSaveController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 23.07.2021.
//

import Foundation
import UIKit


struct Message {
    let text : String
}


class MessageCell : ListCell<Message> {
    override var data : Message! {
        didSet{
            backgroundColor = .blue
        }
    }
}

class MessageSaveController : ListController<MessageCell,Message> {
    
    let navBar = MessageNavBar()
    fileprivate let navBarHeight : CGFloat = 125
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datas = [
            .init(text: "Test1"),
            .init(text: "Test1"),
            .init(text: "Test1"),
            .init(text: "Test1")
        ]
        
        
        view.addSubview(navBar)
        navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                      bottom: nil,
                      trailing: view.trailingAnchor,
                      leading: view.leadingAnchor,
                      size: .init(width: 0, height: navBarHeight))
        
        
        collectionView.contentInset.top = navBarHeight
    }
    
}

extension MessageSaveController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
}


class MessageNavBar: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor =  .white
        addShadow(opacity: 0.3, radius: 10, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.5))
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
