//
//  CGColor.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 13/02/25.
//

import UIKit

extension CGColor {
    func toHexString() -> String? {
        guard let components = self.components else { return nil }
        let r = Int((components[0] * 255).rounded())
        let g = Int((components[1] * 255).rounded())
        let b = Int((components[2] * 255).rounded())
        
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
