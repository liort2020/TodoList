//
//  TextFieldAlert.swift
//  TodoList
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct TextFieldAlert {
    let title: String
    let placeholder: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String
    var handleAction: (String?) -> Void
}

struct TextFieldAlertWrapper<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let content: Content
    let alert: TextFieldAlert
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldAlertWrapper>) -> UIHostingController<Content> {
        UIHostingController(rootView: content)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: UIViewControllerRepresentableContext<TextFieldAlertWrapper>) {
        uiViewController.rootView = content
        let presentedView = uiViewController.presentedViewController
        
        if isPresented && presentedView == nil {
            var alert = self.alert
            alert.handleAction = {
                self.isPresented = false
                self.alert.handleAction($0)
            }
            context.coordinator.alertController = UIAlertController(alert: alert)
            if let alertController = context.coordinator.alertController {
                uiViewController.present(alertController, animated: true)
            }
        } else if !isPresented && presentedView == context.coordinator.alertController {
            uiViewController.dismiss(animated: true)
        }
    }
    
    class Coordinator {
        var alertController: UIAlertController?
    }
}

extension UIAlertController {
    convenience init(alert: TextFieldAlert) {
        self.init(title: alert.title, message: nil, preferredStyle: .alert)
        addTextField { configurationTextField in
            configurationTextField.placeholder = alert.placeholder
        }
        addAction(UIAlertAction(title: alert.secondaryButtonTitle, style: .cancel) { _ in
            alert.handleAction(nil)
        })
        addAction(UIAlertAction(title: alert.primaryButtonTitle, style: .default) { _ in
            alert.handleAction(self.textFields?.first?.text)
        })
    }
}

extension View {
    func alert(isPresented: Binding<Bool>, _ alert: TextFieldAlert) -> some View {
        TextFieldAlertWrapper(isPresented: isPresented, content: self, alert: alert)
    }
}
