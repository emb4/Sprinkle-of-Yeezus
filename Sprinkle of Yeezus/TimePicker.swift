//
//  TimePicker.swift
//  Sprinkle of Yeezus
//
//  Created by Eric Bates on 6/20/18.
//  Copyright © 2018 Eric Bates. All rights reserved.
//

import UIKit

protocol TimePickerDelegate: class {
    
    func didUpdatePicker(date: Date)
}

class TimePicker: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    
    weak var delegate: TimePickerDelegate?
    
    @IBAction func getTimeFromPicker(_ sender: UIDatePicker) {
        delegate?.didUpdatePicker(date: sender.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
