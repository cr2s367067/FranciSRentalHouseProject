//
//  PHPickerRepresentable.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/5.
//

import SwiftUI
import PhotosUI

struct PHPickerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = PHPickerViewController
    
    @Binding var images: [UIImage]
//    @Binding var isPresented: Bool
    var itemProviders = [NSItemProvider]()
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .automatic
        
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    final class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
        
        var parent: PHPickerRepresentable
        
        init(parent: PHPickerRepresentable) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            if !results.isEmpty {
                parent.images = []
                parent.itemProviders = []
            }
            parent.itemProviders = results.map(\.itemProvider)
            loadImages()
//            parent.isPresented = false
        }
        
        private func loadImages() {
            for itemProvider in parent.itemProviders {
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        DispatchQueue.main.async {                        
                            if let image = image as? UIImage {
                                self.parent.images.append(image)
                            } else {
                                print("Could not load image", error?.localizedDescription ?? "")
                            }
                        }
                    }
                }
            }
        }
    }
   
    
    
}
