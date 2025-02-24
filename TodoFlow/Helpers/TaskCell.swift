//
//  UITableViewCell.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 06/02/25.
//

import UIKit

class TaskCell: UITableViewCell {
    
    weak var delegate: TaskCellDelegate?
    
    @IBOutlet var checkBox: UIButton! //Checkbox
    @IBOutlet var taskLabel: UILabel! //TaskLabel
    @IBOutlet var categoryBox: UILabel! //Category Box
    @IBOutlet var categoryLabel: UILabel! //Category Label
    
    var indexPath: IndexPath?

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
    
    func configure(with task: TaskModel, index: IndexPath) {
        //Configure indexPath
        indexPath = index
        //Configure task and category label
        taskLabel.text = task.title
        categoryLabel.text = "  \(task.category.name)  "
        categoryBox.layer.borderColor = task.category.color.cgColor
        
        //Update checkbox based on task completion
        checkBox.isSelected = task.isCompleted
        checkBox.tintColor = task.isCompleted ? UIColor(hex: "#00A86B") : UIColor(hex: "#F4F6F6")
        
        //Strike text if task is completed
        if task.isCompleted {
            let attributeString = NSMutableAttributedString(string: task.title)
            attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: task.title.count))
            taskLabel.attributedText = attributeString
        } else {
            taskLabel.attributedText = NSAttributedString(string: task.title)
        }
    }
        
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        if let indexPath = self.indexPath {
            delegate?.toggleTaskCompletion(at: indexPath)
        }
    }
}
