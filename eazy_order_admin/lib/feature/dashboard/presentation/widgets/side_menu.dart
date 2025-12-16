import 'package:core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key,required this.onItemClick});
  final Function(int) onItemClick;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  bool catalogExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1100;
    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          // 🔥 Close button only in drawer mode (mobile/tablet)
          if (!isDesktop)
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, size: 22),
                color: AppColors.primaryColor,
                onPressed: () => Navigator.pop(context),
              ),
            ),

          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.black12,
                  width: 0.6,
                ),
              ),
            ),
            child: Image.asset("assets/images/app_logo_trans.png"),
          ),

          // Menu items
          Expanded(
            child: ListView(
              children: [

                DrawerListTile(
                  title: "Dashboard",
                  svgSrc: "assets/icons/menu_dashboard.svg",
                  press: () => widget.onItemClick(1),
                ),

                DrawerListTile(
                  title: "Users",
                  svgSrc: "assets/icons/menu_profile.svg",
                  press: () => widget.onItemClick(2),
                ),

                // 🔽 CATALOG MAIN TILE (Expandable)
                DrawerListTile(
                  title: "Catalog",
                  svgSrc: "assets/icons/menu_store.svg",
                  trailing: Icon(
                    catalogExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.primaryColor,
                  ),
                  press: () {
                    if (!catalogExpanded) {
                      // First click → open Category screen
                      widget.onItemClick(3); // Category index
                    }

                    setState(() {
                      catalogExpanded = !catalogExpanded;
                    });
                  },
                ),


                // 🔥 SUBMENU (Category + Product)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: catalogExpanded ? 100 : 0,
                  padding: const EdgeInsets.only(left: 50),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Category
                        ListTile(
                          leading: Icon(Icons.category_outlined,size: 17),
                          title: const Text("Category",
                              style: TextStyle(fontSize: 13.5,color: AppColors.black)),
                          onTap: () => widget.onItemClick(3),
                        ),

                        // Product
                        ListTile(
                          leading: Icon(Icons.production_quantity_limits,size: 17),
                          title: const Text("Product",
                              style: TextStyle(fontSize: 13.5,color: AppColors.black)),
                          onTap: () => widget.onItemClick(4),
                        ),
                      ],
                    ),
                  ),
                ),

                DrawerListTile(
                  title: "Orders",
                  svgSrc: "assets/icons/menu_doc.svg",
                  press: () => widget.onItemClick(5),
                ),

                DrawerListTile(
                  title: "Customers",
                  svgSrc: "assets/icons/menu_store.svg",
                  press: () => widget.onItemClick(6),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.svgSrc,
    required this.press,
    this.trailing,
  });

  final String title, svgSrc;
  final VoidCallback press;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 10,
      visualDensity: const VisualDensity(horizontal: -2),
      leading: SvgPicture.asset(
        height: 16,
        svgSrc,
        colorFilter: ColorFilter.mode(
            AppColors.primaryColor,
            BlendMode.srcIn
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
            color: AppColors.primaryColor
        ),
      ),
      trailing: trailing,
    );
  }
}
