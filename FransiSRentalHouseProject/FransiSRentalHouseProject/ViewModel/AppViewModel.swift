//
//  AppViewModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore


class AppViewModel: ObservableObject {
    
    @EnvironmentObject var localData: LocalData
    
    let fetchFirestore = FetchFirestore()
    let auth = Auth.auth()
    
    @Published var signIn = false
    @Published var signUp = false
    @Published var isSkipIt = false
    @Published var isProvider = false
    @Published var isRenter = false
    @Published var isAgree = false
    @Published var checked = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var alertTitle = ""
    @Published var alertButton = ""
    @Published var tagSelect = "TapHomeButton"
    @Published var isPresent = false
    @Published var userType = ""
    @Published var tempUserType = ""
    
    let selectArray = ["TapHomeButton", "TapPaymentButton", "TapProfileButton", "TapSearchButton", "FixButton"]
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    //    var signInUserType: String {
    //        return persistenceDM.getUsertype()
    //    }
    
    
    func userInfoFormatterChecker(id: String, firstName: String, lastName: String, gender: String, mobileNumber: String) throws {
        if id.count > 10 || id.count < 10 {
            throw UserInformationError.idFormateError
        } else if mobileNumber.count > 10 || mobileNumber.count < 10 {
            throw UserInformationError.mobileNumberFormateError
        } else if gender.isEmpty {
            throw UserInformationError.genderIsNotSelected
        } else if formatterChecker(id: id) == false {
            throw UserInformationError.idFormateError
        } else if id.count == 10 && idChecker(id: id) == false {
            throw UserInformationError.invalidID
        }
    }
    
    private func convertString(input: String) -> String {
        let tempHolder = input
        var replaceString = ""
        input.forEach { char in
            switch char {
            case "A":
                let _replaceString = tempHolder.replacingOccurrences(of: "A", with: "10")
                replaceString = _replaceString
            case "B":
                let _replaceString = tempHolder.replacingOccurrences(of: "B", with: "11")
                replaceString = _replaceString
            case "C":
                let _replaceString = tempHolder.replacingOccurrences(of: "C", with: "12")
                replaceString = _replaceString
            case "D":
                let _replaceString = tempHolder.replacingOccurrences(of: "D", with: "13")
                replaceString = _replaceString
            case "E":
                let _replaceString = tempHolder.replacingOccurrences(of: "E", with: "14")
                replaceString = _replaceString
            case "F":
                let _replaceString = tempHolder.replacingOccurrences(of: "F", with: "15")
                replaceString = _replaceString
            case "G":
                let _replaceString = tempHolder.replacingOccurrences(of: "G", with: "16")
                replaceString = _replaceString
            case "H":
                let _replaceString = tempHolder.replacingOccurrences(of: "H", with: "17")
                replaceString = _replaceString
            case "I":
                let _replaceString = tempHolder.replacingOccurrences(of: "I", with: "34")
                replaceString = _replaceString
            case "J":
                let _replaceString = tempHolder.replacingOccurrences(of: "J", with: "18")
                replaceString = _replaceString
            case "K":
                let _replaceString = tempHolder.replacingOccurrences(of: "K", with: "19")
                replaceString = _replaceString
            case "L":
                let _replaceString = tempHolder.replacingOccurrences(of: "L", with: "20")
                replaceString = _replaceString
            case "M":
                let _replaceString = tempHolder.replacingOccurrences(of: "M", with: "21")
                replaceString = _replaceString
            case "N":
                let _replaceString = tempHolder.replacingOccurrences(of: "N", with: "22")
                replaceString = _replaceString
            case "O":
                let _replaceString = tempHolder.replacingOccurrences(of: "O", with: "35")
                replaceString = _replaceString
            case "P":
                let _replaceString = tempHolder.replacingOccurrences(of: "P", with: "23")
                replaceString = _replaceString
            case "Q":
                let _replaceString = tempHolder.replacingOccurrences(of: "Q", with: "24")
                replaceString = _replaceString
            case "R":
                let _replaceString = tempHolder.replacingOccurrences(of: "R", with: "25")
                replaceString = _replaceString
            case "S":
                let _replaceString = tempHolder.replacingOccurrences(of: "S", with: "26")
                replaceString = _replaceString
            case "T":
                let _replaceString = tempHolder.replacingOccurrences(of: "T", with: "27")
                replaceString = _replaceString
            case "U":
                let _replaceString = tempHolder.replacingOccurrences(of: "U", with: "28")
                replaceString = _replaceString
            case "V":
                let _replaceString = tempHolder.replacingOccurrences(of: "V", with: "29")
                replaceString = _replaceString
            case "X":
                let _replaceString = tempHolder.replacingOccurrences(of: "X", with: "30")
                replaceString = _replaceString
            case "Y":
                let _replaceString = tempHolder.replacingOccurrences(of: "Y", with: "31")
                replaceString = _replaceString
            default:
                break
            }
        }
        return replaceString
    }
    private func sumupCompute(adjustId: String, fixArray: [Int]) -> Int {
        var sumNum = 0
        let tempArray = zip(adjustId, fixArray).map {
            Int($0.description)! * $1
        }
        tempArray.forEach { data in
            sumNum += data
        }
        return sumNum
    }
    
