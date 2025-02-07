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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Semi-Trnsparent Background
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        setUpBottomSheet()
        setupKeyboardObservers()
    }
    
    private func showDatePicker() {
        //Alert for calendar
        let alert = UIAlertController(title: "Select Date", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        let datePicker = UIDatePicker() //Date Picker
        datePicker.datePickerMode = .date //Date Picker Mode
        datePicker.preferredDatePickerStyle = .compact //Data Picker Style
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
        formatter.dateFormat = "MMM d"
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
    
    private func setUpBottomSheet() {
        //Corner Radius
        bottomSheetView.layer.cornerRadius = 16
        //Radius only on top
        bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomSheetView.layer.masksToBounds = true

        // Move bottom sheet off-screen initially
        self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)

        // Animate the bottom sheet sliding up
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.bottomSheetView.transform = .identity
            }
        }
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
                self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height / 2)
            }
        }
    }
    
    //If Keyboard hidden, Move bottom sheet little down
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.bottomSheetView.transform = .identity
        }
    }
    
    //Remove observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
