import SwiftUI
import RealmSwift


    
struct EditView: View {
    @ObservedObject var profile = UserProfile()
    @Environment(\.presentationMode) var presentation
    @Binding var condition: Bool
    @Binding var btcapa : Int
    @Binding var task3: String
    @Binding var date: Date
    @Binding var isON: Bool
    @Binding var pick1: Int

    @State private var toSave = false
    @State private var alert = false
    @State private var alert1 = false
    @State private var sentakusi = ""
    @State private var batteryNo = ""

    var dateFormat: DateFormatter {
        let dformat = DateFormatter()
        dformat.dateFormat = "yyyy/M/d h:mm"
        return dformat
    }
    
    let backGroundColor = LinearGradient(gradient: Gradient(colors: [Color.white, Color.green]), startPoint: .top, endPoint: .bottom)
       
    var body: some View {

        NavigationView {
            ZStack{
            backGroundColor.edgesIgnoringSafeArea(.all)
            Form {
                Section(header: Text("Title & Doの入力")) {
//                    TextField("[タイトル]を入力してください", text: $task2)
//                    TextField("[内容]を入力してください", text: $task2)
                    DatePicker(selection: $date, displayedComponents: .date,label: {Text("登録日時")} )
                    HStack {
                        Text("お気に入り")
                        Toggle(isOn: $isON) {
                        EmptyView()
                        }
                    }
                }
                Section(header: Text("カスタムタイプを選択")) {
                    
                    //-Picker--------------------------
                    Picker(selection: $pick1,
                           label: Text("")) {
                        Text("\(profile.username)").tag(0)
                        Text("\(profile.username2)").tag(1)
                        Text("\(profile.username3)").tag(2)
                    }.pickerStyle(SegmentedPickerStyle())
                    //-Picker--------------------------
                    
                }
                Section{
                    HStack{
                        Spacer()
                        Button(action: {
                            if self.batteryNo == "" {
                                self.alert = false
                                self.alert1.toggle()
                            }else{
                                self.alert1.toggle()
                                self.toSave = true
                                
                //-書き込み--------------------------
                                let realm = try! Realm()
                                let predicate = NSPredicate(format: "date == %@", date as CVarArg)
                                let results = realm.objects(Model.self).filter(predicate).first
                                try! realm.write {
                                    results?.date = date
                                    results?.condition = condition
                                    results?.btcapa = btcapa
                                    results?.pick1 = pick1
                                    results?.isON = isON
                                }
                //---書き込み--------------------------
                                self.alert = true
                                }
                        }){
                    Text("更新")
                        }
                        .padding()
                        .alert(isPresented: $alert1) {
                            switch(alert) {
                                case false:
                                 return
                                    Alert(title: Text("注意"),
                                     message: Text("[タイトル]を入力してください"),
                                     dismissButton: .default(Text("OK")))
                                case true:
                                 return
                                    Alert(title: Text("確認"),
                                          message: Text("タイトル[\(batteryNo)]の内容を更新しました。"),
                                    dismissButton: .default(Text("OK"),
                                    action: {
                                        condition = false
                                        batteryNo = ""
                                        task3 = ""
                                        isON = false
                                        self.presentation.wrappedValue.dismiss()
                                    }))
                             }
                        }
                    Spacer()
            }
        }
            }.navigationBarTitle("")
            }}
    }
    }

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditView()
//    }
//}
