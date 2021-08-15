//
//  MessageCell.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 15.08.2021.
//

import Foundation
import UIKit

class MessageCell : ListCell<Message> {
    
    let messageContainer = UIView(backgroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
    
    let txtMessage : UITextView = {
        
        let txt = UITextView()
        txt.backgroundColor = .clear
        txt.font = .systemFont(ofSize: 20)
        txt.isScrollEnabled = false
        txt.isEditable = false
        return txt
        
        
    }()
    override var data : Message! {
        didSet{
            txtMessage.text = data.message
            
            if data.myDM {
                messageConst.leading?.isActive = false
                messageConst.trailing?.isActive = true
                messageContainer.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                txtMessage.textColor = .white
                
            }else {
                messageConst.leading?.isActive = true
                messageConst.trailing?.isActive = false
                messageContainer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                txtMessage.textColor = .black
            }
        }
    }
    
    
    var messageConst : AnchorConstraints!
    override func createViews() {
        super.createViews()
        addSubview(messageContainer)
        
        
        
        messageConst =  messageContainer.anchor(top: topAnchor, bottom: bottomAnchor, trailing: trailingAnchor, leading: leadingAnchor)
        
        messageConst.leading?.constant = 20
        messageConst.trailing?.constant  = -20
        
        
        messageContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 260).isActive = true
        messageContainer.layer.cornerRadius = 15
        messageContainer.addSubview(txtMessage)
        txtMessage.fillSuperView(padding: .init(top: 5, left: 13, bottom: 5, right: 13))
        
        
        
    }
}
