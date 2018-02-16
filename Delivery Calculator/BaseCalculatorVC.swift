//
//  CalculatorViewController.swift
//  Delivery Calculator
//
//  Created by Тигран on 31.01.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

class BaseCalculatorVC: UIViewController {
    var dataModel: Model? = nil
    var petrol: String = "АИ-80"
    
    @IBOutlet weak var borderPrice: UITextField!
    @IBOutlet weak var petrolPicker: UIPickerView!
    @IBOutlet weak var baseResults: UILabel!
    @IBOutlet weak var calculatorScrollView: UIScrollView!
    @IBAction func baseCalculationButton(_ sender: Any) {
        self.baseResults.text = dataModel?.calculateBasePrice(withBorderPrice: borderPrice.text, petrol: petrol)
        self.calculatorScrollView?.endEditing(true)
    }
    
    var pickerData = [String]()
    
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        
        self.calculatorScrollView?.contentInset = contentInsets
        calculatorScrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        calculatorScrollView?.contentInset = contentInsets
        calculatorScrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func hideKeyboard() {
        self.calculatorScrollView?.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.petrolPicker.delegate = self
        self.petrolPicker.dataSource = self
        
        self.downloadRate()
        
        pickerData = ["АИ-80", "АИ-92", "АИ-95", "ДТ"]
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        calculatorScrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let tabBar = self.tabBarController?.viewControllers
        let settingVC = tabBar![1] as! SettingsViewController
        settingVC.dataModel = self.dataModel
        
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}