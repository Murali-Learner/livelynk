import 'package:flutter/material.dart';
import 'package:livelynk/models/contact_model.dart';
import 'package:livelynk/providers/contact_provider.dart';
import 'package:livelynk/utils/enums/button_status_enum.dart';
import 'package:livelynk/utils/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:livelynk/utils/extensions/naming_extension.dart';

class ContactTile extends StatelessWidget {
  final Contact contact;
  final ButtonStatus status;

  const ContactTile({
    super.key,
    required this.contact,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactProvider>(builder: (context, provider, _) {
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
            style: context.textTheme.titleSmall,
          ),
          subtitle: Text(
            contact.email!,
            style: context.textTheme.labelMedium,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (status == ButtonStatus.ACCEPTED)
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await provider.deleteContact(contact);
                  },
                ),
              if (status == ButtonStatus.REQUESTED)
                Tooltip(
                  message: "Withdraw Request",
                  child: InkWell(
                    onTap: () async {
                      await provider.deleteContact(contact);
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 13,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              if (status == ButtonStatus.INVITED)
                Row(
                  children: [
                    Tooltip(
                      message: "Decline Request",
                      child: InkWell(
                        onTap: () async {
                          await provider.deleteContact(
                            contact,
                            isRequestedContact: true,
                          );
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 13,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 13,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        tooltip: "Accept Request",
                        icon: const Icon(
                          Icons.check,
                          size: 20,
                        ),
                        onPressed: () async {
                          await provider.acceptContactRequest(contact);
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
    });
  }
}
