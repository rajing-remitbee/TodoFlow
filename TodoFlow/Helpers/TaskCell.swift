//
//  UITableViewCell.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 06/02/25.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet var checkBox: UIButton! //Checkbox
    @IBOutlet var taskLabel: UILabel! //Task Label
    @IBOutlet var categoryLabel: UILabel! //Category Label

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Image for checkbox
        checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        checkBox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        
        //Format category label
        categoryLabel.layer.borderWidth = 1
        categoryLabel.layer.cornerRadius = 6
        categoryLabel.clipsToBounds = true
    }
    
    func configure(with task: TaskModel) {
        //Configure task and category label
        taskLabel.text = task.title
        categoryLabel.text = "  \(task.category.name)  "
        categoryLabel.textColor = task.category.color
        categoryLabel.layer.borderColor = task.category.color.cgColor
    }
        
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        sender.isSelected.toggle() // Toggle check
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
