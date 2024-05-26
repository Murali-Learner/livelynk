import 'package:flutter/material.dart';
import 'package:livelynk/providers/contact_provider.dart';
import 'package:livelynk/utils/enums/button_status_enum.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livelynk/models/user_model.dart';
import 'package:livelynk/utils/extensions/naming_extension.dart';

class UserTile extends StatelessWidget {
  final Contact contact;
  final ButtonStatus status;

  const UserTile({super.key, required this.contact, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: ListTile(
        onTap: () {},
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(
            contact.username[0].toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          contact.username.toPascalCase(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(contact.email!),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (status == ButtonStatus.ACCEPTED)
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await Provider.of<ContactProvider>(context, listen: false)
                      .deleteContact(contact.contactId!);
                },
              ),
            if (status == ButtonStatus.REQUESTED)
              Tooltip(
                message: "Decline Request",
                child: InkWell(
                  onTap: () async {
                    await Provider.of<ContactProvider>(context, listen: false)
                        .deleteContact(contact.contactId!);
                  },
                  child: SvgPicture.asset(
                    "assets/icons/person_remove.svg",
                    height: 25,
                    width: 25,
                  ),
                ),
              ),
            if (status == ButtonStatus.INVITED)
              IconButton(
                padding: EdgeInsets.zero,
                tooltip: "Accept Request",
                icon: const Icon(Icons.check),
                onPressed: () async {
                  await Provider.of<ContactProvider>(context, listen: false)
                      .acceptContactRequest(contact.contactId!);
                },
              ),
          ],
        ),
      ),
    );
  }
}
