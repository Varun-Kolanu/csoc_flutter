import 'package:flutter_bloc/flutter_bloc.dart';

class DateCubit extends Cubit<DateTime> {
  DateCubit() : super(DateTime.now());

  void selectDate(DateTime date) {
    emit(date);
  }
  void resetDate() {
    emit(DateTime.now());
  }
}
