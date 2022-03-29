//
//  FurnitureProviderSummitView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/28.
//

import SwiftUI

struct ProductsProviderSummitView: View {

    @EnvironmentObject var storageForProductImage: StorageForProductImage
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var appViewModel: AppViewModel
//    @EnvironmentObject var storageForRoomsImage: StorageForRoomsImage
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var productsProviderSummitViewModel: ProductsProviderSummitViewModel
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    
    
    @State var image = UIImage()
    @State private var showSheet = false
    @State private var tosSheetShow = false
    @State private var isSummitProductPic = false
    @State private var showSummitAlert = false
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                    .edgesIgnoringSafeArea([.top, .bottom])
                VStack(spacing: 5) {
                    ScrollView(.vertical, showsIndicators: false){
                        TitleAndDivider(title: "Ready to Post your products?")
                        StepsTitle(stepsName: "Step1: Upload the room pic.")
                        Button {
                            showSheet.toggle()
                        } label: {
                            ZStack(alignment: .center) {
                                Rectangle()
                                    .fill(Color("fieldGray"))
                                    .frame(width: 378, height: 304)
                                    .cornerRadius(10)
                                Image(systemName: "plus.square")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.gray)
                                if isSummitProductPic == true {
                                    Image(uiImage: self.image)
                                        .resizable()
                                        .frame(width: 378, height: 304)
                                        .cornerRadius(10)
                                        .scaledToFit()
                                }
                            }
                        }
                        StepsTitle(stepsName: "Step2: Please provide the necessary information")
                        VStack(spacing: 10) {
                            InfoUnit(title: "Product Name", bindingString: $productsProviderSummitViewModel.productName)
                            InfoUnit(title: "Product From", bindingString: $productsProviderSummitViewModel.productFrom)
                            InfoUnit(title: "Prodduct Price", bindingString: $productsProviderSummitViewModel.productPrice)
                            InfoUnit(title: "Product Amount", bindingString: $productsProviderSummitViewModel.productAmount)
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text("Product Description")
                                        .modifier(textFormateForProviderSummitView())
                                    Spacer()
                                }
                                TextEditor(text: $productsProviderSummitViewModel.productDescription)
                                    .foregroundStyle(Color.white)
                                    .frame(height: 300, alignment: .center)
                                    .cornerRadius(5)
                                    .background(Color.clear)
                            }
                            .padding()
                            .frame(width: uiScreenWidth - 30)
                            .background(alignment: .center, content: {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 1)
                            })
                            StepsTitle(stepsName: "Step3: Please check out the terms of service.")
                            VStack(alignment: .leading) {
                                Spacer()
                                HStack {
                                    Button {
                                        productsProviderSummitViewModel.holderTosAgree.toggle()
                                    } label: {
                                        Image(systemName: productsProviderSummitViewModel.holderTosAgree ? "checkmark.square.fill" : "checkmark.square")
                                            .foregroundColor(productsProviderSummitViewModel.holderTosAgree ? .green : .white)
                                            .padding(.trailing, 5)
                                    }
                                    Text("I have read and agree the")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .medium))
                                    Text("terms of Service.")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 14, weight: .medium))
                                        .onTapGesture {
                                            tosSheetShow.toggle()
                                        }
                                }
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Button {
                                    Task {
                                        do {
                                            try await firestoreForProducts.summitFurniture(uidPath: firebaseAuth.getUID(), productImage: storageForProductImage.representedProductImageURL, providerName: firestoreToFetchUserinfo.fetchedUserData.displayName, productPrice: productsProviderSummitViewModel.productPrice, productDescription: productsProviderSummitViewModel.productDescription, productUID: firestoreForProducts.productUID, productName: productsProviderSummitViewModel.productName, productFrom: productsProviderSummitViewModel.productFrom, productAmount: productsProviderSummitViewModel.productAmount, isSoldOut: false)
                                            productsProviderSummitViewModel.resetView()
                                        } catch {
                                            self.errorHandler.handle(error: error)
                                        }
                                    }
                                } label: {
                                    Text("Summit")
                                        .foregroundColor(.white)
                                        .frame(width: 108, height: 35)
                                        .background(Color("buttonBlue"))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .alert("Success", isPresented: $showSummitAlert, actions: {
                                            Button {
//                                                resetView()
                                                showSummitAlert = false
                                            } label: {
                                                Text("Okay")
                                                    .foregroundColor(.white)
                                                    .frame(width: 108, height: 35)
                                                    .background(Color("buttonBlue"))
                                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                            }
                                        }, message: {
                                            let message = "Successfuly upload room's information to database, let's try the other if need."
                                            Text(message)
                                        })
                                }
                            }
                            .padding([.trailing, .top])
                            .frame(width: 400)
                        }
                    }
                }
            }
            .overlay(content: {
                if firestoreToFetchUserinfo.presentUserId().isEmpty {
                    UnregisterCoverView(isShowUserDetailView: $appViewModel.isShowUserDetailView)
                }
            })
            .sheet(isPresented: $tosSheetShow, content: {
                TermOfServiceForRentalManager()
            })
            .onAppear(perform: {
                firestoreForProducts.productUID = firestoreForProducts.productIDGenerator()
                storageForProductImage.productImageUUID = storageForProductImage.imagUUIDGenerator()
            })
            .sheet(isPresented: $showSheet) {
                Task {
                    try await storageForProductImage.uploadProductImage(uidPath: firebaseAuth.getUID(), image: image, productID: firestoreForProducts.productUID, imageUID: storageForProductImage.productImageUUID)
                    DispatchQueue.main.async {
                        isSummitProductPic = true
                    }
                }
            } content: {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
            .navigationBarHidden(true)
        }
    }
}
struct FurnitureProviderSummitView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsProviderSummitView()
    }
}
