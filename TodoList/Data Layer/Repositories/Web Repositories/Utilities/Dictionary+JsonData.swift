//
//  Dictionary+JsonData.swift
//  TodoList
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

extension Dictionary {
    func retriveData() throws -> Data {
        try JSONSerialization.data(withJSONObject: self)
    }
}
