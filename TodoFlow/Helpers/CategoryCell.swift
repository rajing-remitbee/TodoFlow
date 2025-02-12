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
    @IBOutlet var editCategoryLabel: UITextField! //Edit Category Label
    
    var onNameEntered: ((String) -> Void)? //Name
    var onColorSelected: (() -> Void)? //Color
    
    //Trigger when editing text
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            onNameEntered?(text)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        //Category Box
        categoryBox?.layer.borderWidth = 1
        categoryBox?.layer.cornerRadius = 6
        categoryBox?.clipsToBounds = true
        
        //Category Label
        editCategoryLabel?.isHidden = true
        editCategoryLabel?.delegate = self
        
        //Tap Gesture for CategoryBox
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryBoxTapped))
        categoryBox?.addGestureRecognizer(tapGesture)
        categoryBox?.isUserInteractionEnabled = true
    }
    
    //Color Selection
    @objc private func categoryBoxTapped() {
        onColorSelected?()
    }
    
    func configure(with task: TaskCategoryModel) {
        categoryLabel.isHidden = task.isEditing //Hide when editing
        editCategoryLabel.isHidden = !(task.isEditing) //Show when editing
        
        if task.isEditing == true {
            editCategoryLabel.text = "" //Empty label
            editCategoryLabel.becomeFirstResponder() //Open keyboard when editing
        } else {
            categoryLabel.text = task.name //Show category name
            categoryBox.layer.borderColor = task.color.cgColor //Show category color
        }
    }
}

extension CategoryCell: UITextFieldDelegate {
    //User clicks enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            onNameEntered?(text)
        }
        //Dismiss keyboard
        textField.resignFirstResponder()
        return true
    }
}


