//
//  Settings.swift
//  Sprinkle of Yeezus
//
//  Created by Eric Bates on 6/17/18.
//  Copyright © 2018 Eric Bates. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class SettingsPage: UIViewController {
    

    @IBOutlet weak var InfoLabel: UILabel!
    @IBOutlet weak var DescButton: UIButton!
    @IBOutlet weak var DescLabel: UILabel!
    @IBOutlet weak var Switch: UISwitch!
    
    var notificationsOn = Bool()
    
    @IBAction func NotificationSwitch(_ sender: UISwitch) {
        if Switch.isOn == true{
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {didAllow, error in})
            
            DescLabel.isHidden = false
            DescButton.isHidden = false
            
            notificationsOn = true
        } else {
            DescLabel.isHidden = true
            DescButton.isHidden = true
            notificationsOn = false
        }
    }
    
    @IBOutlet weak var TimePicked: UIDatePicker!
    var sprinkleTimePicked = Date()
    @IBAction func TimePicker(_ sender: UIDatePicker){
        sprinkleTimePicked = TimePicked.date
    }
    
    func sprinkleNotifications(_ sprinkleList: Array<Sprinkle>) {
        if notificationsOn == true{
            
            let notification = UNMutableNotificationContent()
            let notificationText = pickRandomQuote(sprinkleList)
            notification.body = " \"\(notificationText.quote)\" \(notificationText.quoteSource), \(notificationText.date)"
            
            let timeForSprinkle = TimePicked.date
            let components = Calendar.current.dateComponents([.hour, .minute], from: timeForSprinkle)
            InfoLabel.text = "Sprinkles will be sent every day at \(components.hour):\(components.minute)"
            let notificationTime = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            
        }
    }
    
    override func viewDidLoad() {
        sprinkleNotifications(sprinkleList)
    }
}
