//
//  CategoryStatisticsViewCell.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 19/02/25.
//

import UIKit

class CategoryStatisticsViewCell: UITableViewCell {

    @IBOutlet var categoryBox: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var completeCountLabel: UILabel!
    @IBOutlet var completeRateLabel: UILabel!
    
    func configure(with category: TaskCategoryModel, completed: Int, total: Int) {
        categoryBox.layer.borderWidth = 1
        categoryBox.layer.borderColor = category.color.cgColor
        categoryBox.layer.cornerRadius = 6
        categoryLabel.text = category.name
        let formattedText = "\(completed)/\(total)"
        let formattedCompletionRate = total > 0 ? (completed * 100) / total : 0
        
        // Apply styles
        let attributedText = NSMutableAttributedString(string: formattedText)
        let completedRange = NSRange(location: 0, length: "\(completed)".count)
        attributedText.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .medium), .foregroundColor: UIColor(hex: "#0E100F")], range: completedRange)
        let totalRange = NSRange(location: completedRange.length, length: formattedText.count - completedRange.length)
        attributedText.addAttributes([.font: UIFont.systemFont(ofSize: 10, weight: .medium), .foregroundColor: UIColor(hex: "#7E8491")], range: totalRange)
        completeCountLabel.attributedText = attributedText
            
        let completionText = "\(formattedCompletionRate)%"
        let attributedCompletion = NSMutableAttributedString(string: completionText)
        let percent = NSRange(location: 0, length: "\(formattedCompletionRate)".count)
        attributedText.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .medium), .foregroundColor: UIColor(hex: "#0E100F")], range: percent)
        let percentRange = NSRange(location: completionText.count - 1, length: 1)
        attributedCompletion.addAttributes([.font: UIFont.systemFont(ofSize: 10, weight: .medium), .foregroundColor: UIColor(hex: "#7E8491")], range: percentRange)
        completeRateLabel.attributedText = attributedCompletion
    }

}
