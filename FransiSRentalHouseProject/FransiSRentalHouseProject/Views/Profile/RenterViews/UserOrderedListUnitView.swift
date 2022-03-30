//
//  UserOrderedListUnitView.swift.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/30.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserOrderedListUnitView: View {
    
    @StateObject var userOrderedListViewModel = UserOrderedListUnitView()
    
    
    var body: some View {
//        VStack {
            VStack {
                HStack {
                    //                WebImage(url: URL(string: productImage))
                    Image("furpic2")
                        .resizable()
                        .frame(width: 140, height: 120, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.8), radius: 10)
                    Spacer()
                }
                .padding(.horizontal)
                VStack {
                    ReusableUnit(title: "Product Name", containName: "")
                    ReusableUnit(title: "Product Price", containName: "")
                    ReusableUnit(title: "Product From", containName: "")
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
                        Task {
                            //MARK: Summit comment
                        }
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
//        }
    }
}

//struct UserOrderedListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let userOrderedListViewModel = UserOrderedListViewModel()
//        UserOrderedListView()
//            .environmentObject(userOrderedListViewModel)
//    }
//}


extension UserOrderedListUnitView {
    class UserOrderedListUnitView: ObservableObject {
        
        @Published var comments = ""
        
        let productName: String = ""
        let productImage: String = ""
        let productFrom: String = ""
        let productRating: String = ""
        
        let uiScreenWidth = UIScreen.main.bounds.width
        let uiScreenHeight = UIScreen.main.bounds.height
    }
}
