//
//  TweetViewController.swift
//  Twitter
//
//  Created by Justin Ralph on 10/19/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var TweetTextView: UITextView!
    
    @IBOutlet weak var TextCounter: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TweetTextView.becomeFirstResponder()
        TweetTextView.delegate = self

        // Do any additional setup after loading the view.
    }
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func Tweet(_ sender: Any) {
        if (!TweetTextView.text.isEmpty){
            TwitterAPICaller.client?.postTweet(tweetString: TweetTextView.text, success: { self.dismiss(animated: true, completion: nil)}, failure: { (Error) in
                print("Error posting tweet \(Error)")
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Set the max character limit
        TextCounter.text = ("\(TweetTextView.text.count + (text.count - range.length))/280")
        
        if TweetTextView.text.count + (text.count - range.length) == 281 {
            TextCounter.text = "280/280"
        }
        
        return TweetTextView.text.count + (text.count - range.length) <= 280
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
