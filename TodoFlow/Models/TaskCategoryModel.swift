//
//  TaskCategoryModel.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 06/02/25.
//

import UIKit

struct TaskCategoryModel: Codable {
    var name: String
    var colorHex: String
    var isEditing: Bool
    
    var color: UIColor {
        return UIColor(hex: colorHex)
    }
    
    init(name: String, colorHex: String, isEditing: Bool = false) {
        self.name = name
        self.colorHex = colorHex
        self.isEditing = isEditing
    }
}
