//
//  ScanButtonView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/13.
//

import Foundation
import SwiftUI

struct ScanButton: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> some UIView {
        let textFromCamera = UIAction.captureTextFromCamera(responder: context.coordinator,
                                                            identifier: nil)
        let button = UIButton(primaryAction: textFromCamera)
        return button
    }

    func updateUIView(_: UIViewType, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: UIResponder, UIKeyInput {
        let parent: ScanButton

        init(parent: ScanButton) {
            self.parent = parent
        }

        var hasText: Bool = false
        func insertText(_ text: String) {
            parent.text = text
        }

        func deleteBackward() {}
    }
}
