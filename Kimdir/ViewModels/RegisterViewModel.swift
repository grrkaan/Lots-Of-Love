//
//  RegisterViewModel.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 28.02.2021.
//

import UIKit

class RegisterViewModel {
    
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
    
    
    fileprivate func textValidation() {
        let valid = email?.isEmpty == false && userName?.isEmpty == false && password?.isEmpty == false
        textValidationObserver?(valid)
    }
    
    var textValidationObserver : ((Bool) -> ())?
}
