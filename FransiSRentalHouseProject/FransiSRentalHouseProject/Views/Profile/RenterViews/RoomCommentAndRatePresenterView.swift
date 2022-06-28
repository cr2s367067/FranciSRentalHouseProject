//
//  RoomCommentAndRatePresenterView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/2.
//

import SDWebImageSwiftUI
import SwiftUI

struct RoomCommentAndRatePresenterView: View {
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var roomCARVM: RoomCommentAndRattingViewModel
    @Environment(\.colorScheme) var colorScheme

//    var commentAndRatting: RoomCommentRatting
    var roomsData: RoomDM
    var carTitle = RoomCommentAndRattingView.SectionTitle.self
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    var address: String {
        let city = roomsData.city
        let town = roomsData.town
        let roomAddress = roomsData.address
        return city + town + roomAddress
    }

    var roomImage: String {
        return roomsData.roomsCoverImageURL
    }

    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                viewHeader()
                ForEach(firestoreToFetchRoomsData.roomCARDataSet) { comment in
                    comAndRatePresentUnit(displayName: comment.userDisplayName,
                                          postDate: comment.postTimestamp?.dateValue() ?? Date(),
                                          conRate: $roomCARVM.convenienceRate,
                                          pricRate: $roomCARVM.pricingRate,
                                          neiRate: $roomCARVM.neighborRate,
                                          comments: comment.comment)
                        .onAppear {
//                        roomCARVM.trafficRate = comment.trafficRate
                            roomCARVM.convenienceRate = comment.convenienceRate
                            roomCARVM.neighborRate = comment.neighborRate
                            roomCARVM.pricingRate = comment.pricingRate
                        }
                }
            }
        }
        .modifier(ViewBackgroundInitModifier())
    }
}

// struct RoomCommentAndRatePresenterView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomCommentAndRatePresenterView()
//    }
// }

extension RoomCommentAndRatePresenterView {
    func rattingCompute(input: [RoomCommentRatting]) -> Double {
        guard input.count != 0 else { return 1 }
        var result: Double = 0
        for input in input {
            let con = input.convenienceRate
            let pri = input.pricingRate
            let nei = input.neighborRate
            let subtotal = Double(con + pri + nei) / 3
            result += subtotal
        }
        return result / Double(input.count)
    }

    @ViewBuilder
    func comAndRatePresentUnit(displayName: String, postDate: Date, conRate: Binding<Int>, pricRate: Binding<Int>, neiRate: Binding<Int>, comments: String) -> some View {
        VStack(spacing: 10) {
            HStack {
                Text(displayName)
                    .foregroundColor(.white)
                    .font(.title3)
                Spacer()
                Text(postDate, format: Date.FormatStyle().year().month().day())
                    .foregroundColor(.white)
                    .font(.caption)
            }
//            cusSectionUnit(cusPar: {
//                RoomRattingView(comparing: traRate)
//            }, cusHeader: .traffic)
            cusSectionUnit(cusPar: {
                RoomRattingView(comparing: conRate)
            }, cusHeader: .con)
            cusSectionUnit(cusPar: {
                RoomRattingView(comparing: pricRate)
            }, cusHeader: .pricing)
            cusSectionUnit(cusPar: {
                RoomRattingView(comparing: neiRate)
            }, cusHeader: .neighbor)
            cusComSection(comments: comments, cusHeader: .comment)
            Spacer()
        }
        .padding()
        .frame(width: uiScreenWidth - 30, height: uiScreenHeight / 2)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? .gray.opacity(0.5) : .black.opacity(0.4))
        }
    }

    @ViewBuilder
    func cusComSection(comments: String, cusHeader: RoomCommentAndRattingView.SectionTitle = .con) -> some View {
        Section {
            HStack {
                Text(comments)
                    .foregroundColor(.white)
                    .font(.body)
                Spacer()
            }
        } header: {
            HStack {
                Text(cusHeader.rawValue)
                    .foregroundColor(.white)
                    .font(.headline)
                Spacer()
            }
        }
        .disabled(true)
    }

    @ViewBuilder
    func cusSectionUnit(cusPar: (() -> RoomRattingView)? = nil, cusHeader: RoomCommentAndRattingView.SectionTitle = .con) -> some View {
        Section {
            HStack {
                cusPar?()
                Spacer()
            }
        } header: {
            HStack {
                Text(cusHeader.rawValue)
                    .foregroundColor(.white)
                    .font(.headline)
                Spacer()
            }
        }
        .disabled(true)
    }

    @ViewBuilder
    func viewHeader() -> some View {
        VStack {
            HStack {
                Spacer()
                Group {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(rattingCompute(input: firestoreToFetchRoomsData.roomCARDataSet), specifier: "%.1f")")
                            .foregroundColor(.black)
                            .font(.system(size: 15, weight: .bold))
                    }
                    .padding()
                    .frame(width: 90, height: 30, alignment: .center)
                    .background(alignment: .trailing) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.4), radius: 5)
                    }
                }
            }
            Spacer()
            Section {
                HStack {
                    Text(address)
                        .foregroundColor(.white)
                    Spacer()
                }
            } header: {
                HStack {
                    Text("Room Address")
                        .foregroundColor(.white)
                    Spacer()
                }
            }
        }
        .padding()
        .frame(width: uiScreenWidth - 30, height: uiScreenHeight / 5 + 10)
        .background(alignment: .center) {
            WebImage(url: URL(string: roomImage))
                .resizable()
                .scaledToFill()
                .frame(width: uiScreenWidth - 30, height: uiScreenHeight / 5 + 10)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            RoundedRectangle(cornerRadius: 20)
                .fill(.black.opacity(0.3))
        }
    }
}
