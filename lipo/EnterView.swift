import SwiftUI
import RealmSwift

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
    @Published var oldcapa: Int
    /// 初期化処理
    init() {
        oldcapa = UserDefaults.standard.object(forKey: "oldcapa") as? Int ?? 99
        print("oldcapa:\(oldcapa)です")
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
    private var motoArray = Array(1...99)
    private var sakujyo :Int = 0

    private var token: NotificationToken?
    private var myModelResults = try? Realm().objects(Model.self).sorted(byKeyPath: "batteryNo", ascending: true)
    @Published var cellModels: [ContentViewCellModel] = []

    init() {
        token = myModelResults?.observe { [weak self] _ in
            self?.cellModels = self?.myModelResults?.map {ContentViewCellModel(id: $0.id, condition: $0.condition, btcapa: $0.btcapa, batteryNo: $0.batteryNo, otherInfo: $0.otherInfo, isON: $0.isON, buyDate: $0.buyDate, useDate: $0.useDate, cells: $0.cells) } ?? []
        }
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
            if let firstIndex = motoArray.index(of: sakujyo + 1) {
                motoArray.remove(at: firstIndex)
        }
    }
        print(motoArray)      // ["A", "B", "C", "D"]
//配列から要素のインデックス番号を検索し、該当するインデックス番号の要素を削除↑-------------------
}

    deinit {
        token?.invalidate()
    }
}
    
struct EnterView: View {

    @ObservedObject var profile2 = UserProfile2()

    @ObservedObject var keyboard = KeyboardObserver()
    @State var Cellhairetu = ["1","2","3","4","5","6"]
    @State var batteryNo = 0
//    @State var toSavelipo = false
    @Environment(\.managedObjectContext) var viewContext
    
    @ObservedObject var profile = UserProfile()
    @ObservedObject var model = viewModel()
    @State private var condition = false
    @State private var btcapa = 0
    @State private var otherInfo = ""
    @State private var buyDate = Date()
    @State private var useDate = Date()
    @State private var cells = 0
    @State private var isON = false
    @State private var toSave = false
    @State private var alert = false
    @State private var alert1 = false
    @Environment(\.presentationMode) var presentationMode
    
    @State private var sentakusi = ""

    var dateFormat: DateFormatter {
        let dformat = DateFormatter()
        dformat.dateFormat = "yyyy/M/d h:mm"
        return dformat
    }
    
    let backGroundColor = LinearGradient(gradient: Gradient(colors: [Color.white, Color.green]), startPoint: .top, endPoint: .bottom)
    
    init() {
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
            btcapa = Int("\(profile2.oldcapa)") ?? 99
            otherInfo = "\(btcapa)"
        }


    
    var body: some View {
        NavigationView{
            ZStack{
                backGroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    Text("バッテリー情報入力画面").font(.title)
                    HStack{
                        Toggle(isOn: $condition) {
                            Text("Best Condition Battery")
                        }}.padding(.horizontal, 20.0)
                    VStack{
                        Picker(selection: $cells,
                               label: Text("Number of Cells")) {
                            ForEach(0 ..< Cellhairetu.count) {
                                Text(LocalizedStringKey(Cellhairetu[$0]))
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        
                        Stepper(value: $profile2.oldcapa ,in: 10...6000, step: 10) {
                            Text("Battery Capacity : \(profile2.oldcapa)mAh" )
                        }
                        Stepper(value: $profile2.oldcapa  ,in: 10...6000, step: 100) {
                            Text("( Step : 100mAh )")
                        }
                        Stepper(value: $profile2.oldcapa  ,in: 10...6000, step: 1000) {
                            Text("( Step : 1000mAh )")
                        }
                        DatePicker(selection: $buyDate, displayedComponents: .date,
                                   label: {Text("購入日時 (purchase date)")} )
                        DatePicker(selection: $useDate, displayedComponents: .date,
                                   label: {Text("使用開始 (Start date of use)")} )
                        HStack{
                            Text("Battery No.")
                            Picker(selection: self.$batteryNo, label: Text("BatteryNo")){
                                                ForEach(1..<101){ _x in
                                                    Text("\(_x)")
                                                }
                            }.frame(minWidth: 0, maxWidth: 100, maxHeight: 80)
                            .clipped()
                        }
                        TextField("Other info", text: $otherInfo)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Divider()
                        Button(action: {
                            if self.otherInfo == "010101" {
                                //-裏コマンド実施確認用の動き--------------------------
                                otherInfo = "000"
                                //-Realm全削除--------------------------
                                let realm = try! Realm()
                                try! realm.write {
                                    realm.deleteAll()
                                }
                                //-Realm全削除--------------------------
                            } else {
                                self.alert1.toggle()
                                self.toSave = true
                                //-書き込み--------------------------
                                UserDefaults.standard.set(profile2.oldcapa, forKey: "oldcapa")

                                let models = Model()
                                models.condition = condition
                                models.batteryNo = batteryNo
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
                                self.alert = true
                            }
                        }){
                            Text("Save")
                        }
                        .padding()
                        .alert(isPresented: $alert1) {
                            switch(alert) {
                            case false:
                                return
                                    Alert(title: Text("注意"),
                                          message: Text("[BatteryNo.]を入力してください"),
                                          dismissButton: .default(Text("OK")))
                            case true:
                                return
                                    Alert(title: Text("確認"),
                                          message: Text("Battery No.[ \(batteryNo+1) ]を登録しました。"),
                                          dismissButton: .default(Text("OK"),
                                                                  action: {
                                                                    condition = false
                                                                    batteryNo = 0
                                                                    isON = false
                                                                    self.presentationMode.wrappedValue.dismiss()
                                                                  }))
                            }
                        }
                    }.padding()
                    AdView()
                }.onAppear{
                    self.keyboard.addObserver()
                }.onDisappear{
                    self.keyboard.removeObserver()
                }.padding(.bottom, keyboard.keyboardHeight)
            }}
    }
}




struct EnterView_Previews: PreviewProvider {
    static var previews: some View {
        EnterView()
    }
}
