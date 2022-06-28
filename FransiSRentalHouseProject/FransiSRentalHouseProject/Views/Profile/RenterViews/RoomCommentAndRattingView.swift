//
//  RoomCommentAndRattingView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/1.
//

import SwiftUI

struct RoomCommentAndRattingView: View {
    
    enum SectionTitle: String {
        case roomAddress = "Room Address"
        case expDate = "Expired Date"
//        case traffic = "Traffic"
        case con = "Convenience"
        case pricing = "Pricing"
        case neighbor = "Neighbor"
        case comment = "Comment"
    }
    
    
    @EnvironmentObject var roomCARVM: RoomCommentAndRattingViewModel
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    
    @Environment(\.colorScheme) var colorScheme
    
    @FocusState private var isFocus: Bool
    
    var contractInfo: HouseContract
//    var firestoreUserInfo: FirestoreToFetchUserinfo
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var address: String {
        let zipCode = contractInfo.roomZipCode
        let city = contractInfo.roomCity
        let town = contractInfo.roomTown
        let roomAddress = contractInfo.roomAddress
        return zipCode + city + town + roomAddress
    }
    
    var expDate: String {
        return contractInfo.rentalEndDate.formatted(Date.FormatStyle().year().month().day())
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                sectionUnit(title: SectionTitle.roomAddress.rawValue, containt: address)
                sectionUnit(title: SectionTitle.expDate.rawValue, containt: expDate)
                customSection(
                    cusParent: {
                        RoomRattingView(comparing: $roomCARVM.roomCAR.convenienceRate)
                    },
                    title: SectionTitle.con.rawValue
                )
                customSection(
                    cusParent: {
                        RoomRattingView(comparing: $roomCARVM.roomCAR.pricingRate)
                    },
                    title: SectionTitle.pricing.rawValue
                )
                customSection(
                    cusParent: {
                        RoomRattingView(comparing: $roomCARVM.roomCAR.neighborRate)
                    },
                    title: SectionTitle.neighbor.rawValue
                )
                Section {
                    TextEditor(text: $roomCARVM.roomCAR.comment)
                        .foregroundColor(.primary)
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .disabled(firestoreToFetchRoomsData.roomCAR.isPost ? true : false)
                        .onTapGesture {
                            roomCARVM.roomCAR.comment = ""
                        }
                        .focused($isFocus)
                } header: {
                    HStack {
                        Text(SectionTitle.comment.rawValue)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        Task {
                            do {
                                try await firestoreToFetchRoomsData.postRoomCommetAndRatting(
                                    renter: firebaseAuth.getUID(),
                                    room: .postCAR(
                                        roomUID: firestoreToFetchUserinfo.rentedRoom.rentedRoomUID,
                                        providerUID: firestoreToFetchUserinfo.rentedRoom.rentedProvderUID,
                                        user: firestoreToFetchUserinfo.fetchedUserData.nickName,
                                        room: roomCARVM.roomCAR
                                    )
//                                    roomUID: contractInfo.docID,
//                                    comment: roomCARVM.commentText,
//                                    neighborRate: roomCARVM.neighborRate,
//                                    pricingRate: roomCARVM.pricingRate,
//                                    convenienceRate: roomCARVM.convenienceRate,
//                                    userDisplayName: firestoreUserInfo.fetchedUserData.displayName,
//                                    uidPath: firebaseAuth.getUID()
                                    
                                )
                            } catch {
                                self.errorHandler.handle(error: error)
                            }
                        }
                    } label: {
                        Label(firestoreToFetchRoomsData.roomCAR.isPost ? "Thanks" : "Post", systemImage: "paperplane.circle")
                            .foregroundColor(.white)
                    }
                    .modifier(ButtonModifier())
                    .disabled(firestoreToFetchRoomsData.roomCAR.isPost ? true : false)
                }
            }
            .padding()
            .frame(width: uiScreenWidth - 50, height: uiScreenHeight - 180)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .dark ? .gray.opacity(0.4) : .black.opacity(0.4))
            }
        }
        .modifier(ViewBackgroundInitModifier())
        .onTapGesture {
            isFocus = false
        }
        .onAppear {
            let roomCAR = firestoreToFetchRoomsData.roomCAR
            roomCARVM.commentText = roomCAR.comment
//            roomCARVM.trafficRate = roomCAR.trafficRate
            roomCARVM.convenienceRate = roomCAR.convenienceRate
            roomCARVM.pricingRate = roomCAR.pricingRate
            roomCARVM.neighborRate = roomCAR.neighborRate
        }
    }
}

//struct RoomCommentAndRattingView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomCommentAndRattingView()
//    }
//}


extension RoomCommentAndRattingView {
        
    @ViewBuilder
    func sectionUnit(title: String, containt: String) -> some View {
        Section {
            HStack {
                Text(containt)
                    .foregroundColor(.white)
                Spacer()
            }
        } header: {
            HStack {
                Text(LocalizedStringKey(title))
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func customSection(cusParent: () -> RoomRattingView, title: String) -> some View {
        Section {
            HStack {
                cusParent()
                Spacer()
            }
        } header: {
            HStack {
                Text(LocalizedStringKey(title))
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }

}

struct RoomRattingView: View {
    
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    
    @Binding var comparing: Int
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.white
    var onColor = Color.yellow
    
    let ratingArray: [Int] = UserOrderedListViewModel.RatingStars.allCases.map({$0.rawValue})
    
    func image(number: Int) -> Image {
        if number > comparing {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
    
    var body: some View {
        HStack {
            ForEach(ratingArray, id: \.self) { number in
                Button {
                    comparing = number
                    print(comparing)
                } label: {
                    image(number: number)
                        .foregroundColor(number > comparing ? offColor : onColor)
                }
            }
            .disabled(firestoreToFetchRoomsData.roomCAR.isPost ? true : false)
        }
        .background(alignment: .center) {
            Color.clear
        }
    }
}
