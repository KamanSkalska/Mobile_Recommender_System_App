import 'package:flutter/material.dart';
import 'app_pallete.dart'; // Update this with the correct import for your AppPallete class

// Function to get the ElevatedButton style
ButtonStyle nextButton(BuildContext context) {
  return ElevatedButton.styleFrom(
    backgroundColor: AppPallete.backgroundColor, // Background color
    foregroundColor: AppPallete.whiteColor, // Text color
    elevation: 2,
    textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(
        color: AppPallete.gradient3,
        width: 2.5,
      ),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
  );
}

ButtonStyle answerButtonStyle({required bool isSelected}) {
  return ElevatedButton.styleFrom(
    backgroundColor: isSelected ? AppPallete.gradient3 : Colors.transparent,
    foregroundColor: AppPallete.whiteColor,
    elevation: isSelected ? 4 : 0,
    side: BorderSide(
      color: AppPallete.gradient3,
      width: isSelected ? 2.5 : 1.5,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    textStyle: const TextStyle(fontWeight: FontWeight.bold),
  );
}
