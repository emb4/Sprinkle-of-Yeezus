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
        updateLabelTime()
        updateSwitchStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let savedLabel = UserDefaults.standard.string(forKey: "labelSaved")
        informationLabel.text = savedLabel
        
    }
    
    // MARK: - IBAction
    @IBAction private func NotificationSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "switchStatus") //saves the status of the switch
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
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "Sprinkle-of-Yeezus", content: notification, trigger: trigger)
        
        updateLabelTime()
        
        notificationCenter.add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func updateSwitchStatus(){ //this function checks to see if the switch was flipped in the past and acts accordingly
        let notificationsOn = UserDefaults.standard.bool(forKey: "switchStatus")
        notificationSwitch.isOn = notificationsOn
        if notificationsOn {
            updateUI()
        }
    }
    
    func updateLabelTime(){ //updates the label that shows when the next sprinkle is coming, currently not working 100%
        let time = sprinkleTimePicked
        let timeFormat = DateFormatter()
        timeFormat.dateStyle = .none
        timeFormat.timeStyle = .short
        let formattedTime = timeFormat.string(from: time)
        UserDefaults.standard.set(formattedTime, forKey: "timeSaved")
        let savedFormattedTime = UserDefaults.standard.string(forKey: "timeSaved")
        
        informationLabel.text = "Sprinkles will be sent every day at \n"
        if time == Date() && savedFormattedTime != nil{
            informationLabel.text?.append(savedFormattedTime!)
        } else {
            informationLabel.text?.append(formattedTime)
        }
    }
}


extension SettingsPage: TimePickerDelegate {
    
    func didUpdatePicker(date: Date) {
        sprinkleTimePicked = date
        sprinkleNotifications(sprinkleList)
    }
}
