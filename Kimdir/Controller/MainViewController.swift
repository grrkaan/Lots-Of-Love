//
//  ViewController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 14.02.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    let topStackView = MainBoardTopStackView()
    let profileBundleView = UIView()
    let bottomStackView = MainBoardBottomStackView()
    
    var userProfileViewModels : [UserProfileViewModel] = {
      let profiles = [
        User(userName: "Kaan", job: "Computer Engineer", age: 25, profileImgs: ["pp-1","pp-2"]),
        User(userName: "Selman", job: "Javatar", age: 25, profileImgs: ["pp-2","pp-2"]),
        User(userName: "Gökçe", job: "Artist", age: 21, profileImgs: ["pp-3","pp-2","pp-3","pp-2"]),
        Advertisement(title: "IHS", brandName: "Fcase", posterImgName: "adv-1")
      ] as [ProfileViewModelCreate]
   let viewModels = profiles.map({$0.userProfileViewModelCreate() })
        return viewModels
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        topStackView.btnProfile.addTarget(self, action: #selector(btnProfilePressed), for: .touchUpInside)
        
        layoutEdit()
        profileViewEdit()
        
    }
    
    
    @objc func btnProfilePressed() {
        let registerController = RegisterController()
        present(registerController, animated: true, completion: nil)
        
    }
    
    //MARK:- Layout Edit Function
    func layoutEdit() {
        
        let generalStackView = UIStackView(arrangedSubviews: [topStackView,profileBundleView,bottomStackView])
        generalStackView.axis = .vertical
        
        view.addSubview(generalStackView)
        
        _ = generalStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, leading: view.leadingAnchor)
        
        generalStackView.isLayoutMarginsRelativeArrangement = true
        generalStackView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        generalStackView.bringSubviewToFront(profileBundleView)
        
    }
    
    func profileViewEdit() {
       
        userProfileViewModels.forEach { (uvm) in
            
            let profileView = ProfileView(frame: .zero)

            profileView.userViewModel = uvm
            profileBundleView.addSubview(profileView)
            profileView.fillSuperView()  
        }
        
       
        
    }
    
    
}

