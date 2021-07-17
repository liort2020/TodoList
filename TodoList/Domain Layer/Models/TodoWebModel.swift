//
//  TodoWebModel.swift
//  TodoList
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

protocol TodoModel {
    var id: String { get }
    var title: String { get }
}

struct TodoWebModel: Codable, TodoModel, Equatable {
    let id: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
    }
}
