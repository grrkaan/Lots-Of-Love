//
//  MessagesAndMatchesController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 22.07.2021.
//

import Foundation
import UIKit
import Firebase



struct LastMessage {
    
    let message : String
    let userId : String
    let userName : String
    let imgUrl : String
    let timestamp : Timestamp
    
    init(data : [String : Any]) {
        
        message = data["Message"] as? String ?? ""
        userId = data["UserId"] as? String ?? ""
        userName = data["UserName"] as? String ?? ""
        imgUrl = data["ImgUrl"] as? String ?? ""
        timestamp = data["Timestamp"] as? Timestamp ?? Timestamp.init(date: Date())
        
        
    }
    
}


class LastMessageCell : ListCell<LastMessage> {
    
    let profileImg = UIImageView( #imageLiteral(resourceName: "riri-1"),contentMode: .scaleAspectFill)
    let lblUserName = UILabel(text: "Riri", font: .boldSystemFont(ofSize: 19))
    let lblLastMessage = UILabel(text: "Last Message", font: .systemFont(ofSize: 16), textColor: .gray,numberOfLines: 2)
    
    override func createViews() {
        super.createViews()

        let imgSize : CGFloat = 100
        profileImg.layer.cornerRadius = imgSize / 2
        
        createHorizontalStackView(profileImg.resizing(.init(width: imgSize, height: imgSize)),createStackView(lblUserName,lblLastMessage,spacing: 4),spacing: 20,alignment: .center).padLeft(20).padRight(20)
        
        addSplit(leadingAnchor: lblUserName.leadingAnchor)
        
    }
    
    
    override var data: LastMessage! {
        didSet {

            lblUserName.text = data.userName
            lblLastMessage.text = data.message
            profileImg.sd_setImage(with: URL(string: data.imgUrl))
            
        }
        
    }
}


class MessagesAndMatchesController : ListHeaderController<LastMessageCell,LastMessage,MatchHeader>, UICollectionViewDelegateFlowLayout {
    
    var lastMessageDictionary = [String : LastMessage]()
    fileprivate func getLastMessages() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Messages").document(currentUserId).collection("Last_Messages").addSnapshotListener { (querySnapshot , error) in
            
            if let error = error {
                print("Error when getting last messages \(error.localizedDescription) ")
                return
            }
            
            querySnapshot?.documentChanges.forEach({ (changes) in
                
                if changes.type == .added || changes.type == .modified {
                    let lastMessageData = changes.document.data()
                    let lastMessage = LastMessage(data: lastMessageData)
                    self.lastMessageDictionary[lastMessage.userId] = lastMessage
                }
                
            })
            
            self.resetDatas()
        }
        
    }
    
    fileprivate func resetDatas() {
     
        let lastMessageArray = Array(lastMessageDictionary.values)
      
        datas = lastMessageArray.sorted(by: { (msg1, msg2) -> Bool in
            return msg1.timestamp.compare(msg2.timestamp) == .orderedDescending
        })
        
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func setHeader(_ header: MatchHeader) {
        header.matchesHorizontalController.rootMatchesAndMessagesController = self
    }
    
    func headerMatchSelect(match : Match) {
        let messageSC = MessageSaveController(match: match)
        navigationController?.pushViewController(messageSC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }
    
    
    let navBar = MatchesNavBar()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 145)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        getLastMessages()
        
        
        createScreen()
        
       
        
    }
    
    fileprivate func createScreen() {
        
        navBar.btnBack.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        collectionView.backgroundColor = .white
        view.addSubview(navBar)
        
        
        navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                      bottom: nil,
                      trailing: view.trailingAnchor,
                      leading: view.leadingAnchor,
                      size: .init(width: 0, height: 150))
        
        
        collectionView.contentInset.top = 150
        collectionView.verticalScrollIndicatorInsets.top = 150
        
        let statusBar = UIView(backgroundColor: .white)
        view.addSubview(statusBar)
        
        statusBar.anchor(top: view.topAnchor,
                         bottom: view.safeAreaLayoutGuide.topAnchor,
                         trailing: view.trailingAnchor,
                         leading: view.leadingAnchor)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
}

