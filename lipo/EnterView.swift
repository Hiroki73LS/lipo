import SwiftUI
import RealmSwift
import GoogleMobileAds

class Model: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var condition = false
    @objc dynamic var btcapa = 0
    @objc dynamic var batteryNo = 0
    @objc dynamic var otherInfo = ""
    @objc dynamic var isON = false
    @objc dynamic var buyDate = Date()
    @objc dynamic var useDate = Date()
    @objc dynamic var cells = 0
}

class UserProfile2: ObservableObject {
    /// 前回のバッテリーキャパ
    @Published var oldcapa: Int = 0
    /// 初期化処理
    init() {
        oldcapa = UserDefaults.standard.object(forKey: "oldcapa") as? Int ?? 100
    }
}

struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(12.0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .opacity(configuration.isPressed ? 0.4 : 1)
    }
}

struct ContentViewCellModel {
    let id: String
    let condition : Bool
    let btcapa : Int
    let batteryNo : Int
    let otherInfo : String
    var isON : Bool
    let buyDate : Date
    let useDate : Date
    let cells : Int
}

class viewModel: ObservableObject {
    
    private var ArrayCount :Int = 0
    private var intArray = [Int]()
    var motoArray = Array(1...30)
    private var sakujyo :Int = 0
    
    private var token: NotificationToken?
    private var myModelResults = try? Realm().objects(Model.self).sorted(byKeyPath: "batteryNo", ascending: true)
    @Published var cellModels: [ContentViewCellModel] = []
    
    init() {
        token = myModelResults?.observe { [weak self] _ in
            self?.cellModels = self?.myModelResults?.map {ContentViewCellModel(id: $0.id, condition: $0.condition, btcapa: $0.btcapa, batteryNo: $0.batteryNo, otherInfo: $0.otherInfo, isON: $0.isON, buyDate: $0.buyDate, useDate: $0.useDate, cells: $0.cells) } ?? []
        }
        
        self.cellModels = self.myModelResults?.map {ContentViewCellModel(id: $0.id, condition: $0.condition, btcapa: $0.btcapa, batteryNo: $0.batteryNo, otherInfo: $0.otherInfo, isON: $0.isON, buyDate: $0.buyDate, useDate: $0.useDate, cells: $0.cells) } ?? []
        
        //RealmからBatteryNoを取得して配列に格納してソート↓-------------------
        let realm = try? Realm()
        let btNo = realm?.objects(Model.self)
        ArrayCount = btNo!.count //配列の数を代入
        for i in 0 ..< ArrayCount {
            intArray.append(btNo![i].batteryNo)
            intArray.sort()
        }
        //RealmからBatteryNoを取得して配列に格納してソート↑-------------------
        //配列から要素のインデックス番号を検索し、該当するインデックス番号の要素を削除↓-------------------
        
        for i in 0 ..< ArrayCount {
            sakujyo = intArray[i]
            if let firstIndex = motoArray.firstIndex(of: sakujyo + 1) {
                motoArray.remove(at: firstIndex)
            }
        }
        //配列から要素のインデックス番号を検索し、該当するインデックス番号の要素を削除↑-------------------
        
    }
    
    deinit {
    }
}

struct EnterView: View {
    
    @StateObject var moto = viewModel()
    @ObservedObject var profile2 = UserProfile2()
    @ObservedObject var keyboard = KeyboardObserver()
    @State var Cellhairetu = ["1","2","3","4","5","6"]
    @State var batteryNo = 0
    @ObservedObject var profile = UserProfile()
    @ObservedObject var model = viewModel()
    @State private var condition = false
    @State private var btcapa = 0
    @State private var otherInfo = ""
    @State private var buyDate = Date()
    @State private var useDate = Date()
    @State private var cells = 0
    @State private var isON = false
    @State private var alert1 = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var dateFormat: DateFormatter {
        let dformat = DateFormatter()
        dformat.dateFormat = "yyyy/M/d h:mm"
        return dformat
    }
    
