//
//  CatVC.swift
//  CatSwift
//
//  Created by wangyongyue on 2019/3/13.
//  Copyright © 2019 wangyongyue. All rights reserved.
//

import UIKit

class CatVC: UIViewController {

    var reText = Response()
    var reIf = Response()
    var reBlind = Response()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        let label = RLabel()
        label.backgroundColor = UIColor.blue
        label.textColor = UIColor.red
        label.frame = CGRect.init(x: 50, y: 80, width: 80, height: 30)
        self.view.addSubview(label)
        
        let label1 = RLabel()
        label1.backgroundColor = UIColor.blue
        label1.textColor = UIColor.red
        label1.frame = CGRect.init(x: 200, y: 80, width: 80, height: 30)
        self.view.addSubview(label1)
        
        let label3 = RLabel()
        label3.backgroundColor = UIColor.blue
        label3.textColor = UIColor.red
        label3.frame = CGRect.init(x: 200, y: 180, width: 80, height: 30)
        self.view.addSubview(label3)
        
        let label4 = RLabel()
        label4.backgroundColor = UIColor.blue
        label4.textColor = UIColor.red
        label4.frame = CGRect.init(x: 50, y: 180, width: 80, height: 30)
        self.view.addSubview(label4)
        
        
        let button = RButton()
        button.setTitle("button", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(button)
        button.frame = CGRect.init(x: 50, y: 280, width: 80, height: 30)
        
        let field = RField()
        field.borderStyle  = .roundedRect
        self.view.addSubview(field)
        field.frame = CGRect.init(x: 50, y: 380, width: 80, height: 30)
        
        
        label.v_text(re: reText)
        label1.v_if(re: reIf)
        label1.v_text(re: reText)
        
        label3.v_bind(re: reBlind)
        label3.v_text(re: reText)
        
        label4.v_text(re: reText)
        
        
        button.v_on {
            
            self.reText.v_text = "wyy_click"
            if let isH = self.reIf.v_if{
                self.reIf.v_if = !isH

            }else{
                
                self.reIf.v_if = true

            }
            self.reBlind.v_blind = ["backgroundColor":UIColor.green]
            
        }
        field.v_model {
            
            self.reText.v_text = field.text
            
        }
        
        
    }
    
}
class RLabel:UILabel{
    
    //{{ msg }}
    func v_text(re:Response){
        
        re.responseContent({[weak self] in
            
            self?.text = re.v_text
        })
        
    }
    //v-bind
    func v_bind(re:Response){
        re.responseContent({[weak self] in
            
            if let dic = re.v_blind{
                
                self?.setValuesForKeys(dic)
                
            }
            
        })
        
    }
    //v-if
    func v_if(re:Response){
        
        re.responseContent({[weak self] in
            
            if let v = re.v_if{
                
                self?.isHidden = v
                
            }
        })
        
    }
    
    
    
    
}
class RButton:UIButton{
    
    
    
    //{{ msg }}
    func v_text(re:Response){
        
        re.responseContent({[weak self] in
            
            self?.setTitle(re.v_text, for: .normal)
        })
        
    }
    //v-bind
    func v_bind(re:Response){
        re.responseContent({[weak self] in
            
            if let dic = re.v_blind{
                
                self?.setValuesForKeys(dic)
                
            }
            
        })
        
    }
    //v-if
    func v_if(re:Response){
        
        re.responseContent({[weak self] in
            
            
            if let v = re.v_if{
                
                self?.isHidden = v
                
            }
        })
        
    }
    
    //v-on
    var block:responseBlock?
    func v_on(re:@escaping responseBlock){
        
        self.addTarget(self, action: #selector(clickEvent), for: .touchUpInside)
        block = re
        
    }
    @objc func clickEvent(){
        
        block?()
    }
    
    
    
}
class RField:UITextField{
    
    
    //{{ msg }}
    func v_text(re:Response){
        
        re.responseContent({[weak self] in
            
            self?.text = re.v_text
        })
        
    }
    //v-bind
    func v_bind(re:Response){
        re.responseContent({[weak self] in
            
            if let dic = re.v_blind{
                
                self?.setValuesForKeys(dic)
                
            }
        })
        
    }
    //v-if
    func v_if(re:Response){
        
        re.responseContent({[weak self] in
            
            if let v = re.v_if{
                
                self?.isHidden = v
                
            }
        })
        
    }
    //v-model
    var block:responseBlock?
    func v_model(re:@escaping responseBlock){
        
        block = re
        self.addTarget(self, action: #selector(changeText), for: .editingChanged)
        
    }
    @objc func changeText(){
        
        block?()
    }
    
    
}

typealias responseBlock = () -> ()
class Response:NSObject{
    
    //响应者队列
    var array = Array<responseBlock>()
    private var _v_text:String?
    var v_text:String?{
        set{
            _v_text = newValue
            sendReponserMsg()
        }
        get{
            return _v_text
        }
    }
    private var _v_blind:[String:Any]?
    var v_blind:[String:Any]?{
        set{
            _v_blind = newValue
            sendReponserMsg()
        }
        get{
            return _v_blind
        }
    }
    private var _v_if:Bool?
    var v_if:Bool?{
        set{
            _v_if = newValue
            sendReponserMsg()
        }
        get{
            return _v_if
        }
    }
    
    
    
    func responseContent(_ callBack:@escaping responseBlock){
        array.append(callBack)
    }
    //触发响应
    func sendReponserMsg(){
        
        for value in array{
            
            value()
        }
    }
    //下标
    subscript(index:Int) -> String?{
        
        return "sub"
    }
    //运算符重载
    static func + (a:Response,b:Response) -> Response{
        
        let c = Response()
        c.v_text = a.v_text! + b.v_text!
        return c
    }
}
