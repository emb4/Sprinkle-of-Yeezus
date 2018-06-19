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

    @IBOutlet private weak var InfoLabel: UILabel!
    @IBOutlet private weak var DescButton: UIButton!
    @IBOutlet private weak var DescLabel: UILabel!
    @IBOutlet private weak var Switch: UISwitch!
    @IBOutlet private weak var TimePicked: UIDatePicker!
    
    var sprinkleTimePicked = Date()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        sprinkleNotifications(sprinkleList)
    }
    
    // MARK: - IBAction
    @IBAction private func NotificationSwitch(_ sender: UISwitch) {
        if sender.isOn {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: { didAllow, error in
                sender.isOn = didAllow
            })
        }
        
        updateUI()
    }
    
    @IBAction private func TimePicker(_ sender: UIDatePicker){
        sprinkleTimePicked = TimePicked.date
    }  
    
    // MARK: - Private
    private func updateUI() {
        [DescLabel, DescButton].forEach { $0.isHidden = !Switch.isOn }
    }
    
    private func sprinkleNotifications(_ sprinkleList: Array<Sprinkle>) {
        guard Switch.isOn else {
            return
        }
        
        let notification = UNMutableNotificationContent()
        let notificationText = pickRandomQuote(sprinkleList)
        notification.body = " \"\(notificationText.quote)\" \(notificationText.quoteSource), \(notificationText.date)"

        let timeForSprinkle = TimePicked.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: timeForSprinkle)
        InfoLabel.text = "Sprinkles will be sent every day at \(components.hour):\(components.minute)"
        let notificationTime = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
    }
}
