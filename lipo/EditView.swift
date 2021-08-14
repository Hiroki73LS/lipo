import SwiftUI
import RealmSwift


    
struct EditView: View {
    @State var Cellhairetu = ["1","2","3","4","5","6"]
    @ObservedObject var keyboard = KeyboardObserver()
    @ObservedObject var profile = UserProfile()
    @Environment(\.presentationMode) var presentation
    
    @Binding var condition: Bool
    @Binding var btcapa : Int
    @Binding var batteryNo : String
    @Binding var otherInfo: String
    @Binding var isON: Bool
    @Binding var buyDate: Date
    @Binding var useDate: Date
    @Binding var cells: Int

//    @State var isSaved: Bool
    @State private var toSave = false
    @State private var alert = false
    @State private var alert1 = false
    @State private var sentakusi = ""
    @Environment(\.presentationMode) var presentationMode


    var dateFormat: DateFormatter {
        let dformat = DateFormatter()
        dformat.dateFormat = "yyyy/M/d h:mm"
        return dformat
    }
    
    let backGroundColor = LinearGradient(gradient: Gradient(colors: [Color.white, Color.green]), startPoint: .top, endPoint: .bottom)
       
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
                       label: Text("Number of Cells")) {
                    ForEach(0 ..< Cellhairetu.count) {
                        Text(LocalizedStringKey(Cellhairetu[$0]))
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
                        models.cells = cells
                        models.isON = isON
                        models.buyDate = buyDate
                        models.useDate = useDate
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
                
            Spacer().alert(isPresented: $toSave) {
                Alert(
                    title: Text("登録しますか？"),
                    primaryButton: .default(Text("はい"),
                                            action: {(
                                            )}),
                    secondaryButton: .cancel(Text("いいえ")))
            }
//            Spacer().alert(isPresented: $isSaved) {
//                Alert(title: Text("Message"),
//                      message: Text("The order was saved successfully."),
//                      dismissButton: .default(Text("OK")))
//            }
        }.onAppear{
            self.keyboard.addObserver()
        }.onDisappear{
            self.keyboard.removeObserver()
        }.padding(.bottom, keyboard.keyboardHeight)

            }
        
        
        
//        NavigationView {
//            ZStack{
//            backGroundColor.edgesIgnoringSafeArea(.all)
//            Form {
//                Section(header: Text("Title & Doの入力")) {
////                    TextField("[タイトル]を入力してください", text: $task2)
////                    TextField("[内容]を入力してください", text: $task2)
//                    DatePicker(selection: $buyDate, displayedComponents: .date,label: {Text("登録日時")} )
//                    HStack {
//                        Text("お気に入り")
//                        Toggle(isOn: $isON) {
//                        EmptyView()
//                        }
//                    }
//                }
//                Section(header: Text("カスタムタイプを選択")) {
//
//
//                }
//                Section{
//                    HStack{
//                        Spacer()
//                        Button(action: {
//                            if self.batteryNo == "" {
//                                self.alert = false
//                                self.alert1.toggle()
//                            }else{
//                                self.alert1.toggle()
//                                self.toSave = true
//
//                //-書き込み--------------------------
//                                let realm = try! Realm()
//                                let predicate = NSPredicate(format: "date == %@", buyDate as CVarArg)
//                                let results = realm.objects(Model.self).filter(predicate).first
//                                try! realm.write {
//                                    results?.condition = condition
//                                    results?.btcapa = btcapa
////                                    results?.cells = cells
//                                    results?.isON = isON
//                                }
//                //---書き込み--------------------------
//                                self.alert = true
//                                }
//                        }){
//                    Text("更新")
//                        }
//                        .padding()
//                        .alert(isPresented: $alert1) {
//                            switch(alert) {
//                                case false:
//                                 return
//                                    Alert(title: Text("注意"),
//                                     message: Text("[タイトル]を入力してください"),
//                                     dismissButton: .default(Text("OK")))
//                                case true:
//                                 return
//                                    Alert(title: Text("確認"),
//                                          message: Text("タイトル[\(batteryNo)]の内容を更新しました。"),
//                                    dismissButton: .default(Text("OK"),
//                                    action: {
//                                        condition = false
//                                        batteryNo = ""
//                                        otherInfo = ""
//                                        isON = false
//                                        self.presentation.wrappedValue.dismiss()
//                                    }))
//                             }
//                        }
//                    Spacer()
//            }
//        }
//            }.navigationBarTitle("")
//            }}
    }
    }

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditView()
//    }
//}
