//
//  ViewController.swift
//  Weather
//
//  Created by Echo on 16/3/31.
//  Copyright © 2016年 iDareX. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let appid = "182a7bc925017c33c8fb0744d7fd0290"
    let requestURL = "http://api.openweathermap.org/data/2.5/weather"
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    
    //声明一个变量
    let locationManage: CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.startLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 打开定位
    
    func startLocation() {
        locationManage.delegate = self
        //精确度
        locationManage.desiredAccuracy = kCLLocationAccuracyBest
        
        //ios8+以上必须用它初始化
        if ios8() {
            locationManage.requestWhenInUseAuthorization()
        }
        //打开定位服务
        locationManage.startUpdatingLocation()
    }
    
    //MARK: - 系统是不是晚于iOS8
    
    func ios8() -> Bool {
        let systemVersion = UIDevice.currentDevice().systemVersion
        let svPrefix: String = systemVersion.componentsSeparatedByString(".")[0]
        return Int(svPrefix) >= 8
    }
    
    //MARK: - CLLocationManagerDelegate 定位改变的回调
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations[locations.count - 1]
        if (location.horizontalAccuracy > 0) {
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            updateLocationWeatherInfo(location.coordinate.latitude, longitude: location.coordinate.longitude)
            locationManage.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.description)
    }

    //MARK: - update location weather info
    
    func updateLocationWeatherInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        Alamofire.request(.GET, requestURL, parameters: ["lat": latitude, "lon": longitude, "cnt": 0, "appid": appid])
            .responseJSON { response in
                if let JSON = response.result.value {
                    print("Success JSON: \(JSON)")
                    self.updateUISuccess(JSON as! NSDictionary)
                }
        }
        
        
        
    }
    
    //MARK: - update UI Successed 
    
    func updateUISuccess(jsonResult:NSDictionary!) {
    
        let coun = jsonResult["sys"]?["country"] as? String
        let temperature = jsonResult["main"]?["temp"] as? Double
        let weatherCondition = jsonResult["weather"]?[0]["id"] as? Int
        let iconString = jsonResult["weather"]?[0]["icon"] as? String
        
        guard let v = temperature else { return }
        let temp = Temperature.init(country: coun!, openWeatherMapDegrees: v)
        self.temperatureLabel.text = temp.degrees
        
        let weatherIcon = WeatherIcon(condition: weatherCondition!, iconString: iconString!)
        self.weatherLabel.text = weatherIcon.iconText
        
        self.LocationLabel.text = coun
    }
}

