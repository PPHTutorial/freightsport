import 'package:flutter/material.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';

class DynamicInputList<T> extends StatelessWidget {
  final String title;
  final String addLabel;
  final List<T> items;
  final Widget Function(int index, T item) itemBuilder;
  final VoidCallback onAdd;
  final void Function(int index) onRemove;

  const DynamicInputList({
    super.key,
    required this.title,
    required this.addLabel,
    required this.items,
    required this.itemBuilder,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textGrey,
              ),
            ),
            TextButton.icon(
              onPressed: onAdd,
              icon: Icon(Icons.add, size: 18.w),
              label: Text(addLabel, style: TextStyle(fontSize: 14.sp)),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryBlue,
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        if (items.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              'No items added yet.',
              style: TextStyle(
                color: AppTheme.textGrey.withOpacity(0.5),
                fontSize: 12.sp,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ...List.generate(items.length, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: itemBuilder(index, items[index])),
                SizedBox(width: 8.w),
                IconButton(
                  onPressed: () => onRemove(index),
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20.w,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          );
        }),
        SizedBox(height: 8.h),
      ],
    );
  }
}

class LabeledTextInput extends StatelessWidget {
  final String? label;
  final String hint;
  final String initialValue;
  final void Function(String) onChanged;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const LabeledTextInput({
    super.key,
    this.label,
    required this.hint,
    required this.initialValue,
    required this.onChanged,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        labelStyle: TextStyle(fontSize: 14.sp),
        hintStyle: TextStyle(fontSize: 14.sp),
      ),
      style: TextStyle(fontSize: 14.sp),
    );
  }
}

class KeyValueInput extends StatelessWidget {
  final String keyHint;
  final String valueHint;
  final String initialKey;
  final String initialValue;
  final void Function(String) onKeyChanged;
  final void Function(String) onValueChanged;

  const KeyValueInput({
    super.key,
    required this.keyHint,
    required this.valueHint,
    required this.initialKey,
    required this.initialValue,
    required this.onKeyChanged,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabeledTextInput(
          hint: keyHint,
          initialValue: initialKey,
          onChanged: onKeyChanged,
        ),
        SizedBox(height: 2.h),
        LabeledTextInput(
          hint: valueHint,
          initialValue: initialValue,
          onChanged: onValueChanged,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}
