//
//  YoutubeCreateShareViewController.swift
//  Streamini
//
//  Created by ナム Nam Nguyen on 5/10/17.
//  Copyright © 2017 UniProgy s.r.o. All rights reserved.
//

import UIKit

class YoutubeCreateShareViewController: UIViewController {

    @IBOutlet weak var titleView: UITextView!
    @IBOutlet weak var captionView: UITextField!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var model:YoutubeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.text = "What's happening?"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let videoId = model?.videoId else { return }
        playerView.load(withVideoId: videoId, playerVars: ["playsinline":1])
    }
    

    @IBAction func didTouchPublishButton(_ sender: Any) {
        loadingIndicator.startAnimating()
        let data = NSMutableDictionary(objects: [captionView.text!], forKeys: ["title" as NSCopying])
        if let pm = LocationManager.shared.currentPlacemark {
            data["lon"]  = pm.location!.coordinate.longitude
            data["lat"]  = pm.location!.coordinate.latitude
            data["city"] = pm.locality
        }
        data["videotype"] = "youtube"
        data["extras"] = "{\"videoId\":\"\(model?.videoId ?? "")\"}"
        data["private"] = 0
        StreamConnector().create(data, success: createStreamSuccess, failure: createStreamFailure)
    }
    
    @IBAction func didTouchCloseButton(_ sender: Any) {
        LocationManager.shared.stopMonitoringLocation()
        self.captionView.resignFirstResponder()
        close()
    }
    
    func createStreamSuccess(_ stream: Stream) {
        loadingIndicator.stopAnimating()
        
        LocationManager.shared.stopMonitoringLocation()
        let twitter = SocialToolFactory.getSocial("Twitter")!
        let url = "\(Config.shared.twitter().tweetURL)/\(stream.streamHash)/\(stream.id)"
        twitter.post(UserContainer.shared.logged().name, live: URL(string: url)!)
       
        close()
    }
    
    func createStreamFailure(_ error: NSError) {
        loadingIndicator.stopAnimating()
        
        print("\(error.localizedDescription)")
    }
    
    func close() {
        let childs = self.navigationController?.childViewControllers
        guard let lastVc = childs?.last else { return }
        self.navigationController?.setViewControllers([lastVc], animated: false)
        lastVc.dismiss(animated: true, completion: nil)
    }
}
