
// ignore_for_file: unused_local_variable, prefer_const_constructors, use_super_parameters

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcg_collection_app/providers/quantity_provider.dart';
import 'package:tcg_collection_app/providers/theme_provider.dart';
import 'package:tcg_collection_app/screens/screens.dart';
import '../model/category_model.dart';
import 'package:provider/provider.dart'; 

class CategoryWidget extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryWidget({
    required this.categoryModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
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

                return _buildBottomSheetContent(context, isDarkMode);
              },
            ),
          );
        },
      );
    },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 2, color: Colors.white),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: 150.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(categoryModel.image),
                    fit: BoxFit.scaleDown,
                    onError: (error, stackTrace) {
                      debugPrint("Failed to load image: $error");
                    },
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h,),
                Text(
                  categoryModel.catName,
                  style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff181725),
                  ),
                ),
                // Text(
                //   categoryModel.catDescription,
                //   style: const TextStyle(
                //     fontSize: 14,
                //     color: Color(0xff7C7C7C),
                //   ),
                // ),
                SizedBox(height: 12.h),
                Consumer<CategoryProvider>(
                  builder: (context, provider, child) {
                    final quantity = provider.getQuantity(categoryModel.id); 

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('\$4.99'),
                     //   Text(quantity.toString()),
                       if (quantity > 0)
                        CircleAvatar(
                          backgroundColor: const Color(0xff53B175) ,
                          child: Center(
                            child: quantity > 0
                                    ? const Icon(Icons.check, color: Colors.white) 
                                    : Container(),
                                                   
                          ),
                        ),
                         Container(
                          padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                          width: 46.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            color:  const Color(0xff53B175),
                          ),
                          child: Center(
                            child:  const Icon(Icons.add, color: Colors.white), 
                          ),
                        ),
                      ],
                    ).padOnly(bottom: 8.h);
                  },
                ),
              ],
            ).padOnly(left: 8.w, right: 8.w),
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

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(height: 16.h),
          Center(
            child: Image.network(
              categoryModel.image,
              height: 150.h,
              width: 150.w,
            ),
          ),
          Text(
            categoryModel.catName,
            style: GoogleFonts.montserrat(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            categoryModel.catDescription,
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              color: textColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Product Detail",
            style: GoogleFonts.montserrat(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Apples are nutritious. Apples may be good for weight loss. Apples may be good for your heart. As part of a healthy and varied diet.',
            softWrap: true,
            style: GoogleFonts.montserrat(
              color: textColor,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => provider.decrement(categoryModel.id),
                color: Colors.grey,
              ),
              SizedBox(width: 8.w),
              Container(
                width: 37.w,
                height: 37.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xffE2E2E2),
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
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => provider.increment(categoryModel.id),
                color: Colors.green,
              ),
            ],
          ),
          SizedBox(height: 32.h),
        ],
      ).padOnly(left: 16.w, right: 16.w);
    },
  );
}}