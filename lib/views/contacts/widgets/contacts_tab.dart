import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:livelynk/models/contact_model.dart';
import 'package:livelynk/models/user_model.dart';
import 'package:livelynk/providers/contact_provider.dart';
import 'package:livelynk/utils/enums/button_status_enum.dart';
import 'package:livelynk/utils/enums/contact_status_enum.dart';
import 'package:livelynk/views/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:livelynk/views/widgets/user_tile.dart';

class ContactsTab extends StatefulWidget {
  const ContactsTab({
    super.key,
    required this.status,
    required this.isSendContact,
  });
  final ContactStatus status;
  final bool isSendContact;
  @override
  State<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (widget.status == ContactStatus.ACCEPTED) {
      await Future.delayed(Duration.zero).whenComplete(
        () => Provider.of<ContactProvider>(context, listen: false).fetchUsers(
          status: ContactStatus.ACCEPTED,
          isSendContact: false,
        ),
      );
    } else if (widget.isSendContact) {
      await Future.delayed(Duration.zero).whenComplete(() {
        Provider.of<ContactProvider>(context, listen: false).fetchUsers(
          status: ContactStatus.INVITED,
          isSendContact: true,
        );
      });
    } else {
      await Future.delayed(Duration.zero).whenComplete(() {
        Provider.of<ContactProvider>(context, listen: false).fetchUsers(
          status: ContactStatus.INVITED,
          isSendContact: false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactProvider>(
      builder: (context, provider, _) {
        final Map<int, Contact> userList =
            widget.status == ContactStatus.ACCEPTED
                ? provider.acceptedUsers
                : widget.isSendContact
                    ? provider.invitedUsers
                    : provider.requestedUsers;
        return provider.isLoading
            ? const LoadingWidget()
            : userList.isEmpty
                ? const Center(
                    child: Text("No Contacts"),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 3, bottom: 60),
                          itemCount: userList.length,
                          itemBuilder: (context, index) {
                            final int key = userList.keys.elementAt(index);
                            final Contact user = userList[key]!;

                            return ContactTile(
                              contact: user,
                              status: widget.status == ContactStatus.ACCEPTED
                                  ? ButtonStatus.ACCEPTED
                                  : widget.isSendContact
                                      ? ButtonStatus.REQUESTED
                                      : ButtonStatus.INVITED,
                            );
                          },
                        ),
                      ),
                    ],
                  );
      },
    );
  }
}
