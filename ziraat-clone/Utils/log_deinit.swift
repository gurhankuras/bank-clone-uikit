//
//  logDeinit.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/28/22.
//

import Foundation
import os.log

func log_deinit<T>(_ type: T.Type) {
    os_log("%@ was deinitialized", log: .deinit, type: .debug, String(describing: T.self))
}
