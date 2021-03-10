//
//  LoginViewModel.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 10.03.2021.
//

import Foundation
import Firebase

class LoginViewModel {
    
    var isLogin = Bindable<Bool>()
    var isValid = Bindable<Bool>()
    
    var email : String? {
        
        didSet {
            formValidation()
        }
    }
    
    var password : String? {
         
        didSet {
            formValidation()
        }
    }
    
    
    fileprivate func formValidation() {
        let valid = email?.isEmpty == false && password?.isEmpty == false
        isValid.value = valid
    }
    
    func login(completion : @escaping (Error?) -> ()) {
        
        guard let email = email , let password = password else { return }
        isLogin.value = true
        
        Auth.auth().signIn(withEmail: email, password: password) { (response , error) in
            completion(error)
        }
    }
    
}
