//
//  ViewController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 14.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let topStackView = MainBoardTopStackView()
    let centerView = UIView()
    let bottomStackView = MainBoardBottomStackView()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    
        centerView.backgroundColor = .systemTeal
        layoutEdit()
        
        
    }
    //MARK:- Layout Edit Function
    func layoutEdit() {
        
        let generalStackView = UIStackView(arrangedSubviews: [topStackView,centerView,bottomStackView])
        generalStackView.axis = .vertical
        
        view.addSubview(generalStackView)
        
        generalStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, leading: view.leadingAnchor)
        
    }
    
    
}

