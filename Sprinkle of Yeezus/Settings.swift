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

    @IBOutlet private weak var informationLabel: UILabel!
    @IBOutlet private weak var changeTimeButton: UIButton!
    @IBOutlet private weak var notificationSwitch: UISwitch!
    @IBOutlet private weak var timePicked: UIDatePicker!
    
    private var sprinkleTimePicked = Date()
    private let notificationCenter = UNUserNotificationCenter.current()
    

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        sprinkleNotifications(sprinkleList)
        
        
    }
    
    // MARK: - IBAction
    @IBAction private func NotificationSwitch(_ sender: UISwitch) {
        if sender.isOn {
            notificationCenter.requestAuthorization(options: [.alert, .sound], completionHandler: { didAllow, error in
                DispatchQueue.main.async {
                    sender.isOn = didAllow
                    self.updateUI()
                }
            })
        }
        
        updateUI()
    }
    
    @IBAction private func pickTimeAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "TimePickerViewController") as! TimePicker
        controller.delegate = self
        
        navigationController?.pushViewController(controller, animated: true)
    }  
    
    // MARK: - Private
    private func updateUI() {
        [informationLabel, changeTimeButton].forEach { $0.isHidden = !notificationSwitch.isOn }
    }
    
    private func sprinkleNotifications(_ sprinkleList: Array<Sprinkle>) {
        notificationCenter.removeAllPendingNotificationRequests()
        
        guard notificationSwitch.isOn else {
            return
        }
        
        let notification = UNMutableNotificationContent()
        let notificationText = pickRandomQuote(sprinkleList)
        notification.body = "\"\(notificationText.quote)\" \(notificationText.quoteSource), \(notificationText.date)"

        let components = Calendar.current.dateComponents([.hour, .minute], from: sprinkleTimePicked)
        let hour = components.hour ?? 12
        let minute = components.minute ?? 0
        
        informationLabel.text = "Sprinkles will be sent every day at \(hour):\(minute)"
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "Sprinkle-of-Yeezus", content: notification, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
}

extension SettingsPage: TimePickerDelegate {
    
    func didUpdatePicker(date: Date) {
        sprinkleTimePicked = date
        sprinkleNotifications(sprinkleList)
    }
}
