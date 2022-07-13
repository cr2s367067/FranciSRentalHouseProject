//
//  FurnitureProviderSummitView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/28.
//

import AVKit
import SwiftUI
import AVKit
import PhotosUI

struct ProductsProviderSummitView: View {
    @EnvironmentObject var storageForProductImage: StorageForProductImage
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var productsProviderSummitViewModel: ProductsProviderSummitViewModel
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var searchVM: SearchViewModel
    @Environment(\.colorScheme) var colorScheme

    @FocusState private var isFocused: Bool
    @State private var selectLimit = 5
    
    @State private var getVideo = false

    @State private var getVideo = false

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    init() {
        UITextView.appearance().backgroundColor = .clear
    }

    var body: some View {
        NavigationView {
<<<<<<< HEAD
                VStack(spacing: 5) {
                    ScrollView(.vertical, showsIndicators: false){
                        TitleAndDivider(title: "Ready to Post your products?")
                        //MARK: - Product images
                        StepsTitle(stepsName: "Step1: Upload the product pic.")
=======
            VStack(spacing: 5) {
//                Button("test") {
//                    Task {
//                        do {
//                            try await storageForProductImage.testFetching(
//                                gui: "12312312",
//                                productUID: "BCEFF69C-55CD-47B6-AE2D-68347EB466AE"
//                            )
//                            print("\(storageForProductImage.productImageSet.count)")
//                        } catch {
//                            self.errorHandler.handle(error: error)
//                        }
//                    }
//                }
                ScrollView(.vertical, showsIndicators: false) {
                    TitleAndDivider(title: "Ready to Post your products?")

                    // MARK: - Product images

                    StepsTitle(stepsName: "Step1: Upload the product pic.")
                    Button {
                        productsProviderSummitViewModel.showSheet.toggle()
                    } label: {
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(Color("fieldGray"))
                                .frame(width: uiScreenWidth - 30, height: 304)
                                .cornerRadius(10)
                            Image(systemName: "plus.square")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color.gray)
                            if productsProviderSummitViewModel.isSummitProductPic == true {
                                Image(uiImage: self.productsProviderSummitViewModel.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: uiScreenWidth - 30, height: 304)
                                    .cornerRadius(10)
                            }
                            VStack {
                                HStack {
                                    Spacer()
                                    Text("\(productsProviderSummitViewModel.images.count)")
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(width: 50, height: 30, alignment: .center)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(.black.opacity(0.5))
                                        )
                                }

                                Spacer()
                            }
                            .frame(width: uiScreenWidth - 30, height: 304)
                        }
                        .padding()
                    }
                    .accessibilityIdentifier("phpicker")

                    // MARK: - Product Video

                    HStack {
                        Text("Step2: Upload intro video.")
>>>>>>> PodsAdding
                        Button {
                            productsProviderSummitViewModel.showSheet.toggle()
                        } label: {
                            Image(systemName: getVideo ? "checkmark.square.fill" : "plus.square")
                                .font(.system(size: 25))
                                .foregroundColor(getVideo ? Color.green : Color.white)
                        }
<<<<<<< HEAD
                        .accessibilityIdentifier("phpicker")
                        //MARK: - Product Video
                        HStack {
                            Text("Step2: Upload intro video.")
                            Button {
                                productsProviderSummitViewModel.showSheet.toggle()
                            } label: {
                                Image(systemName: getVideo ? "checkmark.square.fill" : "plus.square")
                                    .font(.system(size: 25))
                                    .foregroundColor(getVideo ? Color.green : Color.white)
                            }
                            Spacer()
                        }
                        .padding()
                        if !(productsProviderSummitViewModel.productVideo?.pathComponents.isEmpty ?? false) {
                            if let url = productsProviderSummitViewModel.productVideo {
                                VStack {
                                    VideoPlayer(player: AVPlayer(url: url))
                                }
                                .frame(width: uiScreenWidth - 30, height: uiScreenHeight / 3, alignment: .center)
                                .padding()
                                .cornerRadius(10)
                            }
                        }
                        //MARK: - Product necessary info
                        StepsTitle(stepsName: "Step3: Please provide the necessary information")
                        VStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text("Product Type")
                                        .modifier(textFormateForProviderSummitView())
                                    Spacer()
                                }
                                HStack {
                                    Spacer()
                                    Section {
                                        Menu {
                                            Picker("", selection: $productsProviderSummitViewModel.productType) {
                                                ForEach(searchVM.groceryTypesArray, id: \.self) {
                                                    Text($0)
                                                }
                                            }
                                        } label: {
                                            HStack {
                                                Text(productsProviderSummitViewModel.productType)
                                                Image(systemName: "chevron.down")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 15))
                                            }
                                            .frame(width: 70 + CGFloat((productsProviderSummitViewModel.productType.count * 8)), height: 40)
                                            .background(alignment: .center) {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(colorScheme == .dark ? .gray.opacity(0.5) : .black.opacity(0.5))
                                            }
                                        }
                                    } header: {
                                        HStack {
                                            Text("Please choose type")
                                            Spacer()
                                        }
                                    }
                                    .accessibilityIdentifier("pickerSection")
                                }
                                .foregroundColor(.white)
=======
                        Spacer()
                    }
                    .padding()
                    if !(productsProviderSummitViewModel.productVideo?.pathComponents.isEmpty ?? false) {
                        if let url = productsProviderSummitViewModel.productVideo {
                            VStack {
                                VideoPlayer(player: AVPlayer(url: url))
>>>>>>> PodsAdding
                            }
                            .frame(width: uiScreenWidth - 30, height: uiScreenHeight / 3, alignment: .center)
                            .padding()
                            .cornerRadius(10)
                        }
                    }

