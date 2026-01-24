import 'package:gritti_app/constants/app_constants.dart';
import 'package:gritti_app/helpers/di.dart';
import 'package:gritti_app/networks/dio/dio.dart';
import 'package:gritti_app/networks/endpoints.dart';

class WellnessGoalsApi {
  Future<Map<String, dynamic>> getWellnessGoals() async {
    // Get user info from /me endpoint which includes wellness goals
    final response = await getHttp(Endpoints.getMe());
    return response.data;
  }

  Future<Map<String, dynamic>> updateWellnessGoals({
    String? bodyPartFocus,
    String? dreamBody,
    String? urgentImprovement,
    String? tryingDuration,
    double? targetWeight,
  }) async {
    final userId = appData.read(kKeyID);

    final Map<String, dynamic> data = {
      'user_id': userId,
    };

    if (bodyPartFocus != null) data['body_part_focus'] = bodyPartFocus;
    if (dreamBody != null) data['dream_body'] = dreamBody;
    if (urgentImprovement != null) data['urgent_improvement'] = urgentImprovement;
    if (tryingDuration != null) data['trying_duration'] = tryingDuration;
    if (targetWeight != null) data['target_weight'] = targetWeight;

    final response = await postHttp(Endpoints.onboardUserInfo(), data);
    return response.data;
  }
}
