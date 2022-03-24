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
    
    //    let fetchFirestore = FetchFirestore()
    //    let auth = Auth.auth()
    
    @Published var paymentSummaryTosAgree = false
    @Published var paymentSummaryAutoPayAgree = false
    
    @Published var rentalPolicyisAgree = false
    
    @Published var isRedacted = true
    
    @Published var isShowUserDetailView = false
    
    @Published var isProvider = false
    @Published var isHoseOwner = false
    @Published var isRentalM = false
    @Published var isRenter = false
    @Published var isAgree = false
    @Published var checked = false
    @Published var showAlert = false
    
    @Published var tagSelect = "TapHomeButton"
    @Published var isPresent = false
    @Published var userType = ""
    @Published var tempUserType = ""
    @Published var userDetailForSignUp = false
    @Published var emailAddress = ""
    @Published var userPassword = ""
    @Published var recheckPassword = ""
    
    
    //:~ Sign up view fields
    @Published var id = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var displayName = "Unknown"
    @Published var mobileNumber = ""
    @Published var dob = Date()
    @Published var address = ""
    @Published var town = ""
    @Published var city = ""
    @Published var zipCode = ""
    @Published var country = "Taiwan"
    @Published var gender = ""
    @Published var providerType = ""
    @Published var rentalManagerLicenseNumber = ""
    
    //:~Provider summit fields (RentalManager)
    @Published var holderName = ""
    @Published var holderMobileNumber = ""
    @Published var roomAddress = ""
    @Published var roomTown = ""
    @Published var roomCity = ""
    @Published var roomZipCode = ""
    @Published var roomArea = ""
    @Published var roomRentalPrice = ""
    @Published var doesSomeDeadinRoomYes = false
    @Published var doesSomeDeadinRoomNo = false
    @Published var someoneDeadinRoom = ""
    @Published var hasWaterLeakingYes = false
    @Published var hasWaterLeakingNo = false
    @Published var waterLeakingProblem = ""
    
    //:~Provider summit fields (HouseOwner)
    @Published var specificBuildingNumber = "" //專有部分建號
    @Published var specificBuildingRightRange = "" //專有部分權利範圍
    @Published var specificBuildingArea = "" //專有部分面積共計
    
    @Published var mainBuildArea = "" //主建物面積__層__平方公尺
    @Published var mainBuildingPurpose = "" //主建物用途
    
    @Published var subBuildingPurpose = "" //附屬建物用途
    @Published var subBuildingArea = "" //附屬建物面積__平方公尺
    
    @Published var publicBuildingNumber = "" //共有部分建號
    @Published var publicBuildingRightRange = "" //共有部分權利範圍
    @Published var publicBuildingArea = "" //共有部分持分面積__平方公尺
    
    @Published var hasParkinglotYes = false //車位-有
    @Published var hasParkinglotNo = false //車位-無
    @Published var parkinglotAmount = "" //汽機車車位數量
    
    @Published var isSettingTheRightForThirdPersonYes = false //設定他項權利-有
    @Published var isSettingTheRightForThirdPersonNo = false //設定他項權利-無
    
    @Published var SettingTheRightForThirdPersonForWhatKind = "" //權利種類
    @Published var isBlockByBankYes = false //查封登記-有
    @Published var isBlockByBankNo = false //查封登記-無
    
    @Published var provideForAll = false //租賃住宅全部
    @Published var provideForPart = false //租賃住宅部分
    @Published var provideFloor = "" //租賃住宅第__層
    @Published var provideRooms = "" //租賃住宅房間__間
    @Published var provideRoomNumber = "" //租賃住宅第__室
    @Published var provideRoomArea = "" //租賃住宅面積__平方公尺
    
    @Published var isVehicle = false //汽車停車位
    @Published var isMorto = false //機車停車位
    @Published var isBoth = false //汽車機車皆有
    @Published var parkingUGFloor = "" //地上(下)第__層
    @Published var parkingStyleN = false //平面式停車位ㄩ
    @Published var parkingStyleM = false //機械式停車位
    @Published var parkingNumber = "" //編號第__號
    @Published var forAllday = false //使用時間全日
    @Published var forMorning = false //使用時間日間
    @Published var forNight = false //使用時間夜間
    
    @Published var havingSubFacilityYes = false //租賃附屬設備-有
    @Published var havingSubFacilityNo = false //租賃附屬設備-無
    
    //:~ paragraph 2
    @Published var providingTimeRangeStart = "" //委託管理期間自
    @Published var providingTimeRangeEnd = "" //委託管理期間至
    
    //:~ paragraph3
    @Published var paybyCash = false //報酬約定及給付-現金繳付
    @Published var paybyTransmission = false //報酬約定及給付-轉帳繳付
    @Published var bankName = "" //金融機構
    @Published var bankOwnerName = "" //戶名
    @Published var bankAccount = "" //帳號
    
    //:~ paragraph12
    @Published var contractSendbyEmail = false //履行本契約之通知-電子郵件信箱
    @Published var contractSendbyTextingMessage = false //履行本契約之通知-手機簡訊
    @Published var contractSendbyMessageSoftware = false //履行本契約之通知-即時通訊軟體
    
    
    
    let selectArray = ["TapHomeButton", "TapPaymentButton", "TapProfileButton", "TapSearchButton", "FixButton"]
    
    
    
    func userDetailViewReset() {
        id = ""
        firstName = ""
        lastName = ""
        mobileNumber = ""
        dob = Date()
        address = ""
        town = ""
        city = ""
        zipCode = ""
        country = ""
        gender = ""
        rentalManagerLicenseNumber = ""
    }
    
    // MARK: remove after testing
