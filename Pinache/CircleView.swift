//
//  CircleView.swift
//  Pinache
//
//  Created by admin on 10/10/16.
//  Copyright © 2016 Jett Raines. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
