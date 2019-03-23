//
//  ViewController.swift
//  ConchCall
//
//  Created by RobertW. on 3/18/19.
//  Copyright © 2019 RobertW. All rights reserved.
//

import UIKit

import Solar
import CoreLocation
import UserNotifications
class ViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate{
    
    
    let locationManager = CLLocationManager()
    var latitudeMap : Double = 0.0
    var longMap: Double = 0.0
    


    @IBOutlet weak var sunsetView: UIImageView!
    

    @IBOutlet weak var sunsetTimeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            longMap = location.coordinate.longitude
            latitudeMap = location.coordinate.latitude
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    @IBAction func activateSchedule(_ sender: Any) {
        // Do any additional setup after loading the view, typically from a nib.
        
        (sender as! UIButton).setTitle("Invitation Sent", for: [])
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        let myLocation = CLLocationCoordinate2D(latitude: latitudeMap , longitude: longMap)
        //let someDate = Date()
        let someDate =  Calendar.current.date(byAdding: .day, value: -1, to: Date())
        //someDate = someDate?.addingTimeInterval(20.0 * 60.0)
        let solar = Solar(for: someDate!, coordinate: myLocation)
        //let dateAsString = solar?.sunrise
         let sunset = solar?.sunset
    
        //let dateComponents = Calendar.current.dateComponents([.timeZone, .year, .month, .day, .hour, .minute, .second], from: sunset!)
        var dateComponents = Calendar.current.dateComponents([  .hour, .minute, .second], from: sunset!)
       /*
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        if hour == dateComponents.hour! && minutes >= dateComponents.minute! {
            //(sender as! UIButton).setTitle("Try Tommorow", for: [])
            sunsetTimeLabel.text = "Sleeping!"
        } else if hour > dateComponents.hour! {
            //(sender as! UIButton).setTitle("Try Tommorow", for: [])
            sunsetTimeLabel.text = "Sleeping!"
        }
        else{
            (sender as! UIButton).setTitle("Invitation Sent", for: [])
 */
            //dateComponents.hour = 14
            //dateComponents.minute = 17
      
            print(" Sunset:  \(dateComponents)")
            sunsetTimeLabel.text = " \( (dateComponents.hour ?? 0) - 12) : " + String(format: "%02d", dateComponents.minute ?? 0)
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
            center.delegate = self
            let content = UNMutableNotificationContent()
            content.title = "Conch Call"
            content.body = "Its Sundown Time to Blow the Conch"
            content.categoryIdentifier = "alarm"
            //content.userInfo = ["customData": "fizzbuzz"]
            content.sound = UNNotificationSound.default
            //content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "shortWav.wav"))
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            //let uuidString = UUID().uuidString
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: "Last Call", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler(.alert)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        print("one")
        
        if response.actionIdentifier == UNNotificationDismissActionIdentifier {
        performSegue(withIdentifier: "goToScreenTwo", sender: self)
            // The user dismissed the notification without taking action
        }
        else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            // The user launched the app
        performSegue(withIdentifier: "goToScreenTwo", sender: self)
        }
        performSegue(withIdentifier: "goToScreenTwo", sender: self)
        // Else handle any custom actions. . .
    
        /*
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")
                performSegue(withIdentifier: "goToScreenTwo", sender: self)
                
                
            case "show":
                // the user tapped our "show more info…" button
                performSegue(withIdentifier: "goToScreenTwo", sender: self)
                print("Show more information…")
                break
                
            default:
                break
            }
        }
       */
        // you must call the completion handler when you're done
        completionHandler()
    }
    
    @IBAction func secretButton(_ sender: Any) {
         performSegue(withIdentifier: "goToScreenTwo", sender: self)
    }
    
}


