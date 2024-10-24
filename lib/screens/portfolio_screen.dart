import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
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
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'My Portfolio',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black, // Change color based on theme
            letterSpacing: 1.2,
          ),
        ),
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
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: Consumer<PortfolioProvider>(
          builder: (context, portfolioProvider, child) {
            if (portfolioProvider.products.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
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

                      return AnimatedPortfolioCard(
                        index: index,
                        isDarkMode: isDarkMode,
                        product: product,
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

class AnimatedPortfolioCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> product;
  final bool isDarkMode;

  const AnimatedPortfolioCard({
    Key? key,
    required this.index,
    required this.product,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 100)), // Staggered animation
      curve: Curves.easeInOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20), // Slide up effect
            child: child,
          ),
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
          // boxShadow: [
          //   if (!isDarkMode)
          //     BoxShadow(
          //       color: Colors.black.withOpacity(0.1), // Light shadow for light mode
          //       spreadRadius: 2,
          //       blurRadius: 10,
          //       offset: const Offset(0, 4),
          //     ),
          // ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDarkMode ? const Color(0xFF505050) : const Color(0xffD8DADC),
                  ),
                ),
                clipBehavior: Clip.hardEdge, // Ensure the image respects the border radius
                height: 110.h, // Specify the height of the container
                width: double.infinity,
                child: Image.network(
                  product['imageUrl'] ?? 'Unknown Product',
                  fit: BoxFit.cover, // Use BoxFit.cover to fill the container while maintaining aspect ratio
                ),
              ),

              SizedBox(height: 8.h),
              // Product name
              Text(
                product['title'] ?? 'Unknown Product',
                softWrap: true,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  color: isDarkMode ? Colors.white : const Color(0xff181725),
                ),
              ),
              SizedBox(height: 4.h),
              // Quantity
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Qty: ${product['quantity'] ?? 'N/A'}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: isDarkMode ? Colors.white70 : const Color(0xff181725),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
