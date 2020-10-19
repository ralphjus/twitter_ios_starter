//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Justin Ralph on 10/17/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var ProfilePic: UIImageView!
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var Username: UILabel!
    
    @IBOutlet weak var tweets: UILabel!
    
    @IBOutlet weak var following: UILabel!
    
    @IBOutlet weak var followers: UILabel!
    
    @IBOutlet weak var myAt: UILabel!
    
    var dictionary = [NSDictionary]()
    var numTweets: Int!

    override func viewWillAppear(_ animated: Bool) {
        TwitterAPICaller.client?.getDictionaryRequest(url: "https://api.twitter.com/1.1/account/verify_credentials.json", parameters: ["skip_status":1], success: { (NSDictionary) in self.dictionary.removeAll()
            self.dictionary.append(NSDictionary)
            print(self.dictionary)
            self.Username.text = (self.dictionary[0]["name"] as! String)
            let PicURL = URL(string: ((self.dictionary[0]["profile_image_url_https"] as? String)!))
            let data = try? Data(contentsOf: PicURL!)
            if let imageData = data {
            self.ProfilePic.image = UIImage(data: imageData)
            }
            let PicURL2 = URL(string: ((self.dictionary[0]["profile_banner_url"] as? String)!))
            let data2 = try? Data(contentsOf: PicURL2!)
            if let imageData = data2 {
            self.background.image = UIImage(data: imageData)
            }
            let friends = self.dictionary[0]["friends_count"] as! NSNumber
            let followers = self.dictionary[0]["followers_count"] as! NSNumber
            let statuses = self.dictionary[0]["statuses_count"] as! NSNumber
            self.following.text = "\(friends.stringValue) pages followed"
            self.followers.text = "\(followers.stringValue) followers"
            self.tweets.text = "\(statuses.stringValue) posts by you"
            self.myAt.text = "@\(self.dictionary[0]["screen_name"] as! String)"

            
            
            
        }, failure: { (Error) in
            print("Error fetching profile \(Error)")
        })
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

