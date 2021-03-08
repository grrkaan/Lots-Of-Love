//
//  Firestore.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 8.03.2021.
//

import Foundation
import Firebase

extension Firestore {
    
    
    func getCurrentUser(completion: @escaping (User? , Error?) -> ()) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Users").document(uid).getDocument { (snapshot , error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let datas = snapshot?.data() else {
                let error = NSError(domain: "io.grrkaan.Kimdir", code: 450, userInfo: [NSLocalizedDescriptionKey : "User Not Found"])
                completion(nil,error)
                return
                
            }
            
            let currentUser = User(datas: datas)
            completion(currentUser,nil)
        }
    }
    
}