                    // MARK: - Product necessary info

                    StepsTitle(stepsName: "Step3: Please provide the necessary information")
                    VStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text("Product Type")
                                    .modifier(textFormateForProviderSummitView())
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Section {
                                    Menu {
                                        Picker("", selection: $productsProviderSummitViewModel.productInfo.productType) {
                                            ForEach(searchVM.groceryTypesArray, id: \.self) {
                                                Text($0)
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Text(productsProviderSummitViewModel.productInfo.productType)
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                        }
                                        .frame(width: 70 + CGFloat(productsProviderSummitViewModel.productInfo.productType.count * 8), height: 40)
                                        .background(alignment: .center) {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(colorScheme == .dark ? .gray.opacity(0.5) : .black.opacity(0.5))
                                        }
                                    }
                                } header: {
                                    HStack {
                                        Text("Please choose type")
                                        Spacer()
                                    }
                                }
                                .accessibilityIdentifier("pickerSection")
                            }
                            .foregroundColor(.white)
                        }
                        .padding()
                        .frame(width: uiScreenWidth - 30)
                        .background(alignment: .center, content: {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 1)
                        })
                        Group {
                            InfoUnit(title: "Product Name", bindingString: $productsProviderSummitViewModel.productInfo.productName)
                                .accessibilityIdentifier("productName")

                            InfoUnit(title: "Product Price", bindingString: $productsProviderSummitViewModel.productInfo.productPrice)
                                .accessibilityIdentifier("price")
                                .keyboardType(.numberPad)
                            if !productsProviderSummitViewModel.productInfo.productPrice.isEmpty {
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack {
                                        Text("Product Cost Infomation")
                                            .modifier(textFormateForProviderSummitView())
                                        Spacer()
                                    }
                                    costInfo(title: "Service Fee (2%)", contain: productsProviderSummitViewModel.serviceFee)
                                    costInfo(title: "Credit Card Payment Fee (2.75%)", contain: productsProviderSummitViewModel.paymentFee)
                                    Divider()
                                        .foregroundColor(.white)
                                    costInfo(title: "Total Cost", contain: productsProviderSummitViewModel.totalCost)
                                }
                                .padding()
                                .frame(width: uiScreenWidth - 30)
                                .background(alignment: .center, content: {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 1)
                                })
                            }
                            InfoUnit(title: "Product Amount", bindingString: $productsProviderSummitViewModel.productInfo.productAmount)
                                .accessibilityIdentifier("amount")
                                .keyboardType(.numberPad)
                            InfoUnit(title: "Product From", bindingString: $productsProviderSummitViewModel.productInfo.productFrom)
                                .accessibilityIdentifier("from")
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text("Product Description")
                                        .modifier(textFormateForProviderSummitView())
                                    Spacer()
                                }
                                TextEditor(text: $productsProviderSummitViewModel.productInfo.productDescription)
                                    .foregroundStyle(Color.white)
                                    .frame(height: 300, alignment: .center)
                                    .cornerRadius(5)
                                    .background(Color.clear)
                                    .accessibilityIdentifier("productDes")
                            }
                            .padding()
                            .frame(width: uiScreenWidth - 30)
                            .background(alignment: .center, content: {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 1)
                            })
                        }

                        StepsTitle(stepsName: "Step3: Please check out the terms of service.")
                        VStack(alignment: .leading) {
                            Spacer()
                            HStack {
                                Button {
                                    productsProviderSummitViewModel.holderTosAgree.toggle()
                                } label: {
<<<<<<< HEAD
                                    Text("Summit")
                                        .foregroundColor(.white)
                                        .frame(width: 108, height: 35)
                                        .background(Color("buttonBlue"))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .alert("Success", isPresented: $productsProviderSummitViewModel.showSummitAlert, actions: {
                                            Button {
                                                productsProviderSummitViewModel.showSummitAlert = false
                                            } label: {
                                                Text("Cancel")
                                            }
                                            Button {
                                                Task {
                                                    do {
                                                        productsProviderSummitViewModel.showProgressView = true
                                                         try await firestoreForProducts.summitFurniture(uidPath: firebaseAuth.getUID(),
                                                                                                       productImage: storageForProductImage.representedProductImageURL,
                                                                                                       providerName: firestoreToFetchUserinfo.fetchedUserData.displayName,
                                                                                                       productPrice: productsProviderSummitViewModel.productPrice,
                                                                                                       productDescription: productsProviderSummitViewModel.productDescription,
                                                                                                       productUID: firestoreForProducts.productUID,
                                                                                                       productName: productsProviderSummitViewModel.productName,
                                                                                                       productFrom: productsProviderSummitViewModel.productFrom, 
                                                                                                       productAmount: productsProviderSummitViewModel.productAmount,
                                                                                                       isSoldOut: false,
                                                                                                       productType: productsProviderSummitViewModel.productType)
                                                        
                                                        try await storageForProductImage.uploadProductImage(uidPath: firebaseAuth.getUID(), image: productsProviderSummitViewModel.images, productUID: firestoreForProducts.productUID)
                                                        if !(productsProviderSummitViewModel.productVideo?.pathComponents.isEmpty ?? false) {
                                                            if let url = productsProviderSummitViewModel.productVideo {
                                                                try await storageForProductImage.uploadProductVideo(movie: url, uidPath: firebaseAuth.getUID(), productUID: firestoreForProducts.productUID)
                                                            }
                                                        }
                                                        try await storageForProductImage.getFirstImageStringAndUpdate(uidPath: firebaseAuth.getUID(), productUID: firestoreForProducts.productUID)
                                                        _ = try await firestoreForProducts.getUploadintData(uidPath: firebaseAuth.getUID(), productUID: firestoreForProducts.productUID)
                                                        try await firestoreForProducts.postProductOnPublic(data: firestoreForProducts.uploadingHolder, productUID: firestoreForProducts.productUID)
                                                        productsProviderSummitViewModel.resetView()
                                                        productsProviderSummitViewModel.showProgressView = false
                                                    } catch {
                                                        self.errorHandler.handle(error: error)
                                                    }
                                                }
                                                productsProviderSummitViewModel.showSummitAlert = false
                                            } label: {
                                                Text("Okay")
                                            }
                                            .accessibilityIdentifier("okay")
                                        }, message: {
                                            let message = "Product's Information is waiting to summit, if you want to adjust something, please press cancel, else press okay to continue"
                                            Text(message)
                                                .accessibilityIdentifier("alertMessage")
                                        })
=======
                                    Image(systemName: productsProviderSummitViewModel.holderTosAgree ? "checkmark.square.fill" : "square")
                                        .foregroundColor(productsProviderSummitViewModel.holderTosAgree ? .green : .white)
                                        .padding(.trailing, 5)
>>>>>>> PodsAdding
                                }
                                .accessibilityIdentifier("tosAgree")
                                Text("I have read and agree the")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .medium))
                                Text("terms of Service.")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 14, weight: .medium))
                                    .onTapGesture {
                                        productsProviderSummitViewModel.tosSheetShow.toggle()
                                    }
                            }
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Button {
                                do {
                                    try productsProviderSummitViewModel.checker(
                                        productName: productsProviderSummitViewModel.productInfo.productName,
                                        productPrice: productsProviderSummitViewModel.productInfo.productPrice,
                                        productFrom: productsProviderSummitViewModel.productInfo.productFrom,
                                        images: productsProviderSummitViewModel.images,
                                        holderTosAgree: productsProviderSummitViewModel.holderTosAgree,
                                        productAmount: productsProviderSummitViewModel.productInfo.productAmount,
                                        productType: productsProviderSummitViewModel.productInfo.productType
                                    )
                                    productsProviderSummitViewModel.showSummitAlert.toggle()
                                } catch {
                                    self.errorHandler.handle(error: error)
                                }
                            } label: {
                                Text("Summit")
                                    .foregroundColor(.white)
                                    .frame(width: 108, height: 35)
                                    .background(Color("buttonBlue"))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .alert("Success", isPresented: $productsProviderSummitViewModel.showSummitAlert, actions: {
                                        Button {
                                            productsProviderSummitViewModel.showSummitAlert = false
                                        } label: {
                                            Text("Cancel")
                                        }
                                        Button {
                                            Task {
                                                do {
                                                    productsProviderSummitViewModel.showProgressView = true

                                                    // MARK: - Summit product and store in provider side

                                                    try await firestoreForProducts.summitProduct(
                                                        gui: firestoreToFetchUserinfo.fetchedUserData.providerGUI ?? "",
                                                        product: .productPublish(
                                                            defaultWithInput: productsProviderSummitViewModel.productInfo,
                                                            providerUID: firebaseAuth.getUID(),
                                                            productUID: firestoreForProducts.productUID
                                                        )
                                                    )

                                                    // MARK: - Store products image

                                                    try await storageForProductImage.uploadProductImage(
                                                        gui: firestoreToFetchUserinfo.fetchedUserData.providerGUI ?? "",
                                                        image: productsProviderSummitViewModel.images,
                                                        productUID: firestoreForProducts.productUID
                                                    )

                                                    // MARK: - Is provider has video

//                                                    if !(productsProviderSummitViewModel.productVideo?.pathComponents.isEmpty ?? false) {
//                                                        if let url = productsProviderSummitViewModel.productVideo {
//                                                            try await storageForProductImage.uploadProductVideo(movie: url, uidPath: firebaseAuth.getUID(), productUID: firestoreForProducts.productUID)
//                                                        }
//                                                    }

                                                    try await storageForProductImage.getFirstImageStringAndUpdate(
                                                        gui: firestoreToFetchUserinfo.fetchedUserData.providerGUI ?? "",
                                                        productUID: firestoreForProducts.productUID
                                                    )
                                                    
                                                    _ = try await firestoreForProducts.getUploadintData(
                                                        gui: firestoreToFetchUserinfo.fetchedUserData.providerGUI ?? "",
                                                        productUID: firestoreForProducts.productUID
                                                    )
                                                    try await firestoreForProducts.productPublishOnPublic(
                                                        procut: firestoreForProducts.uploadingHolder
                                                    )
                                                    productsProviderSummitViewModel.resetView()
                                                    productsProviderSummitViewModel.showProgressView = false
                                                } catch {
                                                    self.errorHandler.handle(error: error)
                                                }
                                            }
                                            productsProviderSummitViewModel.showSummitAlert = false
                                        } label: {
                                            Text("Okay")
                                        }
                                        .accessibilityIdentifier("okay")
                                    }, message: {
                                        let message = "Product's Information is waiting to summit, if you want to adjust something, please press cancel, else press okay to continue"
                                        Text(message)
                                            .accessibilityIdentifier("alertMessage")
                                    })
                            }
                            .accessibilityIdentifier("summitButton")
                        }
                        .padding([.trailing, .top])
                        .frame(width: 400)
                    }
                    .focused($isFocused)
                }
            }
            .modifier(ViewBackgroundInitModifier())
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isFocused = false
                    }
                }
