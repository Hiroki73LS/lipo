import SwiftUI
import RealmSwift


    
struct EditView: View {
    @State var Cellhairetu = ["1","2","3","4","5","6"]
    @ObservedObject var keyboard = KeyboardObserver()
    @ObservedObject var profile = UserProfile()
    @Environment(\.presentationMode) var presentation
    
    @Binding var id: String
    @Binding var condition: Bool
    @Binding var btcapa : Int
    @Binding var batteryNo : Int
    @Binding var otherInfo: String
    @Binding var isON: Bool
    @Binding var buyDate: Date
    @Binding var useDate: Date
    @Binding var cells: Int

    @State private var alert = false
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
            ZStack{
                backGroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                Text("編集画面").font(.largeTitle)
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
                    Picker(selection: self.$batteryNo, label: Text("BatteryNo")){
                                        ForEach(1..<101){ _x in
                                            Text("\(_x)")
                                        }
                    }.frame(minWidth: 0, maxWidth: 100, maxHeight: 100)
                    .clipped()
                }
                TextField("Other info", text: $otherInfo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Divider()
                Button(action: {
                        self.alert = true
//                        self.toSave = true
        //-書き込み--------------------------
                    let realm = try! Realm()
                    let predicate = NSPredicate(format: "id == %@", id as CVarArg)
                    let results = realm.objects(Model.self).filter(predicate).first
                    try! realm.write {
                        results?.condition = condition
                        results?.batteryNo = batteryNo
                        results?.btcapa = btcapa
                        results?.otherInfo = otherInfo
                        results?.cells = cells
                        results?.isON = isON
                        results?.buyDate = buyDate
                        results?.useDate = useDate
                        }
        //-書き込み--------------------------
                    
                    print("\(alert)")
                    _ = Alert(title: Text("確認"),
                          message: Text("Battery No.[ \(batteryNo+1) ]を更新しました。"),
                          dismissButton: .default(Text("OK"),
                                                  action: {
                                                    condition = false
                                                    batteryNo = 0
                                                    isON = false
                                                    self.alert.toggle()
                                                    self.presentationMode.wrappedValue.dismiss()
                                                  }))

                }){
            Text("Save")
                }
                .padding()
            }.padding()
            }.onAppear{
                self.keyboard.addObserver()
            }.onDisappear{
                self.keyboard.removeObserver()
            }.padding(.bottom, keyboard.keyboardHeight)

            }}
        }
    }

struct EditView_Previews: PreviewProvider {
    
    @State static var buyDate: Date = {
            let df = DateFormatter()
            df.dateFormat = "MM/dd/yyyy"
            df.locale = Locale(identifier: "en_us_POSIX")
            //df.timeZone = TimeZone(identifier: "UTC")
            return df.date(from: "4/4/2020")!
        }()
    @State static var useDate: Date = {
            let df = DateFormatter()
            df.dateFormat = "MM/dd/yyyy"
            df.locale = Locale(identifier: "en_us_POSIX")
            //df.timeZone = TimeZone(identifier: "UTC")
            return df.date(from: "4/4/2020")!
        }()

    @State static var id = "UUID"
    @State static var condition = true
    @State static var btcapa = 100
    @State static var batteryNo = 1
    @State static var otherInfo = ""
    @State static var isON = true
    @State static var cells = 3
    
    static var previews: some View {
        EditView(id: $id, condition: $condition, btcapa: $btcapa, batteryNo: $batteryNo, otherInfo: $otherInfo, isON: $isON, buyDate: $buyDate, useDate: $useDate, cells: $cells)
    }
}
