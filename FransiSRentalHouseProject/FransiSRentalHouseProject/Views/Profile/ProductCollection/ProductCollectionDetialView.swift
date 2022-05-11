//
//  ProductCollectionDetialView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/29.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductCollectionDetialView: View {
    
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var productDetailViewModel: ProductDetailViewModel
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(\.colorScheme) var colorScheme
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    @State private var isEdit = false
    @State private var newAmount = ""
    @State private var newDescription = ""
    
    var productData: ProductProviderDataModel
    
    //MARK: Put some visual kit to presenting data, also provider could edit product description
    var body: some View {
        VStack {
            VStack {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack {
                        HStack {
                            WebImage(url: URL(string: productData.productImage))
                                .resizable()
                                .frame(width: 140, height: 120, alignment: .center)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(color: .black.opacity(0.8), radius: 10)
                            Spacer()
                        }

                        ReusableUnit(title: "Product Name", containName: productData.productName)
                        HStack {
                            Text("Product Average Rate: ")
                            Text("\(productDetailViewModel.computeRattingAvg(commentAndRatting: firestoreForProducts.productCommentAndRatting), specifier: "%.1f")")
                            Spacer()
                        }
                        .foregroundColor(.white)
                        ReusableUnit(title: "Product Price", containName: productData.productPrice)
                        ReusableUnit(title: "Product From", containName: productData.productFrom)
                        editAmount(isEdit: isEdit)
                        editDescription(isEdit: isEdit)
                        HStack {
                            Text("Comments And Rate:")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        List {
                            ForEach(firestoreForProducts.productCommentAndRatting) { comment in
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(comment.summitUserDisplayName)
                                    HStack {
                                        Text("Ratting: ")
                                        Text("\(comment.ratting)")
                                        Spacer()
                                    }
                                    Text("Comment: ")
                                    Text(comment.comment)
                                }
                                .font(.body)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: uiScreenWidth - 50, height: uiScreenHeight / 3 + 50)
                    }
                }
            }
            .padding()
            .frame(width: uiScreenWidth - 30)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .dark ? .gray.opacity(0.3) : .black.opacity(0.5))
            }
        }
        .modifier(ViewBackgroundInitModifier())
        .task {
            do {
                guard let id = productData.id else { return }
                try await firestoreForProducts.fetchProductCommentAndRating(providerUidPath: firebaseAuth.getUID(), productID: id)
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
        .onAppear {
            newAmount = productData.productAmount
            newDescription = productData.productDescription
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEdit {
                    Button {
                        if isEdit == true {
                            isEdit = false
                        }
                        Task {
                            do {
                                guard let id = productData.id else { return }
                                try await firestoreForProducts.updateProductAmountAndDesciption(uidPaht: firebaseAuth.getUID(), productID: id, newProductAmount: newAmount, newProductDescription: newDescription)
                                try await firestoreForProducts.fetchStoreProduct(uidPath: firebaseAuth.getUID())
                            } catch {
                                self.errorHandler.handle(error: error)
                            }
                        }
                    } label: {
                        Text("Done")
                    }
                } else {
                    Button {
                        if isEdit == false {
                            isEdit = true
                        }
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }
                }
            }
        }
    }
}


extension ProductCollectionDetialView {
    @ViewBuilder
    func editAmount(isEdit: Bool) -> some View {
        if isEdit {
            VStack {
                HStack {
                    Text("Update Amount: ")
                        .foregroundColor(.white)
                    Spacer()
                }
                HStack {
                    TextField("Amount", text: $newAmount)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .frame(width: uiScreenWidth - 55)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
                    .fill(.white)
            }
        } else {
            ReusableUnit(title: "Product Amount", containName: productData.productAmount)
        }
    }
    
    @ViewBuilder
    func editDescription(isEdit: Bool) -> some View {
        if isEdit {
            VStack {
                HStack {
                    Text("Update Description: ")
                        .foregroundColor(.white)
                        .font(.body)
                    Spacer()
                }
                HStack {
                    TextEditor(text: $newDescription)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .frame(width: uiScreenWidth - 55, height: uiScreenHeight / 5)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
                    .fill(.white)
            }
        } else {
            ReusableUnitWithCommentDescription(title: "Product Description", commentOrDescription: productData.productDescription)
        }
    }
}
