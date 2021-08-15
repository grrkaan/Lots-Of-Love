//
//  MessagesHorizontalController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 15.08.2021.
//

import Foundation
import Firebase
import UIKit
// EslesmelerYatayController 'da temel amacımız eşleştiğimiz  profillerin listelenmesi
class MessagesHorizontalController : ListController<MatchCell,Match>, UICollectionViewDelegateFlowLayout {
    
    
    ///Hiyerarşide olan root controller'ın referansını tutalım
    var rootMatchMessagesController : MessagesAndMatchesController?
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = datas[indexPath.row]
        
        rootMatchMessagesController?.headerEslesmeSecimi(eslesme: eslesme)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 5, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: view.frame.height)
    }
    
    fileprivate func eslesmeleriGetir() {
        
        guard let gecerliKullaniciId  = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Eslesmeler_Mesajlar").document(gecerliKullaniciId).collection("Eslesmeler").getDocuments { (snapshot, hata) in
            
            if let hata = hata {
                print("Eşleşme verileri Getirilemedi : ",hata)
            }
            
            print("Kullanıcının Eşleşme Verileri Getirildi : ")
            
            
            var eslesmeler = [Eslesme]()
            
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let veri = documentSnapshot.data()
                eslesmeler.append(.init(veri: veri))
            })
            self.veriler = eslesmeler
            self.collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection  = .horizontal
        }
        eslesmeleriGetir() /// ListeController'a çekilen eşleşmeler görüntülenir
    }
}
