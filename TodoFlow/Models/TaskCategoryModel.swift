//
//  TaskCategoryModel.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 06/02/25.
//

import UIKit

struct TaskCategoryModel: Codable {
    let name: String
    let colorHex: String
    
    var color: UIColor {
        return UIColor(hex: colorHex)
    }
    
    init(name: String, colorHex: String) {
        self.name = name
        self.colorHex = colorHex
    }
}
