//
//  UIUtils.swift
//  Relayboard Mobile Client
//
//  Created by user on 14.01.2018.
//  Copyright © 2018 Andrey. All rights reserved.
//

import UIKit

class UIUtils: NSObject {
    static func findControlByTag(controls: [UIControl], tag: Int) -> UIControl? {
        for control in controls {
            if control.tag == tag {
                return control
            }
        }
        return nil
    }
}
