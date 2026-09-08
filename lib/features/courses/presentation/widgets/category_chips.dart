import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nhims_lingo/features/courses/data/mock_courses_data.dart';

class CategoryChips extends StatefulWidget {
  final Function(String) onCategorySelected;
  
  const CategoryChips({
    super.key,
    required this.onCategorySelected,
  });

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: mockCategories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onCategorySelected(mockCategories[index]);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1460D9) : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: isSelected ? null : Border.all(color: const Color(0xFFEEEEEE), width: 1),
                ),
                alignment: Alignment.center,
                child: Text(
                  mockCategories[index].tr(),
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 14,
                    color: isSelected ? Colors.white : const Color(0xFF444444),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
