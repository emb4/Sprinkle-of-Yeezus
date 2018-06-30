//
//  ViewController.swift
//  Sprinkle of Yeezus
//
//  Created by Eric Bates on 5/1/18.
//  Copyright © 2018 Eric Bates. All rights reserved.
//

import UIKit
import UserNotifications

var elementPicked = [Int]() //array that keeps track of previously picked quotes to avoid duplicates

func pickRandomQuote(_  sprinkleList: Array<Sprinkle>) -> Sprinkle{
    // Picks a random Kanye Quote from structure
    print("\nPicking quote...")
    let range = sprinkleList.count
    var pick = Int(arc4random_uniform(UInt32(range)))
    var notADuplicate = false
    var selection = sprinkleList[pick]
    var attempt = 0
    
    while notADuplicate == false { //avoids duplicate picks.. unless it can't fine a unique quote after 10 tries
        if elementPicked.contains(pick){
            if attempt == 10{
                print("No unique quotes found after 10 attemps.. picking: \(selection.quote)")
                return selection
            }
            attempt += 1
            print("Duplicate found \(attempt) times.. trying again")
            pick = Int(arc4random_uniform(UInt32(range)))
            selection = sprinkleList[pick]
        } else {
            notADuplicate = true
            print("Picked quote: \(selection.quote)")
            elementPicked.append(pick)
            return selection
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var newQuoteButtonLabel: UIButton!
    @IBOutlet weak var sourceLabel: UILabel!
    
    //Filling in boxes
    func fillTextBoxes(_ sprinkleQuote: Sprinkle) {
        
        //fill quote box with quote
        quoteLabel.text = "\(sprinkleQuote.quote)"
        
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
    }
    
    @IBAction func newQuoteButton(_ sender: UIButton) {
        fillTextBoxes(pickRandomQuote(sprinkleList))
        newQuoteButtonLabel.setTitle("MORE KANYE-FIDENCE", for: .normal)
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        let quote = UIActivityViewController(activityItems: [quoteLabel.text! + " - via Sprinkle of Yeezus app"], applicationActivities: nil)
        present(quote, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



