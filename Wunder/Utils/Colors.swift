//
//  Colors.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let primary = UIColor(red: 1, green: 84, blue: 120)
    static let accent = UIColor(red: 255, green: 10, blue: 43)
    
    static let title = UIColor(red: 33, green: 33, blue: 33)
    static let secondaryTitle = UIColor(red: 72, green: 72, blue: 72)
    
    private convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
        self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
    }
}
