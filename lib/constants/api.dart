import 'package:rick_and_morty/constants/constants.dart';

enum EndPoint {
  character("${Constants.baseUrl}character/"),
  episode("${Constants.baseUrl}episode/");

  final String ep;

  const EndPoint(this.ep);
}
