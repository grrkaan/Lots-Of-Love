//
//  MessageSaveController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 23.07.2021.
//

import Foundation
import UIKit
import Firebase


class MessageSaveController : ListController<MessageCell,Message> {
    
    fileprivate lazy var  navBar = MessageNavBar(match: match)
    fileprivate let navBarHeight : CGFloat = 125
    fileprivate let match : Match
    
    init(match: Match) {
        self.match = match
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class KeyboardView : UIView {
        
        let txtMessage = UITextView()
        let btnSend = UIButton(title: "Send", titleColor: .black, titleFont: .boldSystemFont(ofSize: 17))
        let lblPlaceholder = UILabel(text: "Send Message...", font: .systemFont(ofSize: 16), textColor: .lightGray)
        
        
        override var intrinsicContentSize: CGSize {
            return .zero
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            btnSend.layer.cornerRadius = 10
            btnSend.addBorder(width: 1, color: .lightGray)
            
            backgroundColor = .white
            addShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -9), color: .lightGray)
            autoresizingMask = .flexibleHeight
            
            
            txtMessage.isScrollEnabled = false
            txtMessage.backgroundColor = .white
            txtMessage.textColor = .black
            txtMessage.font = .systemFont(ofSize: 17)
            
            NotificationCenter.default.addObserver(self, selector: #selector(txtMessageChanging), name: UITextView.textDidChangeNotification, object: nil)
            
            createHorizontalStackView(txtMessage,btnSend.resizing(.init(width: 65, height: 65)),alignment: .center).withMarging(.init(top: 0, left: 15, bottom: 0, right: 15))
            
            addSubview(lblPlaceholder)
            lblPlaceholder.anchor(top: nil, bottom: nil, trailing: btnSend.leadingAnchor, leading: leadingAnchor,padding: .init(top: 0, left: 20, bottom: 0, right: 0))
            lblPlaceholder.centerYAnchor.constraint(equalTo: btnSend.centerYAnchor).isActive = true
            
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        @objc func txtMessageChanging() {
            lblPlaceholder.isHidden = txtMessage.text.count != 0
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    
    lazy var messageSubmitView : KeyboardView = {
        
        let messageSubmitView = KeyboardView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        
        messageSubmitView.btnSend.addTarget(self, action: #selector(btnSubmitPressed), for: .touchUpInside)
        
        return messageSubmitView
    }()
    
    
    @objc func btnSubmitPressed() {
        saveMessagesFS()
        saveLastMessageFS()
    }
    
    
    fileprivate func saveLastMessageFS() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let lastMessageData = ["Message": messageSubmitView.txtMessage.text ?? "",
                               "UserName": match.userName,
                               "UserId" : match.userId,
                               "ImgUrl": match.profileImgUrl] as [String : Any]
        
        Firestore.firestore().collection("Messages").document(currentUserId).collection("Last_Messages").document(match.userId).setData(lastMessageData) { (error) in
            
            if let error = error {
                print("Error when saving last message \(error.localizedDescription)")
                return
            }
            
        }
        
        
        
        guard let currentUser = self.currentUser else { return }
        
        let lastMessageData4Lover = ["Message": messageSubmitView.txtMessage.text ?? "",
                                     "UserName": currentUser.userName ?? "",
                                     "UserId" : currentUser.userId ,
                                     "ImgUrl": currentUser.profileImgUrlFirst ?? ""]
        
        
        Firestore.firestore().collection("Messages").document(match.userId).collection("Last_Messages").document(currentUser.userId).setData(lastMessageData4Lover) { (error) in
            
            if let error = error {
                print("Error when saving last message \(error.localizedDescription)")
                return
            }
            
        }
        
    }
    
    fileprivate func saveMessagesFS() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let collection = Firestore.firestore().collection("Messages").document(currentUserId).collection(match.userId)
        
        let data = ["Message" : messageSubmitView.txtMessage.text ?? "",
                    "CurrentUserId" : currentUserId,
                    "LoverId" : match.userId ,
                    "Timestamp" : Timestamp(date: Date())] as [ String : Any]
        
        if data["Message"] as! String != "" {
            collection.addDocument(data: data) { (error) in
                
                if let error = error {
                    print("Getting error when sending message \(error.localizedDescription)" )
                    return
                }
                
                self.messageSubmitView.txtMessage.text = nil
                self.messageSubmitView.lblPlaceholder.isHidden = false
                
            }
            
        }
        
        let collection2 =  Firestore.firestore().collection("Messages").document(match.userId).collection(currentUserId)
        
        if data["Message"] as! String != "" {
            
            collection2.addDocument(data: data) { (error) in
                
                if let error = error {
                    print("Getting error when sending message \(error.localizedDescription)" )
                    return
                }
                
                self.messageSubmitView.txtMessage.text = nil
                self.messageSubmitView.lblPlaceholder.isHidden = false
                
            }
        }
    }
    
    
    override var inputAccessoryView: UIView? {
        
        get {
            
            return messageSubmitView
            
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    
    var currentUser : User?
    
    fileprivate func getCurrentUserData() {
        
        let currentUserId = Auth.auth().currentUser?.uid ?? ""
        
        Firestore.firestore().collection("Users").document(currentUserId).getDocument { (snapshot,error) in
            
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
            
            
            let currentUserData = snapshot?.data() ?? [:]
            self.currentUser = User(datas: currentUserData)
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUserData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisplayConfigure), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        collectionView.keyboardDismissMode = .interactive
        navBar.backBtn.addTarget(self, action: #selector(btnBackPressed), for: .touchUpInside)
        navBar.btnFlag.addTarget(self, action: #selector(btnFlagPressed), for: .touchUpInside)
        
        getMessages()
        
        createDesign()
        
        
    }
    
    
    @objc func keyboardDisplayConfigure() {
        self.collectionView.scrollToItem(at: [0,datas.count-1], at: .bottom, animated: true)
    }
    
    fileprivate func getMessages() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let query = Firestore.firestore().collection("Messages").document(currentUserId).collection(match.userId).order(by: "Timestamp")
        
        query.addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                print("Getting error when getting messages \(error.localizedDescription)" )
                return
            }
            
            snapshot?.documentChanges.forEach({ (changes) in
                
                if changes.type == .added {
                    let messageData = changes.document.data()
                    self.datas.append(.init(messageData: messageData))
                }
                
            })
            
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0,self.datas.count-1], at: .bottom, animated: true)
            
        }
    }
    
    fileprivate func createDesign() {
        
        view.addSubview(navBar)
        navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                      bottom: nil,
                      trailing: view.trailingAnchor,
                      leading: view.leadingAnchor,
                      size: .init(width: 0, height: navBarHeight))
        
        
        collectionView.contentInset.top = navBarHeight
        
        let statusBar = UIView(backgroundColor: .white)
        view.addSubview(statusBar)
        statusBar.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, leading: view.leadingAnchor)
        
        collectionView.verticalScrollIndicatorInsets.top = navBarHeight
        
    }
    
    @objc func btnBackPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func btnFlagPressed() {
        
    }
    
}

extension MessageSaveController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let defaultCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        
        defaultCell.data = self.datas[indexPath.item]
        defaultCell.layoutIfNeeded()
        
        let defaultSize = defaultCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        return .init(width: view.frame.width, height: defaultSize.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
}


