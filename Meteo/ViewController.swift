//
//  ViewController.swift
//  Meteo
//
//  Created by John Britzke on 1/8/18.
//  Copyright © 2018 Thaumatech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var resultLabel: UILabel!
    
    @IBAction func getWeather(_ sender: Any) {
        if let url = URL(string: "https://www.weather-forecast.com/locations/" + cityTextField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
            let request = NSMutableURLRequest(url: url)
        
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                var message = ""
                
                if let error = error {
                    print(error)
                } else {
                    if let unwrappedData = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
                        var stringSeparate = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        
                        if let contentArray = dataString?.components(separatedBy: stringSeparate) {
                            if contentArray.count > 1 {
                                stringSeparate = "</span>"
                                
                                //finally reaching blurb of html text needed for city weather
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparate)
                                if newContentArray.count > 1 {
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                }
                            }
                        }
                    }
                }
                
                if message == "" {
                    message = "Unable to get weather data... Please try again."
                }
                
                DispatchQueue.main.sync {
                    self.resultLabel.text = message
                }
            }
        
            task.resume()  //get the task going
        } else {
            self.resultLabel.text = "Unable to get weather data... Please try again."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

