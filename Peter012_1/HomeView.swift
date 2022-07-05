//
//  HomeView.swift
//  Peter012_1
//
//  Created by DONG SHENG on 2022/7/4.
//

import SwiftUI

class HomeViewModel:ObservableObject{
    
    // 按鈕 4X5 (圖片名稱)
    @Published var ButtonArray: [[String]] = [
        ["clear","number0","plusmn","division"],
        ["number7","number8","number9","multiplication"],
        ["number4","number5","number6","subtraction"],
        ["number1","number2","number3","addition"],
        ["clear","number0","number0","equal"],
    ]
    
    // 按鈕行列數
    let rows = 5
    let columns = 4
    
    @Published var firstValue: Double = 0.0 // 用來儲存上一個值
    @Published var secondValue: Double = 0.0   // 現在正在輸入的
    @Published var newValue1: Double = 0.0 // 用來存計算後的值 (常會錯判成原本的 newValue 所以+1)
    @Published var showNumber: String = "" {
        didSet{
            
        }
    }
    @Published var showNumberDouble: Double = 0.0
    
    @Published var changeBool: Bool = false // 協助 螢幕數字的顯示 如果有值正在輸入 = true
    @Published var action: Bool = false // 檢查能不能運算
    
    
    @Published var divisionErrorText: String = ""
    
    @Published var CurrentOperations: String = ""{
        willSet{
            showNumber = ""
            // 如果 first 是 0 代表 第一次點擊 運算符號
            if CurrentOperations == "" {
                firstValue = secondValue // 把當前的值 存到第一個
                secondValue = 0.0
                print("\(CurrentOperations)")
                
            }  else {
                // 該去運算了
                if let operations = Operations(rawValue: CurrentOperations){
                    switch operations {
                    case .addition:
                        self.newValue1 = firstValue + secondValue
                        
                    case .subtraction:
                        self.newValue1 = firstValue - secondValue
                        
                    case .multiplication:
                        self.newValue1 = firstValue * secondValue
                        
                    case .division:
                        guard secondValue != 0 else { divisionError() ; return }
                        self.newValue1 = firstValue / secondValue
                    }
                }
                self.changeBool = false
                firstValue = newValue1
                secondValue = newValue1
                
            }
            print("Old: \((CurrentOperations))")
        }
        didSet{
            print("New: \((CurrentOperations))")
        }
    }
    
    enum Operations: String{
        case addition
        case subtraction
        case multiplication
        case division
    }
    
    
    func operation(number: String){
        
        guard number != "clear" else { reset() ; return } // 按 C 歸零
        
        guard number != "equal" else {
            result()
            return
        }
        guard number != "plusmn" else {
            
            // 同時變化 輸入字串和輸入Double(second)
            if self.secondValue != 0{
                // 看第一個字元是不是 -
                if showNumber.contains("-") {
                    print(showNumber)
                    self.showNumber = self.showNumber.replacingOccurrences(of: "-", with: "")
                    print("新的\(showNumber)")
                } else {
                    self.showNumber = "-" + showNumber
                }
                self.secondValue = -self.secondValue
                
                if self.secondValue + self.newValue1 == 0{
                    self.newValue1 = self.secondValue
                }
            } else {
                self.newValue1 = -self.newValue1
            }
            
            return
        }
        
        // 利用字串可以直接相加的特性 再轉成Double 就不用移位*10
        
        if let operation = Operations(rawValue: number){
            switch operation {
            case .addition:
                CurrentOperations = "addition"
            case .subtraction:
                CurrentOperations = "subtraction"
            case .multiplication:
                CurrentOperations = "multiplication"
            case .division:
                CurrentOperations = "division"
            }
        }
        
        self.changeBool = true
        
        if number == "number1"{
            self.showNumber.append("1")
        } else if number == "number2"{
            self.showNumber.append("2")
        } else if number == "number3"{
            self.showNumber.append("3")
        } else if number == "number4"{
            self.showNumber.append("4")
        } else if number == "number5"{
            self.showNumber.append("5")
        } else if number == "number6"{
            self.showNumber.append("6")
        } else if number == "number7"{
            self.showNumber.append("7")
        } else if number == "number8"{
            self.showNumber.append("8")
        } else if number == "number9"{
            self.showNumber.append("9")
        } else if number == "number0"{
            self.showNumber.append("0")
        }
//        self.CurrentOperations = ""
        
        secondValue = Double(showNumber) ?? 0
    }
    
    // 運算結果 ()
    func result(){
        if let operations = Operations(rawValue: CurrentOperations){
            switch operations {
            case .addition:
                self.newValue1 = firstValue + secondValue
                
            case .subtraction:
                self.newValue1 = firstValue - secondValue
                
            case .multiplication:
                self.newValue1 = firstValue * secondValue
                
            case .division:
                self.newValue1 = firstValue / secondValue
                
            }
        }
        self.CurrentOperations = ""
//        reset()
    }
    
    func reset(){
        self.firstValue = 0.0
        self.secondValue = 0.0
        self.newValue1 = 0.0
        
        self.showNumber = ""
        self.showNumberDouble = 0.0
        
        self.CurrentOperations = ""
        
        self.divisionErrorText = ""
    }
    
    
    // 除法錯誤 分母不能為0
    func divisionError(){
        self.divisionErrorText = "錯誤 分母不能為0"
    }
    

    // 螢幕上顯示用
    func showValue() -> Double{
        if newValue1 == 0 && secondValue == 0{
            return firstValue
        } else {
            if self.changeBool && secondValue != 0{
                return secondValue
            } else {
                return newValue1
            }
        }
    }
}

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack{
//            Text("正在輸入的文字\(viewModel.showNumber)")
//            Text("正在輸入的 \(viewModel.showNumberDouble)")
//            Text("上一個 \(viewModel.firstValue)")
//            Text("當前 :\(viewModel.secondValue)")
//            Text("TOTAL: \(viewModel.newValue1)")
            
            Text(viewModel.divisionErrorText == "" ? "新版 \(viewModel.showValue())" : viewModel.divisionErrorText)
                .font(.largeTitle.bold())
                .foregroundColor(.pink)
            
            VStack(spacing: 10){
                ForEach(0...self.viewModel.rows - 1, id: \.self){ row in
                    // 1個按鈕為螢幕 1/6
                    // 獲取螢幕寬度 - 4個按鈕總寬度 / 5個間格 -> 1/15
                    // 1/3 * 1/5 = 1/15
                    HStack(spacing:  UIScreen.main.bounds.width / 15){
                        
                        ForEach(0...self.viewModel.columns - 1, id: \.self){ columns in
                            VStack(spacing: UIScreen.main.bounds.width / 15){
                                
                                Button {
                                    viewModel.operation(number: viewModel.ButtonArray[row][columns])
                                    
                                } label: {
                                    Image(viewModel.ButtonArray[row][columns])
                                        .resizable()
                                        .background(
                                            // 依照當前的運算符號 變色
                                            viewModel.ButtonArray[row][columns] == viewModel.CurrentOperations ? .yellow : .brown
                                        )
                                        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
                                        .shadow(color: .black, radius: 1, x: 1, y: 1)
                                        .shadow(color: .black.opacity(0.75), radius: 1.5, x: 1.2, y: 1.2)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
