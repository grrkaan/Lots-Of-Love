//
//  RegisterController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 27.02.2021.
//

import UIKit


class RegisterController: UIViewController {
    
    
    let btnImgSelector : UIButton = {
        
        let btn = UIButton(type: .system)
        
        btn.setTitle("Select Photo", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 15
        btn.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
        return btn
        
    }()
    
    
    let txtEmail : RegisterTextField = {
        
        let email = RegisterTextField(padding: 15)
        
        email.attributedPlaceholder = NSAttributedString(string: "example@kimdir.com", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        email.keyboardType = .emailAddress
        email.addTarget(self, action: #selector(catchTextEdit), for: .editingChanged)
        
        return email
    }()
    
    let txtUserName : RegisterTextField = {
        
        let userName = RegisterTextField(padding: 15)
        
        userName.attributedPlaceholder = NSAttributedString(string: "John Doe", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        userName.keyboardType = .default
        userName.addTarget(self, action: #selector(catchTextEdit), for: .editingChanged)
        
        return userName
    }()
    
    let txtPassword : RegisterTextField = {
        
        let password = RegisterTextField(padding: 15)
        
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        password.isSecureTextEntry = true
        password.addTarget(self, action: #selector(catchTextEdit), for: .editingChanged)
        
        return password
    }()
    
    let btnRegister : UIButton = {
        
        let btn = UIButton(type: .system)
        
        btn.setTitle("Register", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17,weight: .heavy)
        btn.setTitleColor(#colorLiteral(red: 0.9921568627, green: 0.9098039216, blue: 0.8039215686, alpha: 1), for: .normal)
        //   btn.backgroundColor = #colorLiteral(red: 0.262745098, green: 0.2078431373, blue: 0.1254901961, alpha: 1)
        btn.layer.cornerRadius = 15
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        btn.backgroundColor = .lightGray
        btn.titleColor(for: .disabled)
        btn.isEnabled = false
        
        
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editBackgroundGradientColor()
        editLayout()
        createNotificationObs()
        addTapGesture()
        createRegisterViewModelObserver()
    }
    
    let registerViewModel = RegisterViewModel()
    
    fileprivate func createRegisterViewModelObserver() {
        
        registerViewModel.textValidationObserver = { (valid) in
            
            self.btnRegister.isEnabled = valid
            
            if valid {
                self.btnRegister.backgroundColor = #colorLiteral(red: 0.262745098, green: 0.2078431373, blue: 0.1254901961, alpha: 1)
                self.btnRegister.setTitleColor(#colorLiteral(red: 0.9921568627, green: 0.9098039216, blue: 0.8039215686, alpha: 1), for: .normal)
            }else {
                self.btnRegister.backgroundColor = .lightGray
                self.btnRegister.titleColor(for: .disabled)
            }
        }
    }
    
    @objc fileprivate func catchTextEdit(txtField : UITextField) {
        
        if txtField == txtEmail {
            registerViewModel.email = txtEmail.text
        }else if txtField == txtUserName {
            registerViewModel.userName = txtUserName.text
        }else if txtField == txtPassword {
            registerViewModel.password = txtPassword.text
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradient.frame = view.bounds
    }
    
    
    fileprivate func addTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeKeyboard)))
    }
    
    @objc fileprivate func closeKeyboard() {
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        },completion: nil)
    }
    
    fileprivate func createNotificationObs() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(catchOpenKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(catchCloseKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func catchCloseKeyboard() {
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        },completion: nil)
    }
    
    @objc fileprivate func catchOpenKeyboard(notification: Notification) {
        
        guard let keyboardEndValues = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardEndFrame = keyboardEndValues.cgRectValue
        
        let bottomSpace = view.frame.height - (registerSV.frame.origin.y + registerSV.frame.height)
        
        let tolerance = keyboardEndFrame.height - bottomSpace
        
        self.view.transform = CGAffineTransform(translationX: 0, y: -tolerance - 10)
        
    }
    
    lazy var horizontalSv : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            txtEmail,
            txtUserName,
            txtPassword,
            btnRegister
        ])
        
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing =  10
        
        return sv
    }()
    
    lazy var registerSV = UIStackView(arrangedSubviews: [
        btnImgSelector,
        horizontalSv
    ])
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            registerSV.axis = .horizontal
        }else {
            registerSV.axis = .vertical
        }
    }
    
    fileprivate func editLayout() {
        
        view.addSubview(registerSV)
        registerSV.axis = .vertical
        btnImgSelector.widthAnchor.constraint(equalToConstant: 260).isActive = true
        registerSV.spacing = 10
        _ =  registerSV.anchor(top: nil, bottom: nil, trailing: view.trailingAnchor, leading: view.leadingAnchor, padding: .init(top: 0, left: 45, bottom: 0, right: 45))
        registerSV.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
    }
    
    let gradient = CAGradientLayer()
    fileprivate func editBackgroundGradientColor() {
        
        let bottomColor = #colorLiteral(red: 0.007843137255, green: 0.3490196078, blue: 0.3333333333, alpha: 1)
        let topColor = #colorLiteral(red: 0, green: 0.568627451, blue: 0.4862745098, alpha: 1)
        
        gradient.colors = [topColor.cgColor,bottomColor.cgColor]
        gradient.locations = [0,1]
        
        view.layer.addSublayer(gradient)
        gradient.frame = view.bounds
        
    }
    
}
