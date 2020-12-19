//
//  LiveTrafficApiTestCase.swift
//  SingaporeLiveTrafficTests
//
//  Created by Apple on 19/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import XCTest

@testable import SingaporeLiveTraffic

class LiveTrafficApiTestCase: XCTestCase {

       let viewModel = TrafficViewModel()

    //Getting success response as we are passing correct date format
       func testLiveTrafficCameraAPIWithCorrectTimeDateFormat(){
        let strDate = Date().dateToString()
        viewModel.getTrafficImageDataApi(strDate: strDate)
        let expectation = XCTestExpectation()

        self.viewModel.getTrafficImageData = { (error, response) in
            if error != nil {
                XCTAssertTrue(false)
                expectation.fulfill()
            }else{
                XCTAssertTrue(true)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    //Getting fail response as we are passing wrong date format
    func testLiveTrafficCameraAPIWithWrongTimeDateFormat(){
        let strDate = Date().mockDateToString()
          viewModel.getTrafficImageDataApi(strDate: strDate)
          let expectation = XCTestExpectation()

          self.viewModel.getTrafficImageData = { (error, response) in
              if error != nil {
                  XCTAssertTrue(true)
                  expectation.fulfill()
              }else{
                  XCTAssertTrue(false)
                  expectation.fulfill()
              }
          }
          wait(for: [expectation], timeout: 5.0)
      }
}


