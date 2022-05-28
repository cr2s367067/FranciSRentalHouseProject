//
//  MaintainDetailUnitView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/12.
//

import SwiftUI
import SDWebImageSwiftUI

struct MaintainDetailUnitView: View {
    
    @EnvironmentObject var storageForMaintainImage: StorageForMaintainImage
    @EnvironmentObject var firestoreToFetchMaintainTasks: FirestoreToFetchMaintainTasks
    @EnvironmentObject var errorHandler: ErrorHandler
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var providerUidPath: String
    var docID: String
    var taskHolder: MaintainTaskHolder
    
    
    @State private var showSheet = false
    @State private var newSelectedImage = [UIImage]()
    @State private var newDes = ""
    @State private var newDate = Date()
    @State private var newImageURL = ""
    @State private var isEdit = false
    @State private var isProgressing = false
    @FocusState private var isFocus: Bool
    
    var presentingImage: UIImage {
        var firstHolder = UIImage()
        if let firstImage = newSelectedImage.first {
            firstHolder = firstImage
        }
        return firstHolder
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                isEditImage(isEdit: isEdit)
                VStack(spacing: 15) {
                    HStack {
                        Text("Maintain Description")
                            .foregroundColor(.white)
                            .font(.headline)
                        Spacer()
                    }
                    edittingContain(isEdit: isEdit)
                }
                Spacer()
                HStack(spacing: 20) {
                    Spacer()
                    Button {
                        Task {
                            isEdit.toggle()
                            if isEdit {
                                print("Editting")
                            } else {
                                print("update data")
                                do {
                                    guard let id = taskHolder.id else { return }
                                    print(id)
                                    print(providerUidPath)
                                    print(docID)
                                    isProgressing = true
                                    try await storageForMaintainImage.uploadFixItemImage(uidPath: providerUidPath, image: presentingImage, roomUID: docID)
                                    newImageURL = storageForMaintainImage.itemImageURL
                                    try await firestoreToFetchMaintainTasks.updateMaintainTaskInfo(uidPath: providerUidPath, docID: docID, maintainDocID: id, newTaskDes: newDes, newAppointDate: newDate, newImageURL: newImageURL)
                                    try await firestoreToFetchMaintainTasks.fetchMaintainInfoAsync(uidPath: providerUidPath, docID: docID)
                                    isProgressing = false
                                } catch {
                                    self.errorHandler.handle(error: error)
                                }
                            }
                        }
                    } label: {
                        Text(isEdit ? "Update" : "Edit")
                    }
                    .modifier(ButtonModifier())
                    Button {
                        Task {
                            do {
                                guard let id = taskHolder.id else { return }
                                try await firestoreToFetchMaintainTasks.deleteFixedItem(uidPath: providerUidPath, docID: docID, maintainDocID: id)
                                firestoreToFetchMaintainTasks.showMaintainDetail = false
                            } catch {
                                self.errorHandler.handle(error: error)
                            }
                        }
                    } label: {
                        Text("Cancel")
                    }
                    .modifier(ButtonModifier())
                }
            }
            .modifier(SubViewBackgroundInitModifier())
            Spacer()
        }
        .modifier(ViewBackgroundInitModifier())
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isFocus = false
                }
            }
        }
        .onAppear {
            newImageURL = taskHolder.itemImageURL
            newDes = taskHolder.description
            newDate = taskHolder.appointmentDate
        }
        .sheet(isPresented: $showSheet) {
            PHPickerRepresentable(images: $newSelectedImage)
        }
        .overlay {
            if isProgressing {
                CustomProgressView()
            }
        }
    }
}

extension MaintainDetailUnitView {
    
    @ViewBuilder
    func isEditImage(isEdit: Bool) -> some View {
        if isEdit {
            Button {
                showSheet.toggle()
            } label: {
                ZStack {
                    WebImage(url: URL(string: taskHolder.itemImageURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: uiScreenWidth / 2 + 130, height: uiScreenHeight / 4, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    Image(uiImage: presentingImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: uiScreenWidth / 2 + 130, height: uiScreenHeight / 4, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
        } else {
            ZStack {
                WebImage(url: URL(string: taskHolder.itemImageURL))
                    .resizable()
                    .scaledToFill()
                    .frame(width: uiScreenWidth / 2 + 130, height: uiScreenHeight / 4, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Image(uiImage: presentingImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: uiScreenWidth / 2 + 130, height: uiScreenHeight / 4, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
    
    @ViewBuilder
    func edittingContain(isEdit: Bool) -> some View {
        if isEdit {
            HStack {
                DatePicker("Appointment", selection: $newDate, in: Date()...)
                    .datePickerStyle(CompactDatePickerStyle())
                    .font(.system(size: 18))
                    .applyTextColor(.white)
                Spacer()
            }
            .frame(width: uiScreenWidth - 50, alignment: .center)
            TextEditor(text: $newDes)
                .padding()
                .frame(width: uiScreenWidth - 50, height: 200)
                .focused($isFocus)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .onTapGesture {
                    newDes = ""
                }
        } else {
            HStack {
                DatePicker("Appointment", selection: $newDate, in: Date()...)
                    .datePickerStyle(CompactDatePickerStyle())
                    .font(.system(size: 18))
                    .applyTextColor(.white)
                Spacer()
            }
            .frame(width: uiScreenWidth - 50, alignment: .center)
            .disabled(true)
            HStack {
                Text(taskHolder.description)
                    .foregroundColor(.white)
                    .font(.body)
                Spacer()
            }
        }
    }
}

//struct MaintainDetailUnitView_Previews: PreviewProvider {
//    static var previews: some View {
//        MaintainDetailUnitView()
//    }
//}

struct SubViewBackgroundInitModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: uiScreenWidth - 20, height: uiScreenHeight / 2 + 200, alignment: .center)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .dark ? .gray.opacity(0.3) : .black.opacity(0.4))
            }
    }
}
