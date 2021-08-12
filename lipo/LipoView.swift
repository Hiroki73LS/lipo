import SwiftUI

struct ContentView2: View {
    @ObservedObject var keyboard = KeyboardObserver()
    
    @State var Cells = ["1","2","3","4","5","6"]
    @State var capacity = 200
    @State var condition = false
    @State var cells: Int = 0
    @State var otherInfo = ""
    @State var batteryNo = ""
    @State var toSave = false
    @State var isSaved = false
    @State var buyDate = Date()
    @State var useDate = Date()

    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        ScrollView {
            VStack {
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
                
                Stepper(value: $capacity ,in: 10...6000, step: 10) {
                    Text("Capacity : \(capacity)mAh" )
                }
                Stepper(value: $capacity  ,in: 10...6000, step: 100) {
                    Text("( Step : 100mAh )")
                }
                Stepper(value: $capacity  ,in: 10...6000, step: 1000) {
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
                    self.toSave = true
                }) {
                    Text("Save")
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
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
            .environment(\.locale, Locale(identifier: "ja_JP"))
    }
}
}
