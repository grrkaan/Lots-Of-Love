//
//  MatchView.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 17.07.2021.
//

import UIKit
import Firebase
class MatchView: UIView {
    
    
    var currentUser : User!
    
    var loverID : String! {
        didSet {
            
            let query = Firestore.firestore().collection("Users")
            query.document(loverID).getDocument { (snapshot , error) in
                
                if let error = error {
                    print("Getting error when lover datas collecting.. : \(error.localizedDescription)")
                    return
                }
                
                guard let loverData = snapshot?.data() else { return }
                let lover = User(datas: loverData)
                
                let loverName = lover.userName
                self.matchDescLbl.text = "You matched with \(loverName!). Good Luck.Be kind :)"
                
                guard let url = URL(string: lover.profileImgUrlFirst ?? "") else { return }
                
                self.loverImg.sd_setImage(with: url)
                
                guard let currentUserUrl = URL(string: self.currentUser.profileImgUrlFirst ?? "") else { return }
                
                self.currentUserImg.sd_setImage(with: currentUserUrl) { (_,_,_,_) in
                    
                    self.matchAnimations()
                    
                }
                
                
            }
            
        }
        
        
    }
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        blurEffect()
        editLayout()
        
        
    }
    
    fileprivate let dmBtn : UIButton = {
        
        let btn = DMButton()
        btn.setTitle("Send Message", for: .normal)
        
        return btn
    }()
    
    fileprivate let ksBtn : UIButton = {
        
        let btn = KSButton()
        btn.setTitle("Keep Swiping", for: .normal)
        
        return btn
    }()
    
    
    
    fileprivate let matchImg : UIImageView = {
        
        let img = UIImageView(image: #imageLiteral(resourceName: "3.1 eslesme"))
        img.contentMode = .scaleAspectFill
        return img
        
    }()
    
    
    fileprivate let matchDescLbl : UILabel = {

        let lbl = UILabel()
        lbl.text = "You match with . Good Luck. Be kind. :)"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 21)
        return lbl
    }()
    
    fileprivate let currentUserImg : UIImageView = {
        
        let img = UIImageView(image: #imageLiteral(resourceName: "riri-2"))
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.borderWidth = 2
        return img
    }()
    
    
    fileprivate let loverImg : UIImageView = {
        
        let img = UIImageView(image: #imageLiteral(resourceName: "riri-3"))
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.borderWidth = 2
        img.alpha = 0
        return img
    }()
    
    
    lazy var views = [
        matchImg,
        matchDescLbl,
        currentUserImg,
        loverImg,
        dmBtn,
        ksBtn
    ]
    
    
    
    let imgSize : CGFloat = 135
    let paddingSize : CGFloat = -270
    fileprivate func editLayout() {
        
        views.forEach({ (v) in
            addSubview(v)
            v.alpha = 0
            
        })
        
        
        _ = currentUserImg.anchor(top: nil,
                                  bottom: nil,
                                  trailing: centerXAnchor,
                                  leading: nil,
                                  padding: .init(top: .zero, left: .zero, bottom: .zero, right: 20),
                                  size: .init(width: imgSize, height: imgSize))
        
        currentUserImg.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        currentUserImg.layer.cornerRadius = imgSize / 2
        
        _ = loverImg.anchor(top: nil,
                            bottom: nil,
                            trailing: nil,
                            leading: centerXAnchor,
                            padding: .init(top: .zero, left: 20, bottom: .zero, right: .zero),
                            size: .init(width: imgSize, height: imgSize))
        
        loverImg.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        loverImg.layer.cornerRadius = imgSize / 2
        
        _ = matchImg.anchor(top: nil,
                            bottom: matchDescLbl.topAnchor,
                            trailing: nil,
                            leading: nil,
                            padding: .init(top: .zero, left: .zero, bottom: 20, right: .zero),
                            size: .init(width: 290 , height: 80))
        
        matchImg.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = matchDescLbl.anchor(top: nil,
                                bottom: currentUserImg.topAnchor,
                                trailing: trailingAnchor,
                                leading: leadingAnchor,
                                padding: .init(top: .zero, left: .zero, bottom: 35, right: .zero),
                                size: .init(width: 0 , height: 60))
        
        
        _ = dmBtn.anchor(top: currentUserImg.bottomAnchor,
                         bottom: nil,
                         trailing: trailingAnchor,
                         leading: leadingAnchor,
                         padding: .init(top: 30, left: 45, bottom: 0, right: 45),
                         size: .init(width: 0 , height: 60))
        
        _ = ksBtn.anchor(top: dmBtn.bottomAnchor,
                         bottom: nil,
                         trailing: dmBtn.trailingAnchor,
                         leading: dmBtn.leadingAnchor,
                         padding: .init(top: 15, left: 0, bottom: 0, right: 0),
                         size: .init(width: 0 , height: 60))
        
        
    }
    
    
    
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    fileprivate func blurEffect() {
        
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureMatch)))
        addSubview(visualEffectView)
        visualEffectView.fillSuperView()
        visualEffectView.alpha = 0
        delayAnimation(alpha: 1)
        
    }
    
    
    fileprivate func matchAnimations() {
        
        views.forEach({ $0.alpha = 1 })
        
        let angle = 25 * CGFloat.pi / 180
        
        currentUserImg.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 220, y: 0))
        loverImg.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -220, y: 0))
        
        dmBtn.transform = CGAffineTransform(translationX: -450, y: 0)
        ksBtn.transform = CGAffineTransform(translationX: 450, y: 0)
        
        // Animation 1
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
            
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                
                self.currentUserImg.transform = CGAffineTransform(rotationAngle: -angle)
                self.loverImg.transform = CGAffineTransform(rotationAngle: angle)
                
            }
            
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.7) {
                
                self.currentUserImg.transform = .identity
                self.loverImg.transform = .identity
                
                
                
            }
            
            
            
        }) { (_) in
            
        }
        
        
        UIView.animate(withDuration: 0.9, delay: 0.8, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseOut, animations:{
            self.dmBtn.transform = .identity
            self.ksBtn.transform = .identity
        })
    }
    
    
    
    
    
    @objc fileprivate func tapGestureMatch() {
        
        delayAnimation(alpha: 0)
        
    }
    
    
    fileprivate func delayAnimation(alpha : CGFloat) {
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            if alpha == 0 {
                self.alpha = alpha
            }else {
                self.visualEffectView.alpha = alpha
            }
            
        }) {(_) in
            
            if alpha == 0 {
                self.removeFromSuperview()
            }
            
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
