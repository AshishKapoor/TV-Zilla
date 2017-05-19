//
//  SOFilterVC.swift
//  swiftobjc
//
//  Created by Ashish Kapoor on 08/02/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit

class SOFilterVC: UIViewController, SCPopDatePickerDelegate {
    
    // Outlets and properties
    let datePicker                                  = SCPopDatePicker()
    let date                                        = Date()
    var currentTextField                            = UITextField()
    
    @IBOutlet weak var fromReleaseDateTF: UITextField!
    @IBOutlet weak var tillReleaseDateTF: UITextField!
    
    override func viewDidLoad() { super.viewDidLoad() }
 
    // Delegate function for the Picker protocol
    func scPopDatePickerDidSelectDate(_ date: Date) {
        let formatter                               = DateFormatter()
        formatter.dateFormat                        = kDateTimeFormat
        let date                                    = formatter.string(from: date)
        currentTextField.text                       = String(describing: date)
        title                                       = kFilter
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
        if (checkEmptyFields()) {
            if (checkDateValidation()) {
                let soMoviesTVC = soStoryBoard.instantiateViewController(withIdentifier: "SOMoviesTVC") as? SOMoviesTVC
                soMoviesTVC?.tillReleaseYear        = self.tillReleaseDateTF.text!
                soMoviesTVC?.fromReleaseYear        = self.fromReleaseDateTF.text!
                soMoviesTVC?.pageNumber             = kInitialValue
                soMoviesTVC?.currentMovieType       = .filtered
                soMoviesTVC?.title                  = kReleaseDates
                soMoviesTVC?.isFromFilteredMovies   = true
                soMoviesTVC?.setType(type: .filtered)
                self.navigationController?.pushViewController(soMoviesTVC!, animated: true)
            } else {
                let alert = UIAlertController(title: "Enter correct date", message: "Please select correct dates", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: kOkay, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func checkEmptyFields() -> Bool {
        
        if (self.fromReleaseDateTF.text? .isEqual(""))! {
            let alert = UIAlertController(title: "Enter from value", message: "Please select a date", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: kOkay, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        if (self.tillReleaseDateTF.text? .isEqual(""))! {
            let alert = UIAlertController(title: "Enter till value", message: "Please select a date", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: kOkay, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    func checkDateValidation() -> Bool {
        // TODO: Add date validations with returning false. Should be less than current time at least.
        return true
    }
    
    func showDatePicker() {
        self.datePicker.tapToDismiss                = false
        self.datePicker.datePickerType              = SCDatePickerType.date
        self.datePicker.showBlur                    = true
        self.datePicker.datePickerStartDate         = self.date
        self.datePicker.btnFontColour               = UIColor.white
        self.datePicker.btnColour                   = UIColor.darkGray
        self.datePicker.showCornerRadius            = false
        self.datePicker.delegate                    = self
        self.datePicker.show(attachToView: self.view)
    }
    
    // Textfield actions
    
    @IBAction func sender(_ sender: UITextField) {
        
        if fromReleaseDateTF.isEditing {
            title = kMinimumYear
        } else {
            title = kMaximumYear
        }
        currentTextField = sender
        currentTextField.resignFirstResponder()
        showDatePicker()
    }

}
