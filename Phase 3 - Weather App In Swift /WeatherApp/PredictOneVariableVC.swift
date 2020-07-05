//
//  PredictOneVariableVC.swift
//  WeatherApp
//
//  Created by Hung Doan on 7/5/20.
//  Copyright © 2020 Hung Doan. All rights reserved.
//

import UIKit

class PredictOneVariableVC: UIViewController {
    
    
    @IBOutlet weak var inputTemperatureTextField: UITextField!
    @IBOutlet weak var nextTemperatureLabel: UILabel!
    @IBOutlet weak var nextOneConditionImageView: UIImageView!
    @IBOutlet weak var nextOneDegreeLabel: UILabel!
    
    struct NextTemperature : Codable
    {
       let Next: Float
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.inputTemperatureTextField.keyboardType = UIKeyboardType.decimalPad
        self.nextOneConditionImageView.isHidden = true
        self.nextTemperatureLabel.isHidden = true
        self.nextOneDegreeLabel.isHidden = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
//            if self.view.frame.origin.y == 0
//            {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil
        {
//            if self.view.frame.origin.y != 0
//            {
//                self.view.frame.origin.y = 0
//            }
        }
    }
    
    @IBAction func predictButtonClicked(_ sender: Any) {
        UpdateTemperature()
    }
    
    func UpdateTemperature() {
           let inputTemperature = Float(self.inputTemperatureTextField.text!)
           let urlObj = URL(string:"http://ec2-52-15-234-97.us-east-2.compute.amazonaws.com:8090/iot/\(inputTemperature!)")!
           var temps:NextTemperature?
           let session = URLSession.shared
           let task = session.dataTask(with: urlObj)
           {
               (data,response,error)  in
               do {
                   temps = try JSONDecoder().decode(NextTemperature.self, from: data!)
                   DispatchQueue.main.async {
                        self.nextTemperatureLabel.text = String(temps!.Next)
                        self.nextTemperatureLabel.isHidden = false
                        self.nextOneConditionImageView.isHidden = false
                        self.nextOneDegreeLabel.isHidden = false
                   }
               }
               catch
               {
                   print("error");
               }
           }
           task.resume()
       }
}
