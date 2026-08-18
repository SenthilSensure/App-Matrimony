import 'package:dartz/dartz.dart';
import '../base/base_repo.dart';
import 'api_methods.dart';

class AuthRepo extends BaseRepo {

  String token() {
    var token = '';
    if(pref.token.isNotEmpty) {
      token = 'Bearer ${pref.token}';
    }
    return token;
  }

/*  // Login
  Future<Either<dynamic, LoginRes>> login(Map<String, dynamic> input) async {
    try {
      final response = await apiClient.apiClient(
        path: apiLogin,
        method: ApiMethod.post,
        body: input,
      );
      return response.fold((l) {
        return Left(l);
      }, (r) {
        final response = loginResFromJson(r.toString());
        return Right(response);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }*/
}
