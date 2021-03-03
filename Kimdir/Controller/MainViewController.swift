//
//  ViewController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 14.02.2021.
//

import UIKit
import Firebase
import JGProgressHUD
class MainViewController: UIViewController {
    
    let topStackView = MainBoardTopStackView()
    let profileBundleView = UIView()
    let bottomStackView = MainBoardBottomStackView()
    
    var userProfileViewModels = [UserProfileViewModel]()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        topStackView.btnProfile.addTarget(self, action: #selector(profileBtnPressed), for: .touchUpInside)
        bottomStackView.refreshBtn.addTarget(self, action: #selector(refreshBtnPressed), for: .touchUpInside)
        layoutEdit()
        profileViewEditFS()
        getUserDatasFS()
        
        //exampleLogin()
    }
    
    fileprivate func exampleLogin() {
        Auth.auth().signIn(withEmail: "kaan@ihs.com", password: "123456", completion: nil)
    }
    
    
    var lastUserData : User?
    fileprivate func getUserDatasFS() {
       
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Searching New Profiles"
        hud.show(in: view)
        
        let usersQuery = Firestore.firestore().collection("Users")
            .order(by: "UserId")
            .start(after: [lastUserData?.userId ?? ""])
            .limit(to: 1)
        
        
        usersQuery.getDocuments { (snapshot , error) in
            
            if let error = error {
                print(error)
                return
            }
            snapshot?.documents.forEach({ (dSnapshot) in
                hud.dismiss()
                let userData = dSnapshot.data()
                let user = User(datas: userData)
                self.userProfileViewModels.append(user.userProfileViewModelCreate())
                self.lastUserData = user
                self.createProfileFromData(user: user)
            })
            
        }
    }
    
    fileprivate func createProfileFromData(user : User) {
       
        let pView = ProfileView(frame: .zero)
        pView.userViewModel = user.userProfileViewModelCreate()
        profileBundleView.addSubview(pView)
        pView.fillSuperView()
    }
    
    @objc func profileBtnPressed() {
      
        let profileController = ProfileController()
        let navController = UINavigationController(rootViewController: profileController)
        present(navController, animated: true)
        
    }
    
    @objc func refreshBtnPressed() {
        getUserDatasFS()
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
    
    func profileViewEditFS() {
        
        userProfileViewModels.forEach { (uvm) in
            
            let profileView = ProfileView(frame: .zero)
            
            profileView.userViewModel = uvm
            profileBundleView.addSubview(profileView)
            profileView.fillSuperView()  
        }
        
        
        
    }
    
    
}

