//
//  roundedButton.swift
//  PaintMe
//
//  Created by Lalit on 2016-04-01.
//  Copyright © 2016 Bagga. All rights reserved.
//

import UIKit

class roundedButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = 25
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 3
    }
}
