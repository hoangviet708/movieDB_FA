//
//  GenresViewModel.swift
//  SmartMovie
//
//  Created by Hoang Viet on 04/04/2023.
//

import Foundation
import Alamofire

struct ResponseGenresEntity: Codable {
    var genres: [Genre]?
}

final class GenresViewModel {

}

extension GenresViewModel: GenresViewModelProtocol {
    func requestGenres(result: @escaping (Result<ResponseGenresEntity, APIError>) -> Void) {
        let url = "https://api.themoviedb.org/3/genre/movie/list?api_key=d5b97a6fad46348136d87b78895a0c06"
        AF.request(url).responseDecodable(of: ResponseGenresEntity.self) { response in
            switch response.result {
            case .success(let data):
                result(.success(data))
            case .failure(let error):
                print(error)
                result(.failure(.decodeDataFailed))
            }
        }
    }

    func requestMoviesByGenre(genreId: Int, result: @escaping (Result<[Movie], APIError>) -> Void) {
        let url =
        "https://api.themoviedb.org/3/discover/movie?api_key=d5b97a6fad46348136d87b78895a0c06&with_genres=\(genreId)"
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
