//
//  PredictTwoVariableVC.swift
//  WeatherApp
//
//  Created by Hung Doan on 7/5/20.
//  Copyright © 2020 Hung Doan. All rights reserved.
//

import UIKit

class PredictTwoVariableVC: UIViewController {
        
    @IBOutlet weak var inputHumidityLabel: UILabel!
    @IBOutlet weak var inputHumidityTextField: UITextField!
    @IBOutlet weak var inputTemperatureTextField: UITextField!
    @IBOutlet weak var inputTemperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var nextTemperatureLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
           
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.inputTemperatureTextField.keyboardType = UIKeyboardType.decimalPad
        self.inputHumidityTextField.keyboardType = UIKeyboardType.decimalPad
        
        self.conditionImageView.isHidden = true
        self.nextTemperatureLabel.isHidden = true
        self.degreeLabel.isHidden = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func intputOrNotChanged(_ sender: Any) {
        if (self.inputTemperatureTextField.isHidden == true)
        {
            self.inputTemperatureTextField.isHidden = false
            self.inputTemperatureLabel.isHidden = false
            self.inputHumidityLabel.isHidden = false
            self.inputHumidityTextField.isHidden = false
        }
        else
        {
            self.inputTemperatureTextField.isHidden = true
            self.inputTemperatureLabel.isHidden = true
            self.inputHumidityLabel.isHidden = true
            self.inputHumidityTextField.isHidden = true
        }
    }
    
    @IBAction func predictingButtonClicked(_ sender: Any) {
       if(self.inputTemperatureTextField.isHidden == true)
       {
           updateTemperature(isInput:false)
       }
       else
       {
           updateTemperature(isInput:true)
       }
    }
    
    func updateTemperature(isInput:Bool) {
           let urlObj:URL = createURLObject(isInput: isInput)
           callAPI(isInput: isInput, urlObj: urlObj)
    }
       
   func createURLObject(isInput:Bool) -> URL
   {
       var urlObj:URL
       if(isInput==true){
       let inputTemperature = Float(self.inputTemperatureTextField.text!)
       let inputHumidity = Float(self.inputHumidityTextField.text!)
          urlObj = URL(string:"http://ec2-52-15-234-97.us-east-2.compute.amazonaws.com:8090/iot2/\(inputTemperature!)/\(inputHumidity!)")!
       }
       else{
          urlObj = URL(string:"http://ec2-52-15-234-97.us-east-2.compute.amazonaws.com:8090/autoiot2")!
       }
       return urlObj
   }
   
   func callAPI(isInput:Bool, urlObj:URL)
   {
       let session = URLSession.shared
       let task = session.dataTask(with: urlObj)
       {
           (data,response,error)  in
           do {
               if(isInput==true)
               {
                   var temps:NextTemperatureModel?
                   temps = try JSONDecoder().decode(NextTemperatureModel.self, from: data!)
                   DispatchQueue.main.async {
                       self.nextTemperatureLabel.text = String(temps!.Next_Temperature)
                       self.conditionImageView.isHidden = false
                       self.nextTemperatureLabel.isHidden = false
                       self.degreeLabel.isHidden = false
                       }
               }
               else {
                   var temps:NextTwoVariableAutoTemperatureModel?
                   temps = try JSONDecoder().decode(NextTwoVariableAutoTemperatureModel.self, from: data!)
                   DispatchQueue.main.async {
                       self.nextTemperatureLabel.text = String(temps!.Next_Temperature)
                       self.conditionImageView.isHidden = false
                       self.nextTemperatureLabel.isHidden = false
                       self.degreeLabel.isHidden = false
                       }
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
