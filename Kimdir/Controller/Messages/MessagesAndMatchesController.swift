//
//  MessagesAndMatchesController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 22.07.2021.
//

import Foundation
import UIKit
import Firebase


struct Match {
    let userName : String
    let profileImgUrl : String
    
    
    init(data : [String : Any]) {
        self.userName = data["UserName"] as? String ?? ""
        self.profileImgUrl = data["ImgUrlFirst"] as? String ?? ""
    }
    
    
}


class  MatchCell: ListCell<Match> {
    
    let profileImg = UIImageView(UIImage(named: "riri-1")!, contentMode: .scaleAspectFill)
    let lblUsername = UILabel(text: "Rihanna", font: .systemFont(ofSize: 15), textColor: .darkGray, textAlignment: .center, numberOfLines: 2)
    
   
    override var data: Match!{
        didSet{
            lblUsername.text = data.userName
            profileImg.sd_setImage(with: URL(string: data.profileImgUrl))
        }
    
    

    }
    
    override func createViews() {
        super.createViews()
       
        profileImg.clipsToBounds = true
        profileImg.resizing(.init(width: 80, height: 80))
        profileImg.layer.cornerRadius = 40
        createStackView(createStackView(profileImg,alignment: .center),lblUsername)
    }
    
}


class MessagesAndMatchesController : ListController<MatchCell,Match>, UICollectionViewDelegateFlowLayout {
    
   
    
    let navBar = MatchesNavBar()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 145, height: 145)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        getMatches()
       
        navBar.btnBack.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        collectionView.backgroundColor = .white
        view.addSubview(navBar)
        
        
        navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                      bottom: nil,
                      trailing: view.trailingAnchor,
                      leading: view.leadingAnchor,
                      size: .init(width: 0, height: 150))
        
        
        collectionView.contentInset.top = 150
        
    }
    
    
    
    fileprivate func getMatches() {
        
        guard let currenUserID = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Messages").document(currenUserID).collection("Matches").getDocuments { (snapshot , error) in
            
            
            if let error = error {
                print("Getting error when currentuser messages \(error.localizedDescription)")
                return
            }
            
            
            var matches = [Match]()
            
            snapshot?.documents.forEach({(docSnapshot) in
                let data = docSnapshot.data()
                matches.append(.init(data: data))
            })
            self.datas = matches
            self.collectionView.reloadData()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
}
 
extension MessagesAndMatchesController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let match = datas[indexPath.item]
        let messageSaveController = MessageSaveController(match: match)
        navigationController?.pushViewController(messageSaveController, animated: true)
    }
    
    
}
