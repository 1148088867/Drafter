//
//  PreprocessorTest.swift
//  DrafterTests
//
//  Created by LZephyr on 2018/9/2.
//

import XCTest

let ocHeaderCode = """
@protocol MyProtocol3 <NSObject>
- (void)protocolMethod;
@end

@interface MyClass1: NSObject <MyProtocol3>
- (void)method1;
@end

"""

let ocImpCode = """
@implementation MyClass1
- (void)method1 {}
- (void)method3 {}
- (void)protocolMethod {}
@end

@interface MyClass1 (Category) <MyProtocol>
- (void)method2;
@end

@implementation MyClass1 (Category)
- (void)method2 {}
@end
"""

let swiftCode = """
class MyClass2: MyProtocol1 {
    func method1() {}
}

fileprivate extension MyClass2: MyProtocol2 {
    public func method2() {}
    private func method3() {}
}

open extension MyClass2 { 
    fileprivate func method4() {}
}

protocol MyProtocol1 {}
"""

class PreprocessorTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPreprocessor() {
        let _ = Drafter()
        let ocHeaderLexer = SourceLexer(input: ocHeaderCode, isSwift: false)
        let ocImpLexer = SourceLexer(input: ocImpCode, isSwift: false)
        let swiftLexer = SourceLexer(input: swiftCode, isSwift: true)
        
        guard let ocHeaderTypes = ObjcTypeParser().parser.run(ocHeaderLexer.allTokens) else {
            XCTAssert(false)
            return
        }
        guard let ocImpTypes = ObjcTypeParser().parser.run(ocImpLexer.allTokens) else {
            XCTAssert(false)
            return
        }
        guard let swiftTypes = SwiftTypeParser().parser.run(swiftLexer.allTokens) else {
            XCTAssert(false)
            return
        }
        
        let ocHeaderNodes = FileNode(md5: "", drafterVersion: DrafterVersion, path: "", type: .h, swiftTypes: [], objcTypes: ocHeaderTypes)
        let ocImpNodes = FileNode(md5: "", drafterVersion: DrafterVersion, path: "", type: .m, swiftTypes: [], objcTypes: ocImpTypes)
        let swiftNodes = FileNode(md5: "", drafterVersion: DrafterVersion, path: "", type: .swift, swiftTypes: swiftTypes, objcTypes: [])
        
        let classes = Preprocessor.shared.process([ocHeaderNodes, ocImpNodes, swiftNodes])

        XCTAssert(classes.count == 2)
        // OC test
        guard let ocClass = classes.find(name: "MyClass1") else {
            XCTAssert(false, "MyClass1 not found")
            return
        }
        XCTAssert(ocClass.isSwift == false, "ocClass test 1")
        XCTAssert(ocClass.methods.count == 4, "ocClass test 2")
        XCTAssert(ocClass.protocols.count == 2)
        guard let ocMethod1 = ocClass.methods.find(methodName: "method1"),
              let ocMethod2 = ocClass.methods.find(methodName: "method2"),
              let ocMethod3 = ocClass.methods.find(methodName: "protocolMethod") else {
            XCTAssert(false, "method not found in MyClass1")
            return
        }
        XCTAssert(ocMethod1.params.count == 1, "oc method1 test 1")
        XCTAssert(ocMethod1.accessControl == .public, "oc method1 test 2")
        XCTAssert(ocMethod2.accessControl == .private, "oc method1 test 3")
        XCTAssert(ocMethod3.accessControl == .public)

        // Swift test
        guard let swiftClass = classes.find(name: "MyClass2") else {
            XCTAssert(false)
            return
        }
        XCTAssert(swiftClass.methods.count == 4)
        XCTAssert(swiftClass.superCls == nil)
        XCTAssert(swiftClass.protocols.count == 2)
        XCTAssert(swiftClass.methods[0].accessControl == .internal)
        XCTAssert(swiftClass.methods[1].accessControl == .fileprivate)
        XCTAssert(swiftClass.methods[2].accessControl == .private)
        XCTAssert(swiftClass.methods[3].accessControl == .fileprivate)
    }

    func testProtocolPass() {
        let code = """
        @protocol Protocol1 <Protocol2>
        - (void)method1;
        @end
        
        @protocol Protocol2 <Protocol3>
        - (void)method2;
        @end
        
        @protocol Protocol3 <NSObject>
        - (void)method3;
        @end
        
        @interface MyClass: NSObject <Protocol1>
        
        @end
        """

        let lexer = SourceLexer(input: code, isSwift: false)
        let nodes = ObjcTypeParser().parser.run(lexer.allTokens) ?? []
        let file = FileNode(md5: "", drafterVersion: DrafterVersion, path: "", type: .h, swiftTypes: [], objcTypes: nodes)

        guard let interface = AccessControlPass().run(onFiles: [file]).ocTypes.interfaces.first else {
            XCTAssert(false)
            return
        }

        XCTAssert(interface.methods.count == 3)
        XCTAssert(interface.protocols == ["Protocol1"])
        XCTAssert(interface.methods[0].accessControl == .public)
        XCTAssert(interface.methods[1].accessControl == .public)
        XCTAssert(interface.methods[2].accessControl == .public)
    }
}
