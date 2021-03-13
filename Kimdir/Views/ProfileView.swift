//
//  MainProfileView.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 15.02.2021.
//

import UIKit
import SDWebImage
class ProfileView: UIView {
    
    var delegate : ProfileViewDelegate?

    var userViewModel : UserProfileViewModel! {
        
        didSet{
            let viewImgUrl = userViewModel.viewImgs.first ?? ""
            if let url = URL(string : viewImgUrl) {
                profileImg.sd_setImage(with: url)
            }

            lblUserInfos.attributedText = userViewModel.attrString
            lblUserInfos.textAlignment = userViewModel.infoLocation
            
            (0..<userViewModel.viewImgs.count).forEach { (_) in

                let bView = UIView()
                bView.backgroundColor = unselectedImgColor
                
                imgBarStackView.addArrangedSubview(bView)
            }
            
            imgBarStackView.arrangedSubviews.first?.backgroundColor = .white
            setImgViewObserver()
        }
    }
    
   fileprivate func setImgViewObserver() {
    userViewModel.imgIndexObs = { (imgIndex, imgUrl) in
        self.imgBarStackView.arrangedSubviews.forEach{ (sView) in
            sView.backgroundColor = self.unselectedImgColor
        }
        self.imgBarStackView.arrangedSubviews[imgIndex].backgroundColor = .white
        
        if let url = URL(string: imgUrl ?? "") {
            self.profileImg.sd_setImage(with: url)
        }
        
    }
    }
    
    
    fileprivate  let outBorder : CGFloat = 120
    fileprivate  let profileImg = UIImageView(image:#imageLiteral(resourceName: "steve-halama-dfwFFQLvc0s-unsplash") )
    fileprivate  let unselectedImgColor = UIColor(white: 0, alpha: 0.2)
    let lblUserInfos = UILabel()
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        editLayout()
        
        let panG = UIPanGestureRecognizer(target: self, action: #selector(profilePanCatch))
        addGestureRecognizer(panG)
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(profileTapCatch))
        addGestureRecognizer(tapG)
    }

    fileprivate let btnProfileInfo :UIButton = {
        
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "detayliBilgi")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(infoBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    
    fileprivate func editLayout() {
       
        layer.cornerRadius = 10
        clipsToBounds = true
        profileImg.contentMode = .scaleAspectFill
        addSubview(profileImg)
        profileImg.fillSuperView()
        
        createBarStackView()
        createGradientLayer()
        addSubview(lblUserInfos)
        _ = lblUserInfos.anchor(top: nil,
                            bottom: bottomAnchor,
                            trailing: trailingAnchor,
                            leading: leadingAnchor,
                            padding: .init(top: 0, left: 15, bottom: 15, right: 15))
        lblUserInfos.textColor = .white
        lblUserInfos.font = UIFont.systemFont(ofSize: 27,weight: .heavy)
        lblUserInfos.numberOfLines = 0
        
        
        addSubview(btnProfileInfo)
        _ = btnProfileInfo.anchor(top: nil,
                                  bottom: bottomAnchor,
                                  trailing: trailingAnchor,
                                  leading: nil,
                                  padding: .init(top: 0, left: 0, bottom: 20, right: 20),
                                  size: .init(width: 45, height: 45))
    }
    
    
    @objc fileprivate func infoBtnPressed() {
        delegate?.infoBtnPressed(userVM: userViewModel)
    }
    
    var imgIndex = 0
    @objc func profileTapCatch(tapG : UITapGestureRecognizer){
   
        let tapLocation = tapG.location(in: nil)
        
        let nextImgTap = tapLocation.x > frame.width / 2 ? true : false
        
        if nextImgTap {
            userViewModel.nextImg()
        }else {
            userViewModel.prevImg()
        }
        
    }
    
    @objc func profilePanCatch(panGesture : UIPanGestureRecognizer){
        
        
        
        switch panGesture.state {
        
        case .began :
            superview?.subviews.forEach{ (subView) in
                subView.layer.removeAllAnimations()
            }
        
        case .changed :
            swipeAnimation(panGesture)
            
        case .ended :
            endSwipeAnimation(panGesture)
            superview?.subviews.forEach{ (subView) in
                subView.layer.removeAllAnimations()
            }
            
        default :
            break
        }
        
        
    }
    
    
    fileprivate func endSwipeAnimation(_ panGesture : UIPanGestureRecognizer) {
        
        
        let translationWay : CGFloat = panGesture.translation(in: nil).x > 0 ? 1 : -1
        
        let discardProfileFlag : Bool = abs(panGesture.translation(in: nil).x) > outBorder
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut,
                       animations: {
                        if discardProfileFlag {
                            
                            self.frame = CGRect(x: 600 * translationWay, y: 0, width: self.frame.width, height: self.frame.height)
                            
                        }else {
                            self.transform = .identity
                        }
                        
                       })
        { (_) in
            self.transform = .identity
            if discardProfileFlag {
                self.removeFromSuperview()
            }
        }
        
        
    }
    
    fileprivate func swipeAnimation(_ panGesture: UIPanGestureRecognizer) {
        
        let translation = panGesture.translation(in: nil)
        
        let angle : CGFloat = translation.x / 15
        let radianAngle = (angle * .pi) / 180
        
        let swipeTransform = CGAffineTransform(rotationAngle: radianAngle)
        self.transform = swipeTransform.translatedBy(x: translation.x, y: translation.y)
        
    }
    
    
    fileprivate let imgBarStackView = UIStackView()
    
    fileprivate func createBarStackView() {
        
        addSubview(imgBarStackView)
        
        _ = imgBarStackView.anchor(top: topAnchor, bottom: nil, trailing: trailingAnchor, leading: leadingAnchor,padding: .init(top: 8, left: 8, bottom: 0, right: 8),size: .init(width: 0, height: 4))
        imgBarStackView.spacing = 4
        imgBarStackView.distribution = .fillEqually
        
    }
    
    fileprivate func createGradientLayer() {
        
        
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        gradientLayer.locations =  [0,1.5]
        
        
        
        layer.addSublayer(gradientLayer)
        
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol  ProfileViewDelegate {
    func infoBtnPressed(userVM : UserProfileViewModel)
}
