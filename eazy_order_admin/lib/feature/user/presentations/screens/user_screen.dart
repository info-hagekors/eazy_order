import 'package:data_table_2/data_table_2.dart';
import 'package:eazy_order_admin/constants.dart';
import 'package:eazy_order_admin/feature/user/applications/user_controller.dart';
import 'package:eazy_order_admin/feature/user/presentations/widgets/add_user_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:google_fonts/google_fonts.dart';

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});

  static const String routeName = '/user';

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {

  @override
  void initState() {
    ref.read(userControllerProvider.notifier).getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userControllerProvider);
    return SingleChildScrollView(
      primary: false,
      padding: EdgeInsets.all(defaultPadding),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Text(
              "Users",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: SizedBox()),
                SizedBox(
                  width: 140,
                  height: 40,
                  child: AppButton(
                    text: '',
                    onPressed: () => openCreateUserDialog(context),
                    color: AppColors.white,
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 16, color: AppColors.primaryColor,),
                        SizedBox(width: 10),
                        Text(
                            'Add User',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryColor
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20,),
            Expanded(
              child: CommonDataTable<UserModel>(
                items: state.usersList,
                columns: [
                  DataColumn(label: Text('Name'), columnWidth: FlexColumnWidth(3),),
                  DataColumn(label: Text('Email'), columnWidth: FlexColumnWidth(3)),
                  DataColumn(label: Text('Mobile'), columnWidth: FlexColumnWidth(1)),
                  DataColumn(label: Text('Role'), columnWidth: FlexColumnWidth(1)),
                  DataColumn(label: Text('Email Verified'), columnWidth: FlexColumnWidth(1)),
                  DataColumn(label: Text('Phone Verified'), columnWidth: FlexColumnWidth(1)),
                  DataColumn(label: Align(alignment: Alignment.center, child: Text('Action')), columnWidth: FlexColumnWidth(1)),
                ],
                buildRows: (items) => items.map((user) {
                  bool isAdmin = user.role == 'admin';
                  return DataRow(cells: [
                    DataCell(Text(user.name)),
                    DataCell(Text(user.email)),
                    DataCell(Text(user.mobile)),
                    DataCell(Text(user.role.capitalize())),
                    DataCell(Text(user.isEmailVerified ? 'Yes' : 'No')),
                    DataCell(Text(user.isMobileVerified ? 'Yes' : 'No')),
                    DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(onPressed: () {}, icon: Icon(Icons.edit, size: 20, color: AppColors.primaryColor,)),
                            IconButton(onPressed: !isAdmin ? () {} : null,
                                icon: Icon(Icons.delete_outline, size: 20,
                                  color: !isAdmin ? AppColors.primaryColor : AppColors.primaryColor.withAlpha(128),)),
                          ],
                        )
                    ),
                  ]);
                }).toList(),
                isLoading: state.isLoading,
                hasMore: false,
                onLoadMore: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openCreateUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AddUserDialog(
        onCreate: (userData) async {
          await ref.read(userControllerProvider.notifier).createUser(userData);
        },
      ),
    ).then((val) {
      ref.read(userControllerProvider.notifier).getUserData();
    });
  }


}

class CommonDataTable<T> extends StatelessWidget {
  final List<T> items;
  final List<DataColumn> columns;
  final List<DataRow> Function(List<T>) buildRows;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final Widget? searchBar;

  const CommonDataTable({
    super.key,
    required this.items,
    required this.columns,
    required this.buildRows,
    required this.isLoading,
    required this.hasMore,
    required this.onLoadMore,
    this.searchBar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (searchBar != null)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: searchBar!,
          ),
        Expanded(
          child: DataTable2(
            columns: columns,
            rows: buildRows(items),
            columnSpacing: 12,
            horizontalMargin: 12,
            minWidth: 600,
            empty: Center(child: Text('No Data Found.!'),),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            headingRowColor: WidgetStatePropertyAll(AppColors.primaryColor),
            headingTextStyle: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 16
            ),
            dataTextStyle: GoogleFonts.poppins(
                fontSize: 14
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              //border: Border.all(color: AppColors.primaryColor)
            ),
            border: TableBorder.symmetric(
              outside: BorderSide(
                color: AppColors.primaryColor,
                width: 2,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(),
          ),
        if (!isLoading && hasMore)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextButton.icon(
              onPressed: onLoadMore,
              icon: const Icon(Icons.more_horiz),
              label: const Text('Load More'),
            ),
          ),
      ],
    );
  }
}


