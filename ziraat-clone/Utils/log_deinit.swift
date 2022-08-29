//
//  logDeinit.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/28/22.
//

import Foundation
import OSLog

func log_deinit<T>(_ type: T.Type) {
    print(String(describing: T.self), "deinit")
    
    //print(String(reflecting: T.self).split(separator: ".").last!, "deinit")
}
