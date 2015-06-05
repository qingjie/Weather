//
//  ViewController.swift
//  Weather
//
//  Created by qingjiezhao on 6/5/15.
//  Copyright (c) 2015 qingjiezhao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtCity: UITextField!
 
    
    @IBOutlet weak var cityName: UILabel!
    
    
    @IBOutlet weak var cityTemp: UILabel!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.loadingIndicator.startAnimating()
        
        getWeatherData("http://api.openweathermap.org/data/2.5/weather?q=Syracuse,NY")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func okTapped(sender: AnyObject) {
        getWeatherData("http://api.openweathermap.org/data/2.5/weather?q=\(txtCity.text)")
    }

    
    func getWeatherData( urlString : String){
        
        self.loadingIndicator.hidden = true
        self.loadingIndicator.stopAnimating()
        
        
        let url = NSURL(string: urlString)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!){(data,response,error) in
            dispatch_async(dispatch_get_main_queue(), {
                self.setLabels(data)
            })
        }
        task.resume()
    }
    
    func setLabels(weatherData: NSData){
        
        
        var jsonError : NSError?
        let json  = NSJSONSerialization.JSONObjectWithData(weatherData, options: nil, error: &jsonError) as! NSDictionary
        
        if let name = json["name"] as? String{
            cityName.text = name
        }
        
        if let main = json["main"] as? NSDictionary{
            if let temp = main["temp"] as? Double{
                var temperature = round(((temp - 273.15) * 1.8) + 32)
                cityTemp.text = String(format: "%.1f", temperature)
            }
        }else{
            cityTemp.text = "Weather is unavailable."
        }
    }
}

