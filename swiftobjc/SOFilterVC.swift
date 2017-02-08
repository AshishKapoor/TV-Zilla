//
//  SOFilterVC.swift
//  swiftobjc
//
//  Created by Ashish Kapoor on 08/02/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit

class SOFilterVC: UIViewController, SCPopDatePickerDelegate {
    
    let datePicker = SCPopDatePicker()
    let date = Date()
    
    @IBOutlet weak var fromReleaseDateTF: UITextField!
    @IBOutlet weak var tillReleaseDateTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
 
    func scPopDatePickerDidSelectDate(_ date: Date) {
        if fromReleaseDateTF.isEditing {
            self.fromReleaseDateTF.endEditing(true)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date = formatter.string(from: date)
            self.fromReleaseDateTF.text = String(describing: date)
        } else if tillReleaseDateTF.isEditing {
            self.tillReleaseDateTF.endEditing(true)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date = formatter.string(from: date)
            self.tillReleaseDateTF.text = String(describing: date)
        }
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
        
        if (checkEmptyFields()) {
            if (checkDateValidation()) {
                let soMoviesTVC = soStoryBoard.instantiateViewController(withIdentifier: "SOMoviesTVC") as? SOMoviesTVC
                soMoviesTVC?.callFilteredMovies(till: self.tillReleaseDateTF.text!, from: self.fromReleaseDateTF.text!)
                self.navigationController?.pushViewController(soMoviesTVC!, animated: true)
            } else {
                let alert = UIAlertController(title: "Enter correct date", message: "Please select correct dates", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func checkEmptyFields() -> Bool {
        
        if (self.fromReleaseDateTF.text? .isEqual(""))! {
            let alert = UIAlertController(title: "Enter from value", message: "Please select a date", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        if (self.tillReleaseDateTF.text? .isEqual(""))! {
            let alert = UIAlertController(title: "Enter till value", message: "Please select a date", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    func checkDateValidation() -> Bool {
        // Add date validations with returning false. Should be less than current time at least.
        return true
    }
    
    func showDatePicker() {
        self.datePicker.tapToDismiss = true
        self.datePicker.datePickerType = SCDatePickerType.date
        self.datePicker.showBlur = true
        self.datePicker.datePickerStartDate = self.date
        self.datePicker.btnFontColour = UIColor.white
        self.datePicker.btnColour = UIColor.darkGray
        self.datePicker.showCornerRadius = false
        self.datePicker.delegate = self
        self.datePicker.show(attachToView: self.view)
    }
    
    @IBAction func beginEditingFromTF(_ sender: Any) {
        showDatePicker()
    }
    
    @IBAction func beginEditingTillTF(_ sender: Any) {
        showDatePicker()
    }
    
}
