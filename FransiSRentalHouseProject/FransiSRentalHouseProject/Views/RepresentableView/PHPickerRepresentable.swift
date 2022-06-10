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
    
    @Binding var selectLimit: Int
    @Binding var images: [TextingImageDataModel]
    @Binding var video: URL?
    var itemProviders = [NSItemProvider]()
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = selectLimit
        configuration.filter = .any(of: [.images, .videos])
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
            loadItems()
        }
        
        private func loadItems() {
            for itemProvider in parent.itemProviders {
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        print("Is image: \(String(describing: image?.description))")
                        DispatchQueue.main.async {                        
                            if let image = image as? UIImage {
                                self.parent.images.append(TextingImageDataModel(image: image))
                            } else {
                                print("Could not load image", error?.localizedDescription ?? "")
                            }
                        }
                    }
                } else {
                    itemProvider.loadItem(forTypeIdentifier: UTType.movie.identifier) { videoURL, error in
                        DispatchQueue.main.async {                        
                            guard let videoURL = videoURL as? URL else { return }
                            print("video result:  \(videoURL)")
                            self.parent.video = videoURL
                        }
                    }
                }
            }
        }
    }
   
    
    
}

extension Binding {
    static func ??(lhs: Binding<Optional<Value>>, rhs: Value) -> Binding<Value> {
        return Binding {
            lhs.wrappedValue ?? rhs
        } set: {
            lhs.wrappedValue = $0
        }
    }
}
