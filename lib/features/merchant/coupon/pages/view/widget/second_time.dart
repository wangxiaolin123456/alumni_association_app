import 'package:flutter/cupertino.dart';

class SecondTime {
  const SecondTime({
    required this.hour,
    required this.minute,
    required this.second,
  });

  final int hour;
  final int minute;
  final int second;
}

class TimePickerColumn extends StatelessWidget {
  const TimePickerColumn({
    super.key,
    required this.title,
    required this.itemCount,
    required this.initialItem,
    required this.onSelectedItemChanged,
  });

  final String title;
  final int itemCount;
  final int initialItem;
  final ValueChanged<int> onSelectedItemChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF7E8DA3),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
              initialItem: initialItem,
            ),
            itemExtent: 38,
            onSelectedItemChanged: onSelectedItemChanged,
            children: List.generate(
              itemCount,
              (index) => Center(
                child: Text(
                  index.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF102342),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
