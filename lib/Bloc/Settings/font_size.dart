import 'package:flutter_bloc/flutter_bloc.dart';

class MiniPlayerSettingsCubit extends Cubit<double> {
  MiniPlayerSettingsCubit() : super(60);

  void update(double value) => emit(value);
}
