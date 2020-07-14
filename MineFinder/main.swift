//
//  main.swift
//  MineFinder
//
//  Created by Kimyaehoon on 10/07/2020.
//  Copyright © 2020 Kimyaehoon. All rights reserved.
//

import Foundation

func printAndInfoString(text:String) -> String{
    print(text)
    let _info = readLine()
    guard let info = _info else {return ""}
    return info
}

func printAndInfoInt(text:String) -> Int{
    print(text)
    let _info = readLine()
    guard let info = _info, let infoInt = Int(info) else {return 0}
    return infoInt
}
 //

//view(map) - model(ground) - viewController

struct Ground {
    var isMine: Bool //생성할 때 한번만 변경 후 let
    var isVisible: Bool = false
    var aroundNumber: Int = 0
    
    static func CheckMine(x:Int, y:Int, ground:[[Ground]]) -> Bool {
        return ground[y][x].isMine
    }
    
    static func Calculate(x:Int, y: Int, ground:[[Ground]]) -> [[Ground]]{
        var innerGround = ground
            for outerI in -1...1 {
            for  innerI in -1...1{
                if((0...innerGround.count-1).contains(x + innerI)&&(0...innerGround.count-1).contains(y + outerI)){
                    if(outerI == 0 && innerI == 0){
                        
                    } else {
                        if(innerGround[x+innerI][y+outerI].isMine == false && innerGround[x+innerI][y+outerI].isVisible == false){
                            innerGround[x+innerI][y+outerI].isVisible = true
                            
                            if(innerGround[x+innerI][y+outerI].aroundNumber == 0){
                            innerGround = Ground.Calculate(x: x+innerI, y: y+outerI, ground: innerGround)
                            }
                        }
                    }
                }
        }
    }
        return innerGround
}
    
    static func MakeGround(size:Int, count:Int) -> [[Ground]]{
        var ground:[[Ground]] = Array(repeating: Array(repeating: Ground(isMine: false), count: size), count: size)
        
        func random(){
            let randNum = arc4random_uniform(UInt32(size-1))
            let randNum2 = arc4random_uniform(UInt32(size-1))
            
            if ground[Int(randNum)][Int(randNum2)].isMine == true {
                random()
                return
            } else {
                let num = Int(randNum)
                let num2 = Int(randNum2)
                ground[num][num2].isMine = true
                
                for i in -1...1{
                    for n in -1...1{
                        if((0...size-1).contains(num + n)&&(0...size-1).contains(num2 + i)){
                            ground[num+n][num2+i].aroundNumber += 1
                        }
                    }
                }
            }
        }
        
        for _ in 1...count {
            random()
        }
        
        return ground
    }
    
    init(isMine:Bool){
        self.isMine = isMine
    }
}

class Map{
    static func DrawMap(grounds:[[Ground]]){
        func printMap(ground:Ground){
            switch ground.isVisible {
            case true:
                print("\(ground.aroundNumber)",terminator:" ")
            case false:
                print("#",terminator:" ")
            }
        }
        
        for g in grounds {
        for _g in g{
        printMap(ground: _g)
        }
        print("")
        }
    }
}


//viewController
    
func play() -> [[Ground]]{
    print("새 게임을 시작합니다. 원하는 크기와 지뢰수를 알려주세요. ")
    let size = printAndInfoInt(text: "크기: ")
    let count = printAndInfoInt(text: "지뢰수: ")
    
    let ground = Ground.MakeGround(size: size, count: count)
    Map.DrawMap(grounds: ground)
    return ground
}

// 게임시작. 맵만들고 뷰띄우고 입력받고 맵수정하고 뷰띄우고 입력받고 맵수정하고 뷰띄우고 입력받고 폭탄이면 다시 게임시작하고

while true {
    var ground = play()
    
    while true {
        let x = printAndInfoInt(text: "클릭할 y 좌표를 알려주세요. : ")
        let y = printAndInfoInt(text: "클릭할 x 좌표를 알려주세요. : ")

        if(Ground.CheckMine(x: x, y: y, ground: ground))
        {
            print("게임오버")
            break
        } else {
            ground = Ground.Calculate(x: x, y: y, ground: ground)
            Map.DrawMap(grounds: ground)
        }
    }
    
}