<<<<<<< HEAD
                .overlay(content: {
                    if firestoreToFetchUserinfo.presentUserId().isEmpty {
                        UnregisterCoverView(isShowUserDetailView: $appViewModel.isShowUserDetailView)
                    }
                    if productsProviderSummitViewModel.showProgressView == true {
                        CustomProgressView()
                    }
                })
                .sheet(isPresented: $productsProviderSummitViewModel.tosSheetShow, content: {
                    TermOfServiceForRentalManager()
                })
                .onAppear(perform: {
                    firestoreForProducts.productUID = firestoreForProducts.productIDGenerator()
                    storageForProductImage.productImageUUID = storageForProductImage.imagUUIDGenerator()
                })
                .sheet(isPresented: $productsProviderSummitViewModel.showSheet) {
                    productsProviderSummitViewModel.isSummitProductPic = true
                    if !(productsProviderSummitViewModel.productVideo?.pathComponents.isEmpty ?? true) {
                        getVideo = true
                    }
                } content: {
                    PHPickerRepresentable(selectLimit: $selectLimit, images: $productsProviderSummitViewModel.images, video: $productsProviderSummitViewModel.productVideo)
=======
            }
            .overlay(content: {
                if firestoreToFetchUserinfo.userIDisEmpty() {
                    UnregisterCoverView(isShowUserDetailView: $appViewModel.isShowUserDetailView)
>>>>>>> PodsAdding
                }
                if productsProviderSummitViewModel.showProgressView == true {
                    CustomProgressView()
                }
            })
            .sheet(isPresented: $productsProviderSummitViewModel.tosSheetShow, content: {
                TermOfServiceForRentalManager()
            })
            .onAppear(perform: {
                firestoreForProducts.productUID = firestoreForProducts.productIDGenerator()
                storageForProductImage.productImageUUID = storageForProductImage.imagUUIDGenerator()
            })
            .sheet(isPresented: $productsProviderSummitViewModel.showSheet) {
                productsProviderSummitViewModel.isSummitProductPic = true
                if !(productsProviderSummitViewModel.productVideo?.pathComponents.isEmpty ?? true) {
                    getVideo = true
                }
            } content: {
                PHPickerRepresentable(selectLimit: $selectLimit, images: $productsProviderSummitViewModel.images, video: $productsProviderSummitViewModel.productVideo)
            }
            .navigationBarHidden(true)
        }
    }
}

extension ProductsProviderSummitView {
    @ViewBuilder
    func costInfo(title: String, contain: Double) -> some View {
        HStack {
            Text(LocalizedStringKey("\(title): "))
            Text("\(contain, specifier: "%.3f")")
            Spacer()
        }
        .foregroundColor(.white)
        .font(.system(size: 15))
    }
}

@available(iOS 16, *)
extension ProductsProviderSummitView {
    @ViewBuilder
    func photoPicker() -> some View {
        let localID = UUID().uuidString
        let photoPickerItem = PhotosPickerItem(itemIdentifier: localID)
//        PhotosPicker(selection: photoPickerItem, matching: .all(of: [.videos, .images])) {
//            Text("PhotoPicker")
//        }
    }
}
