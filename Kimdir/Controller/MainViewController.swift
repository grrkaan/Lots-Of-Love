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
        bottomStackView.disLikeBtn.addTarget(self, action: #selector(dislikeBtnPressed), for: .touchUpInside)
        
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
            self.getCurrentUserSwipes()
            
        }
        
    }
    
    
    var swipeDatas = [String : Int]()
    fileprivate func getCurrentUserSwipes(){
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Swipes").document(userID).getDocument { (snapshot , error) in
            
            if let error = error {
                print("Error when getting current user swipes : \(error.localizedDescription)")
                return
            }
            
            guard let swipeData = snapshot?.data() as? [String : Int] else {
                
                self.swipeDatas.removeAll()
                self.getUserDatasFS()
                
                return
                
            }
            self.swipeDatas = swipeData
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
        
        lastProfileView = nil
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
                let isThatMe = user.userId == Auth.auth().currentUser?.uid
            
                
                // let swipeCheck = self.swipeDatas[user.userId] != nil
                let swipeCheck = false
                
                if  !isThatMe && !swipeCheck {
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
        

        profileBundleView.subviews.forEach({ $0.removeFromSuperview() })
        getCurrentUser()
        
    }
    
    
    
    fileprivate func saveSwipesFS(swipeFeelings: Int) {
        
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        guard let loverID = lastProfileView?.userViewModel.userID else { return }
        
        
        let swipeData = [loverID : swipeFeelings]
        
        Firestore.firestore().collection("Swipes").document(userID).getDocument { (snapshot , error) in
            
            
            if let error = error {
                print("Getting error when swipes collecting.. \(error.localizedDescription)")
                return
            }
            
            
            if snapshot?.exists == true {
                //Add new Swipes
                
                Firestore.firestore().collection("Swipes").document(userID).updateData(swipeData) { (error) in
                    
                    if let error = error {
                        print("Swipe Save failed.. \(error.localizedDescription)")
                        return
                    }
                    
                    
                    print("Swipe Saved..")
                    
                    if swipeFeelings == 1{
                        self.matchControl(loverID: loverID)
                    }
                    
                }
                
                
            }else {
                // First Swipe Save
                
                Firestore.firestore().collection("Swipes").document(userID).setData(swipeData) { (error) in
                    
                    if let error = error {
                        print("Swipe Save failed.. \(error.localizedDescription)")
                        return
                    }
                    
                    
                    print("Swipe Saved..")
                    
                    if swipeFeelings == 1{
                        self.matchControl(loverID: loverID)
                    }
                    
                }
                
            }
            
        }
        
        
        
        
        
    }
    
    
    
    
    var lastProfileView : ProfileView?
    @objc func likeBtnPressed() {
        
        saveSwipesFS(swipeFeelings: 1)
        profileSwipeAnimation(translation: 800, angle: 18)
        
    }
    
    
    @objc func dislikeBtnPressed() {
        
        
        saveSwipesFS(swipeFeelings: 0)
        profileSwipeAnimation(translation: -800, angle: 18)
        
    }
    
    
    
    fileprivate func profileSwipeAnimation(translation:CGFloat , angle : CGFloat) {
        
        let basicAnimation = CABasicAnimation(keyPath: "position.x")
        basicAnimation.toValue = translation
        basicAnimation.duration = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        basicAnimation.isRemovedOnCompletion = false
        
        
        let swipeAnimaion = CABasicAnimation(keyPath: "transform.rotation.z")
        swipeAnimaion.toValue = CGFloat.pi * angle / 180
        swipeAnimaion.duration = 1
        
        let lastPView = lastProfileView
        lastProfileView = lastPView?.nextProfileView
        
        CATransaction.setCompletionBlock {
            
            lastPView?.removeFromSuperview()
            
        }
        
        lastPView?.layer.add(basicAnimation, forKey: "animation")
        lastPView?.layer.add(swipeAnimaion, forKey: "swipe")
        
        CATransaction.commit()
        
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
    
    
    fileprivate func matchControl(loverID : String) {
        
        print("Match Control Started..")
        
        Firestore.firestore().collection("Swipes").document(loverID).getDocument { (snapshot , error) in
            
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
                
            }
            
            guard let data = snapshot?.data() else { return }
            
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let matchFlag = data[userID] as? Int == 1
            
            if matchFlag {
                print("It's match LOVERS")
                self.getMatchView(loverID: loverID)
                
            }
            
            
            
            
        }
        
    }
    
    
    fileprivate func getMatchView(loverID : String) {
        
        let matchView = MatchView()
        matchView.loverID = loverID
        matchView.currentUser = currentUser
        view.addSubview(matchView)
        matchView.fillSuperView()
        
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
