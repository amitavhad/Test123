//
//  String.swift
//  UnoPointSLM
//
//  Created by Amit A on 23/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import Foundation

extension String {
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
}
