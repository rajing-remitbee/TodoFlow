//
//  BottomSheetMenuViewController.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 10/02/25.
//

import UIKit

class BottomSheetMenuViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var categoryTableView: UITableView! //Categories Table
    @IBOutlet var bottomSheetMenuView: UIView! //BottomSheet Menu View
    @IBOutlet var bottomSheetDragHandle: UIView! //BottomSheet Drag Handle
    
    var taskCategories: [TaskCategoryModel] = [] //Task Categories Array
    var isAddingNewList = false //Edit Mode
    var selectedCategoryIndex: IndexPath? //Selected Index
    
    private var initialBottomSheetY: CGFloat = 0 //Initial BottomSheet Height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Semi-Transparent Background Color
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        //Observer for keyboard - Hide and Show
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //TableView Delegate and Datasource
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        setUpBottomSheet() //Setup Bottomsheet
        setupCategories() //Setup Categories
        addPanGesture() //Setup PanGesture
    }
    
    //When keyboard pops up
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height //Keyboard height

            // Move the bottom sheet up by the keyboard height
            UIView.animate(withDuration: 0.3) {
                self.bottomSheetMenuView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight / 2)
            }
        }
    }
    
    //When keyboard hides
    @objc private func keyboardWillHide(_ notification: Notification) {
        // Reset the bottom sheet position
        UIView.animate(withDuration: 0.3) {
            self.bottomSheetMenuView.transform = .identity
        }
    }
    
    //Setup BottomSheet
    private func setUpBottomSheet() {
        //Corner Radius
        bottomSheetMenuView.layer.cornerRadius = 16
        //Radius only on top
        bottomSheetMenuView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomSheetMenuView.layer.masksToBounds = true
        
        //Drag-Handle Radius
        bottomSheetDragHandle.layer.cornerRadius = 2

        // Move bottom sheet off-screen initially
        self.bottomSheetMenuView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)

        // Animate the bottom sheet sliding up
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.bottomSheetMenuView.transform = .identity
            }
        }
    }
    
    //Fetch and Set CategoryList
    private func setupCategories() {
        taskCategories = CategoryStorage.shared.getCategories() //Fetch Categories
        taskCategories.append(TaskCategoryModel(name: "Add New List", colorHex: "#000000", isEditing: false)) //Add new list menu
    }
    
    //Add Pan Gesture
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))) //Setup PanGesture
        bottomSheetMenuView.addGestureRecognizer(panGesture) //Add PanGesture to BottomSheet
    }
    
    //Handle Pan Gesture
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        //BottomSheet XY Translation
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
            //Initial BottomSheet State
        case .began:
            initialBottomSheetY = bottomSheetMenuView.frame.origin.y
            //Changed BottomSheet State
        case .changed:
            let newY = initialBottomSheetY + translation.y
            if newY >= initialBottomSheetY {
                // Prevent moving up beyond original position
                bottomSheetMenuView.frame.origin.y = newY
            }
            //Final BottomSheet State
        case .ended:
            //Gesture Velocity
            let velocity = gesture.velocity(in: view)
            if velocity.y > 500 {
                // If swipe down fast, dismiss
                dismissBottomSheet()
            } else {
                // Snap back to original position if not swiped hard enough
                UIView.animate(withDuration: 0.3) {
                    self.bottomSheetMenuView.transform = .identity
                }
            }
        default:
            break
        }
    }
   
    //Dismiss the Bottom Sheet
    private func dismissBottomSheet() {
        //Dismiss Animation
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetMenuView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    //ColorPicker Menu
    private func showColorPicker(for indexPath: IndexPath) {
        selectedCategoryIndex = indexPath //Selected Category Index
        let colorPicker = UIAlertController(title: "Pick a Color", message: nil, preferredStyle: .actionSheet) //Color Picker Alert
        
        // Pre-defined colors with names and hexcode
        let colors: [(name: String, hex: String)] = [
            ("Red", "#F44336"),
            ("Pink", "#E91E63"),
            ("Purple", "#9C27B0"),
            ("Deep Purple", "#673AB7"),
            ("Indigo", "#3F51B5"),
            ("Blue", "#2196F3"),
            ("Light Blue", "#03A9F4"),
            ("Teal", "#009688"),
            ("Green", "#4CAF50"),
            ("Light", "#8BC34A"),
            ("Lime", "#CDDC39"),
            ("Yellow", "#FFEB3B"),
            ("Amber", "#FFC107"),
            ("Orange", "#FF9800"),
            ("Deep Orange", "#FF5722"),
            ("Brown", "#795548"),
            ("Grey", "#9E9E9E"),
            ("Blue Gray", "#607D8B")
        ]
        
        // Action for each color
        for color in colors {
            let action = UIAlertAction(title: color.name, style: .default) { _ in
                // Save the hex code of the selected color
                self.saveSelectedColor(color.hex)
            }
            //Set black color for text
            action.setValue(UIColor.black, forKey: "titleTextColor")
            
            //Setup action
            colorPicker.addAction(action)
        }
        
        //Add cancel button
        colorPicker.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        //Display the Alert
        present(colorPicker, animated: true) {
            colorPicker.view.tintColor = UIColor.black // Set black as tint
        }
    }
    
    private func saveSelectedColor(_ hex: String) {
        //Index at position
        guard let indexPath = selectedCategoryIndex else { return }
        
        //Check if it is not the last item
        if indexPath.row >= taskCategories.count - 1 {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //Update color code
            self.taskCategories[indexPath.row].colorHex = hex
            
            // Save only the categories
            let categoriesToSave = self.taskCategories.dropLast()
            CategoryStorage.shared.saveCategories(Array(categoriesToSave))
            
            //Reload data in table
            self.categoryTableView.reloadData()
        }
    }
    
    //Destruct Observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BottomSheetMenuViewController: UITableViewDataSource {
    
    //Number of Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //Single Section
    }
    
    //Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskCategories.count //Row Count
    }
    
    //Configure Each Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Cell Object at Position
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        //Category at Position
        let category = taskCategories[indexPath.row]
        
        cell.configure(with: category)
        
        // If editing, save category when name is entered
        cell.onNameEntered = { [weak self] name in
            guard let self = self else { return }
            if indexPath.row < taskCategories.count - 1 {
                taskCategories[indexPath.row].name = name //Update category name
                taskCategories[indexPath.row].isEditing = false //Update edit mode
            } else {
                //Create new category
                let newCategory = TaskCategoryModel(name: name, colorHex: "#000000", isEditing: false)
                taskCategories[indexPath.row] = newCategory
                
                // Append a new "Add New List" item after saving
                taskCategories.append(TaskCategoryModel(name: "Add New List", colorHex: "#000000", isEditing: false))
            }
            //Store categories
            CategoryStorage.shared.saveCategories(Array(taskCategories.dropLast()))
            //Disable edit mode
            isAddingNewList = false
            DispatchQueue.main.async {
                //Update table in UI
                self.categoryTableView.reloadData()
            }
        }
        
        //Color selection
        cell.onColorSelected = { [weak self] in
            self?.showColorPicker(for: indexPath) //Show color picker menu
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //New List tapped
        if indexPath.row == taskCategories.count - 1 {
            isAddingNewList = true //Enable edit mode
            taskCategories[indexPath.row] = TaskCategoryModel(name: "", colorHex: "#000000", isEditing: true) //New Category
            taskCategories.append(TaskCategoryModel(name: "Add New List", colorHex: "#000000", isEditing: false)) //Add to list
            tableView.reloadData() //Reload data in table
        }
        
        DispatchQueue.main.async {
            if let cell = tableView.cellForRow(at: indexPath) as? CategoryCell {
                cell.editCategoryLabel.becomeFirstResponder() //Open keyboard when adding table
            }
        }
    }
}
