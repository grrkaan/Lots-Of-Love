//
//  Bindable.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 28.02.2021.
//

import UIKit

class Bindable<K> {
    
    var  value : K? {
        didSet {
           observer?(value)
        }
    }
    
    
    var observer : ((K?) -> ())?
    
    func asignValue(observer : @escaping (K?) -> ()) {
        self.observer = observer
    }
}
