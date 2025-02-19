//
//  BottomSheetViewController.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 07/02/25.
//

import UIKit

class BottomSheetViewController: UIViewController {

    @IBOutlet var bottomSheetView: UIView! //BottomSheetView
    @IBOutlet var taskInput: UITextField! //Task TextInput
    @IBOutlet var btnCalendar: UIButton! //Calendar Button
    @IBOutlet var btnCategory: UIButton! //Category Button
    @IBOutlet var btnSubmit: UIButton! //Submit Button
    @IBOutlet var bottomDragHandle: UIView! //Bottom Drag Handle
    
    weak var bottomSheetDelegate: BottomSheetDelegate? //Delegate for BottomSheet
    
    private var initialBottomSheetY: CGFloat = 0 //Initial BottomSheet Height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Semi-Transparent Background
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        setUpBottomSheet()
        setupKeyboardObservers()
        addPanGesture()
    }
    
    private func setUpBottomSheet() {
        //Corner Radius
        bottomSheetView.layer.cornerRadius = 16
        //Radius only on top
        bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomSheetView.layer.masksToBounds = true
        
        //Drag-Handle Radius
        bottomDragHandle.layer.cornerRadius = 2

        // Move bottom sheet off-screen initially
        self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        
        //Make keyboard popup
        taskInput.becomeFirstResponder()
        
        //Setup today as initial date
        updateDateChip(with: Date())
        
        //Setup default category
        updateCategoryChip(with: TaskCategoryModel(name: "Default", colorHex: "#000000"))

        // Animate the bottom sheet sliding up
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.bottomSheetView.transform = .identity
            }
        }
    }
    
    private func showDatePicker() {
        //Alert for calendar
        let alert = UIAlertController(title: "Select Date", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        let datePicker = UIDatePicker() //Date Picker
        datePicker.datePickerMode = .date //Date Picker Mode
        datePicker.preferredDatePickerStyle = .wheels //Data Picker Style
        datePicker.frame = CGRect(x: 10, y: 20, width: 250, height: 200)

        alert.view.addSubview(datePicker)

        //Date Picker - Select Action
        let selectAction = UIAlertAction(title: "Select", style: .default) { _ in
            self.updateDateChip(with: datePicker.date)
        }
        
        //Date Picker - Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(selectAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    
    private func updateDateChip(with date: Date) {
        //Calendar object
        let calendar = Calendar.current
        //Current date
        let today = calendar.startOfDay(for: Date())
        //Selected Date
        let selectedDay = calendar.startOfDay(for: date)
        //Format Date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        var dateText = formatter.string(from: date)
        //Format if today's date
        if selectedDay == today {
            dateText = "Today"
        }
        //Update text
        btnCalendar.setTitle(dateText, for: .normal)
    }
    
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        //View Date Picker
        showDatePicker()
    }
    
    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        //View Category Picker
        showCategoryPicker()
    }
    
    @IBAction func submitButtomTapped(_ sender: UIButton) {
        guard let title = taskInput.text, !title.isEmpty else {
            print("Task title is empty")
            return
        }
        
        let selectedDate = getSelectedDate()
        let selectedCategory = getSelectedCategory()
        
        let newTask = TaskModel(title: title, date: selectedDate, category: selectedCategory, isCompleted: false)
        
        TaskStorage.shared.addTask(newTask)
        
        bottomSheetDelegate?.didAddTasks()
        
        dismissBottomSheet()
    }
    
    //Fetch Selected Date
    private func getSelectedDate() -> Date {
        let dateFormatter = DateFormatter() //Date formatter
        dateFormatter.dateFormat = "MMM d, yyyy" //Format Date
        
        let buttonTitle = btnCalendar.title(for: .normal) ?? "Today"
        
        //Convert to date
        if buttonTitle == "Today" {
            return Date()
        } else if buttonTitle == "Tomorrow" {
            return Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        } else if buttonTitle == "Yesterday" {
            return Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        } else {
            return dateFormatter.date(from: buttonTitle) ?? Date()
        }
    }
    
    private func getSelectedCategory() -> TaskCategoryModel {
        return TaskCategoryModel(name: btnCategory.title(for: .normal) ?? "Default", colorHex: btnCategory.layer.borderColor?.toHexString() ?? "#000000")
    }
    
    private func showCategoryPicker() {
        let categories = CategoryStorage.shared.getCategories()
        
        let alert = UIAlertController(title: "Choose Category", message: nil, preferredStyle: .actionSheet)
        
        for category in categories {
            let action = UIAlertAction(title: category.name, style: .default) { _ in
                self.updateCategoryChip(with: category)
            }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func updateCategoryChip(with category: TaskCategoryModel) {
        btnCategory.setTitle(category.name, for: .normal)
        btnCategory.layer.borderColor = category.color.cgColor
        btnCategory.layer.borderWidth = 1
        btnCategory.layer.cornerRadius = 8
    }

    //Keyboard PopUp Observer
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //If Keyboard Shown, Move bottom sheet little up
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            UIView.animate(withDuration: 0.3) {
                self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height / 1.75)
            }
        }
    }
    
    //If Keyboard hidden, Move bottom sheet little down
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.bottomSheetView.transform = .identity
        }
    }
    
    //Add Pan Gesture
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))) //Setup PanGesture
        bottomSheetView.addGestureRecognizer(panGesture) //Add PanGesture to BottomSheet
    }
    
    //Handle Pan Gesture
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        //BottomSheet XY Translation
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
            //Initial BottomSheet State
        case .began:
            initialBottomSheetY = bottomSheetView.frame.origin.y
            //Changed BottomSheet State
        case .changed:
            let newY = initialBottomSheetY + translation.y
            if newY >= initialBottomSheetY {
                // Prevent moving up beyond original position
                bottomSheetView.frame.origin.y = newY
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
                    self.bottomSheetView.transform = .identity
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
            self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    //Remove observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

