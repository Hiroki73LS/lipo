import SwiftUI
import RealmSwift

class Cellof: ObservableObject {
    
    var cellof0 : Int = 0
    var cellof1 : Int = 0
    var cellof2 : Int = 0
    var cellof3 : Int = 0
    var cellof4 : Int = 0
    var cellof5 : Int = 0
    var cellof6 : Int = 0
    
    init(){
        //セルごとの登録数を取得↓-------------------
        
        let realm = try? Realm()
        cellof0 = realm?.objects(Model.self).count ?? 99
        cellof1 = realm?.objects(Model.self).filter("cells == 0").count ?? 99
        cellof2 = realm?.objects(Model.self).filter("cells == 1").count ?? 99
        cellof3 = realm?.objects(Model.self).filter("cells == 2").count ?? 99
        cellof4 = realm?.objects(Model.self).filter("cells == 3").count ?? 99
        cellof5 = realm?.objects(Model.self).filter("cells == 4").count ?? 99
        cellof6 = realm?.objects(Model.self).filter("cells == 5").count ?? 99
        
            print("全体:\(String(describing: cellof0))")
            print("1:\(String(describing: cellof1))")
            print("2:\(String(describing: cellof2))")
            print("3:\(String(describing: cellof3))")
            print("4:\(String(describing: cellof4))")
            print("5:\(String(describing: cellof5))")
            print("6:\(String(describing: cellof6))")
        //セルごとの登録数を取得↑-------------------
    }
}

struct Setting: View {
    
    @ObservedObject var cellof = Cellof()
    @State private var color = Color.white
    @ObservedObject var profile = UserProfile()
    
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
                    Text("ColorSetting & Info").font(.largeTitle)
                    ColorPicker(selection: $color, label: {
                        Text("SelectColor")
                    })
                    .padding()
                    VStack{
                        Text("全体:\(self.cellof.cellof0)個")
                        Text("１セル:\(self.cellof.cellof1)個")
                        Text("２セル:\(self.cellof.cellof2)個")
                        Text("３セル:\(self.cellof.cellof3)個")
                        Text("４セル:\(self.cellof.cellof4)個")
                        Text("５セル:\(self.cellof.cellof5)個")
                        Text("６セル:\(self.cellof.cellof6)個")
                    }.font(.title2)
                    Spacer()
                    AdView()
                        .frame(width: 320, height: 50)
                } .background(NavigationConfigurator { nc in
                    nc.navigationBar.barTintColor = #colorLiteral(red: 0.9033463001, green: 0.9756388068, blue: 0.9194290638, alpha: 1)
                    nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                })
            }}
    }
}


class UserProfile: ObservableObject {
    /// 選択肢１
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }
    /// 選択肢２
    @Published var username2: String {
        didSet {
            UserDefaults.standard.set(username2, forKey: "username2")
        }
    }
    /// 選択肢３
    @Published var username3: String {
        didSet {
            UserDefaults.standard.set(username3, forKey: "username3")
        }
    }
    /// 初期化処理
    init() {
        username = UserDefaults.standard.string(forKey: "username") ?? ""
        username2 = UserDefaults.standard.string(forKey: "username2") ?? ""
        username3 = UserDefaults.standard.string(forKey: "username2") ?? ""
    }
}

//struct Setting_Previews: PreviewProvider {
//    static var previews: some View {
//        Setting()
//    }
//}
