//
//  CategoryCell.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 11/02/25.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet var categoryBox: UILabel! //Category Box
    @IBOutlet var categoryLabel: UILabel! //Category Label

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        categoryBox?.layer.borderWidth = 1
        categoryBox?.layer.cornerRadius = 6
        categoryBox?.clipsToBounds = true
    }
    
    func configure(with task: TaskCategoryModel) {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
