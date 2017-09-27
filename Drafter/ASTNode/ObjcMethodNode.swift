//
//  ObjcMethodNode.swift
//  Mapper
//
//  Created by LZephyr on 2017/9/27.
//  Copyright © 2017年 LZephyr. All rights reserved.
//

import Foundation

/// 代表OC的方法定义
class ObjcMethodNode: Node {
    var isStatic = false  // 是否为类方法
    var methodBody: String = "" // 函数体
    var returnType: String = "" // 返回值类型
    var params: [Param] = []
}

class Param: Node {
    var type: String = "" // 参数类型
    var outterName: String = "" // 参数的名字
    var innerName: String = "" // 内部形参的名字
}

extension Param {
    convenience init(type: String, outter: String, inner: String) {
        self.type = type
        self.outterName = outter
        self.innerName = inner
    }
}