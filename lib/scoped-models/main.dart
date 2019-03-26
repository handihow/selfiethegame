import 'package:scoped_model/scoped_model.dart';
import './user.dart';
import './game.dart';
import './chat.dart';
import './assignment.dart';

class AppModel extends Model with UserModel, GameModel, ChatModel, AssignmentModel {}
