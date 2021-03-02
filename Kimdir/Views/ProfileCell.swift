//
//  ProfileCell.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 3.03.2021.
//

import UIKit

class ProfileCell: UITableViewCell {

    class EditTextField : UITextField {
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 25, dy: 0)
        }
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 25, dy: 0)
        }
        override var intrinsicContentSize: CGSize {
            return .init(width: 0, height: 45)
        }
    }
    
    let textField : UITextField = {
        let txt = EditTextField()
        txt.placeholder = "Age Info Here ..."
        return txt
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        textField.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        textField.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
