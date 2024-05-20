import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livelynk/models/user_model.dart';
import 'package:livelynk/providers/auth_provider.dart';
import 'package:livelynk/views/utils/extensions/naming_extension.dart';
import 'package:livelynk/views/widgets/loading_widget.dart';

class InviteBox extends StatelessWidget {
  const InviteBox({super.key, required this.contact});
  final User contact;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              "${contact.username.toPascalCase()} is not in your contact List"),
          provider.isLoading
              ? const LoadingWidget()
              : ElevatedButton(
                  onPressed: () async {
                    await Provider.of<AuthProvider>(context, listen: false)
                        .addContact(contact.userId!);
                  },
                  child: const Text("Add Contact"),
                ),
        ],
      ),
    );
  }
}
