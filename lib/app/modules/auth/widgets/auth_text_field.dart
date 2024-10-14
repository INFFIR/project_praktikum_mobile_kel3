// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';

class AuthTextField extends StatefulWidget {
  String? nameText;
  String? hintText;
  bool? isObsecure;
  bool? isPassword;
  TextEditingController? controller;

  AuthTextField({
    super.key,
    this.nameText,
    this.hintText,
    this.isObsecure = false,
    this.isPassword = false,
    this.controller,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.nameText!,
          style: poppinsBlack.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          controller: widget.controller,
          obscureText: widget.isObsecure!,
          decoration: InputDecoration(
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 0,
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              filled: true,
              fillColor: colorBlack.withOpacity(0.05),
              border: InputBorder.none,
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 0,
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 0,
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 0,
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 15,
              ),
              hintText: widget.hintText,
              hintStyle: poppinsBlack.copyWith(
                fontSize: 16,
                color: colorBlack.withOpacity(0.4),
              ),
              suffixIcon: widget.isPassword!
                  ? InkWell(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(
                          10,
                        ),
                        topRight: Radius.circular(
                          10,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          widget.isObsecure = !widget.isObsecure!;
                        });
                      },
                      child: widget.isObsecure!
                          ? const Icon(
                              Icons.visibility_off,
                            )
                          : const Icon(
                              Icons.visibility,
                            ),
                    )
                  : null),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
