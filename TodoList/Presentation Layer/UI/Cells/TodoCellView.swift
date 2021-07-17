//
//  TodoCellView.swift
//  TodoList
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct TodoCellView: View {
    @Binding var todo: Todo
    
    var body: some View {
        HStack {
            Text(todo.title ?? defaultEmptyTitle)
            
            Spacer()
        }
        .padding(.vertical, cellPadding)
    }
    
    // MARK: Constants
    private let cellPadding: CGFloat = 10
    private let defaultEmptyTitle = ""
}

// MARK: - Previews
struct TodoCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // preview light mode
            TodoCellView(todo: Binding.constant(FakeTodoItems.all.first!))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            
            // preview dark mode
            TodoCellView(todo: Binding.constant(FakeTodoItems.all.first!))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            
            // preview right to left
            TodoCellView(todo: Binding.constant(FakeTodoItems.all.first!))
                .previewLayout(.sizeThatFits)
                .environment(\.layoutDirection, .rightToLeft)
                .previewDisplayName(#"\.layoutDirection, .rightToLeft"#)
            
            // preview accessibility extra large
            TodoCellView(todo: Binding.constant(FakeTodoItems.all.first!))
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewLayout(.sizeThatFits)
        }
    }
}
