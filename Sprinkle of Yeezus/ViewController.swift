//
//  ViewController.swift
//  Sprinkle of Yeezus
//
//  Created by Eric Bates on 5/1/18.
//  Copyright © 2018 Eric Bates. All rights reserved.
//

import UIKit
import UserNotifications

func pickRandomQuote(_  sprinkleList: Array<Sprinkle>) -> Sprinkle{
    let range = sprinkleList.count
    let pick = Int(arc4random_uniform(UInt32(range)))
    print(sprinkleList[pick])
    return sprinkleList[pick]
    //This picks a random kanye quote from the structure
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

class ViewController: UIViewController {
    
    @IBOutlet weak var quoteLabel: UILabel!
    var regularCaseQuoteBoxText = String()
    @IBOutlet weak var NewQuoteButtonLabel: UIButton!
    
    //Filling in boxes
    func fillTextBoxes(_ sprinkleList: Sprinkle) {
        let sprinkleQuote = sprinkleList
        
        //fill quote box with quote
        quoteLabel.text = "\(sprinkleQuote.quote)"
       // QuoteBox.centerVertically()
        
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

    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.4705882353, green: 0.9411764706, blue: 0.368627451, alpha: 1)
    }
    
    @IBAction func NewQuoteButton(_ sender: UIButton) {
        fillTextBoxes(pickRandomQuote(sprinkleList))
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



