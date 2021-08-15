//
//  MessagesAndMatchesController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 22.07.2021.
//

import Foundation
import UIKit
import Firebase


class MessagesAndMatchesController : ListHeaderController<MatchCell,Match,MatchHeader>, UICollectionViewDelegateFlowLayout {
    
    
    
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
