import 'package:flutter/material.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/account/widgets/item_section.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Settings',
          style: poppinsBlack.copyWith(
            fontSize: 18,
            color: colorBlack.withOpacity(0.4),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        ItemSection(
          name: 'Edit profile',
          onTap: () {},
          icon: const Icon(
            Icons.chevron_right_rounded,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        ItemSection(
          name: 'Change password',
          onTap: () {},
          icon: const Icon(
            Icons.chevron_right_rounded,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        ItemSection(
          name: 'Add a payment method',
          onTap: () {},
          icon: const Icon(
            Icons.add,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        ItemSection(
          name: 'Push notifications',
          onTap: () {},
          icon: const Icon(
            Icons.toggle_on_outlined,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        ItemSection(
          name: 'Dark mode',
          onTap: () {},
          icon: const Icon(
            Icons.toggle_off_outlined,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
