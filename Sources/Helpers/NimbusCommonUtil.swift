//
//  NimbusCommonUtil.swift
//  NimbusCache
//
//  Created by Vijaysubramani on 26/02/25.
//

import Foundation

public class NimbusCommonUtil {
    public static func getFormattedDateWithTime(dateValue: Date?) -> String {
        guard let dateValue else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFromInputString = dateFormatter.string(from: dateValue)
        return dateFromInputString
    }
}

