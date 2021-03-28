//
//  RegisterViewModel.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 28.02.2021.
//

import UIKit
import Firebase

class RegisterViewModel {
    
    var bindableRegistering = Bindable<Bool>()
    var bindableImg = Bindable<UIImage>()
    var bindableTextValidation = Bindable<Bool>()
    
    var email : String? {
        didSet {
            textValidation()
        }
    }
    var userName : String? {
        didSet {
            textValidation()
        }
    }
    var password : String? {
        didSet {
            textValidation()
        }
    }
    
    
     func textValidation() {
        let valid = email?.isEmpty == false && userName?.isEmpty == false && password?.isEmpty == false && bindableImg.value != nil
        bindableTextValidation.value = valid
    }
    
   
    func register(completion: @escaping (Error?) -> ()) {
        
        guard let email = email else { return }
        guard let password = password else { return }
        bindableRegistering.value =  true
        
        Auth.auth().createUser(withEmail: email, password: password) { (response , error) in
            
            if let error = error {
                completion(error)
                return
            }
           
            self.imgFirebaseUpload(completion: completion)
            
        }
    }
    
    fileprivate func imgFirebaseUpload(completion: @escaping (Error?)-> ()) {
     
        let imgName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(imgName)")
        let imgData = self.bindableImg.value?.jpegData(compressionQuality: 0.8) ?? Data()
        
        ref.putData(imgData, metadata: nil) { (_ , error) in
            if let error = error {
                completion(error)
                return
            }
            
            ref.downloadURL { (url ,error) in
                if let error = error {
                    completion(error)
                    return
                }
                self.bindableRegistering.value = false
                let imgUrl = url?.absoluteString ?? ""
                self.userInfoFirebaseUpload(imgUrl: imgUrl, completion: completion)
            }
        }
    }
    
    
    fileprivate func userInfoFirebaseUpload(imgUrl : String, completion: @escaping (Error?) -> ()) {
        let userId = Auth.auth().currentUser?.uid ?? ""
        
        let userInfo : [String : Any] = ["UserName" : userName ?? "" ,
                        "ImgUrl" : imgUrl ,
                        "UserId" : userId ,
                        "Age" : 18 ,
                        "MinAge": ProfileController.defaultMinAge ,
                        "MaxAge": ProfileController.defaultMaxAge
        ]
        
        Firestore.firestore().collection("Users").document(userId).setData(userInfo) { (error) in
            
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
}
