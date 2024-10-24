// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tcg_collection_app/providers/theme_provider.dart';
import 'package:tcg_collection_app/utils/extensions/extensions.dart';
import '../providers/portfolio_provider.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PortfolioProvider>(context, listen: false).fetchportfolioProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); 
    return Scaffold(
       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
       
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        // backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('My Portfolio'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
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
          ),
 
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: Consumer<PortfolioProvider>(
          builder: (context, portfolioProvider, child) {
            if (portfolioProvider.products.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(portfolioProvider.products.length, (index) {
                      final product = portfolioProvider.products[index];
                      return Container(
                        margin: EdgeInsets.only(right: 12.w),
                        width: 160.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xffD8DADC),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                         
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xffD8DADC),
                          ),
                              ),
                              child: Image.network(
                                product['imageUrl'] ?? 'Unknown Product', 
                                height: 110.h,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            // Product name
                            Text(
                              product['title'] ?? 'Unknown Product',
                              softWrap: true,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                                color: const Color(0xff181725),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Qty: ${product['quantity'] ?? 'N/A'}',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: const Color(0xff181725),
                              ),
                            ),
                          ],
                        ).padAll(16),
                 
                      );
                    }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
