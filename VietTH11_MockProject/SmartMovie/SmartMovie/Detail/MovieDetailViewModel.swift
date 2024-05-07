//
//  MovieDetailViewModel.swift
//  SmartMovie
//
//  Created by Hoang Viet on 05/04/2023.
//

import Foundation
import Alamofire

struct ResponseEntityMovieCast: Codable {
    let id: Int
    let cast: [Cast]
}

struct Cast: Codable {
    let adult: Bool
    let gender: Int
    let id: Int
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let castId: Int
    let character: String
    let creditId: String
    let order: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case gender
        case id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castId = "cast_id"
        case character
        case creditId = "credit_id"
        case order
    }
}

final class MovieDetailViewModel {

}

extension MovieDetailViewModel: MovieDetailViewModelProtocol {
    func getMovieDetail(movieId: Int, result: @escaping (Result<ResponseEntityMovieDetail, APIError>) -> Void) {
        let url = "\(ServerConstant.URLBase.baseURL)\(movieId)?api_key=d5b97a6fad46348136d87b78895a0c06"
        AF.request(url).responseDecodable(of: ResponseEntityMovieDetail.self) { response in
            switch response.result {
            case .success(let movieDetailEntity):
                result(.success(movieDetailEntity))
            case .failure(let error):
                print(error)
                result(.failure(.decodeDataFailed))
            }
        }
    }

    func getMovieCast(movieId: Int, result: @escaping (Result<ResponseEntityMovieCast, APIError>) -> Void) {
        let url = "\(ServerConstant.URLBase.baseURL)\(movieId)/credits?api_key=d5b97a6fad46348136d87b78895a0c06"
        AF.request(url).responseDecodable(of: ResponseEntityMovieCast.self) { response in
            switch response.result {
            case .success(let movieCastEntity):
                result(.success(movieCastEntity))
            case .failure(let error):
                print(error)
                result(.failure(.decodeDataFailed))
            }
        }
    }

    func getMoviesSimilar(movieId: Int, result: @escaping (Result<[Movie], APIError>) -> Void) {
        let url = "\(ServerConstant.URLBase.baseURL)\(movieId)/similar?api_key=d5b97a6fad46348136d87b78895a0c06"
        AF.request(url).responseDecodable(of: ResponseMoviesEntity.self) { response in
            switch response.result {
            case .success(let data):
                result(.success(data.results))
            case .failure(let error):
                print(error)
                result(.failure(.decodeDataFailed))
            }
        }
    }
}
