//
//  YoutubeCell.swift
//  Streamini
//
//  Created by ナム Nam Nguyen on 5/10/17.
//  Copyright © 2017 UniProgy s.r.o. All rights reserved.
//

import UIKit

class YoutubeCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var chanel: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var thumbNail: UIImageView!

    var model:YoutubeModel? {
        didSet{
            if model != nil {
                title.text = model?.title
                chanel.text = model?.chanel
                detail.text = model?.detail
                guard let url = model?.thumbnail else { return }
                thumbNail.sd_setImage(with: URL(string: url))
            }
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
    
}
