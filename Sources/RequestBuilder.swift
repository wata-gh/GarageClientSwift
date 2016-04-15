import Foundation
import APIKit
import Himotoki

struct WrappedRequest<T: GarageRequestType>: RequestType {
//    typealias Response = GarageResponse<T.Resource>

    let baseRequest: T
    let configuration: GarageConfigurationType

    var baseURL: NSURL {
        return configuration.endpoint
    }

    var method: HTTPMethod {
        return baseRequest.method
    }

    var path: String {
        let pathPrefix = configuration.pathPrefix as NSString
        return pathPrefix.stringByAppendingPathComponent(baseRequest.path)
    }

    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) ->
        GarageResponse<T.Resource>? {
        return nil
    }

    func responseFromObject<T: GarageRequestType, D: Decodable where T.Resource == D,
        D == D.DecodedType>
        (object: AnyObject, URLResponse: NSHTTPURLResponse) -> GarageResponse<T.Resource>? {
        guard let resource: T.Resource = try? decodeValue(object) else {
            return nil
        }

        let parameters = headerParameters(URLResponse)
        return GarageResponse(resource: resource,
                              totalCount: parameters.totalCount,
                              linkHeader: parameters.linkHeader)
    }

    func responseFromObject<T: GarageRequestType, D: Decodable where T.Resource == [D],
        D == D.DecodedType>
        (object: AnyObject, URLResponse: NSHTTPURLResponse) -> GarageResponse<T.Resource>? {
        guard let resource: T.Resource = try? decodeArray(object) else {
            return nil
        }

        let parameters = headerParameters(URLResponse)
        return GarageResponse(resource: resource,
                              totalCount: parameters.totalCount,
                              linkHeader: parameters.linkHeader)
    }

    func headerParameters(response: NSHTTPURLResponse) ->
        (totalCount: Int?, linkHeader: LinkHeader?) {
        let totalCount: Int?
        if let totalCountString = response.allHeaderFields["X-List-Totalcount"] as? String {
            totalCount = Int(totalCountString)
        } else {
            totalCount = nil
        }

        let linkHeader: LinkHeader?
        if let linkHeaderString = response.allHeaderFields["Link"] as? String {
            linkHeader = LinkHeader(string: linkHeaderString)
        } else {
            linkHeader = nil
        }

        return (totalCount, linkHeader)
    }
}

class RequestBuilder {
    static func buildRequest<T: GarageRequestType, D: Decodable
        where T.Resource == D, D == D.DecodedType>
        (baseRequest: T, configuration: GarageConfigurationType) ->
        WrappedRequest<T> {
        return WrappedRequest(baseRequest: baseRequest, configuration: configuration)
    }

    static func buildRequest<T: GarageRequestType, D: Decodable
        where T.Resource == [D], D == D.DecodedType>
        (baseRequest: T, configuration: GarageConfigurationType) ->
        WrappedRequest<T> {
        return WrappedRequest(baseRequest: baseRequest, configuration: configuration)
    }
}
