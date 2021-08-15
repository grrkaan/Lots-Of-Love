//
//  ListHeader&FooterController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 18.07.2021.
//

import Foundation
import UIKit



open class ListHeaderAndFooterController <T : ListCell<U>, U, H : UICollectionReusableView, F : UICollectionReusableView> : UICollectionViewController {
    
    
    var datas = [U]() {
        didSet {
            collectionView.reloadData()
        }
       
    }
    
    fileprivate let cellID = "cellID"
    fileprivate let extraViewID = "extraViewID"
    
    
    func setCellHeight(indexPath : IndexPath, cellWidth : CGFloat) -> CGFloat {
        
        let cell = T()
        let extraHeight : CGFloat = 1000
        
        cell.frame = .init(x: 0, y: 0, width: cellWidth, height: extraHeight)
        cell.layoutIfNeeded()
     
        return cell.systemLayoutSizeFitting(.init(width: cellWidth, height: extraHeight)).height
        
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(T.self, forCellWithReuseIdentifier: cellID)
        
        
        collectionView.register(H.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: extraViewID)
        collectionView.register(F.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: extraViewID)
        
        
    }
    
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)  -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! T
        
        cell.data = datas[indexPath.row]
        cell.inputController = self
        
        return cell
    }
    
    open func setHeader(_ header : H) {
        
    }
    
    
    open func setFooter(_ footer : F) {
        
    }
    
    
    open override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let extraView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: extraViewID, for: indexPath)
        
        
        if let header = extraView as? H {
            setHeader(header)
        
        }else if let footer = extraView as? F {
            setFooter(footer)
        }
        
        return extraView

    }
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 
            return datas.count
    }
    
    open override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        view.layer.zPosition = -1
    }
    
    
    public init(scrollWay : UICollectionView.ScrollDirection = .vertical) {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollWay
        
        super.init(collectionViewLayout: layout)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
