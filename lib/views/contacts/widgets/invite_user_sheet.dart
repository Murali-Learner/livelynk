import 'package:flutter/material.dart';
import 'package:livelynk/providers/contact_provider.dart';
import 'package:livelynk/views/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:livelynk/utils/extensions/spacer_extension.dart';
import 'package:livelynk/views/contacts/widgets/invite_user_tile.dart';

class InviteUserSheet extends StatefulWidget {
  const InviteUserSheet({super.key});

  @override
  InviteUserSheetState createState() => InviteUserSheetState();
}

class InviteUserSheetState extends State<InviteUserSheet> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
    searchController.addListener(_onSearchChanged);
  }

  init() async {
    await Provider.of<ContactProvider>(context, listen: false).fetchAllUsers();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final contactProvider =
        Provider.of<ContactProvider>(context, listen: false);
    contactProvider.filterUsers(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContactProvider>();
    return provider.isLoading
        ? const LoadingWidget()
        : FractionallySizedBox(
            heightFactor: 0.9,
            child: Column(
              children: [
                10.vSpace,
                const Text(
                  'Invite Users',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                10.vSpace,
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Users',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Consumer<ContactProvider>(
                    builder: (context, provider, child) {
                      return ListView.builder(
                        itemCount: provider.filteredUsers.length,
                        itemBuilder: (context, index) {
                          var user = provider.filteredUsers[index];
                          return InviteUserTile(user: user);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
