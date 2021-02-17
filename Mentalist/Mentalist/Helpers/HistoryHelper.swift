//
//  HistoryHelper.swift
//  Mentalist
//
//  Created by Juliette Bois on 16.02.21.
//

import Foundation

class HistoryHelper: NSObject {
    static let instance = HistoryHelper()
    var history: [String] = []
    
    public func received(string: String) {
        HistoryHelper.instance.history.append("Reçu : \(string)")
    }

    public func sent(string: String) {
        HistoryHelper.instance.history.append("Envoyé : \(string)")
    }
    
    public func getHistory() -> [String] {
        return HistoryHelper.instance.history
    }

}
