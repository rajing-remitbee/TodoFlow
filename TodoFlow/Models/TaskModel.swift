//
//  TaskModel.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 06/02/25.
//

import Foundation

struct TaskModel: Codable {
    let title: String
    let date: Date
    let category: TaskCategoryModel
}