    func idChecker(id: String) -> Bool {
        lazy var idenNum = id[id.index(id.startIndex, offsetBy: 9)]
        let fixIndex = [1, 9, 8, 7, 6, 5, 4, 3, 2, 1]
        var stringHolder = convertString(input: id)
        stringHolder.removeLast()
        let sumupResult = sumupCompute(adjustId: stringHolder, fixArray: fixIndex)
        let remider = sumupResult % 10
        let outputNum = 10 - remider
        if String(idenNum) == String(outputNum) {
            return true
        } else {
            return false
        }
    }
    
    func formatterChecker(id: String) -> Bool {
        var isCorrect = false
        if id[id.startIndex] == "A" || id[id.startIndex] == "B" || id[id.startIndex] == "C" || id[id.startIndex] == "D" || id[id.startIndex] == "E" || id[id.startIndex] == "F" || id[id.startIndex] == "G" || id[id.startIndex] == "H" || id[id.startIndex] == "I" || id[id.startIndex] == "J" || id[id.startIndex] == "K" || id[id.startIndex] == "L" || id[id.startIndex] == "M" || id[id.startIndex] == "N" || id[id.startIndex] == "O" || id[id.startIndex] == "P" || id[id.startIndex] == "Q" || id[id.startIndex] == "R" || id[id.startIndex] == "S" || id[id.startIndex] == "T" || id[id.startIndex] == "U" || id[id.startIndex] == "V" || id[id.startIndex] == "X" || id[id.startIndex] == "Y" {
            isCorrect = true
        }
        return isCorrect
    }
    
    func passwordCheckAndSignUp(email: String, password: String, confirmPassword: String) throws {
        if email.isEmpty {
            throw SignUpError.emailIsEmpty
        } else if password.isEmpty {
            throw SignUpError.passwordIsEmpty
        } else if confirmPassword.isEmpty {
            throw SignUpError.confirmPasswordIsEmpty
        } else if password.count < 6 {
            throw SignUpError.passwordIstooShort
        } else if isProvider != true, isRenter != true {
            throw SignUpError.missingUserType
        } else if isAgree != true {
            throw SignUpError.termofServiceIsNotAgree
        } else if password != confirmPassword {
            throw SignUpError.passwordAndConfirmIsNotMatch
        }
        signUp(email: email, password: password)
    }
    
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                self?.alertTitle = "Error"
                self?.alertButton = "Ok"
                if let x = error {
                    let err = x as NSError
                    switch err.code {
                    case AuthErrorCode.wrongPassword.rawValue:
                        self?.showAlert = true
                        self?.alertMessage = err.localizedDescription
                    case AuthErrorCode.invalidEmail.rawValue:
                        self?.showAlert = true
                        self?.alertMessage = err.localizedDescription
                    case AuthErrorCode.userNotFound.rawValue:
                        self?.showAlert = true
                        self?.alertMessage = err.localizedDescription
                    default:
                        self?.showAlert = true
                        self?.alertMessage = err.localizedDescription
                    }
                }
                return
            }
            DispatchQueue.main.async {
                self?.signIn = true
                
            }
        }
    }
    
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.signUp = true
            }
        }
    }
    
    
    func signWithAnonymous() {
        auth.signInAnonymously { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            //            guard let user = result?.user else {
            //                return
            //            }
            //            let isAnonymous = user.isAnonymous
            //            let uid = user.uid
            DispatchQueue.main.async {
                self?.isSkipIt = true
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
        } catch let error as NSError {
            print(error.description)
        }
        DispatchQueue.main.async {
            self.signIn = false
            if self.isSkipIt == true {
                self.isSkipIt = false
            }
        }
    }
    
    func resetPassword(email: String) {
        auth.sendPasswordReset(withEmail: email) { [self] error in
            guard error == nil else {
                self.alertTitle = "Error"
                self.alertButton = "Ok"
                if let x = error {
                    let err = x as NSError
                    switch err.code {
                    case AuthErrorCode.invalidMessagePayload.rawValue:
                        self.showAlert = true
                        self.alertMessage = err.localizedDescription
                    default:
                        self.showAlert = true
                        self.alertMessage = err.localizedDescription
                    }
                }
                return
            }
        }
    }
    
    func getSafeAreaTop() -> CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        return keyWindow?.safeAreaInsets.top ?? 0
    }
    
    func getSafeAreaBottom() -> CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        return keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    
    func updateNavigationBarColor() {
        UINavigationBar.appearance().barTintColor = UIColor(named: "backgroundBrown")
        UINavigationBar.appearance().backgroundColor = UIColor(named: "backgroundBrown")
    }
    
    
    
}


