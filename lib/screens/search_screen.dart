import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tcg_collection_app/providers/search_provider.dart';
import 'package:tcg_collection_app/providers/theme_provider.dart';
import 'package:tcg_collection_app/utils/extensions/paddings_ext.dart';
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
             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 SizedBox(height: 3.h),
              Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                backgroundColor: const Color(0xff53B175) ,
                child: Center(
                  child: IconButton(
                            icon: Icon(
                              themeProvider.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              themeProvider.toggleTheme(); 
                            },
                          ),
                ),
                        ),
              ],
            ),
                 SizedBox(height: 2.h),
                  TextFormField(
                    initialValue: searchProvider.searchText,
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some value';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF6F6F6),
                      hintText: 'Search Catalog',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFFAAA6B9),
                      ),
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
                          color: const Color(0xFFE8E8E8),
                          width: 1.w,
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      searchProvider.updateSearchText(text);
                    },
                  ),
                
                  Expanded(
                    child: searchProvider.filteredProducts.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: searchProvider.filteredProducts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 180 / 200,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              final product = searchProvider.filteredProducts[index];
                              return CategoryWidget(
                                categoryModel: CategoryModel(
                                 id: product['id'].toString(),
                                  image: product['image_url'],
                                  catName: product['title'],
                                  catDescription: '',
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ).padOnly(top: 32, left: 16.w, right: 16.w),
            ),
          );
        },
      ),
    );
  }
}
