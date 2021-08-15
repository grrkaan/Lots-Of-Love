//
//  ImageSwipeController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 14.03.2021.
//

import UIKit

class ImageSwipeController: UIPageViewController {

    
    var userVM : UserProfileViewModel! {
       
        didSet {
            controllers = userVM.viewImgs.map({ (imgUrl) -> UIViewController in
                let imgController = ImgController(imgUrl: imgUrl)
                
                return imgController
            })
            setViewControllers([controllers.first!], direction: .forward, animated: false, completion: nil)
            addBarView()
        }
    }
  
    var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
       
        if(userVMFlag){
        imageSwipeCancel()
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureImage)))
        
        
        
    }
    
    
    
    @objc fileprivate func tapGestureImage(gesture : UITapGestureRecognizer) {
        
        let currentController = viewControllers!.first!
        
        if let index = controllers.firstIndex(of: currentController) {
            
            barStackView.arrangedSubviews.forEach( {  $0.backgroundColor = unselectedImgColor  })
            
            if gesture.location(in: self.view).x > view.frame.width / 2 {
                
                
                let nextIndex = min(controllers.count - 1, index + 1)
                let nextController = controllers[nextIndex]
                setViewControllers([nextController], direction: .reverse, animated: false)
                barStackView.arrangedSubviews[nextIndex].backgroundColor = .white
                
            }else {
                
                let previousIndex = max(0, index - 1)
                let previousController = controllers[previousIndex]
                setViewControllers([previousController], direction: .forward, animated: false)
                barStackView.arrangedSubviews[previousIndex].backgroundColor = .white
                
            }
            
            
            
            
            
        }
        
    }
    
    
    
    
    fileprivate func imageSwipeCancel() {
        
        view.subviews.forEach { (v) in
            
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
            
        }
        
        
    }
    
    
    fileprivate let userVMFlag : Bool
    
    init(userVMFlag : Bool = false) {
        
        self.userVMFlag = userVMFlag
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    fileprivate let unselectedImgColor = UIColor(white: 0, alpha: 0.2)
    fileprivate let barStackView = UIStackView(arrangedSubviews: [])
    fileprivate func addBarView() {
        
        userVM.viewImgs.forEach { (_) in
            let barView = UIView()
            barView.layer.cornerRadius = 20
            barStackView.addArrangedSubview(barView)
        }
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
        
        view.addSubview(barStackView)
        _ = barStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                bottom: nil,
                                trailing: view.trailingAnchor,
                                leading: view.leadingAnchor,padding: .init(top: 8, left: 8, bottom: 0, right: 8),
                                size: .init(width: 0, height: 4))
        
    }
    

}

extension ImageSwipeController : UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    
        let showingImgController = viewControllers?.first
        if let index = controllers.firstIndex(where: { $0 == showingImgController }) {
            barStackView.arrangedSubviews.forEach ({ $0.backgroundColor = unselectedImgColor})
            barStackView.arrangedSubviews[index].backgroundColor = .white
        
        }
    }
}

extension ImageSwipeController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let index = self.controllers.firstIndex(where: { $0 == viewController } ) ?? 0
        if index == controllers.count - 1 {
            return nil
        }
        
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = self.controllers.firstIndex(where: { $0 == viewController } ) ?? 0
        if index == 0 {
            return nil
        }
        
        return controllers[index - 1]
    }
    
}

class ImgController : UIViewController {
    
    let imgView = UIImageView(image: #imageLiteral(resourceName: "riri-1"))
    
    init(imgUrl : String) {
        if let url = URL(string: imgUrl) {
            imgView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imgView)
        imgView.fillSuperView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
