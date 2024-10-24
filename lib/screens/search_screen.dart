import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tcg_collection_app/providers/search_provider.dart';
import 'package:tcg_collection_app/providers/theme_provider.dart';
import '../model/category_model.dart';
import '../widgets/category_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ChangeNotifierProvider(
      lazy: false,
      create: (_) => SearchProvider()..fetchProducts(),
      child: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                actions: [
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 25.sp, // Slightly bigger for a more elegant look
                backgroundColor: const Color(0xFFFF7F00), // Use orange color
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      themeProvider.toggleTheme(); // Trigger theme switch
                    },
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300), // Smooth transition
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child); // Smooth scaling effect
                      },
                      child: Icon(
                        themeProvider.themeMode == ThemeMode.light
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        key: ValueKey<bool>(themeProvider.themeMode == ThemeMode.light),
                        color: Colors.white,
                        size: 20.sp, // Adjust icon size for balance
                      ),
                    ),
                  ),
                ),
              ),
            ),
                ],
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: searchProvider.searchText,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some value';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: themeProvider.themeMode == ThemeMode.dark
                            ? const Color(0xFF2A2A2A) // Dark theme fill color
                            : const Color(0xFFF6F6F6), // Light theme fill color
                        hintText: 'Search Catalog',
                        hintStyle: GoogleFonts.poppins(
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white // Dark theme hint text color
                              : const Color(0xFFAAA6B9), // Light theme hint text color
                          fontSize: 14.sp,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white // Dark theme icon color
                              : const Color(0xFFAAA6B9), // Light theme icon color
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color(0xFFE8E8E8),
                            width: 1.w,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color(0xFFE8E8E8),
                            width: 1.w,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color(0xFFFF7F00),
                            width: 1.2.w,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.w,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.red.shade700,
                            width: 1.2.w,
                          ),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white // Dark theme text color
                            : Colors.black, // Light theme text color
                      ),
                      onChanged: (text) {
                        searchProvider.updateSearchText(text);
                      },
                    ),

                    SizedBox(height: 12.h),
                    Expanded(
                      child: searchProvider.filteredProducts.isEmpty
                          ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                        ),
                      )
                          : GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: searchProvider.filteredProducts.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.83,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final product = searchProvider.filteredProducts[index];

                          // Add the animation for each grid item
                          return AnimatedGridItem(
                            index: index,
                            child: CategoryWidget(
                              categoryModel: CategoryModel(
                                id: product['id'].toString(),
                                image: product['image_url'],
                                catName: product['title'],
                                catDescription: '',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedGridItem extends StatelessWidget {
  final int index;
  final Widget child;

  const AnimatedGridItem({
    Key? key,
    required this.index,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 100)), // Add delay based on index
      curve: Curves.easeInOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20), // Slide effect from below
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
