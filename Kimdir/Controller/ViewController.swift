//
//  ViewController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 14.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let topStackView = MainBoardTopStackView()
    let profileBundleView = UIView()
    let bottomStackView = MainBoardBottomStackView()
    
    var userProfileViewModels : [UserProfileViewModel] = [
        User(userName: "Kaan", job: "Computer Engineer", age: 25, profileImg: "pp-1").userProfileViewModelCreate(),
        User(userName: "Selman", job: "Javatar", age: 25, profileImg: "pp-2").userProfileViewModelCreate(),
        User(userName: "Gökçe", job: "Artist", age: 21, profileImg: "pp-3").userProfileViewModelCreate()
    ]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutEdit()
        profileViewEdit()
        
    }
    //MARK:- Layout Edit Function
    func layoutEdit() {
        
        let generalStackView = UIStackView(arrangedSubviews: [topStackView,profileBundleView,bottomStackView])
        generalStackView.axis = .vertical
        
        view.addSubview(generalStackView)
        
        generalStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, leading: view.leadingAnchor)
        
        generalStackView.isLayoutMarginsRelativeArrangement = true
        generalStackView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        generalStackView.bringSubviewToFront(profileBundleView)
        
    }
    
    func profileViewEdit() {
       
        userProfileViewModels.forEach { (uvm) in
            
            let profileView = ProfileView(frame: .zero)
            profileView.profileImg.image = UIImage(named: uvm.viewImg)
            profileView.lblUserInfos.attributedText = uvm.attrString
            profileView.lblUserInfos.textAlignment = uvm.infoLocation
            
            profileBundleView.addSubview(profileView)
            profileView.fillSuperView()  
        }
        
       
        
    }
    
    
}

