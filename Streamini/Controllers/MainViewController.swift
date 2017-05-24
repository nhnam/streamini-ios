//
//  MainViewController.swift
//  Streamini
//
//  Created by Vasily Evreinov on 22/06/15.
//  Copyright (c) 2015 UniProgy s.r.o. All rights reserved.
//

import UIKit

protocol MainViewControllerDelegate: class {
    func streamListReload()
    func changeMode(_ isGlobal: Bool)
}

class MainViewController: BaseViewController, MainViewControllerDelegate, UserSelecting {
    @IBOutlet weak var tableView: UITableView!
    let dataSource  = StreamDataSource()
    weak var rootControllerDelegate: RootViewControllerDelegate?
    var isGlobal    = false
    var timer: Timer?
    
    // MARK: - Network responses
    
    func successStreams(_ live: [Stream], recent: [Stream]) {
        self.tableView.pullToRefreshView.stopAnimating()
        
        dataSource.lives  = live//live.sorted({ (stream1, stream2) -> Bool in stream1.id > stream2.id })
        dataSource.recent = recent//recent.sorted({ (stream1, stream2) -> Bool in stream1.id > stream2.id })
        
        tableView.reloadData()
        
        if let delegate = rootControllerDelegate {
            delegate.modeDidChange(isGlobal)
        }
    }
    
    func failureStream(_ error: NSError) {
        handleError(error)
        self.tableView.pullToRefreshView.stopAnimating()
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func successUser(_ user: User) {
        UserContainer.shared.setLogged(user)
    }
    
    func failureUser(_ error: NSError) {
        handleError(error)
    }
    
    // MARK: - MainViewControllerDelegate
    
    func streamListReload() {
        StreamConnector().streams(isGlobal, success: successStreams, failure: failureStream)
    }
    
    func changeMode(_ isGlobal: Bool) {
        self.isGlobal = isGlobal
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        StreamConnector().streams(isGlobal, success: successStreams, failure: failureStream)
        
        if let delegate = rootControllerDelegate {
            delegate.modeDidChange(isGlobal)
        }
    }
    
    // MARK: - Update
    
    func reload(_ timer: Timer) {
        StreamConnector().streams(isGlobal, success: successStreams, failure: failureStream)
    }    
    
    // MARK: - View life cycle
    
    func configureView() {
        dataSource.userSelectedDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        self.isGlobal = UserDefaults.standard.bool(forKey: "isGlobalStreamsInMain")

        tableView.delegate   = dataSource
        tableView.dataSource = dataSource
        tableView.addPullToRefresh { () -> Void in
            StreamConnector().streams(self.isGlobal, success: self.successStreams, failure: self.failureStream)
        }
        
        UserConnector().get(nil, success: successUser, failure: failureUser)
        changeMode(isGlobal)
        
        self.timer = Timer(timeInterval: TimeInterval(10.0), target: self, selector: #selector(MainViewController.reload(_:)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        
        UIApplication.shared.setStatusBarHidden(false, with: .none)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StreamConnector().streams(isGlobal, success: successStreams, failure: failureStream)
        if timer == nil {
            self.timer = Timer(timeInterval: TimeInterval(10.0), target: self, selector: #selector(MainViewController.reload(_:)), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        }
        UIApplication.shared.setStatusBarHidden(false, with: .none)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer!.invalidate()
        timer = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sid = segue.identifier {
            if sid == "MainToJoinStream" || sid == "MainRecentToJoinStream" {
                let navigationController = segue.destination as! UINavigationController
                let controller = navigationController.viewControllers[0] as! JoinStreamViewController
                controller.stream = (sender as! StreamCell).stream
                controller.isRecent = (sid == "MainRecentToJoinStream")
                controller.delegate = self
            }
        }
    }
    
    // MARK: - UserSelecting protocol
    
    func userDidSelected(_ user: User) {
        self.showUserInfo(user, userStatusDelegate: nil)
    }
    
    // MARK: - Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
