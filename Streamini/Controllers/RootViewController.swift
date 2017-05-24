//
//  RootViewController.swift
//  Streamini
//
//  Created by Vasily Evreinov on 11/08/15.
//  Copyright (c) 2015 Evghenii Todorov. All rights reserved.
//

import UIKit
import Photos

protocol RootViewControllerDelegate: class {
    func modeDidChange(_ isGlobal: Bool)
}

class RootViewController: BaseViewController, RootViewControllerDelegate {
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var recButton: UIButton!
    @IBOutlet weak var peopleButton: UIButton!    
    @IBOutlet weak var containerView: UIView!
    var containerViewController: ContainerViewController?
    
    weak var delegate: MainViewControllerDelegate?
    var isGlobal = false
    
    // MARK: - Actions
    
    @IBAction func recButtonPressed(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "RootToCreate", sender: self)
    }
    
    @IBAction func peopleButtonPressed(_ sender: AnyObject) {
        containerViewController!.peopleViewController()
        homeButton.isSelected   = false
        peopleButton.isSelected = true
        setupPeopleNavigationItems()
    }
    
    @IBAction func mainButtonPressed(_ sender: AnyObject) {
        containerViewController!.mainViewController()
        homeButton.isSelected   = true
        peopleButton.isSelected = false
        setupMainNavigationItems()
    }
    
    func profileButtonItemPressed(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "RootToProfile", sender: nil)
    }
    
    func searchButtonItemPressed(_ sender: AnyObject) {
        let peopleController = containerViewController!.childViewControllers[0] as! PeopleViewController
        if peopleController.isSearchMode {
            peopleController.hideSearch(true)
            peopleController.dataSource!.reload()
        } else {
            peopleController.showSearch(true)
        }
    }
    
    // MARK: - Setup Navigation Items
    
    func setupPeopleNavigationItems() {
        self.title = NSLocalizedString("people_title", comment: "")
        
        let leftButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0))
        leftButton.setImage(UIImage(named: "search"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(RootViewController.searchButtonItemPressed(_:)), for: UIControlEvents.touchUpInside)
        leftButton.setImageTintColor(UIColor(white: 1.0, alpha: 0.5), for: UIControlState())
        leftButton.setImageTintColor(UIColor(white: 1.0, alpha: 1.0), for: UIControlState.highlighted)
        let leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        let rightButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0))
        rightButton.setImage(UIImage(named: "profile"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(RootViewController.profileButtonItemPressed(_:)), for: UIControlEvents.touchUpInside)
        rightButton.setImageTintColor(UIColor(white: 1.0, alpha: 0.5), for: UIControlState())
        rightButton.setImageTintColor(UIColor(white: 1.0, alpha: 1.0), for: UIControlState.highlighted)
        let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        self.navigationItem.leftBarButtonItem  = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupMainNavigationItems() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        let itemImage: UIImage
        if isGlobal {
            self.title = NSLocalizedString("global_title",  comment: "")
            itemImage = UIImage(named: "following")!
        } else {
            self.title = NSLocalizedString("followed_title",  comment: "")
            itemImage = UIImage(named: "global")!
        }
        
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0))
        button.setImage(itemImage, for: UIControlState())
        button.addTarget(self, action: #selector(RootViewController.modeChanged), for: UIControlEvents.touchUpInside)
        button.setImageTintColor(UIColor(white: 1.0, alpha: 0.5), for: UIControlState())
        button.setImageTintColor(UIColor(white: 1.0, alpha: 1.0), for: UIControlState.highlighted)
        let item = UIBarButtonItem(customView: button)
        
        let leftButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0))
        leftButton.setImage(UIImage(named: "search"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(searchTapped(_:)), for: UIControlEvents.touchUpInside)
        leftButton.setImageTintColor(UIColor(white: 1.0, alpha: 0.5), for: UIControlState())
        leftButton.setImageTintColor(UIColor(white: 1.0, alpha: 1.0), for: UIControlState.highlighted)
        let leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        self.navigationItem.rightBarButtonItem = item
        self.navigationItem.leftBarButtonItem  = leftBarButtonItem
    }
    
    // MARK: - RootViewControllerDelegate
    
    func modeDidChange(_ isGlobal: Bool) {
        self.isGlobal = isGlobal
        UserDefaults.standard.set(isGlobal, forKey: "isGlobalStreamsInMain")
        
        if homeButton.isSelected {
            setupMainNavigationItems()
        }
    }
    
    func modeChanged() {
        if let del = delegate {
            del.changeMode(!isGlobal)
        }
    }
    
    func searchTapped(_ sender: AnyObject)
    {
        // Load controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchScreen")
        // Show Controller
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - View life cycle
    
    func configureView() {
        self.navigationController!.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        self.navigationController!.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName: UIColor.white ]
        
        let normalStateColor = UIColor.buttonNormalColor()
        let highlightedStateColor = UIColor.buttonHighlightedColor()
        
        homeButton.setImageTintColor(normalStateColor, for: UIControlState())
        homeButton.setImageTintColor(highlightedStateColor, for: UIControlState.highlighted)
        homeButton.setImageTintColor(highlightedStateColor, for: UIControlState.selected)
        homeButton.isSelected = true
        
        peopleButton.setImageTintColor(normalStateColor, for: UIControlState())
        peopleButton.setImageTintColor(highlightedStateColor, for: UIControlState.highlighted)
        peopleButton.setImageTintColor(highlightedStateColor, for: UIControlState.selected)
        
        recButton.setImage(UIImage(named: "rec-off"), for: UIControlState())
        recButton.setImage(UIImage(named: "rec-on"), for: UIControlState.highlighted)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()        
        modeDidChange(false)
        
        // Ask for use CLLocationManager
        let _ = LocationManager.shared
        
        // Ask for use Camera
        if AVCaptureDevice.responds(to: #selector(AVCaptureDevice.requestAccess(forMediaType:completionHandler:))) {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) -> Void in
            })
        }
        
        // Ask for use Microphone
        if (AVAudioSession.sharedInstance().responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                //
            })
            
        }
        
        // Ask for use Photo Gallery
        if NSClassFromString("PHPhotoLibrary") != nil {
                if #available(iOS 8.0, *) {
                    PHPhotoLibrary.requestAuthorization { (status) -> Void in
                }
                } else {
                    // Fallback on earlier versions
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sid = segue.identifier {
            if sid == "RootToContainer" {
                containerViewController = segue.destination as? ContainerViewController
                containerViewController!.parentController = self
            }
            
            if sid == "RootToProfile" {
                let peopleController = containerViewController!.childViewControllers[0] as! PeopleViewController
                let profileController = segue.destination as! ProfileViewController
                profileController.profileDelegate = peopleController
            }
        }
    }
    
    // MARK: - Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
