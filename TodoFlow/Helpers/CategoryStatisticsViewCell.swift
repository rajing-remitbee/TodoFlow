//
//  CategoryStatisticsViewCell.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 19/02/25.
//

import UIKit

class CategoryStatisticsViewCell: UITableViewCell {

    @IBOutlet var categoryBox: UILabel! //CategoryBox Component
    @IBOutlet var categoryLabel: UILabel! //Category Label Component
    @IBOutlet var completeCountLabel: UILabel! //Completion Count Component
    @IBOutlet var completeRateLabel: UILabel! //Completion Rate Component
    
    func configure(with category: TaskCategoryModel, completed: Int, total: Int) {
        
        //Category Box
        categoryBox.layer.borderWidth = 1
        categoryBox.layer.borderColor = category.color.cgColor
        categoryBox.layer.cornerRadius = 6
        
        categoryLabel.text = category.name //Category Label
        let formattedText = "\(completed)/\(total)" //Completion Count
        let formattedCompletionRate = total > 0 ? (completed * 100) / total : 0 //Completion Rate
        
        // Apply styles for Completion Count
        let attributedText = NSMutableAttributedString(string: formattedText)
        let completedRange = NSRange(location: 0, length: "\(completed)".count)
        attributedText.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .medium), .foregroundColor: UIColor(hex: "#0E100F")], range: completedRange)
        let totalRange = NSRange(location: completedRange.length, length: formattedText.count - completedRange.length)
        attributedText.addAttributes([.font: UIFont.systemFont(ofSize: 10, weight: .medium), .foregroundColor: UIColor(hex: "#7E8491")], range: totalRange)
        completeCountLabel.attributedText = attributedText
            
        //Apply styles for Completion Rate
        let completionText = "\(formattedCompletionRate)%"
        let attributedCompletion = NSMutableAttributedString(string: completionText)
        let percent = NSRange(location: 0, length: "\(formattedCompletionRate)".count)
        attributedText.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .medium), .foregroundColor: UIColor(hex: "#0E100F")], range: percent)
        let percentRange = NSRange(location: completionText.count - 1, length: 1)
        attributedCompletion.addAttributes([.font: UIFont.systemFont(ofSize: 10, weight: .medium), .foregroundColor: UIColor(hex: "#7E8491")], range: percentRange)
        completeRateLabel.attributedText = attributedCompletion
    }

}