    let backGroundColor = LinearGradient(gradient: Gradient(colors: [Color.white, Color.orange.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        print(moto.motoArray[batteryNo])
    }
    
    
    
    var body: some View {
//        NavigationView{
            ZStack{
                backGroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                            .frame(width: 320, height: 20)
                    Text("Input screen").font(.largeTitle)
                    HStack{
                        Toggle(isOn: $condition) {
                            Text("Best Condition Battery")
                                .font(.title2)
                                .bold()
                        }}.padding(.horizontal)
                    VStack{
                        HStack{
                            Text("Choose No. of Cells")
                                .font(.callout)
                                .bold()
                            Spacer()
                        }
                        Picker(selection: $cells,
                               label: Text("Number of Cells")) {
                            ForEach(0 ..< Cellhairetu.count) {
                                Text(LocalizedStringKey(Cellhairetu[$0]))
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }.padding(.horizontal)
                    VStack{
                        VStack{
                            Stepper(value: $profile2.oldcapa ,in: 10...6000, step: 10) {
                                Text("Battery Capacity : \(profile2.oldcapa)mAh" )
                                    .bold()
                            }
                            Stepper(value: $profile2.oldcapa  ,in: 10...6000, step: 100) {
                                Text("( Step : 100mAh )")
                                    .foregroundColor(.orange)
                                    .bold()
                            }
                            Stepper(value: $profile2.oldcapa  ,in: 10...6000, step: 1000) {
                                Text("( Step : 1000mAh )")
                                    .foregroundColor(.orange)
                                    .bold()
                            }
                            DatePicker(selection: $buyDate, displayedComponents: .date,
                                       label: {Text("購入日時").bold()+Text(" (purchase date)").font(.headline)} )
                            DatePicker(selection: $useDate, displayedComponents: .date,
                                       label: {Text("使用開始").bold()+Text(" (Start date of use)").bold().font(.subheadline)} )
                        }
                        HStack{
                            Text("Battery No.")
                                .font(.title)
                                .bold()
                            ZStack{
                                Text("\(self.moto.motoArray[batteryNo])")
                                    .font(.title)
                                Picker(selection: self.$batteryNo, label: Text("BatteryNo")){
                                    ForEach(0 ..< moto.motoArray.count) { num in
                                        Text("\(self.moto.motoArray[num])")
                                    }
                                }.pickerStyle(.menu)
                                    .accentColor(Color.clear)
                                    .fixedSize()
                                    .frame(width: 60, height: 32)
                                    .background(Color(.sRGB, white: 0.5, opacity: 0.1))
                                    .compositingGroup() // << add this modifier above clipping !!!
                                    .clipped()
                            }
                        }.clipped()
                        TextField("Other info", text: $otherInfo)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Divider()
                        Button(action: {
                            print("前\(batteryNo)")
                            print(moto.motoArray[batteryNo])
                            //-書き込み--------------------------
                            UserDefaults.standard.set(profile2.oldcapa, forKey: "oldcapa")
                            
                            let models = Model()
                            models.condition = condition
                            models.batteryNo = moto.motoArray[batteryNo] - 1
                            models.btcapa = profile2.oldcapa
                            models.otherInfo = otherInfo
                            models.cells = cells
                            models.isON = isON
                            models.buyDate = buyDate
                            models.useDate = useDate
                            
                            let realm = try? Realm()
                            try? realm?.write {
                                realm?.add(models)
                            }
                            //-書き込み--------------------------
                            self.alert1.toggle()
                            print("add:\(models)")
                        }){
                            Text("Save")
                                .font(.title)
                                .frame(width: 150, height: 20)
                        }
                        .buttonStyle(MyButtonStyle())
                        .alert(isPresented: $alert1) {
                            Alert(title: Text("確認"),
                                  message: Text("Battery No.[ \(moto.motoArray[batteryNo]) ]を登録しました。"),
                                  dismissButton: .default(Text("OK"),
                                                          action: {
                                print(moto.motoArray[batteryNo])
                                condition = false
                                isON = false
                                self.presentationMode.wrappedValue.dismiss()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                  //処理したいコードを記述
                                    batteryNo = 0
                                }
                            }))
                        }
                    }.padding(.horizontal)
                    Spacer()
                    AdView()
                        .frame(width: 320, height: 100)
                }.onAppear{
                    self.keyboard.addObserver()
                }.onDisappear{
                    self.keyboard.removeObserver()
                }.padding(.bottom, keyboard.keyboardHeight)
            }
    }
}




struct EnterView_Previews: PreviewProvider {
    static var previews: some View {
        EnterView()
    }
}
