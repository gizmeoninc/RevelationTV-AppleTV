//
//  Date.swift
//  KICCTV
//
//  Created by GIZMEON on 07/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
extension Date {
    func convertStringTimeToDate(item: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        let date = dateFormatter.date(from:item)!
        return date
    }
}
extension Date {
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

        return localDate
    }
    
}
extension String {
    func convertToUTC(dateToConvert:String) -> String {
         let formatter = DateFormatter()
         formatter.dateFormat = "dd-MM-yyyy hh:mm a"
         let convertedDate = formatter.date(from: dateToConvert)
         formatter.timeZone = TimeZone(identifier: "UTC")
         return formatter.string(from: convertedDate!)
            
        }
}

