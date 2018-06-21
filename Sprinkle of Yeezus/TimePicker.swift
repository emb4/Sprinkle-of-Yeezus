//
//  TimePicker.swift
//  Sprinkle of Yeezus
//
//  Created by Eric Bates on 6/20/18.
//  Copyright © 2018 Eric Bates. All rights reserved.
//

import UIKit

class TimePicker: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    @IBAction func getTimeFromPicker(_ sender: UIDatePicker) {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var timePicked: Date
        timePicker.datePickerMode = .time
        if timePicked == nil {
            timePicker.date = Date()
        } else {
            timePicker.date = timePicked
        }
            
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
