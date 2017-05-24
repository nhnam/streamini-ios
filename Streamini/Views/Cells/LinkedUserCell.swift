//
//  LinkedUserCellTableViewCell.swift
//  Streamini
//
//  Created by Vasily Evreinov on 07/08/15.
//  Copyright (c) 2015 UniProgy s.r.o. All rights reserved.
//

import UIKit

protocol LinkedUserCellDelegate:class {
    func willStatusChanged(_ cell: UITableViewCell)
}

class LinkedUserCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userStatusButton: SensibleButton!
    weak var delegate: LinkedUserCellDelegate?

    var isStatusOn = false {
        didSet {
            let image: UIImage?
            if isStatusOn {
                image = UIImage(named: "checkmark")
            } else {
                image = UIImage(named: "plus")
            }
            userStatusButton.setImage(image!, for: UIControlState())
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(_ user: User) {
        usernameLabel.text = user.name
        userImageView.contentMode = UIViewContentMode.scaleToFill
        userImageView.sd_setImage(with: user.avatarURL())
     
        userStatusButton.isHidden = UserContainer.shared.logged().id == user.id
        isStatusOn = user.isFollowed
        userStatusButton.addTarget(self, action: #selector(LinkedUserCell.statusButtonPressed(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func updateRecent(_ recent: Stream, isMyStream: Bool = false) {
        userImageView.contentMode = UIViewContentMode.center
        
        if isMyStream {
            self.textLabel!.text = recent.title
        } else {
            usernameLabel.text      = recent.title
            userImageView.image     = UIImage(named: "play")
            userImageView.tintColor = UIColor.navigationBarColor()
            userStatusButton.isHidden = true
        }
    }
    
    func statusButtonPressed(_ sender: AnyObject) {
        if let del = delegate {
            del.willStatusChanged(self)
        }
    }
}
