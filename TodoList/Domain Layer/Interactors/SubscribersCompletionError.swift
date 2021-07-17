//
//  SubscribersCompletionError.swift
//  TodoList
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Combine

extension Subscribers.Completion {
    func checkError() -> Failure? {
        switch self {
        case .failure(let error):
            return error
        case .finished:
            return nil
        }
    }
}