//    func providerSummitChecker(holderName: String, holderMobileNumber: String, roomAddress: String, roomTown: String, roomCity: String, roomZipCode: String, roomArea: String, roomRentalPrice: String, tosAgreement: Bool, isSummitRoomImage: Bool, roomUID: String) throws {
//        if holderName.isEmpty && holderMobileNumber.isEmpty && roomAddress.isEmpty && roomTown.isEmpty && roomCity.isEmpty && roomZipCode.isEmpty && roomArea.isEmpty && roomRentalPrice.isEmpty && tosAgreement == false && isSummitRoomImage == false {
//            throw ProviderSummitError.blankError
//        }
//        if holderName.isEmpty {
//            throw ProviderSummitError.holderNameError
//        }
//        if holderMobileNumber.count != 10 {
//            throw ProviderSummitError.holderMobileNumberFormateError
//        }
//        if roomAddress.isEmpty {
//            throw ProviderSummitError.roomAddressError
//        }
//        if roomTown.isEmpty {
//            throw ProviderSummitError.roomTownError
//        }
//        if roomCity.isEmpty {
//            throw ProviderSummitError.roomCityError
//        }
//        if roomZipCode.isEmpty {
//            throw ProviderSummitError.roomZipCodeError
//        }
//        if roomArea.isEmpty {
//            throw ProviderSummitError.roomAreaError
//        }
//        if roomRentalPrice.isEmpty {
//            throw ProviderSummitError.roomRentalPriceError
//        }
//        if tosAgreement == false {
//            throw ProviderSummitError.tosAgreementError
//        }
//        if isSummitRoomImage == false {
//            throw ProviderSummitError.roomImageError
//        }
//
//        //        localData.addRoomDataToArray(roomUID: roomUID, holderName: holderName, mobileNumber: holderMobileNumber, roomAddress: roomAddress, town: roomTown, city: roomCity, zipCode: roomZipCode, roomArea: roomArea, rentalPrice: roomRentalPrice)
//    }
    
    // MARK: remove after testing
//    func userInfoFormatterChecker(id: String, firstName: String, lastName: String, gender: String, mobileNumber: String) throws {
//        if id.count > 10 || id.count < 10 {
//            throw UserInformationError.idFormateError
//        } else if mobileNumber.count > 10 || mobileNumber.count < 10 {
//            throw UserInformationError.mobileNumberFormateError
//        } else if gender.isEmpty {
//            throw UserInformationError.genderIsNotSelected
//        } else if formatterChecker(id: id) == false {
//            throw UserInformationError.idFormateError
//        } else if id.count == 10 && idChecker(id: id) == false {
//            throw UserInformationError.invalidID
//        }
//    }
    
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
    
    // MARK: remove after testing
//    func passwordCheckAndSignUp(email: String, password: String, confirmPassword: String) throws {
//        if email.isEmpty {
//            throw SignUpError.emailIsEmpty
//        } else if password.isEmpty {
//            throw SignUpError.passwordIsEmpty
//        } else if confirmPassword.isEmpty {
//            throw SignUpError.confirmPasswordIsEmpty
//        } else if password.count < 6 {
//            throw SignUpError.passwordIstooShort
//        } else if isProvider != true, isRenter != true {
//            throw SignUpError.missingUserType
//        } else if isAgree != true {
//            throw SignUpError.termofServiceIsNotAgree
//        } else if password != confirmPassword {
//            throw SignUpError.passwordAndConfirmIsNotMatch
//        }
//        //signUp(email: email, password: password)
//    }
    
    
    
    
    
    
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

struct textFormateForProviderSummitView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.white)
            .font(.system(size: 13, weight: .regular))
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
    
    let uiScreenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
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
                }
            }
        }
        .frame(width: uiScreenWidth - 25)
    }
}

