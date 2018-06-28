//
//  ViewController.swift
//  Sprinkle of Yeezus
//
//  Created by Eric Bates on 5/1/18.
//  Copyright © 2018 Eric Bates. All rights reserved.
//

import UIKit
import UserNotifications

var pickedCount = Array(repeating: 0, count: sprinkleList.count)

func pickRandomQuote(_  sprinkleList: Array<Sprinkle>, _ pickrate: Array<Int>) -> Sprinkle{
    let range = sprinkleList.count
    let pick = Int(arc4random_uniform(UInt32(range)))
    
    var minimum = pickrate.min()
    var selection = sprinkleList[pick]
    if selection.timesPicked == minimum!{
        selection.timesPicked += 1
        
    }
    
    print(sprinkleList[pick])
    return sprinkleList[pick]
    //This picks a random kanye quote from the structure
}

class ViewController: UIViewController {
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var NewQuoteButtonLabel: UIButton!
    @IBOutlet weak var sourceLabel: UILabel!
    
    //Filling in boxes
    func fillTextBoxes(_ sprinkleList: Sprinkle) {
        var sprinkleQuote = sprinkleList
        
        //fill quote box with quote
        quoteLabel.text = "\(sprinkleQuote.quote)"
        sprinkleQuote.timesPicked += 1
       // QuoteBox.centerVertically()
        
        
        //fill source box
        if sprinkleQuote.quoteSource.isEmpty {
            sourceLabel.text = ""
        } else {
            sourceLabel.text = "\(sprinkleQuote.quoteSource)"
        }
  
        //fill source box with year if there is one
        if sprinkleQuote.date != 0 {
            if (sourceLabel.text?.isEmpty)!{
                sourceLabel.text = "\(sprinkleQuote.date)"
            } else {
                sourceLabel.text?.append(", \(sprinkleQuote.date)")
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.4705882353, green: 0.9411764706, blue: 0.368627451, alpha: 1)
        pickedCount[5] = 6
    }
    
    @IBAction func NewQuoteButton(_ sender: UIButton) {
        fillTextBoxes(pickRandomQuote(sprinkleList, pickedCount))
        NewQuoteButtonLabel.setTitle("MORE KANYE-FIDENCE", for: .normal)
       // DescLabel.isHidden = true
    }
    
    @IBAction func ShareButton(_ sender: UIButton) {
        let quote = UIActivityViewController(activityItems: [quoteLabel.text! + " - via Sprinkle of Yeezus app"], applicationActivities: nil)
        present(quote, animated: true, completion: nil)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



