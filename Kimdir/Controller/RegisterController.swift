//
//  RegisterController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 27.02.2021.
//

import UIKit
import Firebase
import JGProgressHUD

class RegisterController: UIViewController{
    
    var delegate : LoginControllerDelegate?
    
    let btnImgSelector : UIButton = {
        
        let btn = UIButton(type: .system)
        
        btn.setTitle("Select Photo", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 15
        btn.heightAnchor.constraint(equalToConstant: 280).isActive = true
        btn.imageView?.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(imgSelectorPressed), for: .touchUpInside)
        
        return btn
        
    }()
    
    
    let txtEmail : CustomTextField = {
        
        let email = CustomTextField(padding: 15, height: 50)
        
        email.attributedPlaceholder = NSAttributedString(string: "example@kimdir.com", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        email.keyboardType = .emailAddress
        email.addTarget(self, action: #selector(catchTextEdit), for: .editingChanged)
        
        return email
    }()
    
    let txtUserName : CustomTextField = {
        
        let userName = CustomTextField(padding: 15, height: 50)
        
        userName.attributedPlaceholder = NSAttributedString(string: "John Doe", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        userName.keyboardType = .default
        userName.addTarget(self, action: #selector(catchTextEdit), for: .editingChanged)
        
        return userName
    }()
    
    let txtPassword : CustomTextField = {
        
        let password = CustomTextField(padding: 15, height: 50)
        
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
        btn.layer.cornerRadius = 15
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btn.backgroundColor = .lightGray
        btn.titleColor(for: .disabled)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
        
        return btn
    }()
    
    let btnLogin : UIButton = {
        
        let btn = UIButton(type: .system)
        
        btn.setTitle("Login", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17,weight: .heavy)
        btn.setTitleColor(#colorLiteral(red: 0.9921568627, green: 0.9098039216, blue: 0.8039215686, alpha: 1), for: .normal)
        btn.layer.cornerRadius = 15
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btn.backgroundColor = #colorLiteral(red: 0.262745098, green: 0.2078431373, blue: 0.1254901961, alpha: 1)
        btn.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        
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
        
        registerViewModel.bindableTextValidation.asignValue { (valid) in

            guard let valid = valid else { return }
            self.btnRegister.isEnabled = valid
            
            if valid {
                self.btnRegister.backgroundColor = #colorLiteral(red: 0.262745098, green: 0.2078431373, blue: 0.1254901961, alpha: 1)
                self.btnRegister.setTitleColor(#colorLiteral(red: 0.9921568627, green: 0.9098039216, blue: 0.8039215686, alpha: 1), for: .normal)
            }else {
                self.btnRegister.backgroundColor = .lightGray
                self.btnRegister.titleColor(for: .disabled)
            }
        }
        
        registerViewModel.bindableImg.asignValue { (profileImg) in
            self.btnImgSelector.setImage(profileImg?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registerViewModel.bindableRegistering.asignValue { (registering) in
           
            if registering == true {
                self.registerHUD.textLabel.text = "Creating User"
                self.registerHUD.show(in: self.view)
            }else {
                self.registerHUD.dismiss()
            }
            
        }
    }
   
    @objc fileprivate func loginPressed() {
        let loginController = LoginController()
        loginController.delegate = delegate
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    
    let registerHUD = JGProgressHUD(style: .light)
    @objc fileprivate func registerPressed() {
        
        self.closeKeyboard()
        registerViewModel.register { (error) in
            
            if let error = error {
                self.errorNotifyHUD(error: error)
                return
            }
        }
    }

    
    fileprivate func errorNotifyHUD(error : Error) {
        
        let hud = JGProgressHUD(style: .dark)
        
        hud.textLabel.text = "Register Failed"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 2, animated: true)
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
        
        if tolerance < 0 {
            return
        }
        
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
        
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(registerSV)
        registerSV.axis = .vertical
        btnImgSelector.widthAnchor.constraint(equalToConstant: 260).isActive = true
        registerSV.spacing = 10
        _ =  registerSV.anchor(top: nil, bottom: nil, trailing: view.trailingAnchor, leading: view.leadingAnchor, padding: .init(top: 0, left: 45, bottom: 0, right: 45))
        registerSV.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(btnLogin)
        _ = btnLogin.anchor(top: nil,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            trailing: view.trailingAnchor,
                            leading: view.leadingAnchor,
                            padding: .init(top: 0, left: 45, bottom: 0 , right: 45))
        
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
    
    
    @objc fileprivate func imgSelectorPressed() {
        
        let imgPickerController = UIImagePickerController()
        imgPickerController.delegate = self
        present(imgPickerController, animated: true, completion: nil)
    }
    
}

extension RegisterController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let pickedImg = info[.originalImage] as? UIImage
        registerViewModel.bindableImg.value = pickedImg
        registerViewModel.textValidation()
        dismiss(animated: true, completion: nil)
    }
    
}
