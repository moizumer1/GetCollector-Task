import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../model/category_model.dart';
import '../providers/quantity_provider.dart';
import '../providers/theme_provider.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryWidget({
    required this.categoryModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;

    return GestureDetector(
      onTap: () {
        final provider = Provider.of<CategoryProvider>(context, listen: false);
        final quantity = provider.getQuantity(categoryModel.id);

        showModalBottomSheet(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          builder: (context) {
            return ChangeNotifierProvider.value(
              value: provider,
              child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF272727) : Colors.white, // Background color
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _buildBottomSheetContent(context, isDarkMode),
                  );
                },
              ),
            );
          },
        );

      },
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        width: 160.w,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF272727) : Colors.white, // Dark mode card background
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.orange, // Border color (can be customized)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color
              spreadRadius: 2, // Spread of the shadow
              blurRadius: 10,  // Softness of the shadow
              offset: Offset(0, 4), // Offset in X and Y direction
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xffD8DADC),
                  ),
                ),
                // Ensure that the container has a specific height
                height: 110.h,
                width: double.infinity,
                clipBehavior: Clip.hardEdge, // Ensure the image respects the border radius
                child: Image.network(
                  categoryModel.image,
                  fit: BoxFit.cover, // Use BoxFit.cover to fill the container
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 1.h),
                    Flexible(
                      child: Text(
                        categoryModel.catName,
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : const Color(0xff181725),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Flexible(
                      child: Consumer<CategoryProvider>(
                        builder: (context, provider, child) {
                          final quantity = provider.getQuantity(categoryModel.id);

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$4.99',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  color: isDarkMode ? Colors.white70 : const Color(0xff181725),

                                ),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: quantity > 0
                                    ? AnimatedScale(
                                  duration: const Duration(milliseconds: 300),
                                  scale: 1.0,
                                  child: CircleAvatar(
                                    key: const ValueKey("checked"),
                                    radius: 12.sp, // Smaller radius for stylish look
                                    backgroundColor: const Color(0xffFF7F00), // Orange color
                                    child: const Icon(Icons.check, size: 16, color: Colors.white),
                                  ),
                                )
                                    : AnimatedScale(
                                  duration: const Duration(milliseconds: 300),
                                  scale: 1.0,
                                  child: CircleAvatar(
                                    key: const ValueKey("add"),
                                    radius: 12.sp, // Smaller radius
                                    backgroundColor: const Color(0xffFF7F00), // Orange color
                                    child: const Icon(Icons.add, size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetContent(BuildContext context, bool isDarkMode) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        final quantity = provider.getQuantity(categoryModel.id);
        final textColor = isDarkMode ? Colors.white : Colors.black;
        final iconColor =  Colors.orangeAccent ; // Change icon color based on theme
        final borderColor = isDarkMode ? const Color(0xff444444) : const Color(0xffE2E2E2); // Border color for input box

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7F00), // Orange shade
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Shadow color
                        blurRadius: 6, // Softness of the shadow
                        offset: const Offset(0, 4), // Offset in X and Y direction
                      ),
                    ],
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.close, size: 16.h), // Set the icon size
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.white, // Icon color
                      padding: EdgeInsets.zero, // Remove padding for perfect centering
                    ),
                  ),
                ),
              ),


              SizedBox(height: 16.h),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    categoryModel.image,
                    height: 150.h,
                    width: 150.w,
                    fit: BoxFit.cover, // Ensure the image fits well within the rounded borders
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                categoryModel.catName,
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                categoryModel.catDescription,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: textColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Product Detail",
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Apples are nutritious. Apples may be good for weight loss. Apples may be good for your heart. As part of a healthy and varied diet.',
                softWrap: true,
                style: GoogleFonts.poppins(
                  color: textColor,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Decrement Button
                  GestureDetector(
                    onTap: () {
                      if (quantity > 0) {
                        provider.decrement(categoryModel.id);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDarkMode ? Colors.white :const Color(0xFF272727) ,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.remove, color: iconColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Quantity Display
                  Container(
                    width: 37.w,
                    height: 37.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDarkMode ? Colors.white :const Color(0xFF272727) ,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$quantity',
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Increment Button
                  GestureDetector(
                    onTap: () {
                      provider.increment(categoryModel.id);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDarkMode ? Colors.white :const Color(0xFF272727) ,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.add, color: iconColor),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
            ],
          ),
        );
      },
    );
  }

}
