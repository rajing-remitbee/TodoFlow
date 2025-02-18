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
    
    func findIndexPath() -> IndexPath? {
        var view = superview
        while let parent = view, !(parent is UITableView) {
            view = parent.superview
        }
        guard let tableView = view as? UITableView else { return nil }
        return tableView.indexPath(for: self)
    }
        
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        sender.isSelected.toggle() // Toggle checkbox state
        // Change tint color dynamically
        sender.tintColor = sender.isSelected ? UIColor(hex: "#00A86B") : UIColor(hex: "#F4F6F6")
        
        if sender.isSelected {
            let attributeString = NSMutableAttributedString(string: taskLabel.text ?? "")
            attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: taskLabel.text?.count ?? 0))
            taskLabel.attributedText = attributeString
        } else {
            taskLabel.attributedText = NSAttributedString(string: taskLabel.text ?? "")
        }
        
        if let indexPath = findIndexPath() {
            delegate?.toggleTaskCompletion(at: indexPath)
        }
    }
}
