import 'package:flutter/material.dart';
import 'package:livelynk/providers/auth_provider.dart';
import 'package:livelynk/utils/enums/contact_status_enum.dart';
import 'package:livelynk/views/contacts/widgets/contacts_tab.dart';
import 'package:livelynk/views/contacts/widgets/invite_user_sheet.dart';
import 'package:provider/provider.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  ContactsPageState createState() => ContactsPageState();
}

class ContactsPageState extends State<ContactsPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, provider, _) {
          return DefaultTabController(
            length: 3,
            initialIndex: 1,
            child: Column(
              children: [
                TabBar(
                  onTap: (int index) async {},
                  tabs: const [
                    Tab(text: 'Invite'), //yours sent invites
                    Tab(text: 'Accepted'), //yours accepted requests
                    Tab(text: 'Requests'), //your requests form others
                  ],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      ContactsTab(
                          status: ContactStatus.INVITED, isSendContact: true),
                      ContactsTab(
                          status: ContactStatus.ACCEPTED, isSendContact: true),
                      ContactsTab(
                          status: ContactStatus.INVITED, isSendContact: false),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInviteUserSheet(context);
        },
        child: const Icon(Icons.group_add_outlined),
      ),
    );
  }

  void _showInviteUserSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => const InviteUserSheet(),
    );
  }
}