struct SummaryItems: View {
    
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var appViewModel: AppViewModel
    
    var checkOutItem = "No Data"
    var checkOutPrice = "0"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(localData.summaryItemHolder) { data in
                    HStack {
                        Button {
                            localData.summaryItemHolder.removeAll(where: {$0.id == data.id})
                            localData.sumPrice = localData.compute(source: localData.summaryItemHolder)
                            appViewModel.isRedacted = true
                        } label: {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .frame(width: 22, height: 22)
                        }
                        Text(data.roomAddress)
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
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(title)
                    .modifier(textFormateForProviderSummitView())
                Spacer()
            }
            TextField("", text: $bindingString)
                .foregroundStyle(Color.white)
                .frame(height: 30)
                .background(Color.clear)
                .cornerRadius(5)
        }
        .padding()
        .frame(width: uiScreenWidth - 30)
        .background(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 1)
        })
    }
}


extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (()->Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    static func userInitial(delay: Double = 0.0, main: (()->Void)? = nil, completion: (()->Void)? = nil) {
        DispatchQueue.main.async {
            main?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}

extension AppViewModel {
    func providerSummitCheckerAsync(holderName: String, holderMobileNumber: String, roomAddress: String, roomTown: String, roomCity: String, roomZipCode: String, roomArea: String, roomRentalPrice: String, tosAgreement: Bool, isSummitRoomImage: Bool, roomUID: String) async throws {
        guard !holderName.isEmpty && !holderMobileNumber.isEmpty && !roomAddress.isEmpty && !roomTown.isEmpty && !roomCity.isEmpty && !roomZipCode.isEmpty && !roomArea.isEmpty && !roomRentalPrice.isEmpty && tosAgreement == true && isSummitRoomImage == true else {
            throw ProviderSummitError.blankError
        }
         guard !holderName.isEmpty else {
            throw ProviderSummitError.holderNameError
        }
         guard holderMobileNumber.count == 10 else {
            throw ProviderSummitError.holderMobileNumberFormateError
        }
         guard !roomAddress.isEmpty else {
            throw ProviderSummitError.roomAddressError
        }
         guard !roomTown.isEmpty else {
            throw ProviderSummitError.roomTownError
        }
         guard !roomCity.isEmpty else {
            throw ProviderSummitError.roomCityError
        }
         guard !roomZipCode.isEmpty else {
            throw ProviderSummitError.roomZipCodeError
        }
         guard !roomArea.isEmpty else {
            throw ProviderSummitError.roomAreaError
        }
        guard !roomRentalPrice.isEmpty else {
            throw ProviderSummitError.roomRentalPriceError
        }
        guard tosAgreement == true else {
            throw ProviderSummitError.tosAgreementError
        }
         guard isSummitRoomImage == true else {
            throw ProviderSummitError.roomImageError
        }
    }
    
    func passwordCheckAndSignUpAsync(email: String, password: String, confirmPassword: String) async throws {
        guard !email.isEmpty else {
            throw SignUpError.emailIsEmpty
        }
        guard !password.isEmpty else {
            throw SignUpError.passwordIsEmpty
        }
        guard !confirmPassword.isEmpty else {
            throw SignUpError.confirmPasswordIsEmpty
        }
        guard password.count >= 6 else {
            throw SignUpError.passwordIstooShort
        }
        guard isProvider == true || isRenter == true else {
            throw SignUpError.missingUserType
        }
        guard password == confirmPassword else {
            throw SignUpError.passwordAndConfirmIsNotMatch
        }
        if isProvider == true {
            guard isHoseOwner == true || isRentalM == true else {
                throw SignUpError.providerTypeError
            }
            if isRentalM == true {
                guard !rentalManagerLicenseNumber.isEmpty else {
                    throw SignUpError.licenseEnterError
                }
                guard rentalManagerLicenseNumber.count == 9 else {
                    throw SignUpError.licenseNumberLengthError
                }
            }
        }
        guard isAgree == true else {
            throw SignUpError.termofServiceIsNotAgree
        }
    }
    
    func userInfoFormatterCheckerAsync(id: String, firstName: String, lastName: String, gender: String, mobileNumber: String) throws {
        guard id.count == 10 else {
            throw UserInformationError.idFormateError
        }
        guard mobileNumber.count == 10 else {
            throw UserInformationError.mobileNumberFormateError
        }
        guard !gender.isEmpty else {
            throw UserInformationError.genderIsNotSelected
        }
        guard formatterChecker(id: id) == true else {
            throw UserInformationError.idFormateError
        }
        guard id.count == 10 && idChecker(id: id) == true else {
            throw UserInformationError.invalidID
        }
    }
}