//struct customSearchTextField
struct customTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 370, height: 50)
            .foregroundColor(.gray)
            .background(Color("fieldGray").opacity(0.07))
            .cornerRadius(10)
            .padding(.top, 10)
    }
}




extension View {
    func placeholer<Content: View>(when showText: Bool, alignment: Alignment = .leading, @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(showText ? 1 : 0)
            self
        }
    }
    
    func userInfoTextfieldPlaceholder<Content: View> (when showText: Bool, alignment: Alignment = .leading, @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder()
            self
        }
    }
    
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func withErrorHandling() -> some View {
        modifier(HandleErrorByShowingAlertViewModifier())
    }
}


struct TabBarButton: View {
    
    @Binding var tagSelect: String
    var buttonImage = ""
    
    var body: some View {
        Button {
            tagSelect = buttonImage
        } label: {
            Image(buttonImage)
        }
    }
}


struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct TitleAndDivider: View {
    
    @State var title: String = ""
    
    var body: some View {
        VStack(spacing: 1) {
            HStack {
                Text(title)
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundColor(.white)
                Spacer()
            }
            HStack {
                VStack {
                    Divider()
                        .background(Color.white)
                        .frame(width: 400, height: 10)
                        .offset(x: -10)
                }
            }
        }
        .padding(.leading)
    }
}

struct SummaryItems: View {
    
    @EnvironmentObject var localData: LocalData
    
    var checkOutItem = "No Data"
    var checkOutPrice = "0"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(localData.summaryItemHolder) { data in
                    HStack {
                        Button {
                            localData.summaryItemHolder.removeAll(where: {$0.itemName == data.itemName})
                            localData.sumPrice = localData.compute(source: localData.summaryItemHolder)
                        } label: {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .frame(width: 22, height: 22)
                        }
                        Text(data.itemName)
                        Spacer()
                        Text("$\(data.itemPrice)")
                    }
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
        }
        .foregroundColor(.white)
        .font(.system(size: 16, weight: .regular))
    }
}

struct AppDivider: View {
    var body: some View {
        HStack {
            VStack {
                Divider()
                    .background(Color.white)
                    .frame(width: 400, height: 10)
                    .offset(x: -10)
            }
        }
        .padding(.leading)
    }
}


struct HandleErrorByShowingAlertViewModifier: ViewModifier {
    @StateObject var errorHandler = ErrorHandler()
    
    func body(content: Content) -> some View {
        content
            .environmentObject(errorHandler)
            .background(
                EmptyView()
                    .alert(item: $errorHandler.currentAlert, content: { currentAlert in
                        Alert(title: Text("Error"), message: Text(currentAlert.message), dismissButton: .default(Text("OK")){
                            currentAlert.dismissAction?()
                        })
                    })
            )
    }
    
}


struct InfoUnit: View {
    
    @State var title: String
    @Binding var bindingString: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .semibold))
            TextField("", text: $bindingString)
                .frame(height: 30)
                .background(Color("fieldGray"))
                .cornerRadius(5)
        }
    }
}


//extension DispatchQueue {
//    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (()->Void)? = nil) {
//        DispatchQueue.global(qos: .background).async {
//            background?()
//            if let completion = completion {
//                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
//                    completion()
//                })
//            }
//        }
//    }
//}
