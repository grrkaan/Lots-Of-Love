//
//  MatchesHorizontalController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 15.08.2021.
//

import Foundation
import UIKit
import Firebase

class MatchesHorizontalController : ListController<MatchCell,Match> , UICollectionViewDelegateFlowLayout {
    
    var rootMatchesAndMessagesController : MessagesAndMatchesController?

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let match = datas[indexPath.row]
        rootMatchesAndMessagesController?.headerMatchSelect(match: match)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 5, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: view.frame.height)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        getMatches()
    }
    
}
