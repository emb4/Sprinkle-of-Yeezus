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
    
    private var sprinkleTimePicked: Date?
    private var notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        sprinkleNotifications(sprinkleList)
    }
    
    // MARK: - IBAction
    @IBAction private func NotificationSwitch(_ sender: UISwitch) {
        if sender.isOn {
            notificationCenter.requestAuthorization(options: [.alert, .sound], completionHandler: { didAllow, error in
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
        guard Switch.isOn, let sprinkleTimePicked = sprinkleTimePicked else {
            return
        }
        
        notificationCenter.removeAllPendingNotificationRequests()
        
        let notification = UNMutableNotificationContent()
        let notificationText = pickRandomQuote(sprinkleList)
        notification.body = " \"\(notificationText.quote)\" \(notificationText.quoteSource), \(notificationText.date)"

        let components = Calendar.current.dateComponents([.hour, .minute], from: sprinkleTimePicked)
        let hour = components.hour ?? 12
        let minute = components.minute ?? 0
        
        InfoLabel.text = "Sprinkles will be sent every day at \(hour):\(minute)"
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "Sprinkle-of-Yeezus", content: notification, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
}
