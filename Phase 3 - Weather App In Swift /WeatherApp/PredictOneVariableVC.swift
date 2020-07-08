//
//  PredictOneVariableVC.swift
//  WeatherApp
//
//  Created by Hung Doan on 7/5/20.
//  Copyright © 2020 Hung Doan. All rights reserved.
//

import UIKit

class PredictOneVariableVC: UIViewController {
    
    @IBOutlet weak var inputTemperatureLabel: UILabel!
    @IBOutlet weak var inputTemperatureTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var nextTemperatureLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
       
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.inputTemperatureTextField.keyboardType = UIKeyboardType.decimalPad
        
        //hidden codition image
        self.conditionImageView.isHidden = true
        self.nextTemperatureLabel.isHidden = true
        self.degreeLabel.isHidden = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func inputOrNotChanged(_ sender: Any) {
        if (self.inputTemperatureTextField.isHidden == true)
        {
            self.inputTemperatureTextField.isHidden = false
            self.inputTemperatureLabel.isHidden = false
        }
        else
        {
            self.inputTemperatureTextField.isHidden = true
            self.inputTemperatureLabel.isHidden = true
        }
    }
    
    @IBAction func predictButtonClicked(_ sender: Any) {
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
           urlObj = URL(string:"http://ec2-52-15-234-97.us-east-2.compute.amazonaws.com:8090/iot/\(inputTemperature!)")!
        }
        else{
           urlObj = URL(string:"http://ec2-52-15-234-97.us-east-2.compute.amazonaws.com:8090/autoiot")!
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
                    var temps:NextOneVariableAutoTemperatureModel?
                    temps = try JSONDecoder().decode(NextOneVariableAutoTemperatureModel.self, from: data!)
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
