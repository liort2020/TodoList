//
//  ImageButton.swift
//  TodoList
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct ImageButton: View {
    @Binding var buttonTapped: Bool
    let buttonIcon: String
    let buttonFont: Font
    
    var body: some View {
        Button {
            buttonTapped = true
        } label: {
            Image(systemName: buttonIcon)
                .font(buttonFont)
        }
    }
}

// MARK: - Previews
struct ImageButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // preview plus icon light mode
            ImageButton(buttonTapped: Binding.constant(true),
                        buttonIcon: "plus",
                        buttonFont: .title)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            
            // preview plus icon dark mode
            ImageButton(buttonTapped: Binding.constant(true),
                        buttonIcon: "plus",
                        buttonFont: .title)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            
            // preview cart icon light mode
            ImageButton(buttonTapped: Binding.constant(true),
                        buttonIcon: "cart",
                        buttonFont: .title)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            
            // preview cart icon dark mode
            ImageButton(buttonTapped: Binding.constant(true),
                        buttonIcon: "cart",
                        buttonFont: .title)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
