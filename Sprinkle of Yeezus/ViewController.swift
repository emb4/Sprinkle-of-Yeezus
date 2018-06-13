//
//  ViewController.swift
//  Sprinkle of Yeezus
//
//  Created by Eric Bates on 5/1/18.
//  Copyright © 2018 Eric Bates. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var QuoteBox: UITextView!
    
    func sprinkleNotifications(_ sprinkleList: Array<Sprinkle>) {
        if notificationsOn == true{
        let notificationText = pickRandomQuote(sprinkleList)
        print("The Notification center is running...")
        let notification = UNMutableNotificationContent()
        notification.body = " \"\(notificationText.quote)\" \(notificationText.quoteSource), \(notificationText.date)"
        notification.badge = 1
        print("A notification should have came out by now...")
        
        let timeBetweenNotifications = UNTimeIntervalNotificationTrigger(timeInterval: 43200, repeats: true)
        let notificationRequest = UNNotificationRequest(identifier: "times up", content: notification, trigger: timeBetweenNotifications)
        
        UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: nil)
        }
    }
    

    
    func pickRandomQuote(_  sprinkleList: Array<Sprinkle>) -> Sprinkle{
        let range = sprinkleList.count
        let pick = Int(arc4random_uniform(UInt32(range)))
        print(sprinkleList[pick])
        return sprinkleList[pick]
        //This picks a random kanye quote from the structure
    }
    
    var regularCaseQuoteBoxText = String()
    
    //Filling in boxes
    func fillTextBoxes(_ sprinkleList: Sprinkle) {
        let sprinkleQuote = sprinkleList
        
        //fill quote box with quote
        QuoteBox.text = "\(sprinkleQuote.quote)"

        
        /*
        //fill source box
        if sprinkleQuote.quoteSource.isEmpty {
            QuoteBox.text.append("\n\n - Kanye West")
        } else {
            QuoteBox.text.append("\n\n \(sprinkleQuote.quoteSource)")
        }
  
        //fill date box with year if there is one
        if sprinkleQuote.date != 0 {
            QuoteBox.text?.append(", \(sprinkleQuote.date)")
        }
 */
        QuoteBox.centerVertically()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {didAllow, error in})
        let selectedQuote = pickRandomQuote(sprinkleList)
        QuoteBox.centerVertically()
        fillTextBoxes(selectedQuote)
        sprinkleNotifications(sprinkleList)
        QuoteBox.centerVertically()
    }
    
    @IBAction func NewQuoteButton(_ sender: UIButton) {
        fillTextBoxes(pickRandomQuote(sprinkleList))
        
    }
    
    @IBAction func ShareButton(_ sender: UIButton) {
        let quote = UIActivityViewController(activityItems: ["\(regularCaseQuoteBoxText) - via Sprinkle of Yeezus app"], applicationActivities: nil)
        present(quote, animated: true, completion: nil)
    }
    
    var notificationsOn = false
    @IBAction func NotificationToggle(_ sender: UISwitch) {
        if notificationsOn == false {
            notificationsOn = true
        } else {
            notificationsOn = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}

