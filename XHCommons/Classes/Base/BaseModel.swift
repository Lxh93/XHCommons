//
//  BaseModel.swift
//  CMICPro
//
//  Created by 李小华 on 2022/11/21.
//


import HandyJSON

class BaseModel : HandyJSON{
    required init() {
        
    }
    func mapping(mapper: HelpingMapper) {
        
    }
}

class FirstModel : BaseModel{
    var code: Int?
    var message: String?
    var data: Any?
}

class MetaModel: BaseModel {
    var page: Int?
    var itemsPerPage : Int?
    var totalCount : Int?
    var totalPage : Int?
    
    // MARK: - local
    var nextPage: Int {
        get {
            (page ?? 1) + 1
        }
    }
    var noMoreDate: Bool {
        get {
            if let total = totalPage,
               page == total{
                return true
            }
            return false
        }
    }
    
}

class PageModel : BaseModel{
    var meta: MetaModel?
}


