import XCTest
import NIOCore
@testable import PostgresNIO

class SASLResponseTests: XCTestCase {

    func testEncodeWithData() {
        let encoder = PSQLFrontendMessageEncoder.forTests
        var byteBuffer = ByteBuffer()
        let sasl = PSQLFrontendMessage.SASLResponse(data: [0, 1, 2, 3, 4, 5, 6, 7])
        let message = PSQLFrontendMessage.saslResponse(sasl)
        XCTAssertNoThrow(try encoder.encode(data: message, out: &byteBuffer))
        
        let length: Int = 1 + 4 + (sasl.data.count)
        
        XCTAssertEqual(byteBuffer.readableBytes, length)
        XCTAssertEqual(byteBuffer.readInteger(as: UInt8.self), PSQLFrontendMessage.ID.saslResponse.rawValue)
        XCTAssertEqual(byteBuffer.readInteger(as: Int32.self), Int32(length - 1))
        XCTAssertEqual(byteBuffer.readBytes(length: sasl.data.count), sasl.data)
        XCTAssertEqual(byteBuffer.readableBytes, 0)
    }
    
    func testEncodeWithoutData() {
        let encoder = PSQLFrontendMessageEncoder.forTests
        var byteBuffer = ByteBuffer()
        let sasl = PSQLFrontendMessage.SASLResponse(data: [])
        let message = PSQLFrontendMessage.saslResponse(sasl)
        XCTAssertNoThrow(try encoder.encode(data: message, out: &byteBuffer))
        
        let length: Int = 1 + 4
        
        XCTAssertEqual(byteBuffer.readableBytes, length)
        XCTAssertEqual(byteBuffer.readInteger(as: UInt8.self), PSQLFrontendMessage.ID.saslResponse.rawValue)
        XCTAssertEqual(byteBuffer.readInteger(as: Int32.self), Int32(length - 1))
        XCTAssertEqual(byteBuffer.readableBytes, 0)
    }
}
