//
//  TaskCellDelegate.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 18/02/25.
//

import UIKit

protocol TaskCellDelegate: AnyObject {
    func toggleTaskCompletion(at indexPath: IndexPath)
}
