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
    @EnvironmentObject var searchVM: SearchViewModel
    

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
                            productsProviderSummitViewModel.showSheet.toggle()
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
                                if productsProviderSummitViewModel.isSummitProductPic == true {
                                    Image(uiImage: self.productsProviderSummitViewModel.image)
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
                                .keyboardType(.numberPad)
                            if !productsProviderSummitViewModel.productPrice.isEmpty {
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
                            InfoUnit(title: "Product Amount", bindingString: $productsProviderSummitViewModel.productAmount)
                                .keyboardType(.numberPad)
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
                                                    .fill(.gray.opacity(0.6))
                                            }
                                        }
                                    } header: {
                                        HStack {
                                            Text("Please choose type")
                                            Spacer()
                                        }
                                    }
                                }
                                .foregroundColor(.white)
                            }
                            .padding()
                            .frame(width: uiScreenWidth - 30)
                            .background(alignment: .center, content: {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 1)
                            })
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
                                            productsProviderSummitViewModel.tosSheetShow.toggle()
                                        }
                                }
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Button {
                                    do {
                                        try productsProviderSummitViewModel.checker(productName: productsProviderSummitViewModel.productName,
                                                                                productPrice: productsProviderSummitViewModel.productPrice,
                                                                                productFrom: productsProviderSummitViewModel.productFrom,
                                                                                    images: productsProviderSummitViewModel.images,
                                                                                    holderTosAgree: productsProviderSummitViewModel.holderTosAgree,
                                                                                    productAmount: productsProviderSummitViewModel.productAmount, productType: productsProviderSummitViewModel.productType)
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
                                                        try await storageForProductImage.uploadProductImage(uidPath: firebaseAuth.getUID(),
                                                                                                            image: productsProviderSummitViewModel.image,
                                                                                                            productID: firestoreForProducts.productUID,
                                                                                                            imageUID: storageForProductImage.productImageUUID)
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
                                        }, message: {
                                            let message = "Product's Information is waiting to summit, if you want to adjust something, please press cancel, else press okay to continue"
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
            } content: {
                PHPickerRepresentable(images: $productsProviderSummitViewModel.images)
            }
            .navigationBarHidden(true)
        }
    }
}

extension ProductsProviderSummitView {
    @ViewBuilder
    func costInfo(title: String, contain: Double) -> some View {
        HStack {
            Text("\(title): ")
            Text("\(contain, specifier: "%.3f")")
            Spacer()
        }
        .foregroundColor(.white)
        .font(.system(size: 15))
    }
}
