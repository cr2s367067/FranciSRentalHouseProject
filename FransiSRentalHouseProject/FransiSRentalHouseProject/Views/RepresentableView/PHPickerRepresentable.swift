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
//            picker.dismiss(animated: true)
//            if !results.isEmpty {
//                parent.images = []
//                parent.itemProviders = []
//            }
//            parent.itemProviders = results.map(\.itemProvider)
//            loadItems()
            picker.dismiss(animated: true) {
                //Thread is in main thread
                print(Thread.isMainThread)
                //Make sure the contain is not empty
                guard let result = results.first else { return }
                let assetid = result.assetIdentifier
                print(assetid as Any)
                
                let prov = result.itemProvider
                let types = prov.registeredTypeIdentifiers
                print("get type \(types)")
                if prov.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                    self.parent.video = URL(string: "")
                    self.loadMovie(result: result)
                } else {
                    self.parent.images = []
                    self.parent.itemProviders = results.map(\.itemProvider)
                    self.loadImage()
                }
            }
        }
        
        private func loadMovie(result: PHPickerResult){
            let movie = UTType.movie.identifier
            let prov = result.itemProvider
            prov.loadFileRepresentation(forTypeIdentifier: movie) { url, error in
                if let url = url {
                    DispatchQueue.main.async {
                        print("get movie url: \(url.absoluteString)")
                        self.duplicateItem(url: url)
                    }
                }
            }
        }
        
        private func duplicateItem(url: URL) {
            let fileid = UUID().uuidString
            let fileName = "\(fileid).mp4"
            let newURL = URL(fileURLWithPath: NSTemporaryDirectory() + fileName)
            try? FileManager.default.copyItem(at: url, to: newURL)
            print("new url: \(newURL)")
            self.parent.video = newURL
        }
        
        private func dealImage(result: PHPickerResult) {
            let prov = result.itemProvider
            prov.loadObject(ofClass: UIImage.self) { images, error in
                DispatchQueue.main.async {
                    if let image = images as? UIImage {
                        self.parent.images.append(TextingImageDataModel(image: image))
                    }
                }
            }
        }
        
        
        private func loadImage() {
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
