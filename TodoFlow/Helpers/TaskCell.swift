//
//  UITableViewCell.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 06/02/25.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet var checkBox: UIButton! //Checkbox
    @IBOutlet var taskLabel: UILabel! //TaskLabel
    @IBOutlet var categoryBox: UILabel! //Category Box
    @IBOutlet var categoryLabel: UILabel! //Category Label

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Initially unchecked
        checkBox?.isSelected = false
        
        //Image for checkbox
        checkBox?.setImage(UIImage(systemName: "square"), for: .normal)
        checkBox?.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        checkBox?.tintColor = UIColor(hex: "#F4F6F6")
        
        //Format category box
        categoryBox?.layer.borderWidth = 1
        categoryBox?.layer.cornerRadius = 6
        categoryBox?.clipsToBounds = true
    }
    
    func configure(with task: TaskModel) {
        //Configure task and category label
        taskLabel.text = task.title
        categoryLabel.text = "  \(task.category.name)  "
        categoryBox.layer.borderColor = task.category.color.cgColor
    }
        
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        sender.isSelected.toggle() // Toggle checkbox state
        // Change tint color dynamically
        sender.tintColor = sender.isSelected ? UIColor(hex: "#00A86B") : UIColor(hex: "#F4F6F6")
    }
}
