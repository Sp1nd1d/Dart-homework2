import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/api_service.dart';

// Провайдер, создающий экземпляр ApiService
final apiProvider = Provider<ApiService>((ref) => ApiService());
