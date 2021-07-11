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
        bottomStackView.likeBtn.addTarget(self, action: #selector(likeBtnPressed), for: .touchUpInside)
        
        layoutEdit()
        getCurrentUser()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
//            let loginController = LoginController()
//            loginController.delegate = self
            let registerController = RegisterController()
            registerController.delegate = self
            let navController = UINavigationController(rootViewController: registerController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
        
        
    }
    
    fileprivate func exampleLogin() {
        Auth.auth().signIn(withEmail: "kaan@ihs.com", password: "123456", completion: nil)
    }
    
    
    fileprivate var currentUser : User?
    fileprivate func getCurrentUser() {
        
        profileBundleView.subviews.forEach({ $0.removeFromSuperview() })
        
        Firestore.firestore().getCurrentUser { (currentUser , error) in
            if let error = error {
                print(error)
                return
            }
            
            self.currentUser = currentUser
            self.getUserDatasFS()
         }
        
    }
    
    var lastUserData : User?
    fileprivate func getUserDatasFS() {
        
        let minAge = currentUser?.minAge ?? ProfileController.defaultMinAge
        let maxAge = currentUser?.maxAge ?? ProfileController.defaultMaxAge
       
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Searching New Profiles"
        hud.show(in: view)
        
        let usersQuery = Firestore.firestore().collection("Users")
            .whereField("Age", isGreaterThanOrEqualTo: minAge)
            .whereField("Age", isLessThanOrEqualTo: maxAge)
        
        
        usersQuery.getDocuments { (snapshot , error) in
            
            if let error = error {
                print(error)
                return
            }
            
            
            var previousProfileView : ProfileView?
            
            snapshot?.documents.forEach({ (dSnapshot) in
                hud.dismiss()
                let userData = dSnapshot.data()
                let user = User(datas: userData)
                
                if user.userId != self.currentUser?.userId {
                   let pView =  self.createProfileFromData(user: user)
                    
                    if self.lastProfileView == nil {
                        self.lastProfileView = pView
                    }
            
                    previousProfileView?.nextProfileView = pView
                    previousProfileView = pView
            
            
            
                }
            })
            
        }
    }
    
    fileprivate func createProfileFromData(user : User) -> ProfileView {
       
        let pView = ProfileView(frame: .zero)
        pView.delegate = self
        pView.userViewModel = user.userProfileViewModelCreate()
        profileBundleView.addSubview(pView)
        profileBundleView.sendSubviewToBack(pView)
        pView.fillSuperView()
        
        return pView
    }
    
    @objc func profileBtnPressed() {
      
        let profileController = ProfileController()
        profileController.delegate = self
        let navController = UINavigationController(rootViewController: profileController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
        
    }
    
    @objc func refreshBtnPressed() {
        getUserDatasFS()
    }
    
    
    
    var lastProfileView : ProfileView?
    @objc func likeBtnPressed() {
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            
            self.lastProfileView?.frame = CGRect(x: 600, y: 0, width: (self.lastProfileView?.frame.width)!, height: (self.lastProfileView?.frame.height)!)
            
            
            let angle = CGFloat.pi * 20 / 180
            self.lastProfileView?.transform = CGAffineTransform(rotationAngle: angle)
            
        }) {(_) in
            
            self.lastProfileView?.removeFromSuperview()
            self.lastProfileView = self.lastProfileView?.nextProfileView
        }
        
        
        

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

extension MainViewController : ProfileControllerDelegate {
    func profileSaved() {
        getCurrentUser()
    }
}

extension MainViewController : LoginControllerDelegate {
    func loginEnd() {
        getCurrentUser()
    }
}

extension MainViewController: ProfileViewDelegate {
    
    func removeProfileFromQueue(profileView: ProfileView) {
        self.lastProfileView?.removeFromSuperview()
        self.lastProfileView = self.lastProfileView?.nextProfileView
    }
    
    
    func infoBtnPressed(userVM : UserProfileViewModel) {
        let profileInfoController = ProfileInfoController()
        profileInfoController.modalPresentationStyle = .fullScreen
        profileInfoController.userVM = userVM
        present(profileInfoController, animated: true)
    }
}
