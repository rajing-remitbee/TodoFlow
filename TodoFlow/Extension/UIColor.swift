//
//  UIColor.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 06/02/25.
//

import UIKit


//Add hex-code to UIColor method
extension UIColor {
    
    
    convenience init(hex: String) {
        //Clean hex string
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0 //Red color
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0 //Green color
        let blue = CGFloat(rgb & 0xFF) / 255.0 //Blue color

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    
    //UIColor -> Convert to Hex string
    func toHex() -> String {
        guard let components = cgColor.components else { return "#000000" }
        let r = Int(components[0] * 255) //Red color
        let g = Int(components[1] * 255) //Green color
        let b = Int(components[2] * 255) //Blue color
        return String(format: "#%02X%02X%02X", r, g, b) //Hex string
    }
}
