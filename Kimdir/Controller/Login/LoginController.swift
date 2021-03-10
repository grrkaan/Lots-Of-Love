//
//  LoginController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 10.03.2021.
//

import UIKit
import JGProgressHUD

class LoginController: UIViewController {
    
    var delegate : LoginControllerDelegate?
    fileprivate let loginVM = LoginViewModel()
    fileprivate let loginHUD = JGProgressHUD(style: .dark)
    
    
    
    let txtEmail : CustomTextField = {
        
        let txt = CustomTextField(padding: 24, height: 55)
        txt.backgroundColor = .white
        txt.keyboardType = .emailAddress
        txt.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        txt.addTarget(self, action: #selector(txtChangeCheck), for: .editingChanged)
        
        return txt
    }()
    
    let txtPassword : CustomTextField = {
       
        let txt = CustomTextField(padding: 24, height: 55)
        txt.backgroundColor = .white
        txt.isSecureTextEntry = true
        txt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        txt.addTarget(self, action: #selector(txtChangeCheck), for: .editingChanged)
        
        return txt
    }()
    
    let btnLogin : UIButton = {
        
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.9921568627, green: 0.9098039216, blue: 0.8039215686, alpha: 1), for: .normal)
        btn.layer.cornerRadius = 15
        btn.backgroundColor = .lightGray
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btn.isEnabled = false
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        btn.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        
        return btn
        
    }()
    
    let btnRegister : UIButton = {
        
        let btn = UIButton(type: .system)
        btn.setTitle("Go to Register", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.9921568627, green: 0.9098039216, blue: 0.8039215686, alpha: 1), for: .normal)
        btn.layer.cornerRadius = 15
        btn.backgroundColor = #colorLiteral(red: 0.262745098, green: 0.2078431373, blue: 0.1254901961, alpha: 1)
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        btn.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
        
        return btn
    }()
    
    
    lazy var verticalStackView : UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [
            txtEmail,
            txtPassword,
            btnLogin
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editBackgroundGradientColor()
        createBindable()
        editLayout()
        addTapGesture()

        
    }
    
    @objc fileprivate func registerPressed() {
        let registerController = RegisterController()
        navigationController?.pushViewController(registerController, animated: true)
    }
    
    
    @objc fileprivate func loginPressed() {
        loginVM.login { (error) in
            self.loginHUD.dismiss()
            
            if let error = error {
                print(error)
                return
            }
            
            //Login OK
            self.dismiss(animated: true)
            self.delegate?.loginEnd()
            
        }
    }
    
    @objc fileprivate func txtChangeCheck(txt: UITextField) {
        
        if txt == txtEmail {
            loginVM.email = txt.text
        } else {
            loginVM.password = txt.text
        }
    }
    
    fileprivate func createBindable() {
        loginVM.isValid.asignValue { (isValid) in
            guard let isValid = isValid else { return }
            self.btnLogin.isEnabled = isValid
            
            if isValid {
                self.btnLogin.backgroundColor = #colorLiteral(red: 0.262745098, green: 0.2078431373, blue: 0.1254901961, alpha: 1)
                self.btnLogin.setTitleColor(#colorLiteral(red: 0.9921568627, green: 0.9098039216, blue: 0.8039215686, alpha: 1), for: .normal)
            }else {
                self.btnLogin.backgroundColor = .lightGray
                self.btnLogin.setTitleColor(.darkGray,for: .disabled)
            }
            
        }
        
        
        loginVM.isLogin.asignValue { (isLogin) in
            
            if isLogin == true {
                self.loginHUD.textLabel.text = "Login..."
                self.loginHUD.show(in: self.view)
            } else {
                self.loginHUD.dismiss()
            }
        }

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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradient.frame = view.bounds
    }
    
    
    fileprivate func editLayout() {
        
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(verticalStackView)
        _ = verticalStackView.anchor(top: nil,
                                     bottom: nil,
                                     trailing: view.trailingAnchor,
                                     leading: view.leadingAnchor,
                                     padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(btnRegister)
        _ = btnRegister.anchor(top: nil,
                               bottom: view.safeAreaLayoutGuide.bottomAnchor,
                               trailing: view.trailingAnchor,
                               leading: view.leadingAnchor,
                               padding: .init(top: 0, left: 50, bottom: 0, right: 50))
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

}

protocol  LoginControllerDelegate {
    func loginEnd()
}
