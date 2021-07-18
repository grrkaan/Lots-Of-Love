//
//  ImageViewAspectFill.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 18.07.2021.
//

import Foundation
import UIKit

class ImageViewAspectFill: UIImageView {
        
    convenience init() {
        
        self.init(image: nil)
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
}
