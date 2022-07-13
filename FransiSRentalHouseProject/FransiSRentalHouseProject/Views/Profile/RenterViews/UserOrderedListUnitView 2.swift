//
//  UserOrderedListUnitView.swift.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/30.
//

import SDWebImageSwiftUI
import SwiftUI

struct UserOrderedListUnitView: View {
    @EnvironmentObject var userOrderedListViewModel: UserOrderedListUnitViewModel
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var firebaseAuth: FirebaseAuth

    var productName: String
    var productPrice: String
    var productImage: String
    var docID: String

    var body: some View {
        VStack {
            HStack {
                WebImage(url: URL(string: productImage))
                    .resizable()
                    .frame(width: 140, height: 120, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .black.opacity(0.8), radius: 10)
                Spacer()
            }
            .padding(.horizontal)
            VStack {
                ReusableUnit(title: "Product Name", containName: productName)
                ReusableUnit(title: "Product Price", containName: productPrice)
                VStack {
                    HStack {
                        Text("Give some comment: ")
                        Spacer()
                    }
                    HStack {
                        TextEditor(text: $userOrderedListViewModel.comments)
                            .foregroundColor(.black)
                            .frame(height: userOrderedListViewModel.uiScreenWidth / 5, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal)

                Button {
//                    Task {
//                        //MARK: Summit comment
//                        do {
//                            try await firestoreForProducts.userToSummitProductComment(uidPath: firebaseAuth.getUID(),
//                                                                                      comment: userOrderedListViewModel.comments,
//                                                                                      rating: String(userOrderedListViewModel.rating),
//                                                                                      docID: docID,
//                                                                                      isUploadComment: userOrderedListViewModel.isUploadComment)
//                        } catch {
//                            self.errorHandler.handle(error: error)
//                        }
//                    }
                    print(docID)
                } label: {
                    Text("Post")
                        .foregroundColor(.white)
                        .frame(width: 108, height: 35)
                        .background(Color("buttonBlue"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding()
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(.brown.opacity(0.6))
                .shadow(color: .black.opacity(0.4), radius: 10)
        }
    }
}

class UserOrderedListUnitViewModel: ObservableObject {
    @Published var comments = ""
    @Published var rating = 0
    @Published var isUploadComment = false

    let productName: String = ""
    let productImage: String = ""
    let productFrom: String = ""
    let productRating: String = ""

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
}
