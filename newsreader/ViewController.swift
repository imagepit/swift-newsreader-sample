//
//  ViewController.swift
//  newsreader
//
//  Created by 高橋良輔 on 2016/09/14.
//  Copyright © 2016年 imagepit. All rights reserved.
//

import UIKit
import PageMenu

class ViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPageMenu()
    }
    
    //-----------------------------------------
    // ページメニュー設定
    //-----------------------------------------
    func setPageMenu(){
        // ページ設定（とりあえず3ページ定義）
        var controllerArray : [UIViewController] = []
        let controller1 = TableViewController(nibName: "TableViewController", bundle: nil)
        controller1.title = "TOP"
        controller1.fetchFrom = "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://menthas.com/top/rss&num=10"
        controllerArray.append(controller1)
        let controller2 = TableViewController(nibName: "TableViewController", bundle: nil)
        controller2.title = "iOS"
        controller2.fetchFrom = "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://menthas.com/ios/rss&num=10"
        controllerArray.append(controller2)
        let controller3 = TableViewController(nibName: "TableViewController", bundle: nil)
        controller3.title = "Ruby"
        controller3.fetchFrom = "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://menthas.com/ruby/rss&num=10"
        controllerArray.append(controller3)
        
        // ページメニューのパラメータ
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)),
            .ViewBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
            .SelectionIndicatorColor(UIColor.orangeColor()),
            .BottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
            .MenuHeight(60.0),
            .MenuItemWidth(90.0),
            .CenterMenuItems(true)
        ]
        
        // ページメニュー初期化
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        // 画面に表示
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        pageMenu!.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

