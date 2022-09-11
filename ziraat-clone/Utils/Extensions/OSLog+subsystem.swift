//
//  OSLog+subsystem.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 9/11/22.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let flow = OSLog(subsystem: subsystem, category: "flow")
    static let view = OSLog(subsystem: subsystem, category: "view")
    static let `deinit` = OSLog(subsystem: subsystem, category: "deinit")


}
