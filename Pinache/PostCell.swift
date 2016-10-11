//
//  PostCell.swift
//  Pinache
//
//  Created by admin on 10/10/16.
//  Copyright © 2016 Jett Raines. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post) {
        
        caption.text = post.caption
        
        likesLbl.text = "\(post.likes)"
        
    }
    


    

}
