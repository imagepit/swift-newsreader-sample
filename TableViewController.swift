//
//  TableViewController.swift
//  newsreader
//
//  Created by 高橋良輔 on 2016/09/14.
//  Copyright © 2016年 imagepit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SafariServices

class TableViewController: UITableViewController {
    
    var fetchFrom: String = "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://menthas.com/top/rss&num=10" // ニュースフィードRSS URL
    var articles: [[String: String?]] = [] // ニュース記事の配列（中身はディクショナリ）
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFeed()
        // カスタムセル登録
        self.tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        // 下スワイプで記事再取得・更新
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "引っ張って更新")
        self.refreshControl?.addTarget(self, action: #selector(TableViewController.fetchFeed), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
    }
    
    //-------------------------------
    // ニュースフィード取得
    //-------------------------------
    func fetchFeed(){
        Alamofire.request(.GET, fetchFrom)
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                let json = JSON(object)
                json["responseData"]["feed"]["entries"].forEach { (_, json) in
                    let article: [String: String?] = [
                        "title": json["title"].string!,
                        "date": json["publishedDate"].string!,
                        "link": json["link"].string!,
                    ]
                    self.articles.append(article)
                    print("articles:\(self.articles)")
                    self.tableView.reloadData()
                    self.refreshControl!.endRefreshing()
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    // セクションの数を指定
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // セル（Row）の数を指定
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 取得した記事の数を指定
        return articles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! TableViewCell
        cell.titleLabel.text = articles[indexPath.row]["title"]!
        cell.indicator.startAnimating()
        cell.indicator.alpha = 1
        cell.link = articles[indexPath.row]["link"]!
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    // セルタップ時の処理
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let svc = SFSafariViewController(URL: NSURL(string: articles[indexPath.row]["link"]!!)!)
        self.presentViewController(svc, animated: true, completion: nil)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
