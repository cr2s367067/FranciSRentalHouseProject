//
//  CommentAndRattingView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/26.
//

import SwiftUI

struct CommentAndRattingView: View {
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    var body: some View {
        VStack {
            ifemptyPlaceHolder()
        }
        .modifier(ViewBackgroundInitModifier())
    }
}

extension CommentAndRattingView {
    @ViewBuilder
    func ifemptyPlaceHolder() -> some View {
        if firestoreForProducts.productCommentAndRatting.isEmpty {
            Text("Hey, we need your suggestion🤓")
                .foregroundColor(.white)
                .font(.system(size: 20))
        } else {
            ScrollView(.vertical, showsIndicators: true) {
                ForEach(firestoreForProducts.productCommentAndRatting) { comment in
                    commentRattingUnit(commentAndRatting: comment)
                }
            }
        }
    }

    @ViewBuilder
    func commentRattingUnit(commentAndRatting: ProductCommentRatting) -> some View {
        VStack(alignment: .center) {
            HStack {
                Text(commentAndRatting.customerDisplayName)
                    .foregroundColor(.white)
                Spacer()
            }
            HStack {
                Text("Rating:")
                Text("\(commentAndRatting.ratting)")
                Spacer()
            }
            .foregroundColor(.white)
            HStack {
                Text("Comment:")
                Spacer()
            }
            .foregroundColor(.white)
            HStack {
                Text(commentAndRatting.comment)
                Spacer()
            }
            .foregroundColor(.white)
            Spacer()
        }
        .padding()
        .frame(width: uiScreenWidth - 30, height: uiScreenHeight / 4 - 50)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .stroke(lineWidth: 3)
                .fill(.white)
        }
    }
}

// struct CommentAndRattingView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentAndRattingView()
//    }
// }
