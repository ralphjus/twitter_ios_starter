//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Justin Ralph on 10/8/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit
import Lottie
import SkeletonView

class HomeTableViewController: UITableViewController {
    
    var TweetArray = [NSDictionary]()
    var numTweets: Int!
    var animationView: AnimationView?
    var refresh = true
    
    @objc func loadTweets(){
        
        numTweets = 20
        
        let resource = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let param = ["count": numTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: resource, parameters: param as [String : Any], success: { (tweets: [NSDictionary]) in
            self.TweetArray.removeAll()
            for tweet in tweets {
                self.TweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            self.StopAnimation()
        }, failure: { (Error) in
            print("could not retrieve tweets")
        })
    }
    
    func loadMoreTweets(){
        
        numTweets += 20
        
        let resource = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let param = ["count": numTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: resource, parameters: param as [String : Any], success: { (tweets: [NSDictionary]) in
            self.TweetArray.removeAll()
            for tweet in tweets {
                self.TweetArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("could not retrieve tweets")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == TweetArray.count {
            loadMoreTweets()
        }
    }

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.showSkeleton()
        StartAnimations()
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadTweets()
        super.viewDidAppear(animated)
        
    }
    
    func StartAnimations() {
        animationView = .init(name: "TweetLoadIcon")
        animationView!.frame = CGRect(x:(view.frame.origin.x + (view.frame.width - 200) / 2), y:(view.frame.origin.y + (view.frame.height - 200) / 2), width: 200, height: 200)
        animationView!.contentMode = .scaleAspectFit
        view.addSubview(animationView!)
        view.superview?.bringSubviewToFront(animationView!)
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 5
        animationView!.play()
        //view.showAnimatedSkeleton()
    }
    
    @objc func StopAnimation(){
        animationView?.stop()
        animationView?.isHidden = true
        view.subviews.last?.removeFromSuperview()
        //view.hideSkeleton()
        refresh = false
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCellTableViewCell", for: indexPath) as! TweetCellTableViewCell
        //if self.refresh {
          //  cell.showAnimatedGradientSkeleton()
        //} else {
          //  cell.hideSkeleton()
        //}
        let userDict = TweetArray[indexPath.row]["user"] as! NSDictionary
        let entities = TweetArray[indexPath.row]["entities"] as! NSDictionary
        //let media = entities["media"] as! NSDictionary
        
        //embedding image
        if entities["media"] != nil{
            
            if let entityArray = entities["media"] as? [[String:Any]],
               let picture = entityArray.first {
                print(picture["media_url_https"] as! String)
                let PicURL = URL(string: picture["media_url_https"] as! String)
                let data = try? Data(contentsOf: PicURL!)
                if let imageData = data {
                    cell.embeddedImage.image = UIImage(data: imageData)
                    cell.embeddedImage.isHidden = false
                }
            }
        }else{
            cell.embeddedImage.isHidden = true
        }
        
        ///
        cell.userNameLabel.text = userDict["name"] as? String
        cell.tweetContent.text =  TweetArray[indexPath.row]["text"] as? String
        
        let PicURL = URL(string: ((userDict["profile_image_url_https"] as? String)!))
        let data = try? Data(contentsOf: PicURL!)
        if let imageData = data {
            cell.ProfileImageView.image = UIImage(data: imageData)
            
            cell.ProfileImageView.layer.cornerRadius = 32.5
            
            cell.ProfileImageView.clipsToBounds = true
        }
        cell.setFavorite(TweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = TweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(TweetArray[indexPath.row]["retweeted"] as! Bool)
        
        return cell
    }

    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeTableViewController: SkeletonTableViewDataSource {
            
        func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
            return "TweetCellTableViewCell"
        }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TweetArray.count
    }
}

@available(iOS 13.0, *)
extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
