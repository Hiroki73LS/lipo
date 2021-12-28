import UIKit
import SwiftUI
import RealmSwift
import GoogleMobileAds


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
        //セルごとの登録数を取得↑-------------------
    }
}

struct Setting: View {
    
    @ObservedObject var cellof = Cellof()
    @State var color1 = Color.white
    @State var color2 = Color.green
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
                    
                    Text("Number of Batteries")
                        .font(.largeTitle)
                    Form {
                        HStack{
                            Image(systemName: "battery.75")
                                .resizable()
                                .frame(width: 60, height: 30)
                            Text("１セル　：　\(self.cellof.cellof1)　個")
                        }
                        HStack{
                            Image(systemName: "battery.75")
                                .resizable()
                                .frame(width: 60, height: 30)
                            Text("２セル　：　\(self.cellof.cellof2)　個")
                        }
                        HStack{
                            Image(systemName: "battery.75")
                                .resizable()
                                .frame(width: 60, height: 30)
                            Text("３セル　：　\(self.cellof.cellof3)　個")
                        }
                        HStack{
                            Image(systemName: "battery.75")
                                .resizable()
                                .frame(width: 60, height: 30)
                            Text("４セル　：　\(self.cellof.cellof4)　個")
                        }
                        HStack{
                            Image(systemName: "battery.75")
                                .resizable()
                                .frame(width: 60, height: 30)
                            Text("５セル　：　\(self.cellof.cellof5)　個")
                        }
                        HStack{
                            Image(systemName: "battery.75")
                                .resizable()
                                .frame(width: 60, height: 30)
                            Text("６セル　：　\(self.cellof.cellof6)　個")
                        }
                    }
                    .font(.title)
                    Spacer()
                        .frame(width: 320, height: 100)
                    AdView()
                        .frame(width: 320, height: 100)
                }
            }}
    }
}


class UserProfile: ObservableObject {
    @Published var UD1: String {
        didSet {
            UserDefaults.standard.set(UD1, forKey: "UD1")
        }
    }
    @Published var UD2: String {
        didSet {
            UserDefaults.standard.set(UD2, forKey: "UD2")
        }
    }
    @Published var UD3: String {
        didSet {
            UserDefaults.standard.set(UD3, forKey: "UD3")
        }
    }

    init() {
        UD1 = UserDefaults.standard.string(forKey: "UD1") ?? ""
        UD2 = UserDefaults.standard.string(forKey: "UD2") ?? ""
        UD3 = UserDefaults.standard.string(forKey: "UD3") ?? ""
    }
}

//struct Setting_Previews: PreviewProvider {
//    static var previews: some View {
//        Setting()
//    }
//}
