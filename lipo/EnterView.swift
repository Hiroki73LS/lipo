import SwiftUI
import RealmSwift

class Model: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var condition = false
    @objc dynamic var btcapa = 0
    @objc dynamic var batteryNo = ""
    @objc dynamic var otherInfo = ""
    @objc dynamic var pick1 = 0
    @objc dynamic var isON = false
    @objc dynamic var date = Date()
}

struct ContentViewCellModel {
    let id: String
    let condition : Bool
    let btcapa: Int
    let batteryNo: String
    let otherInfo: String
    let pick1: Int
    var isON: Bool
    let date: Date
}

class viewModel: ObservableObject {
    
    private var token: NotificationToken?
    private var myModelResults = try? Realm().objects(Model.self)
    @Published var cellModels: [ContentViewCellModel] = []

    init() {
        token = myModelResults?.observe { [weak self] _ in
            self?.cellModels = self?.myModelResults?.map {ContentViewCellModel(id: $0.id, condition: $0.condition, btcapa: $0.btcapa, batteryNo: $0.batteryNo, otherInfo: $0.otherInfo, pick1: $0.pick1, isON: $0.isON, date: $0.date) } ?? []
        }
    }
    
    deinit {
        token?.invalidate()
    }
}
    
struct EnterView: View {
    
    @ObservedObject var keyboard = KeyboardObserver()
    @State var Cells = ["1","2","3","4","5","6"]
    @State var cells: Int = 0
    @State var batteryNo = ""
    @State var toSavelipo = false
    @State var isSaved = false
    @State var buyDate = Date()
    @State var useDate = Date()
    @Environment(\.managedObjectContext) var viewContext
    
    @ObservedObject var profile = UserProfile()
    @ObservedObject var model = viewModel()
    @State private var condition = false
    @State private var btcapa = 200
    @State private var otherInfo = ""
    @State private var date = Date()
    @State private var isON = false
    @State private var pick1 = 0
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
        }
    
    var body: some View {

        NavigationView{
            VStack {
                Text("バッテリー管理情報入力画面").font(.title2)
                HStack{
                Toggle(isOn: $condition) {
                    Text("Best Condition Battery")
                }}.padding(.horizontal, 20.0)
            VStack{
                Picker(selection: $cells,
                       label: Text("Ice cream topping")) {
                    ForEach(0 ..< Cells.count) {
                        Text(LocalizedStringKey(Cells[$0]))
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                Stepper(value: $btcapa ,in: 10...6000, step: 10) {
                    Text("Battery Capacity : \(btcapa)mAh" )
                }
                Stepper(value: $btcapa  ,in: 10...6000, step: 100) {
                    Text("( Step : 100mAh )")
                }
                Stepper(value: $btcapa  ,in: 10...6000, step: 1000) {
                    Text("( Step : 1000mAh )")
                }
                DatePicker(selection: $buyDate, displayedComponents: .date,
                           label: {Text("購入日時 (purchase date)")} )
                DatePicker(selection: $useDate, displayedComponents: .date,
                           label: {Text("使用開始 (Start date of use)")} )
                HStack{
                    Text("Battery No.")
                    TextField("Battery No.", text: $batteryNo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                TextField("Other info", text: $otherInfo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Divider()
                Button(action: {
                    if self.batteryNo == "" {
                        self.alert = false
                        self.alert1.toggle()
                    } else if self.batteryNo == "000121" {
                        print("Realm全削除")
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
                        let models = lipo.Model()
                        models.condition = condition
                        models.batteryNo = batteryNo
                        models.btcapa = btcapa
                        models.otherInfo = otherInfo
                        models.pick1 = pick1
                        models.isON = isON
                        models.date = date
                        let realm = try? Realm()
                        try? realm?.write {
                             realm?.add(models)
                        let Results = realm?.objects(Model.self).sorted(byKeyPath: "date", ascending: true)
                            realm?.add(Results!)
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
                                  message: Text("Battery No.[ \(batteryNo) ]を登録しました。"),
                            dismissButton: .default(Text("OK"),
                            action: {
                                condition = false
                                batteryNo = ""
                                isON = false
                                self.presentationMode.wrappedValue.dismiss()
                            }))
                     }
                }
            }.padding()
                
            Spacer().alert(isPresented: $toSavelipo) {
                Alert(
                    title: Text("登録しますか？"),
                    primaryButton: .default(Text("はい"),
                                            action: {(
                                            )}),
                    secondaryButton: .cancel(Text("いいえ")))
            }
            Spacer().alert(isPresented: $isSaved) {
                Alert(title: Text("Message"),
                      message: Text("The order was saved successfully."),
                      dismissButton: .default(Text("OK")))
            }
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
