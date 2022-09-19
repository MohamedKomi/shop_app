import 'package:flutter/material.dart';

void navigateTo(context,widget){
  Navigator.push(context, MaterialPageRoute(builder:(context)=>widget));
}
Widget customTextFormField({
  required TextEditingController controller,
  required String? Function(String? value) validator,
  required TextInputType inputType,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function()? onSuffixPressed,
  Function()? onTap,
  Function(String s)? onSubmit,
  bool isPassword = false,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: isPassword,
      onTap: onTap,
      onFieldSubmitted: onSubmit,
      style: const TextStyle(
          color: Colors.black,
          fontSize: 18
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: IconButton(icon: Icon(suffix), onPressed: onSuffixPressed),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: defaultColor),
        ),
      ),
      validator: validator,
    );
const defaultColor=Colors.deepOrange;