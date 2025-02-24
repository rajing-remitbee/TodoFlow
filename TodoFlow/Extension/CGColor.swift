//
//  CGColor.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 13/02/25.
//

import UIKit

extension CGColor {
    
    //CGColor -> Convert to Hex String
    func toHexString() -> String? {
        guard let components = self.components else { return nil }
        let r = Int((components[0] * 255).rounded()) //Red color
        let g = Int((components[1] * 255).rounded()) //Green color
        let b = Int((components[2] * 255).rounded()) //Blue color
        return String(format: "#%02X%02X%02X", r, g, b) //Return hex format
    }
}
