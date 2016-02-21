//
//  Themes.swift
//  ProjectSquad
//
//  Created by Karen Oliver on 2/21/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import UIKit

class Themes: NSObject {
    
    struct Colors {
        static let pink = UIColor(red: 1.0, green: 139.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        static let dark = UIColor(red: 95.0/255.0, green: 101.0/255.0, blue: 126.0/255.0, alpha: 1.0)
        static let light = UIColor(red: 253.0/255.0, green: 253.0/255.0, blue: 1.0, alpha: 1.0)
    }
    
    struct Fonts {
        static let bigBold = UIFont(name: "Avenir-Heavy", size: 16)
        static let smallBold = UIFont(name: "Avenir-Heavy", size: 14)
        static let smallNormal = UIFont(name: "Avenir-Medium", size: 14)
        static let kerning: CGFloat = 2.0
    }

}
