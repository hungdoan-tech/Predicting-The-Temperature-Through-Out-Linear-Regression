//
//  PredictTwoVariableVC.swift
//  WeatherApp
//
//  Created by Hung Doan on 7/5/20.
//  Copyright © 2020 Hung Doan. All rights reserved.
//

import UIKit

class PredictTwoVariableVC: UIViewController {
        
        
    @IBOutlet weak var inputTemperatureTwoTextField: UITextField!
    @IBOutlet weak var inputHumidityTwoTextField: UITextField!
    @IBOutlet weak var nextTemperatureTwoLabel: UILabel!
    @IBOutlet weak var degreeTwoLabel: UILabel!
    @IBOutlet weak var conditionTwoImageView: UIImageView!
    
    struct NextTemperature : Codable
    {
       let Future: Float
    }
           
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.inputTemperatureTwoTextField.keyboardType = UIKeyboardType.decimalPad
        self.inputHumidityTwoTextField.keyboardType = UIKeyboardType.decimalPad
        
        self.conditionTwoImageView.isHidden = true
        self.nextTemperatureTwoLabel.isHidden = true
        self.degreeTwoLabel.isHidden = true
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
    
    
    @IBAction func PredictTwoVariableButtonClicked(_ sender: Any) {
        UpdateTemperature()
    }
    
    func UpdateTemperature() {
           let inputTemperature = Float(self.inputTemperatureTwoTextField.text!)
           let inputHumidity = Float(self.inputHumidityTwoTextField.text!)
           let urlObj = URL(string:"http://ec2-52-15-234-97.us-east-2.compute.amazonaws.com:8090/iot2/\(inputTemperature!)/\(inputHumidity!)")!
           var temps:NextTemperature?
           let session = URLSession.shared
           let task = session.dataTask(with: urlObj)
           {
               (data,response,error)  in
               do {
                   temps = try JSONDecoder().decode(NextTemperature.self, from: data!)
                   DispatchQueue.main.async {
                        self.nextTemperatureTwoLabel.text = String(temps!.Future)
                        self.conditionTwoImageView.isHidden = false
                        self.nextTemperatureTwoLabel.isHidden = false
                        self.degreeTwoLabel.isHidden = false
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
