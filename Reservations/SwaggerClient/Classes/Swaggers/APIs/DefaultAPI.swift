//
// DefaultAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class DefaultAPI {
    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func healthGet(completion: @escaping ((_ data: Status?,_ error: Error?) -> Void)) {
        healthGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /health
     - examples: [{contentType=application/json, example={
  "details" : [ "details", "details" ],
  "status" : "status",
  "timestamp" : "timestamp"
}}]

     - returns: RequestBuilder<Status> 
     */
    open class func healthGetWithRequestBuilder() -> RequestBuilder<Status> {
        let path = "/health"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Status>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter input: (body)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func messagePost(input: MessageParams, completion: @escaping ((_ data: MessageResponse?,_ error: Error?) -> Void)) {
        messagePostWithRequestBuilder(input: input).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - POST /message
     - examples: [{contentType=application/json, example={
  "success" : true
}}]
     
     - parameter input: (body)  

     - returns: RequestBuilder<MessageResponse> 
     */
    open class func messagePostWithRequestBuilder(input: MessageParams) -> RequestBuilder<MessageResponse> {
        let path = "/message"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: input)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<MessageResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
