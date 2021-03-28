//
//  ProfileInfoController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 11.03.2021.
//

import UIKit

class ProfileInfoController: UIViewController {
    
    var userVM : UserProfileViewModel! {
        didSet {
            imgSwipeController.userVM = userVM
            lblInfo.attributedText = userVM.attrString
            
        }
    }
    
    lazy var scrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        
        return sv
    }()
    
    
    let imgSwipeController = ImageSwipeController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    let lblInfo : UILabel = {
        
        let lbl = UILabel()
        lbl.text = "Riri 38 \n Singer"
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    
    let btnCloseInfo : UIButton = {
       
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "profilKapat")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
        return btn
        
    }()
    
    lazy var btnDisLike = self.btnCreate(image: UIImage(named: "disLike")!, selector: #selector(disLikeBtnPressed))
    lazy var btnSuperLike = self.btnCreate(image: UIImage(named: "superLike")!, selector: #selector(superLikeBtnPressed))
    lazy var btnLike = self.btnCreate(image: UIImage(named: "like")!, selector: #selector(likeBtnPressed))
    
    fileprivate func editLayout() {
      
        view.backgroundColor = .black
        
        view.addSubview(scrollView)
        scrollView.fillSuperView()
        
        let imgSwipeView = imgSwipeController.view!
        scrollView.addSubview(imgSwipeView)
        imgSwipeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        scrollView.addSubview(lblInfo)
        
        _ = lblInfo.anchor(top: imgSwipeView.bottomAnchor,
                           bottom: nil, trailing: scrollView.trailingAnchor,
                           leading: scrollView.leadingAnchor,
                           padding: .init(top: 10, left: 10, bottom: 0, right: 0))
        
        scrollView.addSubview(btnCloseInfo)
        _ = btnCloseInfo.anchor(top: imgSwipeView.bottomAnchor,
                                bottom: nil,
                                trailing: view.trailingAnchor,
                                leading: nil,
                                padding: .init(top: -25, left: 0, bottom: 0, right: 20),
                                size: .init(width: 50, height: 50))
        
        
        
    }
    
    
    fileprivate let extraPadding : CGFloat = 90
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
        let imgSwipeView = imgSwipeController.view!
        imgSwipeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraPadding)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editLayout()
        blurEffect()
        buttonsEditLayout()
        
    }
    
    @objc fileprivate func closeBtnPressed() {
        self.dismiss(animated: true)
    }
    
    @objc fileprivate func disLikeBtnPressed() {
        print("dislike")
    }
    
    @objc fileprivate func superLikeBtnPressed() {
        print("super")
    }
    
    @objc fileprivate func likeBtnPressed() {
       print("like")
    }
    
    fileprivate func blurEffect() {
        
        let blur = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blur)
        
        view.addSubview(effectView)
        _ = effectView.anchor(top: view.topAnchor,
                              bottom: view.safeAreaLayoutGuide.topAnchor,
                              trailing: view.trailingAnchor,
                              leading: view.leadingAnchor)
        
    }
    
    fileprivate func btnCreate(image: UIImage, selector: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        btn.imageView?.contentMode = .scaleAspectFill
        
        return btn
    }
    
    fileprivate func buttonsEditLayout() {
        
        let sv = UIStackView(arrangedSubviews: [
        btnDisLike,
        btnSuperLike,
        btnLike])
        
        sv.distribution = .fillEqually
        view.addSubview(sv)
        
        _ = sv.anchor(top: nil,
                      bottom: view.safeAreaLayoutGuide.bottomAnchor,
                      trailing: nil,
                      leading: nil,
                      padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                      size: .init(width: 310, height: 85))
        
        sv.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
}
extension ProfileInfoController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yOffset = scrollView.contentOffset.y
        
        var resizer = view.frame.width - (2 * yOffset)
        resizer = max(view.frame.width,resizer)
        
        let imgSwipeView = imgSwipeController.view!
        imgSwipeView.frame = CGRect(x: min(0,yOffset), y: min(0,yOffset), width: resizer, height: resizer + extraPadding)
        
    }
}
