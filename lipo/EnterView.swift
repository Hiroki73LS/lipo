import SwiftUI
import RealmSwift

class Model: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var condition = false
    @objc dynamic var btcapa = 0
    @objc dynamic var otherInfo = ""
    @objc dynamic var pick1 = 0
    @objc dynamic var isON = false
    @objc dynamic var date = Date()
}

struct ContentViewCellModel {
    let id: String
    let condition : Bool
    let btcapa: Int
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
            self?.cellModels = self?.myModelResults?.map {ContentViewCellModel(id: $0.id, condition: $0.condition, btcapa: $0.btcapa, otherInfo: $0.otherInfo, pick1: $0.pick1, isON: $0.isON, date: $0.date) } ?? []
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
                    }else{
                        self.alert1.toggle()
                        self.toSave = true
        //-書き込み--------------------------
                        let models = lipo.Model()
                        models.condition = condition
                        models.btcapa = btcapa
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

//            ZStack{
//                    backGroundColor.edgesIgnoringSafeArea(.all)
//                    Form {
//                        Section(header: Text("バッテリー管理情報入力画面")) {
//                            TextField("[バッテリー管理番号]", text: $task)
//
//                            Picker(selection: $profile.level, label: Text("学年")) {
//                                            ForEach(1 ..< 7) { num in
//                                                Text("\(num)年生")
//                                            }
//                                        }
//                                        Text("選択値:\(profile.level)")
//
//
//
//                            Stepper(value: $profile.level, in: 100...6000 , step : 10) {
//                                Text("バッテリー容量 : \(profile.level) mhA ")
//                            }
//                            TextField("[内容]を入力してください", text: self.$batteryNo)
//                            DatePicker(selection: $date, displayedComponents: .date,label: {Text("登録日時")} )
//                            HStack {
//                                Text("お気に入り")
//                                Toggle(isOn: $isON) {
//                                    EmptyView()
//                                }
//                            }
//                        }
//                        Section(header: Text("定型選択肢を選択")) {
//    //-Picker--------------------------
//                            Picker(selection: $pick1,
//                                   label: Text("")) {
//                                Text("\(profile.username)").tag(0)
//                                Text("\(profile.username2)").tag(1)
//                                Text("\(profile.username3)").tag(2)
//                            }.pickerStyle(SegmentedPickerStyle())
//    //-Picker--------------------------
//                        }
//
//                        Section{
//                        HStack{
//                            Spacer()
//                            Button(action: {
//                                if self.task == "" {
//                                    self.alert = false
//                                    self.alert1.toggle()
//                                }else{
//                                    self.alert1.toggle()
//                                    self.toSave = true
//                    //-書き込み--------------------------
//                                    let models = lipo.Model()
//                                    models.condition = condition
//                                    models.task2 = task2
//
//                                    if pick1 == 0 {
//                                        models.task3 = profile.username
//                                    } else if pick1 == 1 {
//                                        models.task3 = profile.username2
//                                    } else {
//                                        models.task3 = profile.username3
//                                    }
//
//                                    models.pick1 = pick1
//                                    models.isON = isON
//                                    models.date = date
//                                    let realm = try? Realm()
//                                    try? realm?.write {
//                                         realm?.add(models)
//                                    let Results = realm?.objects(Model.self).sorted(byKeyPath: "date", ascending: true)
//                                        realm?.add(Results!)
//                                    }
//                    //-書き込み--------------------------
//                                    self.alert = true
//                                    }
//                            }){
//                        Text("確定")
//                            }
//                            .padding()
//                            .alert(isPresented: $alert1) {
//                                switch(alert) {
//                                    case false:
//                                     return
//                                        Alert(title: Text("注意"),
//                                         message: Text("[タイトル]を入力してください"),
//                                         dismissButton: .default(Text("OK")))
//                                    case true:
//                                     return
//                                        Alert(title: Text("確認"),
//                                              message: Text("タイトル[\(task)]を登録しました。"),
//                                        dismissButton: .default(Text("OK"),
//                                        action: {
//                                            task = ""
//                                            task2 = ""
//                                            task3 = ""
//                                            isON = false
//                                            self.presentationMode.wrappedValue.dismiss()
//                                        }))
//                                 }
//                            }
//                        Spacer()
//                }
//            }
//                }.navigationBarTitle("")
//                }
            }
        }
    }

struct EnterView_Previews: PreviewProvider {
    static var previews: some View {
        EnterView()
    }
}
