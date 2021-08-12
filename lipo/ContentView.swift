import SwiftUI
import RealmSwift

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}

struct ContentView: View {
    @ObservedObject var profile = UserProfile()
    @ObservedObject var model = viewModel()
    @State private var idDetail = ""
    @State private var conditionDetail : Bool = false
    @State private var btcapaDetail : Int = 0
    @State private var batteryNoDetail : String = ""
    @State private var otherInfoDetail : String = ""
    @State private var buyDateDetail = Date()
    @State private var useDateDetail = Date()
    @State private var cellsDetail : Int = 0
    @State private var isONDetail = false
    @State private var toSave = false
    @State private var alert = false
    @State private var alert1 = false
    @State private var isShown: Bool = false
    @State private var isShown2: Bool = false
    @State private var showingAlert = false
    @State private var showAlert = false
    var dateFormat: DateFormatter {
        let dformat = DateFormatter()
        dformat.dateFormat = "yyyy/M/d"
//        dformat.dateFormat = "yyyy/M/d h:mm"
        return dformat
    }
    
    let backGroundColor = LinearGradient(gradient: Gradient(colors: [Color.white, Color.green]), startPoint: .top, endPoint: .bottom)
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                backGroundColor.edgesIgnoringSafeArea(.all)
                VStack{
                    List{
                        ForEach(model.cellModels, id: \.id) {
                            cellModel in
                            Button(action: {
                                idDetail = cellModel.id
                                conditionDetail = cellModel.condition
                                btcapaDetail = cellModel.btcapa
                                batteryNoDetail = cellModel.batteryNo
                                otherInfoDetail = cellModel.otherInfo
                                isONDetail = cellModel.isON
                                buyDateDetail = cellModel.buyDate
                                useDateDetail = cellModel.useDate
                                cellsDetail = cellModel.cells
                                self.showAlert = true
                            }, label: {
                                NavigationLink(destination: EditView(condition: $conditionDetail, btcapa: $btcapaDetail, batteryNo: $batteryNoDetail, otherInfo: $otherInfoDetail, isON: $isONDetail, buyDate: $buyDateDetail, useDate: $useDateDetail, cells: $cellsDetail), isActive: $showAlert) {
                                    HStack{
                                        VStack(alignment:.leading) {
                                            VStack{
                                                HStack{
                                                Text("No.\(cellModel.batteryNo)")
                                                .font(.title)
                                            Spacer()
                                            Text("セル数:\(cellModel.cells)")
                                                .font(.title)
                                            }
                                                HStack{
                                                    Text("容量:\(cellModel.btcapa)mhA")
//                                                        .foregroundColor(Color.gray)
                                                    Spacer()
                                                    Text("購入日:\(dateFormat.string(from: cellModel.buyDate))")
                                                }
                                                HStack{
                                                    Text("備考:\(cellModel.otherInfo)")
//                                                        .foregroundColor(Color.gray)
                                                    Spacer()
                                                    Text("使用日:\(dateFormat.string(from: cellModel.useDate))")
                                                }
                                            }.padding(0.0)
                                        }
                                        if cellModel.condition == true {
                                            Image(systemName: "battery.100")
                                                .foregroundColor(.pink)
                                                .onTapGesture {
                                                    try? Realm().write {
//                                                        cellModel.condition = false
                                                    }}
                                        } else {
                                            Image(systemName: "battery.75")
                                                .foregroundColor(.secondary)
                                                .onTapGesture {
                                                    try? Realm().write {
//                                                        cellModel.condition = true
                                                    }}
                                        }
                                    }
                                }.listRowBackground(Color.clear)
                            }
                            ).background(Color.clear)
                        }
                        .onDelete { indexSet in
                            let realm = try? Realm()
                            let index = indexSet.first
                            let target = realm?.objects(Model.self).filter("id = %@", self.model.cellModels[index!].id).first
                            print(target!)
                            try? realm?.write {
                                realm?.delete(target!)
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .background(NavigationConfigurator { nc in
                    nc.navigationBar.barTintColor = #colorLiteral(red: 0.9033463001, green: 0.9756388068, blue: 0.9194290638, alpha: 1)
                    nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                })
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading:
                                    Button(action: {
                                        self.isShown2 = true
                                    }) {
                                        Image(systemName: "gearshape")
                                            .padding()
                                            .background(Color.clear)
                                    } .sheet(isPresented: self.$isShown2) {
                                        //モーダル遷移した後に表示するビュー
                                        Setting()
                                    },
                                trailing:
                                    HStack {
                                        Button(action: {
                                            self.isShown = true
                                        }) {
                                            Image(systemName: "square.and.pencil")
                                                .padding()
                                                .background(Color.clear)
                                        } .sheet(isPresented: self.$isShown) {
                                            //モーダル遷移した後に表示するビュー
                                            EnterView()
                                        }
                                    })
        }
    }
}


func rowRemove(offsets: IndexSet) {
    let ttt = "111"
    let realm = try! Realm()            // ① realmインスタンスの生成
    let targetEmployee = realm.objects(Model.self).filter("batteryNo == %@", ttt)  // ② 削除したいデータを検索する
    
    print(targetEmployee)
    do{                                 // ③ 部署を更新する
      try realm.write{
        realm.delete(targetEmployee)
      }
    }catch {
      print("Error \(error)")
    }
            }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
