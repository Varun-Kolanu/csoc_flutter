import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:csoc_flutter/cubit/date_cubit.dart';
import 'package:csoc_flutter/services/date_service.dart';

class DateTitle extends StatelessWidget {
  final DateService _dateService =
      DateService(); // Create an instance of DateService

  DateTitle({super.key});

  Future<void> _dateSelection(BuildContext context) async {
    final DateCubit dateCubit = context.read<DateCubit>();
    final DateTime? picked =
        await _dateService.selectDate(context, dateCubit.state);
    if (picked != null) {
      dateCubit.selectDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BlocBuilder<DateCubit, DateTime>(
      builder: (context, selectedDate) {
        final formattedDate = DateFormat('EEEE, MMMM d').format(selectedDate);

        return InkWell(
          onTap: () => _dateSelection(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(formattedDate, style: theme.appBarTheme.titleTextStyle),
              const SizedBox(width: 7),
              Icon(
                Icons.calendar_today,
                size: 16,
                color: theme.primaryColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
