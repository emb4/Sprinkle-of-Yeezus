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
    
    private var sprinkleTimePicked = Defaults.notificationDate ?? Date()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        sprinkleNotifications(sprinkleList)
        anniversaryNotifications()
        updateLabelTime()
        updateSwitchStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Loads saved time from datepicker when getting to view
        let labelTime = UserDefaults.standard.string(forKey: "savedLabel")
        informationLabel.text = labelTime
    }
    
    // MARK: - IBAction
    @IBAction private func notificationSwitch(_ sender: UISwitch) {
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
        //Run when time is set on date picker
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
        
        guard notificationSwitch.isOn else { //Runs only user turns on notification switch
            return
        }
        
        let notification = UNMutableNotificationContent()
        var notificationText = [Sprinkle]()
        var components = Calendar.current.dateComponents([.hour, .minute], from: sprinkleTimePicked) //grabs time from picker
        
        let today = Date()
        let calendar = Calendar.current
        components.day = calendar.component(.day, from: today) //grabs current day from phones calendar
        let month = 30
        var nextDay = DateComponents()
        nextDay.hour = components.hour
        nextDay.minute = components.minute
        
        
        //schedules sprinkles for 30 days
       for days in 0...month {
        notificationText.append(pickRandomQuote(sprinkleList))
        
        notification.body = "\"\(notificationText[days].quote)\"" //Formats notification
        if notificationText[days].quoteSource != "" {
            notification.body.append(" - \(notificationText[days].quoteSource)")
        }
        if notificationText[days].date != 0 {
            notification.body.append(", \(notificationText[days].date)")
        }
        
        nextDay.day = components.day! + days //tommorow is today plus 1 and the time set
        let trigger = UNCalendarNotificationTrigger(dateMatching: nextDay, repeats: false)
        let request = UNNotificationRequest(identifier: "Sprinkle number \(days)", content: notification, trigger: trigger)
        print("Time set for \(nextDay)")
        print("Notification content: \(notificationText[days].quote)")
        
        notificationCenter.add(request) { error in
            if let error = error {
                print(error)
                }
            }
        }
        updateLabelTime()
    }
    
    private func anniversaryNotifications() {
        guard notificationSwitch.isOn else { //Runs only user turns on notification switch
            return
        }
        let today = Date()
        let currentCalendar = Calendar.current
        var anniversaryDate = DateComponents()
        let notification = UNMutableNotificationContent()
        
        struct album{
            let name: String
            let releaseDate: DateComponents
        }
        
        let albumList = [ 
            album(name: "The College Dropout", releaseDate: DateComponents(year: 2004, month: 2, day: 10)),
            album(name: "Late Registration", releaseDate: DateComponents(year: 2005, month: 8, day: 30)),
            album(name: "Graduation", releaseDate: DateComponents(year: 2007, month: 9, day: 11)),
            album(name: "808's and Heartbreak", releaseDate: DateComponents(year: 2008, month: 11, day: 24)),
            album(name: "My Beautiful Dark Twisted Fantasy", releaseDate: DateComponents(year: 2010, month: 11, day: 22)),
            album(name: "Yeezus", releaseDate: DateComponents(year: 2013, month: 6, day: 18)),
            album(name: "The Life of Pablo", releaseDate: DateComponents(year: 2016, month: 2, day: 14)),
            album(name: "Ye", releaseDate: DateComponents(year: 2018, month: 6, day: 1)),
            album(name: "Watch the Throne", releaseDate: DateComponents(year: 2011, month: 8, day: 8)),
            album(name: "Cruel Summer", releaseDate: DateComponents(year: 2012, month: 9, day: 14)),
            album(name: "Kids See Ghosts", releaseDate: DateComponents(year: 2018, month: 6, day: 8))
            ]
        
        for item in albumList{
            anniversaryDate.year = currentCalendar.component(.year, from: today)
            anniversaryDate.month = item.releaseDate.month
            anniversaryDate.day = item.releaseDate.day
            
            let albumAge = anniversaryDate.year! - item.releaseDate.year! //time from albums release to current year
            notification.body = "🎉 \(item.name) was released \(albumAge) years ago today! 🎂"
            let trigger = UNCalendarNotificationTrigger(dateMatching: anniversaryDate, repeats: false)
            let request = UNNotificationRequest(identifier: "Album anniversary for \(item.name)", content: notification, trigger: trigger)
            
            print("The anniversary notification for \(item.name) has been schedualed on \(anniversaryDate)")
            
            notificationCenter.add(request) { error in
                if let error = error {
                    print(error)
                }
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
        
        informationLabel.text = "Sprinkles will be sent every day at \n\(formattedTime)"
        UserDefaults.standard.set(informationLabel.text, forKey: "savedLabel")
        
    }
}


extension SettingsPage: TimePickerDelegate {
    
    func didUpdatePicker(date: Date) {
        Defaults.notificationDate = date
        sprinkleTimePicked = date
        sprinkleNotifications(sprinkleList)
    }
}
